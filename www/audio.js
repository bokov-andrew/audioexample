let audioContext;
let microphone;
let scriptProcessor;
let recording = false;

$(document).ready(function() {
  // Add event listener for starting recording
  $("#startRecordingButton").click(function() {
    if (!recording) {
      startRecording();
    }
  });

  // Add event listener for stopping recording
  $("#stopRecordingButton").click(function() {
    if (recording) {
      stopRecording();
    }
  });
});

Shiny.addCustomMessageHandler("startRecording", function(message) {
  if (!recording) {
    startRecording();
  }
});

Shiny.addCustomMessageHandler("stopRecording", function(message) {
  if (recording) {
    stopRecording();
  }
});

function startRecording() {
  recording = true;

  if (!audioContext) {
    audioContext = new (window.AudioContext || window.webkitAudioContext)();
  }
  
  navigator.mediaDevices.getUserMedia({ audio: true })
    .then(stream => {
      microphone = audioContext.createMediaStreamSource(stream);
      scriptProcessor = audioContext.createScriptProcessor(4096, 1, 1);

      scriptProcessor.onaudioprocess = function(event) {
        const audioData = event.inputBuffer.getChannelData(0);
        Shiny.setInputValue("audioData", { data: Array.from(audioData) }, { priority: "event" });
      };

      microphone.connect(scriptProcessor);
      scriptProcessor.connect(audioContext.destination);
    })
    .catch(err => {
      console.error('Error accessing microphone: ', err);
      recording = false;
    });
}

function stopRecording() {
  if (microphone) {
    microphone.disconnect();
    scriptProcessor.disconnect();
    microphone = null;
    scriptProcessor = null;
  }

  recording = false;
}
