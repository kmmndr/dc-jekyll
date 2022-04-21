FROM alpine:3.15
RUN sed -i -e 's|^\(.*\)v[0-9.]*/main|@edge-testing \1edge/testing\n&|' /etc/apk/repositories

RUN apk add --no-cache \
      ruby \
      ruby-dev \
      build-base \
      \
      caddy \
      goreman@edge-testing \
      \
      git \
      inotify-tools \
      openssh-client

RUN echo 'gem: --no-document' > ~/.gemrc
RUN gem install \
      bundler \
      jekyll

ENV WORKDIR /srv/app
WORKDIR $WORKDIR

COPY entrypoint.sh Caddyfile Procfile /
COPY repo.sh /usr/local/bin

CMD /entrypoint.sh
