library(shiny)

shinyServer(function(input, output, session) {
  rv <- reactiveValues(wave = NULL, recording = FALSE, range=c(0,0))
  
  observeEvent(input$startRecordingButton, {
    session$sendCustomMessage(type = "startRecording", message = list())
    rv$recording <- TRUE
  })
  
  observeEvent(input$stopRecordingButton, {
    session$sendCustomMessage(type = "stopRecording", message = list())
    rv$recording <- FALSE
    #rv$wave <- NULL
  })
  
  observeEvent(input$debug, {
    browser()
  })
  
  # Reactive expression for audio data update
  audio_data <- eventReactive(input$audioData, {
    if (!is.null(input$audioData)) {
      audioData <- as.numeric(input$audioData$data)
      audioData
    } else {
      NULL
    }
  })
  
  output$recstatus <- renderUI(if(rv$recording) span('Recording') else span('Not recording'))
  
  # Observer to update the wave data and plot
  observe({
    req(rv$recording)
    rv$wave <- audio_data()
    range <- isolate(rv$range <- range(c(rv$range,rv$wave)))
    output$wavePlot <- renderPlot({
      if (!is.null(rv$wave)) {
        plot(rv$wave, type = "l", col = "blue", main = "Audio Waveform",
             xlab = "Time (samples)", ylab = "Amplitude", ylim=range)
      } else {
        plot(1, type = "n", xlab = "", ylab = "", main = "Audio Waveform")
        text(1, 1, "No data")
      }
    })
  })
  
  session$onSessionEnded(function() {
    session$sendCustomMessage(type = "stopRecording", message = list())
    rv$recording <- FALSE
  })
})
