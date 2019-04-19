window.addEventListener("turbolinks:load", function(event) {
  $('.assign-to-me').each(function(){
    $('<button type="button" class="button">Assign to Me</button>')
      .click(function(){
        var $assignToMe = $(this).parent('.assign-to-me');
        var newOption = new Option($assignToMe.data('user-title'), $assignToMe.data('user-id'), false, false);
        $(this).parent().find('select')
          .append(newOption)
          .val($assignToMe.data('user-id'))
          .trigger('change');
      }).appendTo($(this));
  });
});
