const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
const port = 4000;

// MySQL connection configuration
const db = mysql.createConnection({
    host: '<MySQL_Private_IP>',
    user: 'mysqladmin',
    password: 'MyPassword123!',
    database: 'mydatabase'
});

// Connect to MySQL
db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        return;
    }
    console.log('Connected to MySQL');
});

// Middleware to parse request body
app.use(bodyParser.urlencoded({ extended: true }));

// Enable CORS
app.use(cors());

// Handle form submission
app.post('/submit', (req, res) => {
    const { name, message } = req.body;
    const query = 'INSERT INTO inputs (name, message) VALUES (?, ?)';
    db.query(query, [name, message], (err, result) => {
        if (err) {
            console.error('Error inserting data:', err);
            res.send('Error storing input.');
            return;
        }
        res.send('Input stored successfully!');
    });
});

// Start the server
app.listen(port, () => {
    console.log(`App running at http://localhost:${port}`);
});
