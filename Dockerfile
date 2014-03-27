FROM panamax/ruby

ADD . /var/app/panamax-ui
RUN chmod +x /var/app/panamax-ui/bin/start.sh

WORKDIR /var/app/panamax-ui
RUN bundle install --gemfile=/var/app/panamax-ui/Gemfile
CMD bundle exec rake db:setup && bundle exec rails s