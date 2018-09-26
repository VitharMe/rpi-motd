FROM resin/rpi-raspbian

MAINTAINER Vithar Me <vithar@vithar.me>

RUN apt-get update && apt-get upgrade -y && apt-get install toilet lolcat tcl git -y

COPY . /

CMD ["./motd.sh"]
