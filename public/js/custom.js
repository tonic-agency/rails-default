
function showModal() {
  var mainModal = document.querySelector('#main-modal'); 
  mainModal.classList.remove('hidden');
} 

function closeModal() {
  var mainModal = document.querySelector('#main-modal'); 
  mainModal.classList.add('hidden');
}

const choices = new Choices('.js-choice');

function initializeTooltips() {
  tippy('[data-tippy-content]');
}

function getData() {

}

function reinitializeJs() { 
  initializeTooltips();
}

document.addEventListener("DOMContentLoaded", function(event){
  reinitializeJs();
});

// add an event listener for the htmx afterRequest event
document.addEventListener("htmx:afterRequest", function(event) {
  reinitializeJs();
});
