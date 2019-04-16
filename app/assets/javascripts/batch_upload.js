window.addEventListener("turbolinks:load", function(event) {

  $('.batch-file').each(function(){
    var $this = $(this);
    var name = $this.attr('name');
    var $select = $('<select name="data_content_type"><option value="upload">File Upload</option><option value="application/json">JSON Input</option><option value="text/csv">CSV Input</option></select>');
    $select.insertBefore(this).select2({
      allowClear: false,
      minimumResultsForSearch: -1
    }).on('change', function(){
      var parent = $(this).parent();
      var $textarea = parent.find('textarea');
      var $input = parent.find('input');
      var name = $textarea.attr('name') || $input.attr('name');
      if(this.value == 'upload'){
        $textarea.hide('fast')[0].removeAttribute('name');
        $input.show('fast').attr('name', name);
      }else{
        $input.hide('fast')[0].removeAttribute('name');
        $textarea.show('fast').attr('name', name);
      }
    });
    var textarea = $('<textarea></textarea>').addClass('txt').hide().on('input', function(){
      this.style.height = "";
      this.style.height = (this.scrollHeight + 10) + "px";
    }).appendTo($this.parent());

  });
});
