library(shiny)

#UI
ui <- fluidPage(

  #App title
  titlePanel("Simple Gantt Viewer"),

  #Main Panel
  fluidRow(
    plotOutput(outputId = "drawGantt",
               height=800,
               click = "gantt_click")
  ),

  #Info Panel
  fluidRow(
    column(width=6,           
           plotOutput(outputId = "fullGantt", 
                      brush=brushOpts(id="time_selector",direction="x"))
    ),
    column(width=6, 
           verbatimTextOutput("task_info")
    )
  )
)
ranges=reactiveValues(x=NULL, y=NULL)
#Server
server <- function(input,output) {
  output$drawGantt <- renderPlot({print_trace(gantt)+coord_cartesian(xlim= ranges$x)})

  output$fullGantt <- renderPlot({print_trace(gantt)})

  output$task_info <- renderPrint({
    tmp=nearPoints(gantt, input$gantt_click, xvar="StartTime", yvar="RessourceId")
    tmp[,c("JobId","Name","RessourceId","StartTime","Duration")]
  })

  observe({
    brush <- input$time_selector
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
    }
  })
 
}

shinyApp(ui=ui, server=server)