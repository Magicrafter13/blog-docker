# Blog [Docker]
This is a docker image for
[my blog](https://gitlab.matthewrease.net/matthew/blog), which is a Flask based
(Python) web app.

The app uses a SQL database, and expects a specific format for the
database/tables. It is recommended that you use the code already provided in
[my post repository](https://gitlab.matthewrease.net/matthew/blog-posts) to
populate the database. Obviously you would provide your own posts (in the
`posts` sub-directory of that repository). More details can be found there, but
essentially you need to:

1. Create a database (titled, for example, `blog`).
2. Grant all privileges for that database (to, for example, the user `blog` with
password `blog`).
3. Run the `update_db` script.

Steps 1 and 2 above:
```sql
CREATE DATABASE blog;
GRANT ALL PRIVILEGES ON blog.* TO 'blog'@'%' IDENTIFIED BY 'blog';
FLUSH PRIVILEGES;
```

Step 3 above:
```sh
python3 ./update_db reset # the reset argument assures the specified database is
                          # cleared and created fresh
```

If using docker-compose, you may skip these steps for now, as by default it
pulls a MariaDB image for you, and I plan to add a way to import posts from the
container itself in a future commit.

# Building the Image
```sh
docker build -t blog-docker .
```

# Running the Image
## Raw with Docker
```bash
docker run \
    -v blog-static:/app/blog/static \ # this is where post images go\
    -e MYSQL_HOST=localhost         \ # you can leave this out if the database is running inside the
                                    \ # same container, such as with the docker-compose
    -e MYSQL_USER=blog              \ # The next 3 values are default and also not needed
    -e MYSQL_PASSWORD=blog \
    -e MYSQL_DATABASE=blog \
    blog-docker
```
## Docker Compose
Make sure you've built the image first.

Modify the `docker-compose.yml` file to suit your needs, paying special
attention to ports, volumes, and environment variables. Additionally, the
compose file will try to pull a MariaDB image and set it up for you. Remove this
if you wish to provide your own.
## General Information
If you're running something like Podman, or some other such solution, the above
information should contain all you need, but to summarize:
### Environment Variables
- **MYSQL_HOST**: defaults to `localhost` - remote address of the database
server (MySQL, MariaDB)
- **MYSQL_USER**: defaults to `blog` - username for authentication
- **MYSQL_PASSWORD**: defaults to `blog` - password for authentication
- **MYSQL_DATABASE**: defaults to `blog` - name of database
### Volumes
- `/app/blog/static`: some assets are not shipped with the image, and are
downloaded here - additionally this is where images for each blog post go
### Ports
uWSGI runs on port 80 in the container.
