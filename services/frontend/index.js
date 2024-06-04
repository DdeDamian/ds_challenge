const http = require('http');
const fs = require('fs');

// set the port to the environment variable PORT or 3000
// also set a custom environment variable MY_ENV_VAR
const port = process.env.PORT || 3000;
const my_env_var = process.env.MY_ENV_VAR || 'not_set';
const my_sec_var = process.env.MY_SECRET_VAR || 'not_set';


// Reads the config.json file
const configData = fs.readFileSync('config.json');
const config = JSON.parse(configData);

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end(`Hello, world! The value from config is: ${config.value}.\n The port is ${port}.\n This is and environment variable. ${my_env_var}.\n And this is a secret. ${my_sec_var}.\n`);
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});