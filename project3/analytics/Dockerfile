FROM python:3.10-slim-buster


RUN apt update -y
RUN apt install build-essential libpq-dev -y
RUN pip install --upgrade pip setuptools wheel

WORKDIR /src
COPY project3/analytics/requirements.txt requirements.txt
RUN pip install -r requirements.txt

ENV DB_USERNAME=myuser
ENV DB_PASSWORD=mypassword
ENV DB_HOST=127.0.0.1
ENV DB_PORT=5433
ENV DB_NAME=mydatabase

COPY project3/analytics/config.py config.py
COPY project3/analytics/app.py app.py

CMD ["python", "app.py"]
# RUN python app.py