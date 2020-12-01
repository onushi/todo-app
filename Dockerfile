FROM node:12.10.0-alpine as node
FROM ruby:2.6.4-alpine

ENV YARN_VERSION 1.17.3

RUN mkdir -p /opt
COPY --from=node /opt/yarn-v$YARN_VERSION /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

WORKDIR /app
ENV TZ=Asia/Tokyo

COPY Gemfile .
COPY Gemfile.lock .
COPY package.json .
COPY yarn.lock .

# because apk fail to fetch APKINDEX
RUN sed -i -e 's/http:/https:/' /etc/apk/repositories

RUN apk update && \
    apk add --no-cache tzdata libxml2-dev curl-dev make gcc libc-dev g++ mariadb-dev && \
    gem install bundler:2.0.2 && \
    bundle install && \
    yarn install && \
    rm -rf /usr/local/bundle/cache/* /usr/local/share/.cache/* /var/cache/* /tmp/* && \
    apk del libxml2-dev curl-dev make gcc libc-dev g++
