FROM ubuntu:14.04
MAINTAINER Thiago Moretto <thiago.moretto@gmail.com>

# Reduce output from debconf
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Setup all needed dependencies
RUN apt-get update
RUN apt-get -y install curl libcurl4-gnutls-dev git libxslt-dev libxml2-dev libpq-dev libffi-dev imagemagick

# Install rvm, ruby, rails, rubygems, passenger, nginx
ENV RUBY_VERSION 2.2.0
ENV PASSENGER_VERSION 4.0.59

# All rvm commands need to be run as bash -l or they won't work.
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable --rails
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/bash.bashrc
RUN /bin/bash -l -c 'rvm requirements'
RUN /bin/bash -l -c 'rvm install $RUBY_VERSION && rvm use $RUBY_VERSION --default'
RUN /bin/bash -l -c 'rvm rubygems current'
RUN /bin/bash -l -c 'gem install passenger --version $PASSENGER_VERSION'
RUN /bin/bash -l -c 'passenger-install-nginx-module --auto-download --auto'
RUN /bin/bash -l -c 'gem install bundler --no-ri --no-rdoc'

# You need a javascript runtime to run rails.
RUN apt-get -y install nodejs

# Nginx log file.
RUN mkdir -p /var/log/nginx/

# You'll need to override the default nginx.conf with you're own. 
# I've provided a sample in the github project.
# ADD local/path/to/nginx.conf /opt/nginx/conf/nginx.conf

# You'll obviously want to expose some ports.
EXPOSE 80
