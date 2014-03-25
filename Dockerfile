FROM panamax/ruby

RUN apt-get install -y g++

ADD . /var/app/panamax-ui
RUN chmod +x /var/app/panamax-ui/bin/start.sh

WORKDIR /var/app/panamax-ui
RUN bundle install --gemfile=/var/app/panamax-ui/Gemfile
CMD "/var/app/panamax-ui/bin/start.sh"