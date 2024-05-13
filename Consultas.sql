--CONSULTAS 
	
	/* TOP 5 AÑOS DE CRIMEN */	
	SELECT EXTRACT(YEAR FROM fecha) AS anio, COUNT(*) AS cantidad_crimenes
	FROM proyecto.crimen
	GROUP BY EXTRACT(YEAR FROM fecha)
	ORDER BY cantidad_crimenes DESC
	LIMIT 5;
	
	/* TOP 3 DISTRITOS POLICIALES CON MAS CRIMEN */
	SELECT crimen.distrito, COUNT(*) cantidad
	FROM proyecto.crimen
	GROUP BY crimen.distrito
	ORDER BY COUNT(*) DESC
	LIMIT 3;
	
	/* TOP 10 CRIMENES COMETIDOS */
	SELECT ofensa.iucr, ofensa.tipo_primario, ofensa.descripcion, COUNT(*) cantidad
	FROM proyecto.ofensa
	INNER JOIN proyecto.crimen ON ofensa.ofensa_id = crimen.datos_ofensa
	GROUP BY ofensa.iucr, ofensa.tipo_primario,ofensa.descripcion
	ORDER BY COUNT(*) DESC
	LIMIT 10;
	
	/* 5 HORAS CON MAS CRIMENES REGISTRADOS*/
	SELECT crimen.hora, COUNT(*) cantidad
	FROM proyecto.crimen
	GROUP BY hora
	ORDER BY COUNT(*) DESC
	LIMIT 5;
	
	/* PORCENTAJE DE ARRESTOS */
	SELECT 
	  ROUND(
	    CAST((SELECT COUNT(*) FROM proyecto.crimen WHERE arresto = TRUE) AS NUMERIC) / 
	    CAST((SELECT COUNT(*) FROM proyecto.crimen) AS NUMERIC),  
	    2  
	  ) AS porcentaje_arrestos;
	
	/* PORCENTAJE DE CRIMENES DOMESTICOS */ 
	SELECT 
	  ROUND(
	    CAST((SELECT COUNT(*) FROM proyecto.crimen WHERE domestico = TRUE) AS NUMERIC) / 
	    CAST((SELECT COUNT(*) FROM proyecto.crimen) AS NUMERIC),  
	    2  
	  ) AS porcentaje_domestico;
	
	/* PROMEDIO DE DIFERENCIA ENTRE ULTIMA ACTUALIZACION Y FECHA DEL CRIMEN REALIZADO */ 
	SELECT ROUND(AVG(ultima_actualizacion - fecha),2) AS dias
	FROM proyecto.crimen;
	
	/* PORCENTAJE DE ARRESTOS POR CRIMEN */ 
	SELECT 
	    tipo_primario,
	    COUNT(*) AS total_crimenes,
	    SUM(CASE WHEN arresto THEN 1 ELSE 0 END) AS total_arrestos,
	    CAST(SUM(CASE WHEN arresto THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS porcentaje_arrestos
	FROM proyecto.crimen
	JOIN proyecto.ofensa ON proyecto.crimen.datos_ofensa = proyecto.ofensa.ofensa_id
	GROUP BY tipo_primario
	ORDER BY porcentaje_arrestos DESC;    
		