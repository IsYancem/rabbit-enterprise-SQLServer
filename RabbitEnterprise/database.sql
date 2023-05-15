CREATE DATABASE RabbitEnterprise;
GO

USE RabbitEnterprise;
GO

CREATE TABLE Roles(
    RolId INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50)
)
GO

CREATE TABLE Usuarios(
    UsuarioId INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50),
    Username NVARCHAR(50),
    Password NVARCHAR(50),
    RolId INT FOREIGN KEY REFERENCES Roles(RolId),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    UsuarioCreador INT FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    FechaModificacion DATETIME,
    UsuarioModificador INT FOREIGN KEY REFERENCES Usuarios(UsuarioId)
)
GO

CREATE TABLE Clientes(
    ClienteId INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    UsuarioCreador INT FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    FechaModificacion DATETIME,
    UsuarioModificador INT FOREIGN KEY REFERENCES Usuarios(UsuarioId)
)
GO

CREATE TABLE Ventas(
    VentaId INT PRIMARY KEY IDENTITY(1,1),
    ClienteId INT FOREIGN KEY REFERENCES Clientes(ClienteId),
    EmpleadoId INT FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    FechaVenta DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10,2),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    UsuarioCreador INT FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    FechaModificacion DATETIME,
    UsuarioModificador INT FOREIGN KEY REFERENCES Usuarios(UsuarioId)
)
GO

CREATE PROCEDURE CrearUsuario
    @Nombre NVARCHAR(50),
    @Username NVARCHAR(50),
    @Password NVARCHAR(50),
    @RolId INT,
    @UsuarioCreador INT
AS
BEGIN
    -- Comprobamos si el usuario tiene permisos para crear un nuevo usuario (solo administradores)
    DECLARE @RolUsuarioCreador NVARCHAR(50);
    SELECT @RolUsuarioCreador = R.Nombre FROM Roles R
    INNER JOIN Usuarios U ON R.RolId = U.RolId
    WHERE U.UsuarioId = @UsuarioCreador;

    IF @RolUsuarioCreador = 'Administrador'
    BEGIN
        INSERT INTO Usuarios(Nombre, Username, Password, RolId, UsuarioCreador)
        VALUES (@Nombre, @Username, @Password, @RolId, @UsuarioCreador);
    END
    ELSE
    BEGIN
        THROW 50000, 'No tienes permisos para crear un nuevo usuario', 1;
    END
END
GO

CREATE TRIGGER ModificarVenta
ON Ventas
AFTER UPDATE
AS
BEGIN
    DECLARE @VentaId INT;
    DECLARE @UsuarioModificador INT;

    SELECT @VentaId = INSERTED.VentaId, @UsuarioModificador = INSERTED.UsuarioModificador
    FROM INSERTED;

    UPDATE Ventas
    SET FechaModificacion = GETDATE(),
        UsuarioModificador = @UsuarioModificador
    WHERE VentaId = @VentaId;
END
GO

CREATE PROCEDURE HacerRespaldo
AS
BEGIN
    DECLARE @NombreArchivo NVARCHAR(255);

    -- Formato del nombre del archivo: Respaldo_AAAA_MM_DD.bak
    SET @NombreArchivo = 'C:\Respaldos\Respaldo_' + REPLACE(CONVERT(NVARCHAR(10), GETDATE(), 120), '-', '_') + '.bak';

    BACKUP DATABASE RabbitEnterprise TO DISK = @NombreArchivo;
END
GO