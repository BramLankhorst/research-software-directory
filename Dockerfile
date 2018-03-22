FROM python:3

RUN (echo "deb http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list)
RUN (apt-get update)
RUN (apt-get -y install sassc)

WORKDIR /src

COPY requirements.txt /src/
RUN pip3 install -r requirements.txt

COPY . /src
RUN (sassc --style=compressed --sourcemap style/rsd.scss static/style/rsd.scss.css)

STOPSIGNAL SIGINT

CMD gunicorn --preload --workers 3 --max-requests 10 --timeout 15 --bind 0.0.0.0:5004 --access-logfile - --error-logfile - entry:application

EXPOSE 5004
