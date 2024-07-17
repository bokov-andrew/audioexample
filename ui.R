library(shiny)

shinyUI(fluidPage(
  titlePanel("Real-time Audio Oscilloscope"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Controls"),
      
      # Recording Buttons
      actionButton("startRecordingButton", "Start Recording", 
                   icon = icon("microphone"), 
                   class = "btn-primary"),
      actionButton("stopRecordingButton", "Stop Recording", 
                   icon = icon("stop"), 
                   class = "btn-danger"),
      actionButton("debug", "Debug", 
                   icon = icon("bug")),
      
      hr(),
      
      # Recording Status
      uiOutput('recstatus'),
      
      hr(),
      
      # Help Text
      h4("Instructions:"),
      p("1. Click 'Start Recording' to begin capturing audio."),
      p("2. Click 'Stop Recording' to end the session."),
      p("3. Use 'Debug' for troubleshooting issues.")
    ),
    
    mainPanel(
      tags$canvas(id = "animationCanvas", width = 800, height = 600, style = "border:1px solid #000000;")
    )
  ),
  tags$script(src = "audio.js"),
  tags$script(src = "sprite.js")
))
