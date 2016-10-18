// function runs on page load and populates the moves for the current game
(function() {
  var get_url = application_url+application_path+'/moves.json';
  $.get(get_url, function(response){
    for(var i = 0; i < response.length; i++) {
      var color = response[i].cpu ? 'pink' : 'red';
      placeMove($(response[i].selector), color );
    }
  });
})();


var placeMove = function(elem, color){
  return elem.css({'background-color': color});
}
