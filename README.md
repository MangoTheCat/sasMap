# sasMap

> Function map for SAS scripts.

- Extract counts of procs and data steps
- Draw a barplot of proc calls jio uio 
- Plot static and interactive network of script dependency


## Installation
Installation from github requires the devtools package to be installed.

```R
# Install sasMap from github
devtools::install_github("MangoTheCat/sasMap")
```
## Usage
```R
# Parse SAS folder
library(sasMap)
sasDir <- system.file('examples/SAScode', package='sasMap')
sasCode <- parseSASfolder(sasDir)

# Draw frequency of proc calls
drawProcs(sasCode$Procs)

# Draw network of SAS scripts. A pdf file can be created by specifying the file name.
net <- renderNetwork(sasDir)
plotSASmap(net, pdffile='static_sas_map.pdf', width=10, height=10)

# Draw basic force directed network graphics using D3 JavaScript library
plotSASmapJS(funData=sasCode)
```

## Licence
GPL 2 © [Mango Solutions](https://github.com/mangothecat)