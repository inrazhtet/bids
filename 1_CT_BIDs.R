#Import dataset GIS union between BIDs and Census Tracts. Keep one CT observation.
#Choose the biggest portion of the CT if it falls within many BIDs.

# pkgs <- c("haven", "tidyverse", "stringr", "glue", "dplyr", "foreign", "WriteXLS", "lubridate")
# install.packages(pkgs)


library(tidyverse)
library(stringr)
library(glue)
library(dplyr)
library(haven)
library(foreign)
library(WriteXLS)
library (lubridate)

data_dir <- "/Users/MoniFlores/Desktop/NYU 4th semester/Data Analysis for Public Policy/CT_BIDs"

#Import joined data from GIS
raw<- glue("{data_dir}/draft/CT_BID.dbf") %>% 
  read.dbf() %>% as_tibble()

#Clean data
#Note that I'm excluding Census Tracts that have less than 10% of its area within a BID.
clean <- raw %>% 
  select(-date_modif, -OBJECTID_1, -FID_geo_ex, -FID_geo__1, -ntaname, -ntacode, -ctlabel, -shape_leng, -cdeligibil, -boro_code, -puma, - Shape_Le_1, -Shape_Area  ) %>%  
  filter(!is.na(ct2010), !is.na(bid), a_weight > 0.1) %>%
  #Make BID_id a character  
  mutate (BID_id = as.character(objectid),
          BID_id = str_pad(BID_id, 4, "left", pad = "0"),
          CT_id = ct2010,
          CT_id_full = boro_ct201,
          BID_name = bid,
          BID_date = date_creat,
          CT_a_weight = a_weight,
          BID_dummy = 1
          )%>%
  #Keep only one observation per CT
  group_by(CT_id_full) %>% 
  mutate(
    max_a=max(a_weight)
  ) %>% 
  filter(a_weight==max_a) %>% 
  ungroup() %>% 
  select (CT_id, CT_id_full, areaCT_ft, CT_a_weight, BID_dummy,
          BID_id, BID_name, areaBID_ft, BID_date, boro_name)

#Test to see how many BIDs were excluded of the analysis
summary_c <- clean %>% summarise(Unique_BIDs = n_distinct(BID_id))
summary_r <- raw %>% summarise(Unique_BIDs = n_distinct(objectid))
#75 BIDs in raw file, 69 BIDs in clean file. 
#6 BIDs excluded for not having an area within a CT that's  big enough to be representative.
 
#Test to see how many unique CT are in the clean file
summary_CT <- clean %>% summarise(Unique_CT = n_distinct(CT_id_full))
#233 unique CT, this is equal to number of obs in the dataset. 

#Export clean file
exp_path<- glue("{data_dir}/Clean/CT_BIDs.dta") 
clean %>% write.dta(exp_path)

#Create new file with full list of CT and join it with CT_BIDs file

#Import CTs file
raw_CT<- glue("{data_dir}/draft/CT.dbf") %>% 
  read.dbf() %>% as_tibble()

clean_CT<-raw %>%
  filter(!is.na(ct2010)) %>% 
  mutate (CT_id = ct2010,
          CT_id_full = boro_ct201)%>%
  #remove dups
  group_by(CT_id_full) %>% filter(row_number(areaCT_ft) == 1) %>% 
  select (CT_id, CT_id_full, areaCT_ft, boro_name) %>% 
  ungroup()

#Full join both datasets
full_CT<- clean_CT %>% full_join(clean, by=c("CT_id", "CT_id_full", "areaCT_ft", "boro_name"))

#Export full CT file
exp_path2<- glue("{data_dir}/Clean/CT_BIDs_Full.dta") 
full_CT %>% write.dta(exp_path2)


