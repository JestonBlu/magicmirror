#!/bin/bash

set -e

branch=${1:-master}

CL='\033[0;32m' # Green
NC='\033[0m' # No Color

_info() {
  echo -e "\n${CL}${1}${NC}\n"
}

cd $HOME

_info "Step1: Installing docker"

# install docker using official convenience script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm -f get-docker.sh

# postinstall docker, add current user to group "docker"
sudo usermod -aG docker $USER

_info "Step2: Installing magicmirror docker setup"

rm -rf ./magicmirror
git clone https://gitlab.com/khassel/magicmirror.git
cd ./magicmirror/run

[[ "$branch" == "master" ]] || git switch "$branch"

cp original.env .env
cp original.compose.yaml compose.yaml

[[ "$branch" == "master" ]] || sed -i 's|MM_IMAGE=.*|MM_IMAGE="karsten13/magicmirror:'$branch'"|g' .env

# set scenario to electron:
sed -i 's|MM_SCENARIO=.*|MM_SCENARIO="electron"|g' .env
# use xserver:
sed -i 's|MM_XSERVER=.*|MM_XSERVER="xserver"|g' .env

_info "Step3: Pulling docker images"

# need sudo for docker here because group docker not active yet
sudo docker compose pull

_info "Step4: Starting magicmirror"

sudo docker compose up -d

_info "Step5: Reboot needed, starting in 20 sec."

# delete this install script
rm -- "$HOME/$0" || true

sleep 20

sudo reboot now