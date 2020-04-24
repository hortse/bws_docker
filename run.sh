sudo apt-get -y update
sudo apt-get -y remove docker docker-engine docker.io
sudo apt-get -y install docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo apt-get -y install python3-pip
sudo pip3 install pyopenssl docker-compose
sudo docker-compose up -d
