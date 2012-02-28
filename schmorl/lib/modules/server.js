//handles initializationof the server
//sets up sockets, listens for data and sends updates

var Spine = require("spine");
var Express = require('express');
var Sys = require("sys");
var Util = require('util');
var Socketio = require("socket.io");
    
Server = Spine.Class.create();
//var Server = Spine.Model.setup("Server", ["server_name"]);
Server.include({
  server_name: "Schmorl Game Engine",
  port: 8080,
  public_folder: "/srv/schmorl/public",
  app: null,

  start_server: function(server_name, path_to_public_folder, port)  {
    this.server_name = server_name
    this.public_folder = path_to_public_folder

    if(typeof(port) === 'undefined')  {
      port = this.port
    } else {
      this.port = port
    }
    
    app = Express.createServer();
    app.listen(port);

    //the this variable is not available inside of subfunctions, so aliasing
    var path = this.public_folder
    app.configure(function(){
      app.use(Express.methodOverride());
      app.use(Express.bodyParser());
      app.use(app.router);
      app.use(Express.static(path));
      app.use(Express.errorHandler({ dumpExceptions: true, showStack: true }));
    });
    this.app = app
    io = Socketio.listen(app);

    //the this variable is not available inside of subfunctions, so aliasing
    var sn = this.server_name
    io.sockets.on('connection', function(client) {
      client.emit("init_data", {
        server_name: sn
      });

      client.on('enter_command', function(message){
        console.log(message.command);
        //send to all clients
        io.sockets.emit("chat_message", {
          chat_data: client.id + ": " + message.command
        });
      });
      
      client.on('chcker_add', function(message)  {
        board_changes = game_board.process_user_input(client.id, message)
        io.sockets.emit("board_update", board_changes)

        score_updates = game_board.get_player_score_if_changed()
        io.sockets.emit("player_score_update", score_update)
      });

      client.on('disconnect', function(){
        //Sys.puts("client disconnected: "+client.sessionId);
        //socket.broadcast({ player_disconnected: client.sessionId });
        //delete players[client.sessionId];
      });
    });
  },
});
