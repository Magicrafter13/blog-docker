#!/usr/bin/sh -x

if [ ! -f /app/blog/static/nerdfont.css ] || [ ! -f /app/blog/static/nerdfont.woff2 ]
then
	update static
fi

if [ "$UPDATE_DB" = always ]
then
	update db
fi

touch /app/blog/access.log
uwsgi --ini /app/blog/default.ini --ini /app/blog.ini
