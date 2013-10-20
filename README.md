# Hotfix

### The fastest hotfix solution

Hotfix is a tool for making fast hotfixes without deploy.


There are only four simple steps needed to make hotfix:

1) Choose file

2) Make changes

3) Click "Update and restart!" button

4) Enjoy fastest hotfix you ever made!

Installation
------------

1) Configure database.yml
Application doesn't use db at all so it wil be enough to to take database options from config/database.yml.sample

2) Configure application.yml
in this file you should configure ssh options of your server, watched application path and watched server restart command(see application.yml.sample). Like database.yml yiu should copy or symlink it to config during deploy.

3) Deploy application

4) Enjoy 