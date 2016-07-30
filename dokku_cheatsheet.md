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
dokku domains:add myapp example.com

# list custom domains for app
dokku domains myapp

# clear all custom domains for app
dokku domains:clear myapp

# remove a custom domain from app
dokku domains:remove myapp example.com

