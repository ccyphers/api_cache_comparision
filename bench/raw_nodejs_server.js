const { createClient } = require('redis');

const redisClient = createClient();
const cacheKey = 'GET/cacheable-----d41d8cd98f00b204e9800998ecf8427e';


const http = require('node:http');

function startServer() {
  const server = http.createServer(async (req, res) => {
    if(req.url === '/cacheable') {
      const v = await redisClient.get(cacheKey);
      res.end(v);
    } else {
      res.end('');
    }
    
  });
  server.on('clientError', (err, socket) => {
    socket.end('HTTP/1.1 400 Bad Request\r\n\r\n');
  });
  server.listen(8082);
}

redisClient.connect().then(startServer)