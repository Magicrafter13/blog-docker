#!/usr/bin/sh

if [ "$REBUILD_DB" = "true" ]
then
	echo FLUSHING DATABASE
	python3 update_db reset
fi

cd blog
sh update

uwsgi --logto ./uwsgi.log --http :80 --wsgi-file ./app.py --need-app
