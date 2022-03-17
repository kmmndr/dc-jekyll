FROM alpine:3.15
RUN sed -i -e 's|^\(.*\)v3.15/main|@edge-testing \1edge/testing\n&|' /etc/apk/repositories

RUN apk add --no-cache ruby caddy goreman@edge-testing
RUN apk add --no-cache ruby-dev build-base

RUN echo 'gem: --no-document' > ~/.gemrc
RUN gem install \
      bundler \
      jekyll

ENV WORKDIR /srv/app
WORKDIR $WORKDIR

COPY entrypoint.sh Caddyfile Procfile /

CMD /entrypoint.sh
