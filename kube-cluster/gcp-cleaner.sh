#!/bin/sh
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

GMAIL_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
GOOGLE_CLOUD_PROJECT_ID=$(gcloud projects list)

project_id=$(whiptail --inputbox "Would you like to delete resources 
  $GOOGLE_CLOUD_PROJECT_ID in $GMAIL_ACCOUNT account?" 20 100 3>&1 1>&2 2>&3) 
if [ "$?" == 0 ] ;then
  echo ${red}"Deleting the project $project_id in the ${GMAIL_ACCOUNT} gmail account"${reset}
  gcloud projects delete $project_id --quiet
else
  echo "Cancelled deletion of project. Thank you!"
fi