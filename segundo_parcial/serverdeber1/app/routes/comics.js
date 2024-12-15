const express = require('express');
const router = express.Router();

const { getAllComics, getComicByName, createComic, updateComic, deleteComic } = require('../controllers/comics');

router.get('/', getAllComics);

router.get('/nombre/:nombreComic', getComicByName);

router.post('/createComic', createComic);

router.patch('/:id', updateComic);

router.delete('/:id', deleteComic);

module.exports = router;