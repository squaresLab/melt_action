#!/bin/sh -l

export PYTHONPATH=$PYTHONPATH:/home/test/FixIt
echo $1
echo $2
echo "Ttying to see head"
git config --global --add safe.directory /github/workspace
git show 08ef232c1a2c66e7b39d90322cb2e85dd34f2dd5:pandas/tests/arithmetic/common.py

cd /home/test/FixIt/
python3 src/inference/main.py --path $1 --base $2 > $1/generated_file.txt
echo "rules=generated_file.txt" >> $GITHUB_OUTPUT