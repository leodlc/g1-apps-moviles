const express = require('express');
const router = express.Router();    

const { getAllCharacters, getCharacterByName, createCharacter, updateCharacter, deleteCharacter } = require('../controllers/personajes');

router.get('/', getAllCharacters);

router.get('/nombre/:nombrePersonaje', getCharacterByName);

router.post('/createCharacter', createCharacter);

router.patch('/:id', updateCharacter);


router.delete('/:id', deleteCharacter);

module.exports = router;