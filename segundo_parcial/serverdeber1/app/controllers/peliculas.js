const { httpError } = require('../helpers/handleError');
const { getDb } = require('../../config/mongo');
const { ObjectId } = require('mongodb');
const Joi = require('joi'); // Para validaciones

// Función para validar el ObjectId
const isValidObjectId = (id) => ObjectId.isValid(id) && (String(new ObjectId(id)) === id);

// Esquema de validación para pelicula
const movieSchema = Joi.object({
    nombrePelicula: Joi.string().required(),
    imagenPelicula: Joi.string().uri().optional(),
    infoAdicional: Joi.string().optional()
});

// Obtener todas las películas
const getAllMovies = async (req, res) => {
    try {
        const db = getDb();
        const movies = await db.collection('peliculas').find({}).toArray();
        res.send({ data: movies });
    } catch (e) {
        console.error("Error in getAllMovies:", e);
        httpError(res, e);
    }
};

const getMovieByName = async (req, res) => {
    try {
        const nombrePelicula = decodeURIComponent(req.params.nombrePelicula); // Decodificar la URL
        const db = getDb();

        const movie = await db.collection('peliculas').findOne({
            nombrePelicula: { $regex: `^${nombrePelicula}$`, $options: 'i' } // Búsqueda insensible a mayúsculas
        });

        if (!movie) {
            return res.status(404).send({ error: 'Película no encontrada' });
        }

        res.send({ data: movie });
    } catch (e) {
        console.error("Error in getMovieByName:", e);
        httpError(res, e);
    }
};



// Crear una nueva película
const createMovie = async (req, res) => {
    try {
        const { error, value } = movieSchema.validate(req.body);
        if (error) {
            return res.status(400).send({ error: error.details[0].message });
        }

        const db = getDb();
        const result = await db.collection('peliculas').insertOne(value);

        res.status(201).send({
            message: 'Película creada exitosamente',
            data: { ...value, id: result.insertedId }
        });
    } catch (e) {
        console.error("Error in createMovie:", e);
        httpError(res, e);
    }
};

// Actualizar una película existente
const updateMovie = async (req, res) => {
    try {
        const { id } = req.params;
        const { imagenPelicula, infoAdicional } = req.body;

        if (!isValidObjectId(id)) {
            return res.status(400).send({ error: 'ID no válido' });
        }

        const db = getDb();
        const updatedMovie = {
            $set: { imagenPelicula, infoAdicional }
        };

        const result = await db.collection('peliculas').updateOne({ _id: new ObjectId(id) }, updatedMovie);
        if (result.matchedCount === 0) {
            return res.status(404).send({ error: 'Película no encontrada' });
        }

        const updatedMsg = await db.collection('peliculas').findOne({ _id: new ObjectId(id) });
        res.send({ message: 'Película actualizada correctamente', data: updatedMsg });
    } catch (e) {
        console.error("Error in updateMovie:", e);
        httpError(res, e);
    }
};

// Eliminar una película
const deleteMovie = async (req, res) => {
    try {
        const { id } = req.params;

        if (!isValidObjectId(id)) {
            return res.status(400).send({ error: 'ID no válido' });
        }

        const db = getDb();
        const result = await db.collection('peliculas').deleteOne({ _id: new ObjectId(id) });

        if (result.deletedCount === 0) {
            return res.status(404).send({ error: 'Película no encontrada' });
        }

        res.send({ message: 'Película eliminada correctamente' });
    } catch (e) {
        console.error("Error in deleteMovie:", e);
        httpError(res, e);
    }
};

// Exportar las funciones
module.exports = {
    getAllMovies,
    getMovieByName,
    createMovie,
    updateMovie,
    deleteMovie
};
