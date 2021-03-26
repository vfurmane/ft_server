FROM debian:buster

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y nginx

WORKDIR /usr/src/ft_server
COPY srcs/* ./
CMD ["./start.sh"]

EXPOSE 80
