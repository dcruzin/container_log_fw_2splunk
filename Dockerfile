FROM fluent/fluentd:v1.5-debian-1
MAINTAINER David_Cruz davidfpcruz@gmail.com

USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN buildDeps="sudo make gcc g++ libc-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

# this is the default collection where the fluentd entrypoint will load plugins
COPY plugins/* /fluentd/plugins/

COPY fluent.conf /fluentd/etc/

USER fluent
