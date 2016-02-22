# ownCloud-Pack
Place this two file in anywhere you want to pack owncloud.

    pack.sh
    settings.ini

# settings.ini File
One ini file for one customer. You can create another ini file based on **settings.ini** file.  
In settings.ini, there are three main block and app block.  
Three main block including `[owner]`, `[pack]` and `[core]`. All parameter in core block does not need to modify.
* `[owner]` block including `name` (customer name) and `allapps` (allapps include app that customer want. The apps name in allapps parameter must be the same with app block name and there are `,` between apps name.)
* `[pack]` block including `prefix` (directory name in tar file) and `version` (owncloud version)
* `[core]` block including `name` (owncloud core directory name), `branch` (owncloud core branch), `archivebranch` (a branch used to pack), `flag` (determine which kind of this branch, brnach or tag) and `git_url` (the url where can git clone app)

There are not only one app block in settings.ini file. There are two samples of app block below.  
```
[activity]
sourcename=activity
match=Yes
branch=v8.2.1
flag=tag
git_url=https://github.com/owncloud/activity.git

[config_history]
sourcename=owncloud-config_history
match=No
branch=v8.2.1
flag=tag
git_url=https://github.com/inwinstack/owncloud-config_history.git
```
* `sourcename` means app name git clone from git_url.
* `match` means wether the app name git clone from git_url equals to app block name.
* `branch` apps branch name.
* `flag` determine which kind of this branch, brnach or tag.
* `git_rul` the url where can git clone app


# pack.sh File
This **pack.sh** file will update your owncloud app to the latest according to **settings.ini** file.

#  Executing script
Sample:  
Behind `--config` you have to input a specific ini file. Through `-v` you can see the detail result during udpate.

    ./pack.sh --config settings.ini -v
