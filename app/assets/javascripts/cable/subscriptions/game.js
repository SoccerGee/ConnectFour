App.cable.subscriptions.create({
  channel: "GameChannel",
}, {
  recieved: function(data){ console.log(data); }
});
