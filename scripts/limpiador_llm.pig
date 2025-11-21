/* Script: Análisis de Frecuencia desde Texto Plano
   Estrategia: TextLoader para evitar errores de parsing CSV
*/

-- 1. CARGA DE DATOS RAW
-- Usamos TextLoader(). Esto carga cada línea del archivo en una sola variable llamada 'line'.
-- No busca comas ni puntos y comas. Lee la línea completa.
raw_lines = LOAD 'input/respuestas_llm.txt' USING TextLoader() AS (line:chararray);

-- 2. CARGA DE STOPWORDS
-- Recuerda: Si tus textos están en inglés, usa el stopwords.txt en inglés.
stopwords = LOAD 'input/stopwords.txt' AS (word:chararray);

-- 3. TOKENIZACIÓN
-- Tomamos la línea completa, la pasamos a minúsculas y la rompemos en palabras.
words_dirty = FOREACH raw_lines GENERATE 
    FLATTEN(TOKENIZE(LOWER(line))) AS word;

-- 4. LIMPIEZA (REGEX)
-- Aquí es donde quitamos puntuación, comillas, paréntesis, etc.
-- SOLO INGLÉS Y NÚMEROS: '[^a-z0-9]'
-- SI ES ESPAÑOL: '[^a-z0-9áéíóúñ]'
words_clean = FOREACH words_dirty GENERATE 
    REPLACE(word, '[^a-z0-9]', '') AS word;

-- Filtramos "basura" que haya quedado (ej. si había una palabra que era solo "!!!", ahora es vacía)
-- También filtramos palabras de 1 letra (como "a" o números sueltos) para limpiar ruido.
words_final = FILTER words_clean BY SIZE(word) > 1;

-- 5. FILTRADO DE STOPWORDS (JOIN)
-- Cruzamos las palabras del texto con la lista de prohibidas
joined_words = JOIN words_final BY word LEFT OUTER, stopwords BY word USING 'replicated';

-- Nos quedamos con las que NO hicieron match (lado derecho es NULL)
valid_words = FILTER joined_words BY stopwords::word IS NULL;

-- Proyectamos solo la palabra limpia
processed_words = FOREACH valid_words GENERATE words_final::word AS word;

-- 6. CONTEO (WORD COUNT)
grouped_words = GROUP processed_words BY word;

word_counts = FOREACH grouped_words GENERATE 
    group AS word, 
    COUNT(processed_words) AS count;

-- 7. ORDENAR Y GUARDAR
ordered_counts = ORDER word_counts BY count DESC;

-- Guardamos. Aquí sí usamos PigStorage(',') para que el RESULTADO sea un CSV fácil de leer.
STORE ordered_counts INTO 'salida_conteo_final_llm' USING PigStorage(',');
