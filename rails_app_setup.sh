#!/bin/bash
# run script on your rails app

app_name=
local_app_dir=
ip_vps=

cd $local_app_dir
git remote add dokku dokku@$ip_vps:$app_name

# Gemfile
echo "
gem 'rails_12factor', group: :production
" >> Gemfile

# config/puma.rb
touch config/puma.rb
echo "threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
" >> config/puma.rb

# Procfile
echo "web: bundle exec puma -C config/puma.rb
" >> Procfile

bundle

# Add commit with changes
git add Gemfile Gemfile.lock config/puma.rb Procfile
git commit -m 'setup dokku'
git push origin master
