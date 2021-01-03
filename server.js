//SETTING STATIC NAMES
const SERVER_PORT = 80
const db = require('./db')
//SETTING SERVER
const express = require('express');
const bodyParser = require('body-parser');
const app = express()
app.use(bodyParser.json());
app.get('/', (req, res) => res.send('server is on air!\n'))
app.get('/directors', (req, res) => {
    
  
  res.json(famousDirectors)
});

console.log('Started!')
//CREATE THE NEEDED DATA ON THE DB
db.prepareDB()
//START THE SERVER
app.listen(80);
console.log(`Server is listenning on port ${SERVER_PORT}`);


