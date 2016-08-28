#!/bin/bash

scriptPath=$(cd $(dirname $0); pwd)

[[ -f $scriptPath/$1.env ]] || { echo $1.env not found; exit 1; }
ln -s -f $scriptPath/$1.env $scriptPath/.env

echo Switched to environment \"$1\"