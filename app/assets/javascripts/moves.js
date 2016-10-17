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
      placeMove(target,'red');
    });

  });

  // function runs on page load and populates the moves for the current game
  (function() {
    var get_url = application_url+application_path+'/moves.json';
    $.get(get_url, function(response){
      for(var i = 0; i < response.length; i++) {
        placeMove($(response[i].selector),'red');
      }
    });
  })();


  var placeMove = function(elem, color){
    elem.css({'background-color': color});
  }
});

