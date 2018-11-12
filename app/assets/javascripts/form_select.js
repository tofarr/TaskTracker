window.addEventListener("turbolinks:load", function(event) {
  $('select.input').each(function(){
    var $this = $(this);
    var search = $this.data('search');
    if(search){
      var excludeIds = $this.data('exclude-ids') || [];
      $this.select2({
        ajax: {
          url: '/' + search + '.json',
          processResults: function (data) {
            var results = data.map(function(result){
              return {
                id: result.id,
                text: result.title || result.username
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
      });
    }
  });
});
