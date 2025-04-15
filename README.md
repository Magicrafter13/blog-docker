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
    -v blog-posts:/app/posts        \ # this is where the Markdown(+YAML) files go
    -v blog-static:/app/blog/images \ # this is where post images go
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

By default it binds on port 8080, and creates/uses a Docker volume called
`db_data` for the MariaDB database.
## General Information
If you're running something like Podman, or some other such solution, the above
information should contain all you need, but to summarize:
### Environment Variables
- **MYSQL_HOST**: defaults to `localhost` - remote address of the database
server (MySQL, MariaDB)
- **MYSQL_USER**: defaults to `blog` - username for authentication
- **MYSQL_PASSWORD**: defaults to `blog` - password for authentication
- **MYSQL_DATABASE**: defaults to `blog` - name of database
- **REBUILD_DB**: defaults to `true` - when true, drops all tables in the
database and recreates it when the image is run
### Volume Locations
- `/app/posts`: this is where each .md post file goes
- `/app/blog/images`: this is where images for each blog post go
#### Additional Information/Considerations
1. Post filenames should consist of numbers only. They can technically be in any
format, but the recommended format is `YYYYmmddHHMM.md`, or sequential IDs:
`0.md`, `1.md`, etc.
2. Image filenames must match their `.md` counterparts, and end with `.webp`.
The images don't technically have to be webp, aside from the fact that all the
metadata on the webpages will indicate they are webp files.
3. If you store your posts in a `.git` repo (that the container can see), and
set `REBUILD_DB` to `false`, then the database will be updated on each image
run, based on the changes in the most recent git commit. For example, if the
last commit received has a file being edited, the existing post (assuming you
didn't change the filename) will be deleted, and re-added with the updated
content - if the commit has a file which has been deleted, the post will be
deleted from the database - and if the commit has a new file, that post will be
added to the database. Any post/file not involved in the commit will be ignored
and untouched. This is good for slightly reducing disk I/O, however if the
database itself is not saved between image runs (for example, you're using the
docker compose method without a volume), then this is pointless and will not
produce the desired results.
4. If you do not want the Docker image to touch your database at all (as in,
modifying data), set `REBUILD_DB` to false, and don't volume mount `/app/posts`
at all. This should effectively prevent any attempts at modifying data (you can
also just disable write related permissions on the database).
### Ports
uWSGI runs on port 80 in the container.

# Misc
Docker image from https://binfalse.de/
