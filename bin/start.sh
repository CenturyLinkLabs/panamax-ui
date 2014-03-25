#!/bin/bash

cd /var/app/panamax-ui
bundle install --gemfile=/var/app/panamax-ui/Gemfile
bundle exec rake db:setup
bundle exec rails s