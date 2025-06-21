FROM debian:bullseye

# Instalar SSH y rsync
RUN apt-get update && apt-get install -y openssh-server rsync sudo

# Crear usuario y carpetas necesarias
RUN useradd -ms /bin/bash user && \
    mkdir -p /home/user/.ssh && \
    mkdir -p /home/users/documentos && \
    chown -R user:user /home/users

# Copiar la clave pública para conexión SSH
COPY id_rsa.pub /home/user/.ssh/authorized_keys

# Permisos correctos
RUN chown -R user:user /home/user/.ssh && \
    chmod 700 /home/user/.ssh && \
    chmod 600 /home/user/.ssh/authorized_keys

# Preparar el SSH
RUN mkdir /var/run/sshd
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
