# Chicago-Crimes-2001-to-Present-Data-Proyect
## Introducción 
Se diseñó un sistema de gestión de datos sobre el dataset de crímenes en Chicago con el propósito de almacenar, administrar y analizar de forma efectiva la información relacionada con actividades delictivas. Este informe se enfoca en la normalización de los datos además de una serie de consultas con fines estadísticos. <br> <br>
<ul>
  <li>El archivo llamado *Normalización* contiene el código para la creación de tablas, limpieza necesaria de los datos e inserción de datos</li>
  <li>El archivo llamado *Consultas* contiene el código para la obtención de datos estadísticos después de la normalización</li>
  <li>El archivo llamado *Resultados* contiene las gráficas obtenidas de las consultas</li>
</ul>

## DataSet
Los datos se pueden descargar desde el *CHICAGO DATA PORTAL* en formato CSV <br>
https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-Present/ijzp-q8t2/about_data <br>

## Análisis de los datos
El proyecto se realizó con PostgreSQL <br>
### Procesamiento de los datos 
<ol>
  <li> Manejo de valores nulos: los valores nulos fueron identificados y eliminados </li>
  <li>Eliminación de datos irrelevantes: se eliminaron las columnas irrelevantes para el planteamiento del problema específico </li>
</ol>

## Normalización
Con el fin de optimizar la eficacia, se llevó a cabo un proceso de normalización que implicó la reestructuración de la tabla inicial de Delitos en tres tablas separadas pero interrelacionadas: Crimen, Locacion y Ofensa. <br> <br>
Schema: <br>

<table border="1">
  <tr>
    <th>Locacion</th>
    <th>Ofensa</th>
    <th>Crimen</th>
  </tr>
  <tr>
    <td>Almacena detalles de ubicación únicos</td>
    <td>Clasifica tipos de delitos</td>
    <td>Tabla principal que enlaza con Ubicación y Ofensa</td>
  </tr>
  <tr>
    <td>Columnas: location_id (primary key), block, location_description</td>
    <td>Columnas: offense_id (primary key), iucr, primary_type, description</td>
    <td>Columnas: id (primary key), case_number, date, last_update, arrest, domestic, district, ward, community_area, location_id, offense_id</td>
  </tr>
</table>

Ventajas: esta normalización minimiza la redundancia de datos y mejora la eficiencia de las consultas. <br>
## Consultas
Las estadísticas obtenidas son: <br>
<ul>
  <li>Top 5 años con mayor número de crímenes </li>
  <li>Top 3 distritos policiales con más crimen </li>
  <li>Top 10 crímenes más cometidos </li>
  <li>Top 5 horarios con más crímenes registrados </li>
  <li>Porcentaje de arrestos </li>
  <li>Porcentaje de crímenes domésticos </li>
  <li>Promedio de diferencia entre última actualización y fecha del reporte del crimen </li>
  <li>Porcentaje de arrestos por crimen </li>
</ul>


## Implicaciones Éticas
El proyecto de análisis de crímenes en Chicago conlleva importantes implicaciones éticas dadas la sensibilidad inherente de los datos. La divulgación de información detallada sobre crímenes podría resultar en la estigmatización de comunidades enteras o individuos específicos, perpetuando así estereotipos y prejuicios. Además, existe el riesgo de que la interpretación de las estadísticas sea sesgada o malinterpretada, lo que podría exacerbar aún más la polarización y la desconfianza en el sistema de justicia. Por último, la seguridad y la integridad de los datos deben ser prioridades absolutas para prevenir cualquier manipulación malintencionada o acceso no autorizado que pueda comprometer la confianza pública en el proyecto y sus resultados.










