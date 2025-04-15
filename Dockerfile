# syntax=docker/dockerfile:1

FROM python:3

EXPOSE 80

LABEL org.opencontainers.image.title="W3CSS Flask Blog"
LABEL org.opencontainers.image.description="Python uWSGI web app with SQL backend"
LABEL org.opencontainers.image.authors="self@matthewrease.net"
LABEL com.portainer.envvars="MYSQL_HOST,MYSQL_USER,MYSQL_PASSWORD,MYSQL_DATABASE,USE_CSP,REBUILD_DB"
LABEL com.portainer.dotenv-hint="/app/blog/.env"

# Files

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

COPY entrypoint.sh ./
COPY blog ./blog
COPY bin ./bin

COPY patch.py ./

COPY 202504011200.* ./
COPY blog-posts/update_db ./

# Patch Flask app to support /images/ since we don't want /static/ to be mounted by the user.

RUN mv blog/app.py app.py
RUN cat app.py patch.py > blog/app.py
RUN rm app.py patch.py

# Default post for new user

RUN mkdir -p posts blog/images
RUN mv 202504011200.md posts/
RUN mv 202504011200.webp blog/images

# Runtime

ENV PATH="/app/bin:$PATH"
ENV MYSQL_HOST=127.0.0.1
ENV USE_CSP=false
ENV REBUILD_DB=true

CMD ["./entrypoint.sh"]
