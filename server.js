require("dotenv").config();
const app = require("./src/app");

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor del catálogo digital escuchando en el puerto ${PORT}`);
});
