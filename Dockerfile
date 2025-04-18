# syntax=docker/dockerfile:1

FROM python:3

EXPOSE 8080

LABEL org.opencontainers.image.title="W3CSS Flask Blog"
LABEL org.opencontainers.image.description="Python uWSGI web app with SQL backend"
LABEL org.opencontainers.image.authors="self@matthewrease.net"
LABEL com.portainer.envvars="MYSQL_HOST,MYSQL_USER,MYSQL_PASSWORD,MYSQL_DATABASE,USE_CSP,REBUILD_DB,UPDATE_DB"
LABEL com.portainer.dotenv-hint="/app/blog/.env"

# Files

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
ADD https://www.nerdfonts.com/assets/css/webfont.css blog/static/nerdfont.css
ADD https://www.nerdfonts.com/assets/fonts/Symbols-2048-em%20Nerd%20Font%20Complete.woff2 blog/static/nerdfont.woff2
ADD http://afarkas.github.io/lazysizes/lazysizes.min.js blog/static/lazysizes.min.js
RUN sed -i 's#\.\./fonts/Symbols-2048-em Nerd Font Complete.woff2#/static/nerdfont.woff2#' blog/static/nerdfont.css

# Default post for new user

RUN mkdir -p posts blog/static/images
RUN mv 202504011200.md posts/
RUN mv 202504011200.webp blog/static/images

# End

RUN chown www-data:www-data -R /app

# Runtime

USER www-data

ENV PATH="/app/bin:$PATH"

ENV PYTHONDONTWRITEBYTECODE=1

ENV MYSQL_HOST=127.0.0.1
ENV USE_CSP=false
ENV REBUILD_DB=true
ENV UPDATE_DB=always

CMD ["entrypoint.sh"]
