FROM fluent/fluentd:v1.5-debian-1
MAINTAINER David_Cruz davidfpcruz@gmail.com

USER root

COPY Gemfile ./
COPY *.gemspec ./

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN buildDeps="sudo make gcc g++ libc-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install -N fluent-plugin-systemd -v "1.0.2" \
 && sudo gem install -N fluent-plugin-concat -v "2.2.2" \
 && sudo gem install -N fluent-plugin-prometheus -v "1.3.0" \
 # required to parse multi_json
 && sudo gem install fluent-plugin-jq \
 && sudo gem install bundler \
 && sudo bundle \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY fluent.conf /fluentd/etc/

USER fluent
