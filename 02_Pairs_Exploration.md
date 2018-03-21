Pairs Exploration
================
Zarni Htet

### Libraries

``` r
library(rio)
```

    ## Warning: package 'rio' was built under R version 3.3.2

### Importing cleaned data

``` r
All_BIDS <- import("CT_BIDs_Full.dta")
```

### Exploring the cleaned data

``` r
head(All_BIDS)
```

    ##   CT_id CT_id_full areaCT_ft boro_name CT_a_weight BID_dummy BID_id
    ## 1    14       2060   2496580         5         NaN       NaN     NA
    ## 2   143         98   1905744         3   0.1348670         1   0063
    ## 3   145        100   1860672         3   0.6364856         1   0063
    ## 4   147        102   1860725         3   0.3435306         1   0059
    ## 5   149        104   1864331         3   0.1817558         1   0062
    ## 6   166        116   1063396         3   0.6533888         1   0063
    ##   BID_name areaBID_ft BID_date
    ## 1      NaN        NaN      NaN
    ## 2       27    5019608    17855
    ## 3       27    5019608    17855
    ## 4       37    7764914    17855
    ## 5        8    2250620    17855
    ## 6       27    5019608    17855

### Checking out the Number of BIDS based on name

``` r
length(unique(All_BIDS$BID_name))
```

    ## [1] 70

``` r
head(All_BIDS$BID_name)
```

    ## [1] NaN  27  27  37   8  27

### Checking out the Number of BIDS based on ID

``` r
length(unique(All_BIDS$BID_id))
```

    ## [1] 70

``` r
head(All_BIDS$BID_id)
```

    ## [1] "NA"   "0063" "0063" "0059" "0062" "0063"

### General Clarification Comments

1.  The BIDS ID and the BID Names are the same but with Zeros being stripped?
2.  The characteristics of the Census tract right now is its area, borough? These will be joined with more census tract characteristics?
3.
