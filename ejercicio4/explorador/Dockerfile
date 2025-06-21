FROM python:3.10-slim

RUN apt-get update && apt-get install -y bash

COPY alerta_script.sh /usr/local/bin/alerta_script.sh
COPY web_server.py /web_server.py

RUN pip install flask

CMD bash -c "/usr/local/bin/alerta_script.sh & python3 /web_server.py"
