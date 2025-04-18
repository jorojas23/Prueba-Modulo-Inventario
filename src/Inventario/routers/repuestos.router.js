import { Router } from "express";
import RepuestosController from "../controllers/repuestos.controller.js";

class RepuestosRouter {
    constructor() {
        this.router = Router();
        this.controller = new RepuestosController(); // Instancia del controlador
    }

    start() {
        // Rutas para Repuestos
        this.router.get("/", (req, res) => this.controller.getAll(req, res)); // Obtener todos los repuestos
        this.router.get("/:id", (req, res) => this.controller.getById(req, res)); // Obtener un repuesto por ID
        this.router.post("/", (req, res) => this.controller.create(req, res)); // Crear un repuesto
        this.router.put("/:id", (req, res) => this.controller.updateById(req, res)); // Actualizar un repuesto por ID
        this.router.delete("/:id", (req, res) => this.controller.deleteById(req, res)); // Eliminar un repuesto por ID

        return this.router;
    }
}

export default new RepuestosRouter();