# Tarea3SD
Repositorio para la tarea 3 de Sistemas Distribuidos


## Hacer dump a csv con el siguiente comando (procurar tener levantada la base de datos de el repositorio anterior)

```bash
sudo docker exec tareasd_db_1 psql -U postgres -d db_consultas -c "\copy preguntas to STDOUT csv header" > ./dump/preguntas.csv
```