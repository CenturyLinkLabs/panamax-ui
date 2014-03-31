FROM panamax/ruby

ADD . /var/app/panamax-ui
ADD ctl-base-ui /var/app/ctl-base-ui
WORKDIR /var/app/panamax-ui
RUN bundle install --gemfile=/var/app/panamax-ui/Gemfile
CMD bundle exec rails s
