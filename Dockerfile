# syntax=docker/dockerfile:1

FROM python:3

EXPOSE 80

LABEL org.opencontainers.image.title="W3CSS Flask Blog"
LABEL org.opencontainers.image.description="Python uWSGI web app with SQL backend"
LABEL org.opencontainers.image.authors="self@matthewrease.net"
LABEL com.portainer.envvars="MYSQL_HOST,MYSQL_USER,MYSQL_PASSWORD,MYSQL_DATABASE"
LABEL com.portainer.dotenv-hint="/app/blog/.env"

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN mkdir -p /app/blog/static

WORKDIR blog

ENV MYSQL_HOST=127.0.0.1
ENV USE_CSP=false

CMD sh update
CMD uwsgi --http :80 --wsgi-file ./app.py --need-app
