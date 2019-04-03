window.addEventListener("turbolinks:load", function(event) {

  $('.form-upload').each(function(){
    //Actual image will be submitted in a hidden form element
    var imgUploadField = document.createElement('input');
    imgUploadField.type = 'hidden';
    imgUploadField.className = 'img-upload-field';
    this.parentNode.append(imgUploadField)

  }).change(function(){ // when the file upload value changes...
    var $container = $(this).parent('.form-img-container');
    var imgUploadField = $container.find('.img-upload-field')[0];

    //Remove existing prview image
    $container.find('.image, .crop-container').fadeOut('slow', function(){
      $(this).remove();
    });

    //Read the file
    if (this.files && this.files[0] && isImg(this.files[0].type)) {
      setName(imgUploadField, this);
      var reader = new FileReader();
      reader.onload = function(e) {

        var cropSize = parseInt($container.data('crop-size'));
        var resize = $container.data('resize');

        //Add the image to the DOM
        var $cropContainer = $('<div/>')
          .addClass('crop-container')
          .width(cropSize)
          .height(cropSize)
          //.append($img)
          .appendTo($container)
          .hide()
          .fadeIn('slow');

        //Initialize croppie
        var croppie = new Croppie($cropContainer[0], {
          viewport: { width: cropSize, height: cropSize },
          //boundary: { width: cropSize, height: cropSize },
          showZoomer: true,
          enableResize: resize,
          enableOrientation: true,
          update: function (data) {
            clearTimeout(this.debounce);
            this.debounce = setTimeout(function(){
              this.result('base64').then(function(dataImg) {
                $cropContainer.parent('.form-img-container').find('.img-upload-field').val(dataImg);
              });
            }.bind(this), 200);
          },
          url: e.target.result
        });

      }
      reader.readAsDataURL(this.files[0]);
    }else{
      setName(this, imgUploadField);
    }

  }).each(function(){

    //Trigger change if a file is initially in place (TODO: can this happen?)
    if(this.files && this.files[0]){
      $(this).trigger('change');
    }
  })

});

function isImg(mimeType){
  return mimeType == 'image/jpg'
    || mimeType == 'image/jpeg'
    || mimeType == 'image/png'
    || mimeType == 'image/gif';
}

function setName(addName, removeName){
  var name = addName.name || removeName.name;
  if(!addName.name){
    addName.name = name;
  }
  if(removeName.name){
    removeName.removeAttribute('name');
  }
}
