window.addEventListener("turbolinks:load", function(event) {
  $('.table').each(function(){
    var $table = $(this);
    if(($table.width() < 700) || ($table.width() > $table.parent().width())){
      table2Cards($table);
    }
  })
});


function table2Cards(table){
  var columns = table.find('thead th');
  table.find('tbody tr').each(function(){
    row2Cards($(this), columns).insertBefore(table);
  });
  table.detach();
}

function row2Cards(row, columns){
  var card = $('<div/>').addClass('table-card card');
  var cells = row.children('td')
  for(var i = 0; i < cells.length; i++){
    cell2Row($(cells[i]), $(columns[i])).appendTo(card);
  }
  return card;
}

function cell2Row(cell, column){
  return $('<div/>').addClass('level')
    .append($('<label/>').addClass('level-item-left column is-one-quarter').html(column.html()))
    .append($('<span/>').addClass('level-item-left column is-three-quarters').append(cell.contents().detach()));
}
