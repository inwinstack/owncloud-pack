# ownCloud-Pack
Place this two file in anywhere you want to pack owncloud.

    pack.sh
    settings.ini

# settings.ini File
One ini file for one customer. You can create another ini file based on **settings.ini** file.  
In settings.ini, there are four main block and app block.  
Four main block including `[owner]`, `[pack]`, `[core]` and `[theme]`.
```
[owner]
name=settings
allapps=user_status_validator,user_permission,config_history,shared_session,activity_ext,show_all_activity,singlesignon,activity_logging,user_quota,sharing_group,ajax_event_dispatcher,gallery,activity,files_pdfviewer,files_texteditor,firstrunwizard,notifications,files_mv
```
* `name` customer name.
* `allapps` include apps that customer want. The apps name in allapps parameter must be the same with app block name and there are `,` between apps name.
```
[pack]
prefix=owncloud
version=8.2.1
```
* `prefix`: directory name in tar file.
* `version`: owncloud version.  

All parameter in core block does not need to modify.
```
[core]
name=owncloud
branch=release-8.2.1
archivebranch=archive/8.2.1
git_url=https://github.com/inwinstack/owncloud-core.git
```
* `name`: owncloud core directory name.
* `branch`: core branch name.
* `archivebranch`: a branch used to pack.
* `git_url`: the url where can git clone owncloud core.  

You have to keep `[theme]` block even though you do not want to use theme. If you don't want to use theme, just modify **use_theme** to **no**.
```
[theme]
name=MOE
use_theme=yes
branch=master
flag=branch
git_url=https://github.com/inwinstack/owncloud-theme-moe.git
```
* `name`: theme name.
* `use_theme`: whether you want to use theme.
* `branch`: theme branch name.
* `flag`: determine which kind of this branch, branch or tag.
* `git_url`: the url where can git clone theme.

If you don't want to use singlesignon app, you have to delete singlesignon app name from allapps in `[owner]` and modify **use_sso** in `[singlesignon]` to **no**.
```
[singlesignon]
name=singlesignon
use_sso=yes
branch=v8.2.1
flag=tag
git_url=https://github.com/inwinstack/owncloud-singlesignon.git
```
* `name`: singlesignon name.
* `use_sso`: whether you want to use singlesignon.
* `branch`: singlesignon branch name.
* `flag`: determine which kind of this branch, branch or tag.
* `git_url`: the url where can git clone theme.

If you need singlesignon app, you must modify **name** in `[sso]` to a suitable value. One sso will for one custmer.
```
[sso]
name=sso-asus
branch=v8.2.1
git_url=https://github.com/inwinstack/owncloud-sso-asus.git
```
* `name`: customer's singlesignon name.
* `branch`: sso branch name.
* `git_url`: the url where can git clone theme.



There are not only one app block in settings.ini file. There are two samples of apps block below.  
```
[activity]
name=activity
branch=v8.2.1
flag=tag
git_url=https://github.com/owncloud/activity.git

[config_history]
name=config_history
branch=v8.2.1
flag=tag
git_url=https://github.com/inwinstack/owncloud-config_history.git
```
* `name`: app name.
* `branch`: apps branch name.
* `flag`: determine which kind of this branch, branch or tag.
* `git_url`: the url where can git clone this app.

# pack.sh File
This **pack.sh** file will update your owncloud app to the latest according to **settings.ini** file.

#  Executing script
Sample:  
Behind `--config` you have to input a specific ini file. Through `-v` you can see the detail result during udpate.

    ./pack.sh --config settings.ini -v

#  After executing script
You can find `owncloud-8.2.1.tar.bz2` you just pack according to your settings.ini file in `owncloud/.tmp/` directory.
