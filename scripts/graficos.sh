#!/bin/bash

set -e

echo "Creando gráficos de barra y nube de palabras para las respuestas de Yahoo!"

python ./graficos_yahoo.py

echo "Gráficos de Yahoo! creados correctamente en /dump"

echo "Creando gráficos de barra y nube de palabras para las respuestas de la LLM"

python ./graficos_llm.py

echo "Gráficos de LLM creados correctamente en /dump"
