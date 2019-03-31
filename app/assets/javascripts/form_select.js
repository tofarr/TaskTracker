window.addEventListener("turbolinks:load", function(event) {
  $('select.input').each(function(){
    var $this = $(this);
    var search = $this.data('search');
    if(search){
      var excludeIds = $this.data('exclude-ids') || [];

      var attrs = {
        ajax: {
          url: '/' + search + '.json',
          processResults: function (data) {
            var results = data.map(function(result){
              return {
                id: result.id,
                text: result.identifier || result.title || result.username
              };
            });
            if(excludeIds.length){
              results = results.filter(function(result){
                return excludeIds.indexOf(result.id) < 0;
              });
            }
            return { results: results };
          }
        }
      };
      var allowClear = ($this.data('allow-clear') == "true");
      if(allowClear){
        attrs.placeholder = "No Value";
        attrs.allowClear = true;
      }
      var params = $this.data('params');
      if(params){
        attrs.data = params;
      }

      $this.select2(attrs);
    }
  });
});
