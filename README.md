# ownCloud-Pack
Place this two file in anywhere you want to pack owncloud.

    pack.sh
    settings.ini

# settings.ini File
One ini file for one customer. You can create another ini file based on **settings.ini** file.  
In settings.ini, there are three main block and app block.  
Three main block including `[owner]`, `[pack]` and `[core]`.
```
[owner]
name=moe
allapps=user_status_validator,user_permission,config_history,shared_session,activity_ext,show_all_activity,singlesignon,activity_logging,user_quota,sharing_group,ajax_event_dispatcher,gallery,activity,files_pdfviewer,files_texteditor,firstrunwizard,notifications,files_mv
```
* `name` customer name.
* `allapps` include apps that customer want. The apps name in allapps parameter must be the same with app block name and there are `,` between apps name.
```
[pack]
prefix=owncloud
version=8.2.1
```
* `prefix`: means directory name in tar file.
* `version`: owncloud version.  

All parameter in core block does not need to modify.
```
[core]
name=owncloud
branch=release-8.2.1
archivebranch=archive/8.2.1
flag=branch
git_url=https://github.com/inwinstack/owncloud-core.git
```
* `name`: owncloud core directory name.
* `branch`: core branch name.
* `archivebranch`: a branch used to pack.
* `flag`: determine which kind of this branch, brnach or tag.
* `git_url`: the url where can git clone owncloud core

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
* `sourcename`: means app name git clone from git_url.
* `match`: means whether the app name git clone from git_url equals to app block name. If match equals to Yes, it will not change app name. If match equals to No, it will change app name.
* `branch`: apps branch name.
* `flag`: determine which kind of this branch, branch or tag.
* `git_url`: the url where can git clone app


# pack.sh File
This **pack.sh** file will update your owncloud app to the latest according to **settings.ini** file.

#  Executing script
Sample:  
Behind `--config` you have to input a specific ini file. Through `-v` you can see the detail result during udpate.

    ./pack.sh --config settings.ini -v
