FROM opensuse/leap:15.4

RUN zypper --non-interactive install --no-recommends \
    gcc-c++ ruby2.5 ruby2.5-devel ruby2.5-rubygem-bundler && \
    zypper --non-interactive install -t pattern devel_basis

ENV LANG "en_US.UTF-8"

ENV RKE_NODE_ADDR NULL
ENV RKE_INSTANCE_ADDR NULL
ENV RKE_INSTANCE_INDEX NULL

WORKDIR /srv/www/api

COPY Gemfile* /srv/www/api

RUN bundle install

COPY . /srv/www/api

EXPOSE 8080

CMD ["bundler", "exec", "rackup", "-o", "0.0.0.0", "-p", "8080"]
