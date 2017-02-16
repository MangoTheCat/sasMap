# Install packages
if (!require("devtools"))
  install.packages("devtools", repos = "http://cran.ma.imperial.ac.uk/")
if (!require("sasMap"))
  devtools::install_github("MangoTheCat/sasMap")
if (!require("shiny"))
  install.packages("shiny", repos = "http://cran.ma.imperial.ac.uk/")
if (!require("shinythemes"))
  install.packages("shinythemes", repos = "http://cran.ma.imperial.ac.uk/")
if (!require("shinyFiles"))
  install.packages("shinyFiles", repos = "http://cran.ma.imperial.ac.uk/")
if (!require("markdown"))
  install.packages("markdown", repos = "http://cran.ma.imperial.ac.uk/")
if (!require("visNetwork"))
  install.packages("visNetwork", repos = "http://cran.ma.imperial.ac.uk/")


# Load packages
library(shiny) 
library(shinythemes)
library(shinyFiles)
library(markdown)
library(visNetwork)
library(sasMap)

options(width = 80)
