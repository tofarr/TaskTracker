window.addEventListener("turbolinks:load", function(event) {
  $('fieldset.hidden-default').each(function(){
    $(this).children('legend').on('click', function(){
      var $this = $(this);
      var $icon = $this.find('i');
      var $fieldset = $this.parent('fieldset.hidden-default');
      var $toggle = $fieldset.children('.hidden-default-inner');
      if($icon.hasClass('fa-caret-down')){
        $fieldset.addClass('collapsed');
        $icon.removeClass('fa-caret-down').addClass('fa-caret-up');
        $toggle.slideUp('slow');
      }else{
        $fieldset.removeClass('collapsed');
        $icon.removeClass('fa-caret-up').addClass('fa-caret-down');
        $toggle.slideDown('slow');
      }
    }).addClass('button').prepend($('<span class="icon is-small"><i class="fas fa-caret-up"></i></span>'))
    $(this).addClass('collapsed').children('.hidden-default-inner').hide();
  });
});
