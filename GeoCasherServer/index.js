var Hapi = require('hapi');
var sleep = require('sleep');

// Create a server with a host and port
var server = new Hapi.Server();

server.connection({
    host: 'localhost',
    port: 8000
});

server.register(require('inert'), function (err) {

    if (err) {
        throw err;
    }

    server.route({
        method: 'GET',
        path: '/imagefeed.json',
        handler: function (request, reply) {
        // comment out next two lines for immediate server response
            var responseDelayInSeconds = 3
            sleep.sleep(responseDelayInSeconds);
            reply.file('./imagefeed.json');
        }
    });

    server.start(function (err) {

        if (err) {
            throw err;
        }

        console.log('Server running at:', server.info.uri);
    });
});