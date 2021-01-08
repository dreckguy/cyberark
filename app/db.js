const COLLECTION_NAME = 'famous-directors'
const {DB_URL} = process.env
console.log(`set DB URL as ${DB_URL}`)
const FAMOUS_DIRECTORS = require('./famous-directors.json')
//SETTING DB
const Database = require('arangojs').Database;
const db = new Database(DB_URL);
const collection = db.collection(COLLECTION_NAME);

exports.loadDbWithData = function(){
    console.log('loading famous directors to db')
    collection.create(COLLECTION_NAME).then(
            () => {
            console.log('Collection created')
            const film = {director: "David Lynch",film: "Lost Highway"}
            collection.save(FAMOUS_DIRECTORS).then(
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
