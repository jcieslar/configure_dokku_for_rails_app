#!/bin/bash
# run script on your vps

ip_vps=

######################### VPS setup one time run #########################
# login to vps and run script
ssh root@$ip_vps << EOF

  # ssh for dokku user
  cat /root/.ssh/authorized_keys | sshcommand acl-add dokku dokku

  #swap file - optional
  swapon -s
  fallocate -l 2048m /mnt/swap_file.swap
  chmod 600 /mnt/swap_file.swap
  mkswap /mnt/swap_file.swap
  swapon /mnt/swap_file.swap
  echo "/mnt/swap_file.swap none swap sw 0 0" >> /etc/fstab

  ######### Plugins #########

  # postgres
  dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
  dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
EOF
