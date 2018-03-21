FROM node:8.9.4-alpine

ARG SSH_KEY

RUN mkdir /root/.ssh/

RUN echo -e ${SSH_KEY} > /root/.ssh/id_rsa

RUN chmod 400 /root/.ssh/id_rsa

COPY known_hosts /root/.ssh/

RUN apk add --no-cache git openssh python build-base

RUN git clone git@github.com:Koyfin/koyfin-vocabulary.git

RUN rm -r /root/.ssh/

RUN mkdir /microservice

WORKDIR /microservice

COPY . ./

RUN ls -la ./

CMD ["sleep 10000"]
