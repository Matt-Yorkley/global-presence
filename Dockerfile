# Arcane secrets of Rails Dockermancy gleaned from:
# - https://docs.docker.com/samples/rails/
# - https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development
# - https://community.fly.io/t/ruby-on-rails-deployments/341/18

ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-slim-buster

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ARG NODE_VERSION

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    nodejs \
    yarn \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ARG BUNDLER_VERSION

# Upgrade RubyGems and install required Bundler version
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

RUN mkdir -p /rails
WORKDIR /rails

ARG RAILS_ENV="production"
ENV RAILS_ENV=${RAILS_ENV}
ARG BUNDLE_WITHOUT="development test"
ENV BUNDLE_WITHOUT=${BUNDLE_WITHOUT}

COPY Gemfile Gemfile.lock ./
RUN bundle config --global frozen 1 \
    && bundle install -j4 --retry 3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . .

RUN VITE_RUBY_AUTO_BUILD=false bundle exec rake assets:precompile

CMD rails s -p 3000 -b 0.0.0.0
