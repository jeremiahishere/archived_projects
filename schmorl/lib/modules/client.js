//handles initialization of the client
//sets up sockets
//requests initial board setup information
//maintains board state with the server

/*var Spine = require("spine");
var Express = require('express');
var Sys = require("sys");
var Util = require('util');
var Io = require("socket.io");*/

Client = Spine.Class.create();
Client.include({
  socket: null,
  //port probably unnecessary now
  port: 8080,
  init: function(port)  {
    if(typeof(port) === 'undefined')  {
      port = this.port
    } else {
      this.port = port
    }

    var socket = new io.connect()

    socket.on('connect', function(){ return true; });

    socket.on('disconnect', function(){ setTimeout(function() { document.location = document.location; }, 2000); });

    socket.on('init_data', function(message) {
      $('game_engine').innerHTML += message.server_name
    });

    socket.on('chat_message', function(message) {
      $('chat_history').innerHTML += "<br />" + message.chat_data
    });
    this.socket = socket

    /*
    document.addEventListener('keydown', function(e)  {
      e.preventDefault();
      //do something with the keydown event here
      socket.emit('keydown', {
        key_code: e.keyCode
      });
    }, false);*/

    document.addEventListener('keydown', function(e)  {
      if(e.keyCode == 13)  {
        socket.emit('enter_command', {
          command: $('console_input_text').value
        });
        $('console_input_text').value = ""
      }
    }, false);
  },
});
