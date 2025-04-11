#!/usr/bin/sh

cd blog
sh update

uwsgi --logto ./uwsgi.log --http :80 --wsgi-file ./app.py --need-app
