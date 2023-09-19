#!/bin/bash

# Directorio base
base_dir="/var/log/"

# Tamaño máximo en bytes (1 MB)
max_size=$((1024 * 1024))

# Eliminar archivos .gz
find "$base_dir" -type f -name "*.gz" -delete

# Eliminar archivos que contengan algún número en el nombre
find "$base_dir" -type f -name "*[0-9]*" -delete

# Crear una lista de archivos duplicados y dejar el más reciente
find "$base_dir" -type f -exec md5sum {} + | sort > /tmp/files_md5sum.txt
awk '{print $1}' /tmp/files_md5sum.txt | sort | uniq -d | while read -r line; do
  grep "$line" /tmp/files_md5sum.txt | sort -k2,2nr | awk 'NR>1 {print $2}' | xargs rm -f
done
rm /tmp/files_md5sum.txt

# Eliminar archivos más grandes que 1 MB
find "$base_dir" -type f -size +${max_size}c -delete

# Eliminar archivos que terminen en un número
find "$base_dir" -type f -regex '.*[0-9]$' -delete
