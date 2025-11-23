# Tarea3SD
Repositorio para la tarea 3 de Sistemas Distribuidos, que utiliza Apache Pig y Hadoop para el analisis de lingüístico entre respuestas generadas por LLM (Gemini) y respuestas humanas sobre un dataset de Yahoo! Answers.

Clonar repositorio:

```bash
git clone https://github.com/pingusdingus99/Tarea3SD.git
cd Tarea3SD
```

## ⚠️ Disclaimer
La ejecución de este proyecto **NO FUNCIONA** en Windows por un bug que arruina los scripts de bash que se encuentran dentro de `/hadoop-config` y `scripts` su funcionamiento fue probado con éxito en Linux.

## Dump de respuestas a analizar
***Este proyecto va de la mano con las 2 previas entregas que se encuentran en [este repositorio](https://github.com/DarellGutierrez/TareaSD_Entrega2), con el cual se generaron las respuestas LLM, eligiendo guardar en la base de datos aquellas respuestas que superaran nuestro umbral de calidad con respecto a las respuestas humanas del dataset original (definido en la entrega anterior).***

En caso de tener una base de datos **`levantada`** desde la entrega anterior, se requiere extraer las columnas `mejor_respuesta` **(respuesta humana de dataset de Yahoo)** y `respuesta_llm` **(respuesta LLM de Gemini)**, para esto, dentro del directorio raíz de este proyecto ejecuta:

```bash
cd dump

sudo docker exec -it tareasd_db_1   psql -U postgres -d db_consultas \
-c "COPY (SELECT respuesta_llm FROM preguntas) TO STDOUT" \
> respuestas_llm.txt

sudo docker exec -it tareasd_db_1   psql -U postgres -d db_consultas \
-c "COPY (SELECT mejor_respuesta FROM preguntas) TO STDOUT" \
> respuestas.txt
```
Si no se tienen respuestas en una base de datos previa entonces se pueden utilizar los que ya se encuentran en `/dump` subidos en el repositorio que corresponden a **1739 respuestas**.

## Levantar proyecto
Una vez se tienen los datos a analizar se levantan los servicios de Hadoop-Pig y una imágen de Python para generación de gráficas, ejecutando el siguiente comando desde la raíz del proyecto:

```bash
sudo docker-compose up --build -d
```

Entrando al entorno de Hadoop con Pig:

```bash
sudo docker exec -it hadoop-pig bash
```

Se ejecuta el script de bash para los subir datos a hdfs y ejecutar script de pig **una vez dentro del contenedor**:

```bash
/scripts/hadoop-pig.sh
```

Una vez termine su ejecución, los resultados se encontrarán dentro de `/dump` para ser analizados por nuestro módulo con python. Puede salir del script con `Ctrl + C` y luego escribiendo `exit` para salir del contenedor.

## Generación de gráficos de barra y nube de palabras.

Entrando al contenedor de python para ejecutar los scripts de generación de gráficos:

```bash
sudo docker exec -it python-scripts bash
```

Una vez dentro del contenedor ejecutar el script de bash:

```bash
./graficos.sh
```

Al finalizar su ejecución los gráficos de barra y nube de palabras de las respuestas de Yahoo! y LLM se encontrarán en forma de .png's dentro del directorio `/dump` en la raíz del proyecto
