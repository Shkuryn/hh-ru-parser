
FROM ruby:3.2.2

WORKDIR /app

COPY . /app

RUN bundle install

CMD ["bash"]
