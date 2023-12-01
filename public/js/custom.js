function initializeChoices() {
  let choices_elems = document.querySelectorAll('.js-choice');

  if (choices_elems.length > 0) {
    const choices = new Choices('.js-choice');
  }
}

function initializeTippy() {
  tippy('[data-tippy-content]');
}

function reinitializeJs() { 
  initializeTippy();
  initializeChoices();
}

document.addEventListener("DOMContentLoaded", function(event){
  reinitializeJs();
  Dropzone.autoDiscover = false;
});

// add an event listener for the htmx afterRequest event
document.addEventListener("htmx:afterRequest", function(event) {
  reinitializeJs();
});
