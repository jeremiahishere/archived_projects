exports.Server = require("./lib/modules/server.js").Server
var server = Server.init();
var server_name = "jeremiahs engine"
var path_to_public = __dirname + "/public"
var port = 8080
server.start_server(server_name, path_to_public, port);
