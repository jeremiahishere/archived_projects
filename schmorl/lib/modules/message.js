//base message to communicate between the client and server

Message = Spine.Class.create();
Message.include({
  client_id: null
  message: null

  init: function(client_id, message)  {
    self.client_id = client_id
    self.message = message
  }
});
