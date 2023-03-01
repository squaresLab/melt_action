#!/bin/sh -l

echo $1
ls /github/workspace
echo "great, rule!" > /github/workspace/generated_file.txt
