#!/bin/bash

export PORT=5103
export MIX_ENV=prod
export GIT_PATH=/home/taskTracker/src/taskTracker

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "taskTracker2" ]; then
	echo "Error: must run as user 'taskTracker2'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/taskTracker ]; then
	echo mv ~/www/taskTracker ~/old/$NOW
	mv ~/www/taskTracker ~/old/$NOW
fi

mkdir -p ~/www/taskTracker
REL_TAR=~/src/taskTracker/_build/prod/rel/taskTracker/releases/0.0.1/taskTracker.tar.gz
(cd ~/www/taskTracker && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/taskTracker2/src/taskTracker/start.sh
CRONTAB

#. start.sh
