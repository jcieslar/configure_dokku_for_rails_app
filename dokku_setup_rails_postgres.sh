#!/bin/bash
# run script on your vps

ip_vps=
app_name=
db_name

# login to vps
ssh root@$ip_vps

# ssh for dokku user
cat /root/.ssh/authorized_keys | sshcommand acl-add dokku dokku

#swap file - optional
swapon -s
fallocate -l 2048m /mnt/swap_file.swap
chmod 600 /mnt/swap_file.swap
mkswap /mnt/swap_file.swap
swapon /mnt/swap_file.swap
echo "/mnt/swap_file.swap none swap sw 0 0" >> /etc/fstab

## Plugins
# deploy hooks
cd /var/lib/dokku/plugins
git clone https://github.com/mlomnicki/dokku-deploy-hooks deploy-hooks
cd

# postgres
dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres


# ###### Rails app

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
