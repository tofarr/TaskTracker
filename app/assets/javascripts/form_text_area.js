window.addEventListener("turbolinks:load", function(event) {
  var textareas = document.getElementsByClassName('textarea');
  for(var t = 0; t < textareas.length; t++){
    new SimpleMDE({ element: textareas[t] });
  }
});
