const { MongoClient } = require('mongodb');

let db;

const dbConnection = async () => {
  const DB_URI = process.env.DB_URI;
  const client = new MongoClient(DB_URI);

  try {
    await client.connect();
    db = client.db(); // Asignar la base de datos a una variable global
    console.log('Database connected successfully');
  } catch (error) {
    console.log('Database connection failed', error);
    throw error; // Propagar el error para manejarlo fuera
  }
};

const getDb = () => {
  if (!db) {
    throw new Error('Database not connected');
  }
  return db;
};

module.exports = { dbConnection, getDb };
