FROM ruby:3.4.3-alpine

ARG RAILS_ROOT=/task_manager

ARG PACKAGES="\
  build-base \
  bash \
  curl \
  git \
  less \
  nodejs \
  postgresql-client \
  postgresql-dev \
  readline-dev \
  libxml2-dev \
  libxslt-dev \
  yaml-dev \
  zlib-dev \
  tzdata \
  vim \
  yarn \
  gcompat \
  libffi-dev \
  openssl-dev \
"

RUN apk update \
    && apk upgrade --no-cache \
    && apk add --no-cache $PACKAGES

RUN gem install bundler

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock  ./
RUN bundle install --jobs 5

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . $RAILS_ROOT

ENV PATH="$RAILS_ROOT/bin:$PATH"

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
