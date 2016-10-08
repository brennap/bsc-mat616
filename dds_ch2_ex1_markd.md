---
title: "nyt data report"
author: "Paul Brennan"
output: html_document
---



This section processes the data file by:
*read it into a dataframe
*add an age category
*assign names to gender values (also separate unknown gender for users not logged in)

```r
# Because my for-loop broke
dir_name <- "/home/brennap/Documents/school/MAT-616/doing_data_science/dds_datasets/dds_ch2_nyt"
dir_contents <- list.files(path=dir_name, pattern='nyt1.csv')
csv <- dir_contents[1]
# normal from here on
nyt_data <- read.csv(file=paste(dir_name, csv, sep="/"))
nyt_data$age_cat <- cut(nyt_data$Age, c(-Inf,0,18,24,34,44,54,64,Inf))
nyt_data$ctr <- nyt_data$Clicks / nyt_data$Impressions
nyt_data$Gender[nyt_data$Gender == 1] <- "male"
nyt_data$Gender[nyt_data$Gender == 0] <- "female"
nyt_data$Gender[nyt_data$Signed_In == 0] <- "unknown"
nyt_data$Gender <- factor(nyt_data$Gender)
```

# Summary of `csv`

```r
summary(nyt_data)
```

```
##       Age             Gender        Impressions         Clicks       
##  Min.   :  0.00   female :153070   Min.   : 0.000   Min.   :0.00000  
##  1st Qu.:  0.00   male   :168265   1st Qu.: 3.000   1st Qu.:0.00000  
##  Median : 31.00   unknown:137106   Median : 5.000   Median :0.00000  
##  Mean   : 29.48                    Mean   : 5.007   Mean   :0.09259  
##  3rd Qu.: 48.00                    3rd Qu.: 6.000   3rd Qu.:0.00000  
##  Max.   :108.00                    Max.   :20.000   Max.   :4.00000  
##                                                                      
##    Signed_In          age_cat            ctr        
##  Min.   :0.0000   (-Inf,0]:137106   Min.   :0.0000  
##  1st Qu.:0.0000   (34,44] : 70860   1st Qu.:0.0000  
##  Median :1.0000   (44,54] : 64288   Median :0.0000  
##  Mean   :0.7009   (24,34] : 58174   Mean   :0.0185  
##  3rd Qu.:1.0000   (54,64] : 44738   3rd Qu.:0.0000  
##  Max.   :1.0000   (18,24] : 35270   Max.   :1.0000  
##                   (Other) : 48005   NA's   :3066
```


```r
histogram(~ Impressions | age_cat, data=nyt_data,
                main="Distribution of Impressions by Age Cat.")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)

```r
histogram(~ ctr | age_cat, data=nyt_data,
                main="Distribution of CTR by Age Cat.")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-2.png)

```r
histogram(~ ctr | age_cat, data=subset(nyt_data,ctr != 0),
                main="Distribution of Non-Zero CTR by Age Cat.")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-3.png)

```r
densityplot(~ Impressions | age_cat, groups=Gender, auto.key=T, data=nyt_data, plot.points=F,
                  main="Distribution of Impressions by Age Cat.")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-4.png)

```r
densityplot(~ ctr | age_cat, groups=Gender, auto.key=T, data=nyt_data, plot.points=F,
                  main="Distribution of CTR by Age Cat.")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-5.png)

```r
densityplot(~ ctr | age_cat, groups=Gender, auto.key=T, data=subset(nyt_data,ctr != 0), plot.points=F,
                  main="Distribution of Non-Zero CTR by Age Cat.")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-6.png)

```r
densityplot(~ ctr, groups=Signed_In, data=subset(nyt_data,ctr!=0), plot.points=F, auto.key=T,
            main="Distribution of Non-Zero CTR by Signed-In State")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-7.png)

```r
bwplot(age_cat ~ ctr | Gender, data=subset(nyt_data, ctr != 0), layout=c(1,3),
             main="Distribution of Non-Zero CTR by Age and Gender")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-8.png)

```r
rm(nyt_data)
```
