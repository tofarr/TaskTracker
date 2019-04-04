window.addEventListener("turbolinks:load", function(event) {

  $('.form-upload').each(function(){
    var $container = $(this).parents('.form-upload-container');
    var $preview = $container.find('.form-img-preview img');
    if($preview.length){
      showCropButton($container);
    }
    $container.find('.crop-button').click(cropClicked);
    $container.data('field-name', $container.find('.form-upload').attr('name'));
  }).change(function(){ // when the file upload value changes...
    var $container = $(this).parents('.form-upload-container');
    $container.find('.form-img-preview').empty();
    if (this.files && this.files[0] && isImg(this.files[0].type)) {
      showCropButton($container);
      setPreview($container, this.files[0]);
    }else{
      hideCropButton($container);
      $container.find('.img-upload-field').remove();
      $container.find('.form-upload').attr('name', $container.data('field-name'));
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

function showCropButton($container){
  $container.find('.crop-button').removeClass('hidden');
}

function hideCropButton($container){
  $container.find('.crop-button').addClass('hidden');
}

function setPreview($container, file){
  var reader = new FileReader();
  reader.onload = function(e) {
    $('<img/>')
      .attr('src', e.target.result)
      .addClass('image')
      .appendTo($container.find('.form-img-preview'));
  }
  reader.readAsDataURL(file);
}

function cropClicked(event){

  var $container = $(event.target).parents('.form-upload-container');

  var $element = $('<div/>').addClass('cropper').html('<div class="croppie"></div>'+
  '<div class="level-item-center controls">'+
  '<button type="button" class="button cancel-button">Cancel</button>'+
  '<button type="button" class="button confirm-button is-info">Confirm</button>'+
  '</div>');

  var popup = new TPopup({
    classes: ['crop-popup','drop'],
    content: $element[0],
    outsideClickCloses: false
  });

  var $preview = $container.find('.form-img-preview img');
  var $croppie = $element.find('.croppie');

  var cropSize = parseInt($container.data('crop-size'));
  var croppie = new Croppie($croppie[0], {
    viewport: { width: (cropSize || ($croppie.width() - 50)), height: (cropSize || ($croppie.height() - 100)) },
    boundary: { width: $croppie.width(), height: $croppie.height() - 50 },
    showZoomer: true,
    enableResize: !cropSize,
    enableOrientation: true,
    url: $preview.attr('src')
  });

  $element.find('.cancel-button').click(function(){
    popup.close();
  });

  $element.find('.confirm-button').click(function(){
    croppie.result('base64').then(function(dataImg) {
      $preview.attr('src', dataImg);

      $container.find('.form-upload')[0].removeAttribute('name');

      var $input = $container.find('.img-upload-field');
      if(!$input.length){
        $input = $('<input/>')
          .attr('type', 'hidden')
          .attr('name', $container.data('field-name'))
          .addClass('img-upload-field')
          .appendTo($container);
      }
      $input.val(dataImg);

      popup.close();
    });
  });
}
