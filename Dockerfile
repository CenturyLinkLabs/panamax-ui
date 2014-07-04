FROM 74.201.240.198:5000/ruby:alpha

ENV RAILS_ENV production

RUN bundle install --without development test

CMD bundle exec rake assets:precompile && \
  bundle exec rails s -e production
