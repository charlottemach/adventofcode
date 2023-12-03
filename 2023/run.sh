#!/bin/bash


if [ $# -ne 1 ]
then
    echo "Usage: run.sh DAY"
    exit 1
fi

DAY=$1

docker build -t $DAY $DAY/ && docker container run -it --rm $DAY
