#!/bin/bash

while getopts a:b: OPTION
do
  case $OPTION in
    a) APPLICATION_SEQ=$OPTARG;;
    b) CHECKOUT_BRANCH=$OPTARG;;
    \?) echo "Usage:$0 [-a application] [-b checkout branch] " 1>&2
        exit 1;;
   esac
done

if [ -z $APPLICATION_SEQ ]; then
  echo "usage:not specified distributing application." 1>&2
  exit 1
fi

if [ -z $CHECKOUT_BRANCH ]; then
  echo "usage:not specified checkout branch." 1>&2
  exit 1
fi

APPLICATIONS=(`echo $APPLICATION_SEQ | tr -s ':' ' '`)

# 対象アプリケーションを指定ブランチにチェックアウトして最新のコードをpullする
for APPLICATION in ${APPLICATIONS[@]}
do
  cd $APPLICATION
  if [ -z `git branch | tr -d "*" | tr -d " " | grep -Eo "^$CHECKOUT_BRANCH$"` ]; then 
    git branch $CHECKOUT_BRANCH origin/$CHECKOUT_BRANCH
  fi
  git checkout $CHECKOUT_BRANCH
  git pull origin $CHECKOUT_BRANCH
  cd ..
done

echo "success checkout $CHECKOUT_BRANCH and pull all applications." 
