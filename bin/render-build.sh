set -o errexit

bundle install --without development test
bundle exec rails assets:precompile
bundle exec rails assets:clean