require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { dbConnection } = require('./config/mongo');

const app = express();

const PORT = process.env.PORT || 3000;
app.use(cors());
app.use(express.json());

// Cargar todas las rutas desde './app/routes/index.js'
app.use('/api/1.0', require('./app/routes'));  // Todas las rutas van a partir de /api/1.0

dbConnection().then(() => {
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });
}).catch(error => {
  console.error('Failed to connect to the database', error);
  process.exit(1); // Salir del proceso si no se puede conectar a la base de datos
});
