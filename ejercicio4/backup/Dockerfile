FROM debian:bullseye

RUN apt-get update && apt-get install -y rsync openssh-client

COPY backup_script.sh /usr/local/bin/backup_script.sh
COPY id_rsa /root/.ssh/id_rsa

RUN chmod 600 /root/.ssh/id_rsa && chmod +x /usr/local/bin/backup_script.sh

CMD ["bash", "/usr/local/bin/backup_script.sh"]
