FROM ruby:2.7.0-slim
MAINTAINER KasaHNO3 <umbrella.hsiao@gmail.com>
RUN apt-get update && apt-get install -y build-essential nodejs git vim
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler -v '2.3.11'
RUN bundle install
RUN gem update --system
CMD ["rails", "server", "-b", "0.0.0.0"]
# `gem update --system` is for: Warning: the running version of Bundler is older than the version that created the lockfile
