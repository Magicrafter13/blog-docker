#!/usr/bin/sh -x

if [ ! -f /app/blog/static/nerdfont.css ] || [ ! -f /app/blog/static/nerdfont.woff2 ]
then
	update static
fi

if [ "$UPDATE_DB" = always ]
then
	update db
fi

uwsgi --ini /app/blog.ini
