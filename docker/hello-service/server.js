var http = require('http');
var url = require('url');

const salutation = process.env.SALUTATION;

var handleRequest = function(request, response) {
  console.log('Received request for URL: ' + request.url);
  response.writeHead(200);

  var q = url.parse(request.url, true).query;
  response.end(salutation + ' ' + (q.name || 'World') + '!');
};
var www = http.createServer(handleRequest);
www.listen(8000);
