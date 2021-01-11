//SETTING STATIC NAMES
const SERVER_PORT = 4000
const db = require('./db')
console.log('directors to send when needed:')
db.getAllDirectors().then(data=>{
  console.log(data)
}).catch(err=>{
  console.error(`Error: ${err.message}`)
})
//SETTING SERVER
const express = require('express');
const bodyParser = require('body-parser');
const app = express()
app.use(bodyParser.json());
app.get('/', (req, res) => res.send('server is on air!\n'))
app.get('/directors', (req, res) => {
  db.getAllDirectors()
  .then(directors=> res.json(directors))
  .catch(err=> console.error(`Err: ${err.message}`))
});

console.log('Started!')
//START THE SERVER
app.listen(SERVER_PORT);
console.log(`Server is listenning on port ${SERVER_PORT}`);


