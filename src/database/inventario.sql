
CREATE TABLE Modelos_Productos (
    Id_Producto INT AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Codigo VARCHAR(50),
    Tipo_Producto VARCHAR(50),
    Tipo_Unidad VARCHAR(20),
    Unidades_Maximas INT,
    Unidades_Minimas INT NOT NULL,
    PRIMARY KEY (Id_Producto)
);


CREATE TABLE Almacen_Ubicacion (
    Id_Ubicacion INT AUTO_INCREMENT,
    Area VARCHAR(100) NOT NULL,
    Ubicacion VARCHAR(100),
    PRIMARY KEY (Id_Ubicacion)
);


CREATE TABLE Modelos_Equipos (
    Id_Modelo INT AUTO_INCREMENT,
    Modelo VARCHAR(100),
    Nombre VARCHAR(100),
    Descripcion TEXT,
    Codigo VARCHAR(50) NOT NULL,
    Marca VARCHAR(100),
    Unidades INT,
    PRIMARY KEY (Id_Modelo)
);


CREATE TABLE Instrumentos (
    Id_Instrumento INT AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Tipo_Instrumento VARCHAR(50),
    Unidades INT,
    Unidades_Minimas INT,
    Unidades_Maximas INT,
    PRIMARY KEY (Id_Instrumento)
);


CREATE TABLE Productos (
    Id_Producto INT AUTO_INCREMENT,
    Id_modelo_productos INT NOT NULL,
    Unidades INT,
    Fecha_Vencimiento DATE NOT NULL,
    PRIMARY KEY (Id_Producto),
    FOREIGN KEY (Id_modelo_productos) REFERENCES Modelos_Productos(Id_Producto) ON DELETE CASCADE
);


CREATE TABLE Productos_Ubicacion (
    Id_Compuesto INT AUTO_INCREMENT,
    Unidades_Por_Ubicacion INT,
    Id_Producto INT NOT NULL,
    Id_Ubicacion INT NOT NULL,
    PRIMARY KEY (Id_Compuesto),
    FOREIGN KEY (Id_Producto) REFERENCES Productos(Id_Producto) ON DELETE CASCADE,
    FOREIGN KEY (Id_Ubicacion) REFERENCES Almacen_Ubicacion(Id_Ubicacion) ON DELETE CASCADE
);


CREATE TABLE Instrumentos_Ubicacion (
    Id_Compuesto INT AUTO_INCREMENT,
    Unidades_Por_Ubicacion INT,
    Id_Instrumento INT NOT NULL,
    Id_Ubicacion INT NOT NULL,
    PRIMARY KEY (Id_Compuesto),
    FOREIGN KEY (Id_Instrumento) REFERENCES Instrumentos(Id_Instrumento) ON DELETE CASCADE,
    FOREIGN KEY (Id_Ubicacion) REFERENCES Almacen_Ubicacion(Id_Ubicacion) ON DELETE CASCADE
);


CREATE TABLE Equipos (
    Id_Equipo INT AUTO_INCREMENT,
    Fecha_Instalacion DATE,
    Estado VARCHAR(50),
    Frecuencia_mantenimiento VARCHAR(50),
    Numero_de_serie VARCHAR(100),
    Id_Modelo INT NOT NULL,
    Id_Ubicacion INT NOT NULL,
    PRIMARY KEY (Id_Equipo),
    FOREIGN KEY (Id_Modelo) REFERENCES Modelos_Equipos(Id_Modelo) ON DELETE CASCADE,
    FOREIGN KEY (Id_Ubicacion) REFERENCES Almacen_Ubicacion(Id_Ubicacion) ON DELETE CASCADE
);


CREATE TABLE Repuestos (
    Id_Repuesto INT AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Numero_de_Pieza VARCHAR(100),
    Unidades INT,
    Unidades_Minimas INT NOT NULL,
    Unidades_Maximas INT,
    Id_Ubicacion INT NOT NULL,
    PRIMARY KEY (Id_Repuesto),
    FOREIGN KEY (Id_Ubicacion) REFERENCES Almacen_Ubicacion(Id_Ubicacion)
);

DELIMITER $$

CREATE TRIGGER actualizar_unidades_producto
AFTER UPDATE ON Productos_Ubicacion
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET Unidades = (
        SELECT SUM(Unidades_Por_Ubicacion)
        FROM Productos_Ubicacion
        WHERE Id_Producto = NEW.Id_Producto
    )
    WHERE Id_Producto = NEW.Id_Producto;
END$$

-- Trigger para actualizar las unidades de Instrumentos
CREATE TRIGGER actualizar_unidades_instrumento
AFTER UPDATE ON Instrumentos_Ubicacion
FOR EACH ROW
BEGIN
    UPDATE Instrumentos
    SET Unidades = (
        SELECT SUM(Unidades_Por_Ubicacion)
        FROM Instrumentos_Ubicacion
        WHERE Id_Instrumento = NEW.Id_Instrumento
    )
    WHERE Id_Instrumento = NEW.Id_Instrumento;
END$$

-- Trigger para actualizar las unidades de Repuestos
CREATE TRIGGER actualizar_unidades_repuesto
AFTER UPDATE ON Repuestos
FOR EACH ROW
BEGIN
    UPDATE Repuestos
    SET Unidades = (
        SELECT SUM(Unidades)
        FROM Repuestos
        WHERE Id_Modelo = NEW.Id_Modelo
    )
    WHERE Id_Repuesto = NEW.Id_Repuesto;
END$$

-- Trigger para actualizar las unidades de Equipos
CREATE TRIGGER actualizar_unidades_equipo
AFTER UPDATE ON Equipos
FOR EACH ROW
BEGIN
    UPDATE Modelos_Equipos
    SET Unidades = (
        SELECT COUNT(*)
        FROM Equipos
        WHERE Id_Modelo = NEW.Id_Modelo
    )
    WHERE Id_Modelo = NEW.Id_Modelo;
END$$

DELIMITER ;