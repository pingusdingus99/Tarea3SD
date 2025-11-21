# Tarea3SD
Repositorio para la tarea 3 de Sistemas Distribuidos, que utiliza Apache Pig y Hadoop para el analisis de datos entre respuestas gemeradas por LLM (Gemini) y respuestas humanas sobre un dataset de Yahoo! Answers.

Clonar repositorio:

```bash
git clone https://github.com/pingusdingus99/Tarea3SD.git
cd Tarea3SD
```

## Dump de respuestas a analizar
Este proyecto va de la mano con las 2 previas entregas que se encuentran en [este repositorio](https://github.com/DarellGutierrez/TareaSD_Entrega2), con el cual se generaron las respuestas LLM, eligiendo guardar en la base de datos aquellas respuestas que superaran nuestro umbral de calidad con respecto a las respuestas humanas del dataset original.

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
Si no se tienen respuestas en una base de datos previa entonces se pueden utilizar los que ya se encuentran en `/dump` subidos en el repositorio que corresponden a **1400 respuestas**.

## Levantar proyecto
Una vez se tienen los datos a analizar se levantan los servicios de Pig y Hadoop, ejecutando el siguiente comando desde la raíz del proyecto:

```bash
sudo docker-compose up --build -d
```

Y luego entrando al contenedor:

```bash
sudo docker exec -it hadoop-pig bash
```

Finalmente ejecutando el script de subir datos a hdfs y ejecutar script de pig **una vez dentro del contenedor**:

```bash
/scripts/entrypoint.sh
```

Una vez termine su ejecución, los resultados se encontrarán dentro de `/dump` para ser analizados por nuestro módulo con python.

## Gráfico de datos en barras horizontales y nube de palabras.