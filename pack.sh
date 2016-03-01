#!/bin/bash

VERBOSE=0
workspace=$(pwd)

# Process command-line arguments.
while test $# -gt 0; do
    case $1 in
        --config )
            shift
            CONFIGFILE=$1
            shift
            ;;

        --verbose | -v )
            shift
            VERBOSE=1
            ;;

        * )
            break
            ;;
    esac
done

function logln () {
    if [ $VERBOSE -eq 1 ]; then
        echo $1
    fi
}

function log () {
    if [ $VERBOSE -eq 1 ]; then
        echo -n $1
    fi
}

function tupdate (){
    echo "use tupdate"
    git checkout master   # checkout to master branch
    git fetch --tags      # udpate tags from github/inwinstack
    git checkout $branch  # checkout to tags
    git log -2            # show last two log
}

function bupdate (){
    echo "use bupdate"
    git checkout $branch		# checkout to branch
    git pull --rebase origin $branch	# update branch from github/inwinstack
    git log -2				# show last two log
}

# Update all apps.
function appupdate(){
    # config file name
    echo "========Update apps===========ConfigName:$CONFIGFILE============================="

    # get apps name in owner block
    profile=`sed -n '/allapps/'p $CONFIGFILE | awk -F= '{print $2}' | sed 's/,/ /g'`

    # execute update
    for App in $profile
    do
      echo "----------------------------------------------------------------------------"
      branch=$(awk -F '=' '/\['"$App"']/{a=1}a==1&&$1~/branch/{print $2;exit}' $CONFIGFILE)
      flag=$(awk -F '=' '/\['"$App"']/{a=1}a==1&&$1~/flag/{print $2;exit}' $CONFIGFILE)
      echo -e "App: $App\tBranch: $branch\tflag: $flag\n"
      log "Updating app: $App ..."
      echo 
      cd $workspace/owncloud/apps/$App

      if [ "$flag" == "tag" ]; then
          tupdate
      elif [ "$flag" == "branch" ]; then
          bupdate
      fi

      cd $workspace
      echo
      logln "Updating app: $App ... done"
    done
    echo "============================================================================"
}

# Check whether all app exist, if not git clone it.
function appclone(){
    # config file name
    echo "=========Checkout whether inwin app exist.========ConfigName:$CONFIGFILE========"

    # get all apps name in owner block
    profile=`sed -n '/allapps/'p $CONFIGFILE | awk -F= '{print $2}' | sed 's/,/ /g'`

    # execute clone
    for App in $profile
    do
      echo "----------------------------------------------------------------------------"
      branch=$(awk -F '=' '/\['"$App"']/{a=1}a==1&&$1~/branch/{print $2;exit}' $CONFIGFILE)
      git_url=$(awk -F '=' '/\['"$App"']/{a=1}a==1&&$1~/git_url/{print $2;exit}' $CONFIGFILE)
      appname=$(awk -F '=' '/\['"$App"']/{a=1}a==1&&$1~/name/{print $2;exit}' $CONFIGFILE)
      echo -e "App: $App\tUrl: $git_url\n"
      cd $workspace/owncloud/apps/
      
      if [ -d "$App" ]; then
          echo -e "$App exists.\n" 
      else
          echo -e "$App does not exist.\n"
	  log "cloning app: $App ..."
	  echo
	  git clone $git_url $appname
	  cd $appname
	  git checkout $branch
	  echo
	  logln "cloning app: $App ... done"
      fi

      cd $workspace
    done
    echo "============================================================================"
}

#Checkout whether owncloud core exist, if it exist update it, or git clone it.
function owncloudcore(){
    # config file name
    echo "=========Checkout whether core exist.========ConfigName:$CONFIGFILE============="
      corename=$(awk -F '=' '/\['"core"']/{a=1}a==1&&$1~/name/{print $2;exit}' $CONFIGFILE)
      corebranch=$(awk -F '=' '/\['"core"']/{a=1}a==1&&$1~/branch/{print $2;exit}' $CONFIGFILE)
      archivebranch=$(awk -F '=' '/\['"core"']/{a=1}a==1&&$1~/archivebranch/{print $2;exit}' $CONFIGFILE)
      coregit_url=$(awk -F '=' '/\['"core"']/{a=1}a==1&&$1~/git_url/{print $2;exit}' $CONFIGFILE)
	echo -e "Name: $corename\tBranch: $corebranch\tArchiveBranch: $archivebranch"
	echo -e "Url: $coregit_url\n"

      if [ -d "$corename" ]; then
          echo -e "$corename exists.\n"
	  log "updating core: $corename ..."
	  echo
	  cd $corename
	  git checkout $corebranch
	  git branch -D $archivebranch
	  git pull --rebase origin $corebranch
	  git checkout -b $archivebranch
          git cherry-pick e78ae5171b960cef5c035305f0881a9cdb60b2b5 4534346ce155a23bf12a3e10c2da0e19a14235a1
	  git log -3
	  echo
	  logln "updating core: $corename ... done"
      else
          echo -e "$corename does not exist.\n"
          log "cloning core: $corename ..."
	  echo
          git clone $coregit_url $corename
          cd $corename
          git checkout $corebranch
          git checkout -b $archivebranch
          git cherry-pick e78ae5171b960cef5c035305f0881a9cdb60b2b5 4534346ce155a23bf12a3e10c2da0e19a14235a1
          git log -3
	  cd $workspace/$corename
	  git submodule init
	  git submodule update
	  cd 3rdparty
	  git checkout v8.2.1
          echo
          logln "cloning core: $corename ... done"
      fi

      cd $workspace
    echo "============================================================================"
}

function theme(){
    name=$(awk -F '=' '/\['"theme"']/{a=1}a==1&&$1~/name/{print $2;exit}' $CONFIGFILE)
    use_theme=$(awk -F '=' '/\['"theme"']/{a=1}a==1&&$1~/use_theme/{print $2;exit}' $CONFIGFILE)
    flag=$(awk -F '=' '/\['"theme"']/{a=1}a==1&&$1~/flag/{print $2;exit}' $CONFIGFILE)
    branch=$(awk -F '=' '/\['"theme"']/{a=1}a==1&&$1~/branch/{print $2;exit}' $CONFIGFILE)
    git_url=$(awk -F '=' '/\['"theme"']/{a=1}a==1&&$1~/git_url/{print $2;exit}' $CONFIGFILE)
    if [ "$use_theme" == "Yes" ] || [ "$use_theme" == "yes" ]; then
	echo -e "Use theme.\n"
	cd owncloud/themes
	if [ -d "$name" ]; then
            echo -e "$name exists.\n"
	    cd $name
	    if [ "$flag" == "tag" ]; then
                tupdate
            elif [ "$flag" == "branch" ]; then
                bupdate
            fi
        else
            echo -e "$name does not exist.\n"
            log "cloning $name ..."
            echo
            git clone $git_url $name
            cd $name
            git checkout $branch
            logln "cloning $name ... done"
	fi
    else
	echo "Do not use theme."
    fi

    cd $workspace
}

function pack(){
    prefix=$(awk -F '=' '/\['"pack"']/{a=1}a==1&&$1~/prefix/{print $2;exit}' $CONFIGFILE)
    version=$(awk -F '=' '/\['"pack"']/{a=1}a==1&&$1~/version/{print $2;exit}' $CONFIGFILE)
    cd owncloud
    if [ -d ".tmp" ]; then
        echo -e "Remove origin .tmp/\n"
        rm -rf .tmp/
        ./archive.sh --prefix $prefix --version $version -v
    else
        ./archive.sh --prefix $prefix --version $version -v
    fi
}

owncloudcore
appclone
appupdate
theme
pack
