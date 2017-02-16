fluidPage(
  theme = shinytheme("united"),
  #shinythemes::themeSelector(),
  navbarPage(
    "sasMap - Function Map for SAS",
    tabPanel(
      "sasMap",
      sidebarPanel(
        helpText(
          "This shiny application gathers functionality with the aim to ease your migration, 
          conversion, transformation or parallel programming with SAS and R. The bulk of it is
          the sasMap R package, which carries out static code analysis for SAS by 
          extracting summary information of procs, data steps and macro calls etc., and 
          visualizing script/macro dependencies. For more customized
          output, you may want to run the sasMap funcions in an R IDE, e.g. RStudio.
          Hope it makes your journey more of a breeze."),
        helpText(a("Take a look at sasMap GitHub repo -> .->", href = "https://github.com/MangoTheCat/sasMap", target = "_blank")),
        hr(),
        helpText(""),
        checkboxInput("localChek", "I want to specify a local directory (Warning: It only works when running the shiny app from a local machine).", value = FALSE),
        conditionalPanel(
          "input.localChek == true",
          shinyDirButton("dir", "Chose directory", "Specify a local directory")
        ),
        helpText("sasMap is reading this directory:"),
        verbatimTextOutput("printpath")
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Stats Summary", 
                   tableOutput("stats_summary")),
          tabPanel("Procs", 
                   br(),
                   fluidRow(
                     column(width = 3,
                            tableOutput("list_procs")
                     ),
                     column(width = 9, 
                            plotOutput("plot_procs", height = "400px", width = "400px"))
                     )
                   ),
          tabPanel("Function Map (Static)", 
                   plotOutput("plot_nw", height = 600, width = 750)),
          tabPanel(
            #tags$head(
            #  tags$style(HTML(" #plot_nw_js { height:90vh !important; } "))
            #),
            "Function Map (interactive)", br(), visNetworkOutput("plot_nw_js")
          )
        )
      ),
      icon = icon("share-alt")
    ),
    tabPanel(
      "Reference", 
      includeMarkdown("md/guide.md"),
      icon = icon("info")
    ),
    tabPanel(
      "Script parser",
      sidebarPanel(
        fileInput('uploadFile', 'Upload a SAS Script', multiple=TRUE,
                  accept=c('.sas', '.SAS', 'text/comma-separated-values, text/plain')) 
      ),
      mainPanel(
        verbatimTextOutput("text1"),
        tableOutput("table1"),
        plotOutput("plot1", height = "400px", width = "400px")
      ),
      icon = icon("file-code-o")
    )
  ),
  hr(),
  includeMarkdown("md/footer.md")
)
