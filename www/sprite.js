let canvas = document.getElementById("animationCanvas");
let context = canvas.getContext("2d");
let spriteY = canvas.height / 2;
let spriteSpeed = 0;
let spriteImage = new Image();
spriteImage.src = "sprite.png";  // Ensure this file is in the www directory

Shiny.addCustomMessageHandler("updateSprite", function(message) {
  let pitch = message.pitch;

  // Adjust sprite speed based on pitch (higher pitch = higher speed)
  spriteSpeed = pitch / 10;
});

function animateSprite() {
  context.clearRect(0, 0, canvas.width, canvas.height);

  // Update sprite position
  spriteY = spriteSpeed;
  if (spriteY < 0) spriteY = 0;
  if (spriteY > canvas.height) spriteY = canvas.height; 

  // Draw sprite
  context.drawImage(spriteImage, canvas.width / 2 - 25, spriteY - 25, 50, 50);

  requestAnimationFrame(animateSprite);
}

spriteImage.onload = function() {
  animateSprite();
}