window.addEventListener("turbolinks:load", function(event) {

  $('.img-upload').each(function(){
    //Actual image will be submitted in a hidden form element
    var imgUploadField = document.createElement('input');
    imgUploadField.type = 'hidden';
    imgUploadField.name = this.name;
    imgUploadField.className = 'img-upload-field';
    this.removeAttribute('name');
    this.parentNode.append(imgUploadField)

  }).change(function(){ // when the file upload value changes...
    var $container = $(this).parent('.form-img-container');

    //Remove existing prview image
    $container.find('.image, .crop-container').fadeOut('slow', function(){
      $(this).remove();
    });

    //Read the file
    if (this.files && this.files[0]) {
      var $input = $(this);
      var reader = new FileReader();
      reader.onload = function(e) {

        //Create an image
        var $img = $('<img/>')
          .addClass('crop-image')
          .on('load', function(){

            //Add the image to the DOM
            var $cropContainer = $('<div/>')
              .addClass('crop-container')
              .append($img)
              .appendTo($container)
              .hide()
              .fadeIn('slow');

            //Initialize croppie
            var cropSize = parseInt($container.data('crop-size'));
            var croppie = new Croppie($img[0], {
              viewport: { width: cropSize, height: cropSize },
              showZoomer: true,
              enableResize: true,
              enableOrientation: true,
              update: function (data) {
                clearTimeout(this.debounce);
                this.debounce = setTimeout(function(){
                  this.result('base64').then(function(dataImg) {
                    $cropContainer.parent('.form-img-container').find('.img-upload-field').val(dataImg);
                  });
                }.bind(this), 200);
              }
            });

          }).attr('src', e.target.result);

      }
      reader.readAsDataURL(this.files[0]);
    }

  }).each(function(){

    //Trigger change if a file is initially in place (TODO: can this happen?)
    if(this.files && this.files[0]){
      $(this).trigger('change');
    }
  })

});
