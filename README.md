# sasMap

[![Travis-CI Build Status](https://travis-ci.org/MangoTheCat/sasMap.svg?branch=master)](https://travis-ci.org/MangoTheCat/sasMap)

> Static code analysis for SAS scripts
* Extract counts of proc and data steps
* Summarise SAS files

## Usage
```R

library(sasMap)

sasPath <- system.file('examples/SAScode/Macros/fun2.SAS', package='sasMap')
summariseSASScript(sasPath)

```