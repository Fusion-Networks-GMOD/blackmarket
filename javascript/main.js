const express = require('express');
const mysql = require('mysql');
const cors = require('cors');
const crypto = require('crypto');
const atob = require('atob');
const os = require('os');
const request = require('request');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const pool = mysql.createPool({
  host: '',
  user: '',
  password: '',
  database: '',
});

function getServerIP() {
    const networkInterfaces = os.networkInterfaces();

    for (let interfaceName in networkInterfaces) {
        const interface = networkInterfaces[interfaceName];

        for (let interfaceInfo of interface) {
            if (!interfaceInfo.internal && interfaceInfo.family === 'IPv4') {
                return interfaceInfo.address;
            }
        }
    }

    return null;
}

//console.log('Server IP: ', getServerIP()); 
console.log('http://' , getServerIP() , ":2017");

app.get('/blackmarket', (req, res) => {
    const sid64 = req.query.steamid64;

    if(sid64) {
        pool.getConnection((err, connection) => {
            if (err) throw err;

            const query = 'SELECT * FROM blackmarket ';
            console.log(query);

            connection.query(query, [sid64], (error, results) => {
                connection.release();

                if (error) {
                    res.status(500).send('An error occurred during the query');
                } else {
                    if (results.length > 0) {
                        res.json(results); 
                    } else {
                        res.status(404).send('No result found');
                    }
                }
            });
        });
    } else {
        res.status(400).send('Bad Request: Missing steamid64 you fucking retard');
    }
});




const port = 2017;
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
