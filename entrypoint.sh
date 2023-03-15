#!/bin/sh -l

export PYTHONPATH=$PYTHONPATH:/home/test/FixIt
echo $1
echo $2
echo $(pwd)
python3 src/inference/main.py --path $1 --base $2 > $1/generated_file.txt
echo "rules=generated_file.txt" >> $GITHUB_OUTPUT