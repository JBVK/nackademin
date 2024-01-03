#!/bin/bash

log_file_path="/var/log/salesapp/salesapp.log"

lastday=$(date -d "yesterday" +"%Y-%m-%d")

number_of_failures=$(cat $log_file_path | grep "FAILURE" | grep $lastday | wc -l)

echo $number_of_failures > /home/ec2-user/number_of_failures
