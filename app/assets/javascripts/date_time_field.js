window.addEventListener("turbolinks:load", function(event) {
  $('.input.date-time').flatpickr({
    enableTime: true,
    dateFormat: "Y-m-d H:i",
  });
});
