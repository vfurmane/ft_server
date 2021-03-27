FROM debian:buster

RUN apt-get update && apt-get install -y \
    nginx

WORKDIR /usr/src/ft_server
COPY srcs/* ./
ENTRYPOINT ["./start.sh"]

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
