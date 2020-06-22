FROM nginx:1.10-alpine

ADD docker/vhost.conf /etc/nginx/conf.d/default.conf

RUN apk update && \
    apk add git

WORKDIR /var
RUN rm -rf www
RUN git clone https://github.com/thanhnv8421/blog www
