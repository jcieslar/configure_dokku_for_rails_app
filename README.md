# Configure dokku for rails app with Postgresql DB.

Bash script for configuring dokku for rails app on VPS like Digital Ocean.

## How to use

Clone repository an set variables in files:

```bash
# Add plugins and swap file on VPS
# set your VPS IP: ip_vps= 111.11.11.111
dokku_one_time_run.sh
# Create app and postgres DB on VPS dokku
# set variables:
# ip_vps=111.11.11.111
# app_name=sample_app
# db_name=sample_app_production
dokku_setup_rails_app.sh
# Add puma and rails_12factor local app and Procfile
# set variables:
# app_name=sample_app
# local_app_dir=~/work/sample_app
# ip_vps=111.11.11.111
rails_app_setup.sh
```

Then you can run 3 scripts:

```bash
./dokku_one_time_run.sh
./dokku_setup_rails_app.sh
./rails_app_setup.sh
```

After thath you are ready to deploy, on your app dir:

```bash
git push dokku master
```


## usefull/inspiration links:
* http://www.rubyfleebie.com/how-to-use-dokku-on-digitalocean-and-deploy-rails-applications-like-a-pro/
* http://dokku.viewdocs.io/dokku/advanced-usage/persistent-storage/
* http://dokku.viewdocs.io/dokku/deployment/application-deployment/
* http://dokku.viewdocs.io/dokku/advanced-usage/backup-recovery/


## List of usefull dokku commands for rails app

```bash

# list of all environment variables for your app
dokku config app_name

# set env variable
dokku config:set app_name FOO='bar'

# app logs
dokku logs app_name

# rails
dokku run app_name rake db:migrate
dokku run app_name rails c

# deploy
git push dokku master
# deploy from custom branch
git push dokku custom_your_branch_name:master

# storage
dokku storage:list app_name

# mount storage to rails public/uploads
dokku storage:mount $app_name /var/lib/dokku/data/storage/$app_name:/app/public/uploads

# domain

# add a domain to an app
dokku domains:add app_name example.com

# list custom domains for app
dokku domains app_name

# clear all custom domains for app
dokku domains:clear app_name

# remove a custom domain from app
dokku domains:remove app_name example.com

# postgres import dump
dokku postgres:import db_name < your_dump

# SSL with letsencrypt
# Add to `/etc/hosts` new line: `192.192.8.8 example.com`

dokku config:set --no-restart my-rails-app DOKKU_LETSENCRYPT_EMAIL=your@email.com
dokku letsencrypt app_name
dokku letsencrypt:auto-renew app_name
dokku letsencrypt:cron-job --add app_name
```

# Cron jobs:
run:

```
sudo crontab -e
```

Edit file:

```bash
PATH=/usr/local/bin:/usr/bin:/bin
SHELL=/bin/bash

* * * * * /bin/bash -c 'dokku run app_name rails r AppModel.run_something'
```

Process and Container Management

```
ps <app>                                       # List processes running in app container(s)
ps:rebuild <app>                               # Rebuild an app from source
ps:rebuildall                                  # Rebuild all apps from source
ps:report [<app>] [<flag>]                     # Displays a process report for one or more apps
ps:restart <app>                               # Restart app container(s)
ps:restart-policy <app>                        # Shows the restart-policy for an app
ps:restartall                                  # Restart all deployed app containers
ps:scale <app> <proc>=<count> [<proc>=<count>] # Get/Set how many instances of a given process to run
ps:set-restart-policy <app> <policy>           # Sets app restart-policy
ps:start <app>                                 # Start app container(s)
ps:startall                                    # Start all deployed app containers
ps:stop <app>                                  # Stop app container(s)
ps:stopall                                     # Stop all app container(s)
```
