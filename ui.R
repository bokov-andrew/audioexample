library(shiny)

shinyUI(fluidPage(
  titlePanel("Real-time Audio Oscilloscope"),
  sidebarLayout(
    sidebarPanel(
      actionButton("start", "Start Recording"),
      actionButton("stop", "Stop Recording"),
      actionButton("debug", "debug"),
      hr(),
      uiOutput('recstatus')
    ),
    mainPanel(
      plotOutput("wavePlot")
    )
  ),
  tags$script(src = "audio.js")
))
