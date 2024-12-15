const { httpError } = require('../helpers/handleError');
const { getDb } = require('../../config/mongo');
const { ObjectId } = require('mongodb');
const Joi = require('joi'); // Para validaciones

// Función para validar el ObjectId
const isValidObjectId = (id) => ObjectId.isValid(id) && (String(new ObjectId(id)) === id);

// Esquema de validación para comic
const comicSchema = Joi.object({
    nombreComic: Joi.string().required(),
    imagenComic: Joi.string().uri().optional(),
    infoAdicional: Joi.string().optional()
});

// Obtener todos los cómics
const getAllComics = async (req, res) => {
    try {
        const db = getDb();
        const comics = await db.collection('comics').find({}).toArray();
        res.send({ data: comics });
    } catch (e) {
        console.error("Error in getAllComics:", e);
        httpError(res, e);
    }
};

const getComicByName = async (req, res) => {
    try {
        const nombreComic = decodeURIComponent(req.params.nombreComic); // Decodificar la URL
        const db = getDb();

        const comic = await db.collection('comics').findOne({
            nombreComic: { $regex: `^${nombreComic}$`, $options: 'i' } // Búsqueda insensible a mayúsculas
        });

        if (!comic) {
            return res.status(404).send({ error: 'Cómic no encontrado' });
        }

        res.send({ data: comic });
    } catch (e) {
        console.error("Error in getComicByName:", e);
        httpError(res, e);
    }
};



// Crear un nuevo cómic
const createComic = async (req, res) => {
    try {
        const { error, value } = comicSchema.validate(req.body);
        if (error) {
            return res.status(400).send({ error: error.details[0].message });
        }

        const db = getDb();
        const result = await db.collection('comics').insertOne(value);

        res.status(201).send({
            message: 'Cómic creado exitosamente',
            data: { ...value, id: result.insertedId }
        });
    } catch (e) {
        console.error("Error in createComic:", e);
        httpError(res, e);
    }
};

// Actualizar un cómic existente
const updateComic = async (req, res) => {
    try {
        const { id } = req.params;
        const { imagenComic, infoAdicional } = req.body;

        if (!isValidObjectId(id)) {
            return res.status(400).send({ error: 'ID no válido' });
        }

        const db = getDb();
        const updatedComic = {
            $set: { imagenComic, infoAdicional }
        };

        const result = await db.collection('comics').updateOne({ _id: new ObjectId(id) }, updatedComic);
        if (result.matchedCount === 0) {
            return res.status(404).send({ error: 'Cómic no encontrado' });
        }

        const updatedMsg = await db.collection('comics').findOne({ _id: new ObjectId(id) });
        res.send({ message: 'Cómic actualizado correctamente', data: updatedMsg });
    } catch (e) {
        console.error("Error in updateComic:", e);
        httpError(res, e);
    }
};

// Eliminar un cómic
const deleteComic = async (req, res) => {
    try {
        const { id } = req.params;

        if (!isValidObjectId(id)) {
            return res.status(400).send({ error: 'ID no válido' });
        }

        const db = getDb();
        const result = await db.collection('comics').deleteOne({ _id: new ObjectId(id) });

        if (result.deletedCount === 0) {
            return res.status(404).send({ error: 'Cómic no encontrado' });
        }

        res.send({ message: 'Cómic eliminado correctamente' });
    } catch (e) {
        console.error("Error in deleteComic:", e);
        httpError(res, e);
    }
};

// Exportar las funciones
module.exports = {
    getAllComics,
    getComicByName,
    createComic,
    updateComic,
    deleteComic
};
