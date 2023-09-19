#!/bin/bash

# path to dir log
log_root="/var/log"

# size max kilobytes
max_size_kb=1024  # 1MB

# Busca y elimina archivos duplicados con extensiones numeradas (.1, .2, .3, .4)
find "$log_root" -type f -name "*.log.[0-9]*" -o -name "*.gz.[0-9]*" -o -name "*.err"  |
  awk -F'[.]' '{print $1}' |                 # Elimina la extensi  n numeradas
  sort |                                      # Ordena por nombre de archivo
  uniq -d |                                   # Encuentra nombres de archivo duplicados
  xargs -I {} sh -c 'ls -t "{}".* | tail -n +2 | xargs rm -f' # Elimina archivos 

