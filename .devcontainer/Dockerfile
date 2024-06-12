FROM ruby:3.3.2-slim-bullseye
MAINTAINER KasaHNO3 <umbrella.hsiao@gmail.com>

# set timezone
ARG TimeZone=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/${TimeZone} /etc/localtime
RUN echo ${TimeZone} > /etc/timezone

RUN apt-get update && apt-get install -y gcc make git vim
# build-essential could provide better experience, while the installation is slow
COPY ruby-extensions/Gemfile /usr/workspace/.devcontainer/ruby-extensions/Gemfile
COPY ruby-extensions/Gemfile.lock /usr/workspace/.devcontainer/ruby-extensions/Gemfile.lock

WORKDIR /usr/workspace/.devcontainer/ruby-extensions
RUN gem install bundler -v '2.5.11'
RUN bundle install

WORKDIR /usr/workspace


