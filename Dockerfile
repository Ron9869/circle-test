FROM node:8.9.4-alpine

RUN mkdir /microservice

RUN apk add --no-cache git openssh python build-base

WORKDIR /microservice

COPY . ./

ENTRYPOINT ["sleep 10000"]
