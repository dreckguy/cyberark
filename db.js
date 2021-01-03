const COLLECTION_NAME = 'famous-directors'
const DB_URL = 'http://127.0.0.1:8529'
const famousDirectors = require('./famous-directors.json')
//SETTING DB
const Database = require('arangojs').Database;
const db = new Database(DB_URL);
const collection = db.collection(COLLECTION_NAME);

exports.prepareDB = function(){
    console.log('Init!')
    collection.create(COLLECTION_NAME).then(
            () => {
            console.log('Collection created')
            const film = {director: "David Lynch",film: "Lost Highway"}
            collection.save(famousDirectors).then(
                meta => {
                  console.log(`created needed data on DB!`)
                }
              );
            }
          ).catch(err=>{
              console.error(`Error: ${err.message}`)
          })
}

exports.getAllDirectors = async function(){
    const data = await collection.all()
    const directors = data._result.map(object => ({director:object.director,film:object.film}))
    return directors
}

exports.getAllDirectors().then(data=>{
    console.log(data)
}).catch(err=>console.error(`Err: ${err.message}`))

