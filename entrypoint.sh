#!/bin/sh -l

export PYTHONPATH=$PYTHONPATH:/home/test/FixIt
python3 src/inference/main.py > $1/generated_file.txt
echo "rules=generated_file.txt" >> $GITHUB_OUTPUT