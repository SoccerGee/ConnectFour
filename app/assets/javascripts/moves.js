$(document).ready(function(){

  // When a user clicks a tile on the board to make a new move
  $('.board td').on('click',function(e){
    var target = $(e.target);
    var post_url = application_url+application_path+'/moves.json';
    var data = {
      x_loc : parseInt(target.attr('class')),
      y_loc : parseInt(target.closest('tr').attr('class'))
    };

    $.post(post_url, { move: data }, function(response){
      if(response.move) {
        var user_dom = getDomFromMove(response.move.x_loc, response.move.y_loc);
        placeMove(user_dom,'red');
      }
      if(response.cpu_move) {
        var cpu_dom = getDomFromMove(response.cpu_move.x_loc, response.cpu_move.y_loc);
        placeMove(cpu_dom,"black");
      }
    });

  });


  var getDomFromMove = function(x,y){
    return $('.board tr.'+y+' td.'+x);
  }
});

