sudo apt-get -y update
sudo apt-get -y remove docker docker-engine docker.io
sudo apt-get -y install docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo apt-get -y install python3-pip
sudo pip install pyopenssl docker-compose
sudo mkdir -p /opt/wordpress
cd /opt/wordpress
sudo chmod -R 777 /opt/wordpress
sudo docker-compose up -d
