--CREACION DEL ESQUEMA 'proyecto' 
	
	CREATE SCHEMA IF NOT EXISTS proyecto;

--CREACION DE LAS TABLAS 'registros', 'locacion', 'ofensa', 'crimen'

	CREATE TABLE IF NOT EXISTS proyecto.registros (
	    crimen_id INT,
	    numero_caso VARCHAR(15),
	    fecha text,
	    cuadra VARCHAR(100),
	    iucr VARCHAR(4),
	    tipo_primario VARCHAR(100),
	    descripcion VARCHAR(100),
	    locacion_descripcion VARCHAR(100),
	    arresto BOOLEAN,
	    domestico BOOLEAN,
	    beat INT, 
	    distrito INT,
	    ward INT,
	    area_comunidad INT,
	    codigo_fbi VARCHAR(4),
	    coordenada_x VARCHAR(100),
	    coordenada_y VARCHAR(100),
	    anio INT,
	    ultima_actualizacion VARCHAR(100),
	    latitud VARCHAR(100),
	    longitud VARCHAR(100),
	    locacion VARCHAR(100)
	);
	
	CREATE TABLE IF NOT EXISTS proyecto.locacion (
	    locacion_id BIGserial PRIMARY KEY,
	    cuadra VARCHAR(100),
	    locacion_descripcion VARCHAR(100)
	);
	
	CREATE TABLE IF NOT EXISTS proyecto.ofensa(
		ofensa_id BIGserial PRIMARY KEY,
		iucr VARCHAR(4),
    	tipo_primario VARCHAR(100),
    	descripcion VARCHAR(100)
	);
	
	CREATE TABLE IF NOT EXISTS proyecto.crimen(
		crimen_id INT PRIMARY KEY,
		numero_caso VARCHAR(100),
		fecha DATE,
		hora TIME,
		ultima_actualizacion DATE,
		arresto BOOLEAN,
		domestico BOOLEAN,
		codigo_fbi VARCHAR(4), 
		beat INT,
		distrito INT,
		ward INT,
		area_comunidad INT,
		datos_locacion INT REFERENCES proyecto.locacion(locacion_id),
		datos_ofensa INT REFERENCES proyecto.ofensa(ofensa_id)
		
	);
	
--LIMPIEZA DE DATOS 	
	
	--ELIMINA LOS DATOS CON VALORES NULOS REFERENTES A LA UBICACION
	DELETE FROM proyecto.registros
	WHERE ward IS NULL OR area_comunidad IS NULL
	
	--SEPARA LA COLUMNA FECHA EN DOS NUEVAS COLUMNAS 'fecha', 'hora'
	ALTER TABLE proyecto.registros
		ADD COLUMN fecha_date DATE,
		ADD COLUMN fecha_time TIME;
		
		UPDATE proyecto.registros
		SET 
	    	fecha_date = TO_DATE(SUBSTRING(fecha FROM 1 FOR 10), 'MM/DD/YYYY'), 
	    	fecha_time = CAST(TO_CHAR(TO_TIMESTAMP(SUBSTRING(fecha FROM 12 FOR 11), 'HH:MI:SS AM'), 'HH24:MI:SS') AS TIME);
	
	ALTER TABLE proyecto.registros DROP COLUMN fecha;
	ALTER TABLE proyecto.registros RENAME COLUMN fecha_date TO fecha;
	ALTER TABLE proyecto.registros RENAME COLUMN fecha_time TO hora;
	
	--EXTRAE LA FECHA DE LA COLUMNA 'ultima_actualizacion'
	ALTER TABLE proyecto.registros
		ADD COLUMN ultima_actualizacion_fecha DATE;
	
		UPDATE proyecto.registros
		SET 
    		ultima_actualizacion_fecha = TO_DATE(SUBSTRING(ultima_actualizacion FROM 1 FOR 10), 'MM/DD/YYYY');
   
    ALTER TABLE proyecto.registros DROP COLUMN ultima_actualizacion;
	ALTER TABLE proyecto.registros RENAME COLUMN ultima_actualizacion_fecha TO ultima_actualizacion;
	
	--LIMPIA LA COLUMNA 'locacion_descripcion'
	UPDATE proyecto.registros
		SET locacion_descripcion = 
		CASE 
			WHEN locacion_descripcion LIKE 'AIRPORT%' THEN 'AIRPORT'
	        WHEN locacion_descripcion LIKE 'VEHICLE%' THEN 'VEHICLE'
	        WHEN locacion_descripcion LIKE 'SCHOOL%' THEN 'SCHOOL'
	        WHEN locacion_descripcion LIKE 'COLLEGE%' THEN 'COLLEGE'
	        WHEN locacion_descripcion LIKE 'RESIDENCE%' THEN 'RESIDENCE'
	        ELSE locacion_descripcion
		END;	
	
--INSERCION DE DATOS 

	INSERT INTO proyecto.locacion (cuadra, locacion_descripcion)
	SELECT DISTINCT cuadra, locacion_descripcion
	FROM proyecto.registros;

	INSERT INTO proyecto.ofensa (iucr, tipo_primario, descripcion)
	SELECT DISTINCT iucr, tipo_primario, descripcion 
	FROM proyecto.registros;

	INSERT INTO proyecto.crimen(crimen_id, numero_caso, fecha, hora, ultima_actualizacion, arresto, domestico, codigo_fbi, beat, distrito, ward, area_comunidad, datos_locacion, datos_ofensa)
	SELECT crimen_id, numero_caso, fecha, hora, ultima_actualizacion, arresto, domestico, codigo_fbi, beat, distrito, ward, area_comunidad, locacion_id, ofensa_id
	FROM(	SELECT * 
			FROM proyecto.registros
				INNER JOIN proyecto.locacion ON proyecto.locacion.cuadra = proyecto.registros.cuadra AND 
											    proyecto.locacion.locacion_descripcion = proyecto.registros.locacion_descripcion
	
				INNER JOIN proyecto.ofensa ON proyecto.ofensa.iucr = proyecto.registros.iucr AND 
								  proyecto.ofensa.descripcion = proyecto.registros.descripcion AND 
								  proyecto.ofensa.tipo_primario = proyecto.registros.tipo_primario 
		);