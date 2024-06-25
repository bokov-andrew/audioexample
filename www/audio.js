let audioContext;
let microphone;
let scriptProcessor;

Shiny.addCustomMessageHandler("startRecording", function(message) {
  startRecording();
});

Shiny.addCustomMessageHandler("stopRecording", function(message) {
  stopRecording();
});

function startRecording() {
  if (!audioContext) {
    audioContext = new (window.AudioContext || window.webkitAudioContext)();
  }
  
  navigator.mediaDevices.getUserMedia({ audio: true })
    .then(stream => {
      microphone = audioContext.createMediaStreamSource(stream);
      scriptProcessor = audioContext.createScriptProcessor(4096, 1, 1);
      
      scriptProcessor.onaudioprocess = function(event) {
        const audioData = event.inputBuffer.getChannelData(0);
        Shiny.setInputValue("audioData", { data: Array.from(audioData) });
      };
      
      microphone.connect(scriptProcessor);
      scriptProcessor.connect(audioContext.destination);
    })
    .catch(err => console.error('Error accessing microphone: ', err));
}

function stopRecording() {
  if (microphone) {
    microphone.disconnect();
    scriptProcessor.disconnect();
    microphone = null;
    scriptProcessor = null;
  }
}
