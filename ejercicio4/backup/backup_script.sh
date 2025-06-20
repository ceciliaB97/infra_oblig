#!/bin/bash

while true; do
    for i in 1 2 3; do
        echo "Realizando backup desde maquina$i..."
        RSYNC_DIR="/home/maquina$i"
        mkdir -p "$RSYNC_DIR"
        rsync -az -e "ssh -i /root/.ssh/id_rsa -o StrictHostKeyChecking=no" \
              user@maquina$i:/home/users/documentos/ "$RSYNC_DIR"
    done
    echo "Backup completado. Esperando 2 minutos..."
    sleep 120
done
