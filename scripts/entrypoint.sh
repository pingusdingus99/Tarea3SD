#!/bin/bash
set -e

echo "Esperando a que el NameNode salga de SafeMode"
until hdfs dfsadmin -safemode get | grep -q "OFF"; do
	echo "NameNode en Safe Mode... esperando"
	sleep 3
done

echo "Subiendo respuestas yahoo a hdfs"
hdfs dfs -put -f /dump/respuestas.txt input

echo "Subiendo respuestas llm a hdfs"
hdfs dfs -put -f /dump/respuestas_llm.txt input

echo "Subiendo stopwords a hdfs"
hdfs dfs -put -f /dump/stopwords.txt input

echo "Ejecutando script Pig para limpiar respuestas yahoo"
pig -x mapreduce /scripts/limpiador.pig

echo "Mostrando output de pig para respuestas yahoo"
hdfs dfs -cat salida_conteo_final_yahoo/part* || true

echo "Ejecutando script Pig para limpiar respuestas llm"
pig -x mapreduce /scripts/limpiador_llm.pig

echo "Mostrando output de pig para respuestas llm"
hdfs dfs -cat salida_conteo_final_llm/part* || true

echo "Guardando resultados en /dump"
hdfs dfs -get salida_conteo_final_llm/part-r-00000 /dump/resultados_llm.txt
hdfs dfs -get salida_conteo_final_yahoo/part-r-00000 /dump/resultados_yahoo.txt

echo "Completado, resultados guardados en /dump, resultados_yahoo.txt y resultados_llm.txt"

tail -f /dev/null

