SAS to R guide
==============

*Copied from the [asnr/sas-to-r](https://github.com/asnr/sas-to-r) GitHub Repository. To make a contribution or put together more use cases, you can fork the repo and make your own!*


### Reading instructions: 
* under each subheading, the first code block is SAS and the second code block is the R translation;
* <kbd>ctrl</kbd>+<kbd>F</kbd> is your friend.

`data step` 
-----------

#### Save data to disk ####

```SAS
data save_lib.save_ds;
    set in_lib.in_ds;
run;
```

```r
# Here save_lib is a string representing a directory. '.rda' is 
# sometimes used instead of '.RData'
save(in_ds, file=file.path(save_lib, "save_ds.RData"))
# To load in_ds back into the environment
load(file.path(save_lib, "save_ds.RData"))
```


#### Concatenate datasets ####

```SAS
data concatenated;
    set mydata1 mydata2;
run;
```

```r
# Note that if a factor variable in the two dataframes has different
# levels, then rbind will take the union of these levels
# while bind_rows will coerce the variable to string.
concatenated = rbind(mydata1, mydata2)
concatenated = dplyr::bind_rows(mydata1, mydata2)
```


#### Filter data or 'where' statement ####

```SAS
data out_ds;
    set in_ds;
    where gender = 'M' and age >= 18;
run;
```

```r
out_ds = in_ds[in_ds$gender == 'M' & in_ds$age >= 18, ]
# or with dplyr
out_ds = dplyr::filter(in_ds, gender == 'M', age >= 18)
```



`proc freq`
-----------

```SAS
proc freq data=mydata;
    tables myvar / nocol nopercent nocum;
run;
```

```r
table(mydata$myvar)
```


#### Sort by frequency ####
```SAS
proc freq order=freq data=mydata;
	tables myvar / nocol nopercent nocum;
run;
```

```r
sort(table(mydata$myvar), decreasing=TRUE)
```


#### With missing ####

```SAS
proc freq data=mydata;
    tables myvar / nocol nopercent nocum missing;
run;
```

```r
# only displays NA count if positive, to always include use "always"
table(mydata$myvar, useNA="ifany")
```


#### Percentages, missing & sorted by frequency ####

```SAS
proc freq data=mydata;
    tables myvar / nocol nopercent nocum missing;
run;
```

```r
# no concise way to combine counts w/ percentages in core R
counts = sort(table(mydata$myvar, useNA="ifany"), decreasing=True)
counts
prop.table(counts)

# we can do better with dplyr
library(dplyr)
pfreq = function(...) {
    group_by(...) %>%
        summarise(n=n()) %>%
        mutate(perc=paste0(round(100 * n/sum(n), 1), "%")) %>%
        arrange(desc(n))
}
pfreq(mydata, myvar)
```


`proc means`
------------

```SAS
proc means data=mydata min p25 median mean p75 max;
    var myvar;
run;
```

```r
summary(mydata$myvar)
```


#### More percentiles ####

```SAS
proc means data=mydata n mean std min max p1 p5 p10 p25 median p75 p90 p95 p99;
	var myvar;
run;
```

```r
quantile(mydata$myvar, c(0, 0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99, 1))
```


`proc sort`
-----------

```SAS
proc sort data=in_data out=out_data; by myvar1 descending myvar2; run;
```

```r
out_data = in_data[order(in_data$myvar1, -in_data$myvar2), ]
# or with dplyr
out_data = dplyr::arrange(in_data, myvar1, desc(myvar2))
```


#### Find duplicated rows ####

```SAS
proc sort data=mydata NODUPKEY out=_null_ dupout=dups; by _all_; run;
```

```r
dups = mydata[duplicated(mydata), ] 
# if you want to count duplicated rows: sum(duplicated(mydata))
```


#### Find duplicated values ####

```SAS
proc sort data=mydata NODUPKEY out=_null_ dupout=dups; by myvar; run;
```

```r
dups = mydata$myvar[duplicated(mydata$myvar)]
```


`proc print`
------------

```SAS
proc print data=mydata (obs=6);
run;
```

```r
head(mydata)
```



`proc contents`
---------------

```SAS
proc contents data=mydata;
run;
```

```r
str(mydata)
```


#### Save output ####

```SAS
proc contents noprint data=mydata out=contents;
run;
```

```r
contents = str(mydata)
```

`proc format`
-------------

#### Transform values according to a format ####
```SAS
proc format;
	value agefmt
	15-<21  = "15-20"
	21-<25  = "21-24"
	25-high = "25+"
	other   = " "
	;
run;

data out_ds;
	set in_ds;
	age_grouped=put(age, agefmt.);
run;
```

```r
out_ds$age_f = cut(out_ds$age, 
                   breaks=c(15, 21, 25, Inf),
                   right=FALSE,
                   labels=c("15-20", "21-24", "25+"), 
                   ordered_result=TRUE)
```


`Misc`
-------------

#### Number of rows in a datastep ####

```SAS
* haha nice try. Try this for size: http://www2.sas.com/proceedings/sugi26/p095-26.pdf;
```

```r
nrow(mydata)  # or NROW(mydata)
dim(mydata)   # lists the number of rows and columns in a dataframe
```


#### Capping a number ####

```SAS

```

```r
cap = function(x, xmin=-Inf, xmax=Inf) {
	# x = value to be capped (numeric, vectorised)
	# xmin = lower bound to be imposed on x (numeric)
	# xmax = upper bound to be imposed on x (numeric)
	pmax(xmin, pmin(x, xmax))
}
mydata$number_capped = cap(mydata$number, 10, 200000)
```

#### Linear models ####

```SAS

```

```r
fit = mgcv::gam(response ~ predictor, data=in_ds)
```
