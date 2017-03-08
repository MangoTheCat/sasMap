function(input, output, session) { 

  # dir
  shinyDirChoose(input, 
                 'dir', 
                 roots = c(home = '~'),
                 filetypes = c('', 'txt', 'sas', 'SAS'))
  
  # path
  path <- reactive({
    if (input$localCheck) {
      home <- normalizePath("~")
      file.path(home, paste(unlist(input$dir$path[-1]),
        collapse = .Platform$file.sep))
    } else {
      system.file('examples/SAScode', package='sasMap')
    }
   
  })
  
  # Print path
  output$printpath <- renderPrint(path())
  
  #---------------------------------
  # Stats Summmary Tab
  output$stats_summary <- renderTable({
    req(path())
    parseSASfolder(path())
  })
  
  # Prco Tab - list procs and draw bar plot
  output$list_procs <- renderTable({ 
    listProcs(path())
  }) 
  
  output$plot_procs <- renderPlot({
    validate(
      need(path(), "Please choose a folder")
    )
    drawProcs(path())
  })
  
  #---------------------------------
  # Plot static network
  output$plot_nw <- renderPlot({
    validate(
      need(path(), "Please choose a folder")
    )
    net <- renderNetwork(path())
    plotSASmap(net)
  })
  
  #---------------------------------
  # Plot interactive network
  output$plot_nw_js <- renderVisNetwork({
    validate(
      need(path(), "Please choose a folder")
    )
    plotSASmapJS(path())
  })
  
  
  
  #---------------------------------
  # Parse sas script
  scriptFile <- reactive({
    ## Shout or silent if no file uploaded?
    #validate(
    #  need(input$uploadFile, "Please upload a SAS script")
    #)
    req(input$uploadFile)
    input$uploadFile$datapath
  })
  
  dat <- reactive({
    trim <- function(x) gsub("^\\s+|", "", x)
    out <- trim(scan(scriptFile(), what = character(), sep = "\n",
                     quiet = TRUE))
    return(out)
  })
  
  output$text1 <- renderPrint({
    validate(
      need(scriptFile(), "Please upload a SAS script")
    )
    dat()
  })
  
  parsed <- reactive({
    parseSASscript(scriptFile(), output='data.frame')
  })
  
  output$table1 <- renderTable({ 
    parsed()
  })

  
  output$plot1 <- renderPlot({
    drawProcs(scriptFile())
  })
  
}