#!/bin/bash

#18.04.1 LTS

#!/bin/bash

while $(lsof -w /var/lib/dpkg/lock>/dev/null)
do
    echo "dpkg lock is active"
    sleep 1
done
echo "dpkg lock is ours!"


sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88


sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo apt-get install -y docker-compose

sudo usermod -aG docker ubuntu


