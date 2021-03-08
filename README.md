# sasMap

<<<<<<< HEAD
[![Travis-CI Build Status](https://travis-ci.com/PolloPequeno/sasMap.svg?branch=Pollo)](https://travis-ci.com/github/PolloPequeno/sasMap) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/sasMap)](http://cran.r-project.org/package=sasMap) [![](http://cranlogs.r-pkg.org/badges/sasMap)](http://cran.rstudio.com/web/packages/sasMap/index.html) [![Coverage Status](https://img.shields.io/codecov/c/github/MangoTheCat/sasMap/master.svg)](https://codecov.io/gh/MangoTheCat/sasMap)
=======
[![Travis-CI Build Status](https://travis-ci.org/MangoTheCat/sasMap.svg?branch=master)](https://travis-ci.org/MangoTheCat/sasMap) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/sasMap)](http://cran.r-project.org/package=sasMap) [![](http://cranlogs.r-pkg.org/badges/sasMap)](http://cran.rstudio.com/web/packages/sasMap/index.html) [![Coverage Status](https://img.shields.io/codecov/c/github/MangoTheCat/sasMap/master.svg)](https://codecov.io/gh/MangoTheCat/sasMap)
>>>>>>> parent of b1664e4 (Update README.md)


> Static code analysis for SAS scripts

* Extract counts of proc and data steps

* Summarise SAS files

## Usage
```R

library(sasMap)

sasPath <- system.file('examples/SAScode/Macros/fun2.SAS', package='sasMap')
summariseSASScript(sasPath)

```