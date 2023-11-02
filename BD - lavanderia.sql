USE lavanderia;
-- Tablas 
CREATE TABLE Usuario (
    IdUsuario INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Usuario VARCHAR(255) NOT NULL,
    Contraseña VARCHAR(255) NOT NULL,
    id_empleado int NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado) ,
    ind VARCHAR(10) NOT NULL
);

CREATE TABLE Empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY NOT NULL, 
    nombre VARCHAR(255) NOT NULL,
    apaterno VARCHAR(255) NOT NULL,
    amaterno VARCHAR(255) ,
    dni VARCHAR(255),
    estadocivil VARCHAR(255),
    edad VARCHAR(255),
    correo VARCHAR(255),
    telefono VARCHAR(255),
    direccion VARCHAR(255),
    fechacont VARCHAR(255),
    tipocont VARCHAR(255),
    Cargo VARCHAR(255),
    sueldo VARCHAR(255),
    id_hijos int,
    ind VARCHAR(10) NOT NULL,
    FOREIGN KEY (id_hijos) REFERENCES Hijos_emp(id_hijos)
);
CREATE TABLE Hijos_emp (
    id_hijos INT AUTO_INCREMENT PRIMARY KEY NOT NULL, 
    cant_h int,
    ind varchar(10)
);

CREATE TABLE Cliente (
    idcliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    telefono VARCHAR(255),
    Genero VARCHAR(255),
    id_pedido INT,
    ind VARCHAR(10) NOT NULL
);
CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fechaped VARCHAR(255),
    t_entrega VARCHAR(255),
    peso VARCHAR(255),
    monto VARCHAR(255),
    producto VARCHAR(255),
    tipo_prenda VARCHAR(255),
    id_pedidopag INT,
	id_cliente INT,
    id_empleado INT,
    id_producto INT,
    ind VARCHAR(10),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(idcliente),
    FOREIGN KEY (id_pedidopag) REFERENCES Detalle_Pedido(id_pedidopag)
);

CREATE TABLE Producto(
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nom_producto varchar(100),
    categoria VARCHAR(40),
    cantidad VARCHAR(30),
	ind VARCHAR(10)
);

CREATE TABLE Detalle_Pedido (
    id_pedidopag INT AUTO_INCREMENT PRIMARY KEY,
    estado_pago VARCHAR(255),
    monto_pend VARCHAR(255),
    monto_pagado VARCHAR(255),
    estado_envio VARCHAR(255)
);

CREATE TABLE Maquina (
    idmaquina INT AUTO_INCREMENT PRIMARY KEY,
    nombre_maquina VARCHAR(255),
    fecha_ing VARCHAR(255),
    fechamant VARCHAR(255),
    ind VARCHAR(255),
    id_empleado INT, 
    FOREIGN KEY  (id_empleado) REFERENCES  Empleado (id_empleado)
);

-- Crear tabla Pagina
CREATE TABLE `pagina` (
  `IdPagina` int primary key AUTO_INCREMENT NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `Indicador` varchar(1) DEFAULT NULL
);
ALTER TABLE `pagina`
  MODIFY `IdPagina` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;


CREATE TABLE ProgramaEmp (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    horario VARCHAR(255),
    dia VARCHAR(255),
    hora_entrada VARCHAR(255),
    hora_salida VARCHAR(255),
    ind VARCHAR(255),
    id_empleado INT, 
    FOREIGN KEY  (id_empleado) REFERENCES  Empleado (id_empleado)
);

-- procedimientos almacenados
-- Inserción para un EMPLEADO regular
CALL sp_InsertarEmpleado(
    'Juan', 'Perez', 'Lopez', '987654321', '12345678', 'Soltero', '25',
    'juan@example.com', 'Calle 123', '2023-01-01', 'Medio Tiempo', 'EMPLEADO', '5000',
    'juan123', 'contraseña123', 2
);

-- Inserción para un JEFE
CALL sp_InsertarEmpleado(
    'Maria', 'Gomez', 'Rodriguez', '123456789', '87654321', 'Casado', '30',
    'maria@example.com', 'Avenida 456', '2022-12-01', 'Fijo', 'JEFE', '8000',
    'maria456', 'contraseña456', 1
);

-- Inserción para RECURSOS HUMANOS
CALL sp_InsertarEmpleado(
    'Carlos', 'Martinez', 'Santos', '567890123', '98765432', 'Soltero', '28',
    'carlos@example.com', 'Calle 789', '2023-02-15', 'Fijo', 'RECURSOS HUMANOS', '6000',
    'carlos789', 'contraseña789', 0
);

-- Inserción para un CONTADOR
CALL sp_InsertarEmpleado(
    'Ana', 'Lopez', 'Gonzalez', '234567890', '34567890', 'Casado', '35',
    'ana@example.com', 'Avenida 789', '2023-03-10', 'Medio Tiempo', 'CONTADOR', '7000',
    'ana987', 'contraseña987', 3
);
drop procedure sp_InsertarEmpleado;
-- insertar datos en empleado
DELIMITER //
CREATE PROCEDURE sp_InsertarEmpleado(
    IN p_nombre VARCHAR(255),
    IN p_apaterno VARCHAR(255),
    IN p_amaterno VARCHAR(255),
    IN p_telefono VARCHAR(255),
    IN p_dni VARCHAR(255),
    IN p_estadocivil VARCHAR(255),
    IN p_edad VARCHAR(255),
    IN p_correo VARCHAR(255),
    IN p_direccion VARCHAR(255),
    IN p_fechacont VARCHAR(255),
    IN p_tipocont VARCHAR(255),
    IN p_cargo VARCHAR(255),
    IN p_sueldo VARCHAR(255),
    IN p_usuario VARCHAR(255),
    IN p_contraseña VARCHAR(255),
    IN p_cann_hijos INT
)
BEGIN
    DECLARE last_id INT;

    -- Insertar Hijos
    INSERT INTO Hijos_emp (cann_h, ind)
    VALUES (p_cann_hijos, 'S');

    -- Obtener el último ID insertado en Hijos_emp
    SELECT LAST_INSERT_ID() INTO last_id;

    -- Insertar Empleado
    INSERT INTO Empleado (
        nombre, apaterno, amaterno, telefono, dni, estadocivil, edad,
        correo, direccion, fechacont, tipocont, Cargo, sueldo, id_hijos, ind
    )
    VALUES (
        p_nombre, p_apaterno, p_amaterno, p_telefono, p_dni, p_estadocivil, p_edad,
        p_correo, p_direccion, p_fechacont, p_tipocont, p_cargo, p_sueldo, last_id, 'S'
    );

    -- Obtener el último ID insertado en Empleado
    SELECT LAST_INSERT_ID() INTO last_id;

    -- Insertar Usuario
    INSERT INTO Usuario (Usuario, Contraseña, id_empleado, ind)
    VALUES (p_usuario, p_contraseña, last_id, 'S');

    COMMIT;
END //
DELIMITER ;
-- visualizar a los empleados
DELIMITER //
CREATE PROCEDURE sp_MostrarEmpleados()
BEGIN
    SELECT 
        e.*,
        u.Usuario,
        h.cann_h
    FROM Empleado e
    INNER JOIN Usuario u ON e.id_empleado = u.id_empleado
    INNER JOIN Hijos_emp h ON e.id_hijos = h.id_hijos
    WHERE e.ind = 'S';
END //
DELIMITER ;
-- buscar empleado por id
DELIMITER //
CREATE PROCEDURE sp_RecuperarEmpleadoYUsuario(IN p_idempleado INT)
BEGIN
    SELECT 
        e.*, 
        u.Usuario
    FROM Empleado e
    INNER JOIN Usuario u ON e.id_empleado = u.id_empleado
    WHERE e.id_empleado = p_idempleado;
END //
DELIMITER ;
-- actualizar empleados
DELIMITER //
CREATE PROCEDURE sp_ActualizarEmpleadoYUsuario(
    IN p_idempleado INT,
    IN p_nombre VARCHAR(255),
    IN p_apaterno VARCHAR(255),
    IN p_amaterno VARCHAR(255),
    IN p_dni VARCHAR(255),
    IN p_estadocivil VARCHAR(255),
    IN p_edad VARCHAR(255),
    IN p_correo VARCHAR(255),
    IN p_telefono VARCHAR(255),
    IN p_direccion VARCHAR(255),
    IN p_fechacont VARCHAR(255),
    IN p_tipocont VARCHAR(255),
    IN p_cargo VARCHAR(255),
    IN p_sueldo VARCHAR(255),
    IN p_usuario VARCHAR(255),
    IN p_cantidad_hijos INT
)
BEGIN
    START TRANSACTION;

    UPDATE Empleado
    SET
        nombre = p_nombre,
        apaterno = p_apaterno,
        amaterno = p_amaterno,
        dni = p_dni,
        estadocivil = p_estadocivil,
        edad = p_edad,
        correo = p_correo,
        telefono = p_telefono,
        direccion = p_direccion,
        fechacont = p_fechacont,
        tipocont = p_tipocont,
        Cargo = p_cargo,
        sueldo = p_sueldo
    WHERE id_empleado = p_idempleado;

    UPDATE Usuario
    SET
        Usuario = p_usuario
    WHERE id_empleado = p_idempleado;

    UPDATE Hijos_emp
    SET
        cann_h = p_cantidad_hijos
    WHERE id_hijos = (SELECT id_hijos FROM Empleado WHERE id_empleado = p_idempleado);

    COMMIT;
END //
DELIMITER ;
-- eliminar trabajador
DELIMITER //
CREATE PROCEDURE sp_EliminarTrabajador(IN p_idempleado INT)
BEGIN
    START TRANSACTION;

    UPDATE Empleado
    SET
        ind = 'N'
    WHERE id_empleado = p_idempleado;

    UPDATE Usuario
    SET
        ind = 'N'
    WHERE id_empleado = p_idempleado;

    UPDATE Hijos_emp
    SET
        ind = 'N'
    WHERE id_hijos = (SELECT id_hijos FROM Empleado WHERE id_empleado = p_idempleado);

    COMMIT;
END //
DELIMITER ;
-- validar usuario y devolver el cargo
DELIMITER //
CREATE PROCEDURE sp_ValidarUsuarioContrasena(
    IN p_usuario VARCHAR(255),
    IN p_contrasena VARCHAR(255),
    OUT p_mensaje VARCHAR(255),
    OUT p_cargo VARCHAR(255)
)
BEGIN
    DECLARE cargo_encontrado VARCHAR(255);

    -- Buscar el usuario y contraseña
    SELECT e.Cargo INTO cargo_encontrado
    FROM Usuario u
    INNER JOIN Empleado e ON u.id_empleado = e.id_empleado
    WHERE u.Usuario = p_usuario AND u.Contraseña = p_contrasena AND e.ind = 'S';

    -- Validar si se encontró el usuario y contraseña
    IF cargo_encontrado IS NOT NULL THEN
        SET p_mensaje = NULL;
        SET p_cargo = cargo_encontrado;
    ELSE
        SET p_mensaje = 'Usuario o contraseña incorrectos';
        SET p_cargo = NULL;
    END IF;
END //
DELIMITER ;

-- inserciones
-- activando los formularios por medio de la pagina
INSERT INTO pagina (`IdPagina`,`Nombre`, `Descripcion`, `Indicador`) VALUES
(1,'FrmEmpleado', 'Acceso GRUD al formulario de Empleado', 'S'),
(2,'Frm_RegPedido', 'Acceso GRUD al formulario de Pedido', 'S'),
(3,'.Menu_Contabilidad', 'Acceso GRUD al formulario de Contabilidad', 'S'),
(4,'Menu_Empleado', 'Acceso GRUD al formulario de Menu Empleado', 'S'),
(5,'Menu_Jefe', 'Acceso GRUD al formulario de lista Menu Jefe', 'S'),
(6,'Menu_Login', 'Acceso GRUD al formulario de Menu Login', 'S'),
(7,'Menu_RH', 'Acceso GRUD al formulario de Menu RH', 'S');
-- Inserción para un EMPLEADO regular
