#!/bin/bash

## Color codes
green=$(tput setaf 2)
red=$(tput setaf 1)
reset=$(tput sgr0)

DIR=$(pwd)
DATAFILE="$DIR/$1"
#
# FuchiCorp common script to set up Google terraform environment variables
# these all variables should be created on your config file before you run script.
# <ENVIRONMENT> <BUCKET> <DEPLOYMENT> <PROJECT> <CREDENTIALS>

if [ ! -f "$DATAFILE" ]; then
  echo "setenv: Configuration file not found: $DATAFILE"
  return 1
fi
BUCKET=$(sed -nr 's/^google_bucket_name\s*=\s*"([^"]*)".*$/\1/p'             "$DATAFILE")
PROJECT=$(sed -nr 's/^google_project_id\s*=\s*"([^"]*)".*$/\1/p'             "$DATAFILE")
ENVIRONMENT=$(sed -nr 's/^deployment_environment\s*=\s*"([^"]*)".*$/\1/p'    "$DATAFILE")
DEPLOYMENT=$(sed -nr 's/^deployment_name\s*=\s*"([^"]*)".*$/\1/p'            "$DATAFILE")
CREDENTIALS=$(sed -nr 's/^google_credentials_json\s*=\s*"([^"]*)".*$/\1/p'   "$DATAFILE") 

if [ -z "$ENVIRONMENT" ]
then
    echo "setenv: 'deployment_environment' variable not set in configuration file."
    return 1
fi

if [ -z "$BUCKET" ]
then
  echo "setenv: 'google_bucket_name' variable not set in configuration file."
  return 1
fi

if [ -z "$PROJECT" ]
then
    echo "setenv: 'google_project_id' variable not set in configuration file."
    return 1
fi

if [ -z "$CREDENTIALS" ]
then
    echo "${green}Using the default location <$HOME/google-credentials.json>${reset}"
    CREDENTIALS="$HOME/google-credentials.json"
fi

if [ -z "$DEPLOYMENT" ]
then
    echo "setenv: 'deployment_name' variable not set in configuration file."
    return 1
fi

cat << EOF > "$DIR/backend.tf"
terraform {
  backend "gcs" {
    bucket  = "${BUCKET}"
    prefix  = "${ENVIRONMENT}/${DEPLOYMENT}"
  }
}
EOF
cat "$DIR/backend.tf"


CURRENT_TF_VERSION="$(terraform version  | awk '{print $2}' | head -n1)"
echo "You are using the terraform version ${CURRENT_TF_VERSION}"
if [[ $CURRENT_TF_VERSION != "v0.13.7" ]]; then
  echo """${red}
################################################################################################
##   You are using non supported terraform version!!                                          ## 
##   for this project you need to use <v0.13.7> terraform version                             ##
##   Please run the ${yellow}tfswitch -l${red} command to change the terraform version                       ##
################################################################################################
    ${reset}"""
    return 1
fi

export GOOGLE_APPLICATION_CREDENTIALS=${CREDENTIALS}
export DATAFILE
/bin/rm -rf "$DIR/.terraform" 2>/dev/null
/bin/rm -rf "$PWD/common_configuration.tfvars" 2>/dev/null

# Checking for updates and merges in remote branch
echo "${green}Checking your branch for merges/updates${reset}"
git remote update &> /dev/null
BRANCH=$(git branch | grep '*' | awk '{print $2}') 
git status -uno | grep -i "Your branch is behind 'origin/${BRANCH}'"  &> /dev/null

if [ $? -eq 0 ]; then
  read -p "${red}There have been changes in ${BRANCH} branch, do you want to git pull: ${reset}" yes
  if [[ $yes == yes ]] || [[ $yes == y ]] || [[ $yes == Y ]]; then
    git pull
    echo "${green}Your local branch is up to date with remote ${BRANCH} now${reset}"
  else
    echo "${red}Skipping git pull, your local branch is not up to date with remote ${BRANCH} branch${reset}"
  fi
elif [ $? -eq 1 ]; then
  echo "${green}You branch is up to date'${reset}"
fi

echo "setenv: Initializing terraform"
terraform init #> /dev/null
