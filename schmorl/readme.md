Beginnings of a spine+node.js game framework.

To install, install npm on your system, the install express, spine, and stitch.  To start the server type node index.js.  Spine seems to randomly need more npm packages, just read the error messages and add news ones as necessary.  I have included my npm package information in the project to make things easier.  Not sure if it will work on other computers

need to make a symlink from /lib to /public/lib

game loop

- someone connects
  - gets a session id from the server
    - server updates its player list
  - gets a player object
  - send the session id of the player object to the server
  - gets the list of all objects in the game
    - uses it to populate their sidek

- player asynchronusly watch keypresses and send to server as soon as possible
  - send to server
  - also update own environment

- server running on a clock
  - collects all keystrokes from clients
  - sends them all out on every clock cycle

- someone disconnects
  - remove the session id from the server
  - push changes out on next clock cycle

see http://stackoverflow.com/questions/5481675/node-js-and-mutexes for javascript mutex strategy for a bounded buffer.
