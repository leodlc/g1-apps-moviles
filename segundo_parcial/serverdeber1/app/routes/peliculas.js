const express = require('express');
const router = express.Router();   

const { getAllMovies, getMovieByName, createMovie, updateMovie, deleteMovie } = require('../controllers/peliculas');
const { route } = require('./personajes');


router.get('/', getAllMovies);

router.get('/nombre/:nombrePelicula', getMovieByName);

router.post('/createMovie', createMovie);

router.patch('/:id', updateMovie);

router.delete('/:id', deleteMovie);


module.exports = router;