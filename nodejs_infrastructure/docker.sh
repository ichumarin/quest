#!/bin/bash

echo "Please make sure your terminal is open from artemis repository."
sleep 2
echo which branch do you want switch for artemis app version?
echo "1.0.0 2.0.0 3.0.0 4.0.0 5.0.0 6.0.0 7.0.0 8.0.0 9.0.0 10.0.0"
git branch
echo Please type the app version
read version
git checkout $version
echo "Please type your private docker nexus repository domain address. Example:mywebsite.com"
read repo
docker build -t docker.$repo/artemis:$version .
docker images
echo "Would you like to push it to your private docker nexus repository? Only yes will be accepted."
 read yes
 if [[ $yes == "yes" || $yes == "yes" ]];
 then 
   docker push  docker.$repo/artemis:$version
 else
   echo Push Cancelled
 fi