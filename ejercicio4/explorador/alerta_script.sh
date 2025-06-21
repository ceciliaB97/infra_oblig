#!/bin/bash
mkdir -p /home/alertas_detectadas
PROCESADOS="/home/alertas_detectadas/procesados.txt"

touch "$PROCESADOS"

while true; do
    find /mnt/backups -type f | while read -r file; do
        # Si el archivo ya fue procesado, saltar
        grep -qxF "$file" "$PROCESADOS" && continue

        if grep -q "Alarma" "$file"; then
            timestamp=$(date "+%Y-%m-%d %H:%M:%S")
            word_count=$(wc -w < "$file")
            a_count=$(grep -o '\w\+a\b' "$file" | wc -l)
            echo "$timestamp | $file | Palabras: $word_count | Finalizan con 'a': $a_count" >> /home/alertas_detectadas/log_alertas.txt
        fi

        # Marcar archivo como procesado
        echo "$file" >> "$PROCESADOS"
    done
    sleep 60
done
