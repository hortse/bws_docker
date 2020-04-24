sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo apt-get -y install python-pip
sudo pip install pyopenssl docker-compose
sudo mkdir -p /opt/wordpress
cd /opt/wordpress
sudo chmod -R 777 /opt/wordpress
sudo docker-compose up -d
