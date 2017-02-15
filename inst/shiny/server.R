function(input, output, session) { 

  # dir
  shinyDirChoose(input, 
                 'dir', 
                 roots = c(home = '~'), 
                 filetypes = c('', 'txt'))
  dir <- reactive(input$dir)
  
  # path
  path <- reactive({
    home <- normalizePath("~")
    file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
  })
  
  # files
  output$files <- renderPrint(path())
    
  
  #---------------------------------
  # Stats Summmary Tab
  output$stats_summary <- renderTable({ 
    parseSASfolder(path())
  })
  
  # Prco Tab - list procs and draw bar plot
  output$list_procs <- renderTable({ 
    listProcs(path())
  }) 
  
  output$plot_procs <- renderPlot({
    validate(
      need(input$dir, "Please choose a folder")
    )
    drawProcs(path())
  })
  
  #---------------------------------
  # Plot static network
  output$plot_nw <- renderPlot({
    validate(
      need(input$dir, "Please choose a folder")
    )
    net <- renderNetwork(path())
    plotSASmap(net)
  })
  
  # Plot interactive network
  output$plot_nw_js <- renderVisNetwork({
    validate(
      need(input$dir, "Please choose a folder")
    )
    plotSASmapJS(path())
  })
  
  
  
  #---------------------------------
  # Parse sas script
  dat <- reactive({ #eventReactive(input$go, 
    if (is.null(input$uploadFile)) return(NULL)

    trim <- function(x) gsub("^\\s+|", "", x)
    out <- trim(scan(input$uploadFile$datapath, what = character(), sep = "\n",
                     quiet = TRUE))
    return(out)
  })
  
  output$text1 <- renderPrint({
    validate(
      need(input$uploadFile, "Please upload a SAS script")
    )
    dat()
  })
  
  parsed <- reactive({
    validate(
      need(input$uploadFile != "", "Please select a script")
    )
    parseSASscript(input$uploadFile$datapath, output='data.frame')
  })
  
  output$table1 <- renderTable({ 
    parsed()
  })
  
  output$plot1 <- renderPlot({
    validate(
      need(input$uploadFile != "", "Please select a script")
    )
    drawProcs(input$uploadFile$datapath)
  })
  

  output$script <- renderUI({
    includeMarkdown(paste0("md/script_", input$inputCase, ".md"))
  })
  
  output$sasoutput <- renderUI({
    includeHTML(paste0("md/SAS Output_", input$inputCase, ".htm"))
  })  
  
  ###
    
  r_example <- "# Example 41.2 Regression with Mileage Data
# https://support.sas.com/documentation/cdl/en/statug/63962/HTML/default/viewer.htm#statug_glm_sect048.htm
# Type 1 error
mileage <- read.csv('data/m.csv', header = TRUE)
res1 <- lm(mpg ~ mph + I(mph^2), data = mileage)
summary(res1)
anova(res1)

# Type 3 error
options(contrasts=c('contr.sum','contr.poly'))
res2 <-lm(mpg ~ mph + I(mph^2), data = mileage) 
summary(res2)
anova(res2)
"
  #------------------------- 
  #-r
  output$rcode <- renderUI({
    div(class="col", 
      div(class="row-xs-6",
          shinyAce::aceEditor("r_code", mode="r",
                              value = r_example
          ),
          actionButton("rEval", "Run", icon = icon("rocket"))
      ),
      div(class = "row-xs-1", br()),
      div(class="row-xs-6", htmlOutput("rCodeEval"))
    )
  })
  
  # evaluate R code when button is clicked
  output$rCodeEval <- renderPrint({
    if (input$rEval == 0) return()
    isolate({
      
      r_code <- input$r_code
      r_output <- paste0("```{r cache = FALSE, echo = TRUE}\n",r_code,"\n```")
      return(HTML(paste(knitr::knit2html(text = r_output, fragment.only = TRUE, quiet = TRUE),
                        '<script>', 'MathJax.Hub.Typeset();', '</script>', sep = '\n')))
    })
  })
    
}

