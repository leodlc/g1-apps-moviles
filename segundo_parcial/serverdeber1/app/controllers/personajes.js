const { httpError } = require('../helpers/handleError');
const { getDb } = require('../../config/mongo');
const { ObjectId } = require('mongodb');
const Joi = require('joi'); // Para validaciones

// Función para validar el ObjectId
const isValidObjectId = (id) => ObjectId.isValid(id) && (String(new ObjectId(id)) === id);

// Esquema de validación para personaje
const characterSchema = Joi.object({
    nombrePersonaje: Joi.string().required(),
    imagenpersonaje: Joi.string().uri().optional(),
    infoAdicional: Joi.string().optional()
});

// Obtener todos los personajes
const getAllCharacters = async (req, res) => {
    try {
        console.log("getAllCharacters invoked");
        const db = getDb();
        const characters = await db.collection('personajes').find({}).toArray();
        res.send({ data: characters });
    } catch (e) {
        console.error("Error in getAllCharacters:", e);
        httpError(res, e);
    }
};

const getCharacterByName = async (req, res) => {
    try {
        // Decodificar el nombre del personaje (manejar espacios y caracteres especiales)
        const nombrePersonaje = decodeURIComponent(req.params.nombrePersonaje); 
        
        const db = getDb();

        // Realizar una búsqueda insensible a mayúsculas/minúsculas y exacta
        const character = await db.collection('personajes').findOne({
            nombrePersonaje: { $regex: `^${nombrePersonaje}$`, $options: 'i' }
        });

        // Si no se encuentra el personaje, enviar un error 404
        if (!character) {
            return res.status(404).send({ error: 'Personaje no encontrado' });
        }

        // Respuesta con los datos del personaje
        res.send({ data: character });

    } catch (e) {
        console.error("Error in getCharacterByName:", e);
        httpError(res, e);
    }
};


// Crear un nuevo personaje
const createCharacter = async (req, res) => {
    try {
        const { error, value } = characterSchema.validate(req.body);
        if (error) {
            return res.status(400).send({ error: error.details[0].message });
        }

        const db = getDb();
        const result = await db.collection('personajes').insertOne(value);

        res.status(201).send({
            message: 'Personaje creado exitosamente',
            data: { ...value, id: result.insertedId }
        });
    } catch (e) {
        console.error("Error in createCharacter:", e);
        httpError(res, e);
    }
};

// Actualizar un personaje existente
const updateCharacter = async (req, res) => {
    try {
        const { id } = req.params;
        const { imagenpersonaje, infoAdicional } = req.body;

        if (!isValidObjectId(id)) {
            return res.status(400).send({ error: 'ID no válido' });
        }

        const db = getDb();
        const updatedCharacter = {
            $set: { imagenpersonaje, infoAdicional }
        };

        const result = await db.collection('personajes').updateOne({ _id: new ObjectId(id) }, updatedCharacter);
        if (result.matchedCount === 0) {
            return res.status(404).send({ error: 'Personaje no encontrado' });
        }

        const updatedMsg = await db.collection('personajes').findOne({ _id: new ObjectId(id) });
        res.send({ message: 'Personaje actualizado correctamente', data: updatedMsg });
    } catch (e) {
        console.error("Error in updateCharacter:", e);
        httpError(res, e);
    }
};

// Eliminar un personaje
const deleteCharacter = async (req, res) => {
    try {
        const { id } = req.params;

        if (!isValidObjectId(id)) {
            return res.status(400).send({ error: 'ID no válido' });
        }

        const db = getDb();
        const result = await db.collection('personajes').deleteOne({ _id: new ObjectId(id) });

        if (result.deletedCount === 0) {
            return res.status(404).send({ error: 'Personaje no encontrado' });
        }

        res.send({ message: 'Personaje eliminado correctamente' });
    } catch (e) {
        console.error("Error in deleteCharacter:", e);
        httpError(res, e);
    }
};

// Exportar las funciones
module.exports = {
    getAllCharacters,
    getCharacterByName,
    createCharacter,
    updateCharacter,
    deleteCharacter
};
