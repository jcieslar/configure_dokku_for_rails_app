#!/bin/bash
# run script on your vps

ip_vps=
app_name=
db_name=

######################### VPS setup Rails app and postgres DB #########################

ssh root@$ip_vps << EOF
  dokku apps:create $app_name
  dokku postgres:create $db_name
  dokku postgres:link $db_name $app_name
  ## import dump
  # dokku postgres:connect db < ./dump.sql

  # ### linking public/uploads storage
  # /var/lib/dokku/data/storage/app_name:/app/public/uploads

  # creating storage for the app 'ruby-rails-sample'
  mkdir -p  /var/lib/dokku/data/storage/$app_name

  # ensure the proper user has access to this directory
  chown -R dokku:dokku /var/lib/dokku/data/storage/$app_name

  # as of 0.7.x, you should chown using the `32767` user and group id
  chown -R 32767:32767 /var/lib/dokku/data/storage/$app_name

  # mount the directory into your container's /app/storage directory, relative to root
  dokku storage:mount $app_name /var/lib/dokku/data/storage/$app_name:/app/public/uploads
EOF

################################################################################
