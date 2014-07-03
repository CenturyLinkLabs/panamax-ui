FROM 74.201.240.198:5000/ruby:alpha

ENV RAILS_ENV production

# Need to find a more elegant way to handle this
RUN mv ctl-base-ui ../ctl-base-ui

RUN bundle install --without development test

CMD bundle exec rake assets:precompile && \
  bundle exec rails s -e production
