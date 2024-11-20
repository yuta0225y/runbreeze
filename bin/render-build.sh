set -o errexit

bundle config set without 'development test'
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
