# sasMap

> Function map for SAS scripts.

- Extract counts of procs and data steps
- Draw a barplot of proc calls
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

# Write sas code stats to csv  
write.csv(sasCode, 'sasCode.csv', row.names = FALSE)

# List counts of proc calls
listProcs(sasCode$Procs)
 
# Draw frequency of proc calls
drawProcs(listProcs(sasCode$Procs))
```

<img src="inst/examples/figs/Proc calls.png" alt="Proc Calls Overview" />

```R
# Draw network of SAS scripts. A pdf file can be created by specifying the file name.
net <- renderNetwork(sasDir)
plotSASmap(net, pdffile='static_sas_map.pdf', width=10, height=10)

# Draw basic force directed network graphics using D3 JavaScript library
plotSASmapJS(funData=sasCode)
```
<img src="inst/examples/figs/SAS script network.png" alt="Script Calls Network" />

## Licence
GPL 2 © [Mango Solutions](https://github.com/mangothecat)