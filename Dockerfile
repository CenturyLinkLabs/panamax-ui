FROM 74.201.240.198:5000/ruby:alpha

ADD . /var/app/panamax-ui
RUN mv /var/app/panamax-ui/ctl-base-ui /var/app/ctl-base-ui

EXPOSE 3000

WORKDIR /var/app/panamax-ui
RUN bundle
CMD bundle exec rails s
