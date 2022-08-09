#!/bin/sh
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


## Getting Google Project Id but if you have multiple projects it will get the first one 
GOOGLE_CLOUD_PROJECT=$(gcloud config list --format='text(core.project)'| awk '{print $2}')  

declare -a roles=("container.admin" "dns.admin" "compute.admin" "storage.admin" "owner")

## Create a service account <common-service-account> for cluster deployment.
if gcloud iam service-accounts create common-service-account --display-name "common-service-account" 2> /dev/null ; then 
    echo "${green}Created service account <common-service-account> !!${reset}"
else
    echo "${red}The service account is already exist!!${reset}"
fi 
## Getting email of the service account and binding the roles <roles>
SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --filter="displayName:common-service-account" --format='value(email)')
until [ $SERVICE_ACCOUNT_EMAIL 2> /dev/null ]
do
    SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --filter="displayName:common-service-account" --format='value(email)')
    echo "waiting for a service account to be created properly"
    sleep 3
done

for role in "${roles[@]}"
do
   gcloud projects add-iam-policy-binding "$GOOGLE_CLOUD_PROJECT" --member=serviceAccount:"$SERVICE_ACCOUNT_EMAIL" --role=roles/"$role" >  /dev/null
   echo "${green}Binding the role <$role> to the service account <$SERVICE_ACCOUNT_EMAIL>${reset}"
done

## Making sure service account doesnt exceed limit of 10 keys for per service account
export KEY=$(gcloud iam service-accounts keys list --iam-account="$SERVICE_ACCOUNT_EMAIL" | sed -n "4p" | awk '{print $1}')
gcloud iam service-accounts keys delete $KEY --iam-account="$SERVICE_ACCOUNT_EMAIL" --quiet 2> /dev/null 

## Making sure the service account json file is created
if [[ -f $HOME/google-credentials.json ]]; then
    if whiptail --yesno "It turns out you have <$HOME/google-credentials.json> already. Would you like to override it?" 20 60 ;then
        echo "${red}It turns out you have already <$HOME/google-credentials.json> and now it moved  to $HOME/old-google-credentials.json${reset}"
        /bin/mv "$HOME/google-credentials.json" $HOME/old-google-credentials.json
        gcloud iam service-accounts keys create "$HOME/google-credentials.json" --iam-account="$SERVICE_ACCOUNT_EMAIL"
        /usr/bin/cp -rf "$HOME/google-credentials.json" $HOME/.google-credentials.json 
        echo "${green}The <$HOME/google-credentials.json> is created!!${reset}"
    else
        echo "Using the default <$HOME/google-credentials.json> file!!"
    fi
else
    gcloud iam service-accounts keys create "$HOME/google-credentials.json" --iam-account="$SERVICE_ACCOUNT_EMAIL"
    /usr/bin/cp -rf "$HOME/google-credentials.json" $HOME/.google-credentials.json 
    echo "${green}The <$HOME/google-credentials.json> is created!!${reset}"
fi

## Creating the uniq bucket in GCP
if gsutil mb -c coldline -p "$GOOGLE_CLOUD_PROJECT" "gs://$1" 2> /dev/null; then
    echo "${green}The bucket <$1> has been created!!${reset}"
else
    echo "${red}The bucket already exist do not use this bucket re-run the script with another bucket name${reset}"
fi

gcloud services enable compute.googleapis.com
gcloud services enable dns.googleapis.com
gcloud services enable storage-api.googleapis.com
gcloud services enable container.googleapis.com
