FROM panamax/ruby

ADD . /var/app/panamax-ui

WORKDIR /var/app/panamax-ui
RUN bundle install --gemfile=/var/app/panamax-ui/Gemfile
CMD bundle exec rails s
