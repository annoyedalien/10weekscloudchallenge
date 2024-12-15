const express = require('express');
const mysql = require('mysql');
const cors = require('cors');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: 'mysql-serverdemo.mysql.database.azure.com',
    user: 'mysqladmin',
    password: 'MyPassword123',
    database: 'webappdb'
});

db.connect(err => {
    if (err) {
        console.error('Error connecting to the database:', err);
        return;
    }
    console.log('Connected to the database');
});

app.get('/api/dogs', (req, res) => {
    db.query('SELECT * FROM dogs', (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            res.status(500).send('Server error');
            return;
        }
        res.json(results);
    });
});

app.post('/api/dogs', (req, res) => {
    const { name, description } = req.body;
    if (!name || !description) {
        return res.status(400).send('Name and Description are required');
    }
    db.query('INSERT INTO dogs (name, description) VALUES (?, ?)', [name, description], (err, results) => {
        if (err) {
            console.error('Error inserting data:', err);
            res.status(500).send('Server error');
            return;
        }
        res.status(201).send('Dog added');
    });
});

app.listen(port, '0.0.0.0', () => {
    console.log(`Server running on http://localhost:${port}`);
});
