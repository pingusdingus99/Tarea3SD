A = LOAD '/dump/preguntas.csv' USING PigStorage(',') AS (col1:chararray, col2:int);
B = FILTER A BY col2 > 10;
DUMP B;