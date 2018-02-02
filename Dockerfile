# set our node environment, either development or production
# defaults to production, compose overrides this to development on build and run
ARG NODE_IMG=node
ARG NODE_VERSION=9-alpine
ARG NODEMON_VERSION=latest
ARG NODE_ENV=production
ARG PORT=80
# Base Node
FROM $NODE_IMG:$NODE_VERSION AS base
MAINTAINER Dragosh <oancea.dragosh@gmail.com>
LABEL vendor="I{ustomMade"
# Application root
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
VOLUME ["/usr/src/app"]
ADD . /usr/src/app
## Exposing
EXPOSE $PORT 5858 9229

# HEALTHCHECK
RUN apk add --no-cache curl
HEALTHCHECK CMD curl -fs http://localhost:$PORT || exit 1
# Global packages
RUN npm i -g nodemon@$NODEMON_VERSION --loglevel error --unsafe-perm
# Provides cached layer for node_modules
ADD package.json /tmp/package.json
RUN cd /tmp && npm install --loglevel error && npm cache clean --force
RUN cp -a /tmp/node_modules /usr/src/app/
## Default ENVs
ENV PORT $PORT
ENV NODE_ENV $NODE_ENV
ENV PATH /usr/src/app/node_modules/.bin:$PATH
## Execute, compose overrides this to development
CMD [ "node", "bin/server.js"]
