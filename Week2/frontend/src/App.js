import React, { useEffect, useState } from 'react';
import axios from 'axios';
import './App.css';

const App = () => {
    const [dogs, setDogs] = useState([]);
    const [dogName, setDogName] = useState('');
    const [dogDescription, setDogDescription] = useState('');

    useEffect(() => {
        axios.get('http://your-app-server-ip:3000/api/dogs')
            .then(response => {
                console.log(response.data); // Log the response data
                setDogs(response.data);
            })
            .catch(error => console.error('Error fetching data:', error));
    }, []);

    const handleSubmit = (e) => {
        e.preventDefault();
        axios.post('http://your-app-server-ip:3000/api/dogs', { name: dogName, description: dogDescription })
            .then(response => {
                setDogs([...dogs, { id: response.data.insertId, name: dogName, description: dogDescription }]);
                setDogName('');
                setDogDescription('');
            })
            .catch(error => console.error('Error adding dog:', error));
    };

    return (
        <div className="container">
            <h1>Types of Dogs</h1>
            <form onSubmit={handleSubmit}>
                <input
                    type="text"
                    value={dogName}
                    onChange={(e) => setDogName(e.target.value)}
                    placeholder="Enter dog name"
                    required
                />
                <input
                    type="text"
                    value={dogDescription}
                    onChange={(e) => setDogDescription(e.target.value)}
                    placeholder="Enter dog description"
                    required
                />
                <button type="submit">Add Dog</button>
            </form>
            <ul className="dog-list">
                {dogs.map(dog => (
                    <li key={dog.id} className="dog-item">
                        <h2>{dog.name}</h2>
                        <p>{dog.description}</p>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default App;
