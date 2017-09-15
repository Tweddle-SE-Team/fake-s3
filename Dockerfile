FROM alpine:3.4

RUN apk add --no-cache --update ruby \
                                ruby-dev \
                                ruby-bundler \
                                python py-pip \
                                git \
                                curl \
                                build-base \
                                libxml2-dev \
                                libxslt-dev
RUN pip install boto awscli

COPY fakes3.gemspec Gemfile Gemfile.lock /app/
COPY lib/fakes3/version.rb /app/lib/fakes3/
WORKDIR /app

RUN bundle install

COPY Rakefile test /app/
RUN rake

COPY . /app/

ENTRYPOINT bin/fakes3 server -H ${FAKE_S3_HOSTNAME-fake-s3} \
                             -a ${FAKE_S3_ADDRESS-0.0.0.0} \
                             -r ${FAKE_S3_ROOT-/opt/fakes3} \
                             -p ${FAKE_S3_PORT-80} \
                             -b ${FAKE_S3_BUCKETS-test}
