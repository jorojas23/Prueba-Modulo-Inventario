import express, {static as stc, json, urlencoded} from "express";
import cors from "cors";
import dotenv from "dotenv";
import {Server as HttpServer} from "http";

/*

Importacion de los routers 
Para el integrador separar cuales routers son de cada modulo

*/

// import VistasRouter from "./src/Vistas/routers/vistas.router.js";
import AlmacenRouter from "./src/Inventario/routers/almacen.router.js";
import EquiposRouter from "./src/Inventario/routers/equipos.router.js";
import InstrumentosRouter from "./src/Inventario/routers/instrumentos.router.js";
import ProductosRouter from "./src/Inventario/routers/productos.router.js";
import RepuestosRouter from "./src/Inventario/routers/repuestos.router.js";


//Permite el uso del archivo .env 
// RECUERDA CONFIGUAR EL ARCHIVO .env ANTES DE EJECUTAR EL SERVIDOR
dotenv.config()

const app = express();
const httpServer = new HttpServer(app);

// app.set("view engine", "ejs");

/*

Configuraciones varias

Esta configurado el server para enviar la pagina index.html de la carpeta public.
Hacer la navegacion desde el front hacia las carpeta pages en un futuro

*/

app.use(stc("public")); // Para el frontend localizado en la carpeta Public, lleva directamente al index.html mientra no haya algo en el enpoint "/" IMPORTANTE
app.use(json());
app.use(urlencoded());

app.use(cors());

/* 

Instanciamiento de los routers 
Cada Router va a contener una parte de la api (el backend) y cada router va estar dirijido a hacer un crud en la base de datos 
Por ahora el router de vistas no se va a utilizar va a hacer puro html, aunque la prioridad aurorita es hacer el backend

*/

// const pages = new VistasRouter();

const almacen = new AlmacenRouter();
const equipos = new EquiposRouter();
const instrumentos = new InstrumentosRouter();
const productos = new ProductosRouter();
const repuestos = new RepuestosRouter();

/*

    Declaracion de las rutas para los endpoints
    Todas las rutas que empiecen por "/api/..." van renferenciadas al backend para no mezclar con la navegacion del front
    IMPORTANTE NO USAR LA RUTA "" O "/" DIRECTAMENTE PARA QUE FUNCIONE EL DIRECCIONAMIENTO A LOS ARCHIVOS ESTATICOS EN LA CARPTEA PUBLIC

*/

// app.use("", pages.start()); // No se va a usar las paginas ejs por ahora NO DESCOMENTAR

app.use("/api/inventario/alamacen/", almacen.start());
app.use("/api/inventario/equipos/", equipos.start());
app.use("/api/inventario/instrumentos/", instrumentos.start());
app.use("/api/inventario/productos/", productos.start());
app.use("/api/inventario/repuestos/", repuestos.start());

// Regresa error a cualquier enpoint no existente
app.all("*", (req, res) => {
    res.status(404).json({ "error": "endpoint no encontrado" })
});

const server = httpServer.listen(process.env.PORT, () => {
    console.log(`http://localhost:${server.address().port}`)
});