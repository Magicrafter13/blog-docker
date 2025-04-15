#!/usr/bin/sh

cd blog

if [ ! -f static/nerdfont.css ] || [ ! -f static/nerdfont.woff2 ]
then
	update static
fi

if [ "$UPDATE_DB" = always ]
then
	update db
fi

uwsgi --logto ./uwsgi.log --http :80 --wsgi-file ./app.py --need-app
