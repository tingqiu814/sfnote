FROM alpine:latest
MAINTAINER tingqiu814 skin20120726@sina.cn

# to run binary file build by golang 
RUN mkdir /lib64 && ln -s /lib/ld-musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# install nginx
RUN apk --update add nginx
RUN mkdir /run/nginx
RUN touch /run/nginx/nginx.pid

EXPOSE 80
 
CMD ["nginx", "-g", "daemon off;"]
