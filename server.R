library(shiny)

shinyServer(function(input, output, session) {
  rv <- reactiveValues(pitch = NULL, recording = FALSE)
  
  observeEvent(input$startRecordingButton, {
    session$sendCustomMessage(type = "startRecording", message = list())
    rv$recording <- TRUE
  })
  
  observeEvent(input$stopRecordingButton, {
    session$sendCustomMessage(type = "stopRecording", message = list())
    rv$recording <- FALSE
    #rv$pitch <- NULL
  })
  
  observeEvent(input$debug, {
    browser()
  })
  
  # Reactive expression for audio data update
  # audio_data <- eventReactive(input$audioData, {
  #  if (!is.null(input$audioData)) {
  #    audioData <- as.numeric(input$audioData$data)
  #    audioData
  #  } else {
  #    NULL
  #  }
  #})
  
  output$recstatus <- renderUI(if(rv$recording) span(paste('Recording:',rv$pitch)) else span('Not recording'))
  
  # Observer to update the wave data and plot
  observe({
    rv$pitch <- input$pitchData
    
    if (rv$recording) {
      session$sendCustomMessage(type = "updateSprite", message = list(pitch = rv$pitch))
    }
  })
  
  session$onSessionEnded(function() {
    session$sendCustomMessage(type = "stopRecording", message = list())
    rv$recording <- FALSE
  })
})
