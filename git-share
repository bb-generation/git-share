#!/bin/sh
# vim: set et ts=2 sw=2
#
# Copyright (c) 2011 Bernhard Eder (<git@bbgen.net>)
# 
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
# 
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
# 
#    1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 
#    2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 
#    3. This notice may not be removed or altered from any source
#    distribution.

setup_git_daemon()
{
  SHAREDIR=$1
  LOCALPORT=$2
  git daemon --base-path=$SHAREDIR/share/ --export-all --reuseaddr \
  --port=$LOCALPORT --enable=receive-pack &
  GITDPID=$!
}

setup_git_share()
{
  SHAREDIR=$1
  mkdir -p $SHAREDIR
  git clone --bare . $SHAREDIR/share/share
}

setup_remote()
{
  SHAREDIR=$1
  git remote add share $SHAREDIR/share/share
}

setup_ssh()
{
  DESTINATION=$1
  REMOTEPORT=$2
  LOCALPORT=$3
  ssh $DESTINATION -R $REMOTEPORT:localhost:$LOCALPORT -n -f sleep 365d
  SSHDPID=`pgrep -n ssh`
}

# http://stackoverflow.com/questions/392022/best-way-to-kill-all-child-processes/3211182#3211182
killtree() {
    local _pid=$1
    local _sig=${2-TERM}
    for _child in $(ps -o pid --no-headers --ppid ${_pid}); do
        killtree ${_child} ${_sig}
    done
    kill -${_sig} ${_pid}
}


clean()
{
  git remote rm share
  rm -rf .git/share

  killtree $GITDPID
  kill $SSHDPID
  wait
  echo git share stopped
  exit
}



GITDIR=.git

if [ "$1" = "--help" ]; then
  echo "usage: git share [remotehost] [remoteport] [localport]"
  echo
  echo "Example: git share myhost.com 55555"
  echo
  echo "git config:"
  echo "\tshare.remotehost"
  echo "\tshare.remoteport"
  echo "\tshare.localport"
  exit
fi

if [ ! -d $GITDIR ]; then
  echo You need to run this command from the toplevel of the working tree.
  exit 1
fi

if [ $# -gt 0 ]; then
  REMOTEHOST=$1
elif [ "`git config --get share.remotehost`" != "" ]; then
  REMOTEHOST=`git config --get share.remotehost`
else
  REMOTEHOST=localhost
fi

if [ $# -gt 1 ]; then
  REMOTEPORT=$2
elif [ "`git config --get share.remoteport`" != "" ]; then
  REMOTEPORT=`git config --get share.remoteport`
else
  REMOTEPORT=50423
fi

if [ $# -gt 2 ]; then
  LOCALPORT=$3
elif [ "`git config --get share.localport`" != "" ]; then
  LOCALPORT=`git config --get share.localport`
else
  LOCALPORT=9418
fi

trap "clean" INT

setup_git_share $GITDIR
setup_remote $GITDIR
setup_git_daemon $GITDIR $LOCALPORT
setup_ssh $REMOTEHOST $REMOTEPORT $LOCALPORT


echo You can now clone at git://localhost:50423/share
while [ 1 ]; do sleep 1d; done

