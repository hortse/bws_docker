#!/bin/bash
#Docker Wordpress environment v0.1
STARTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ ! $1 ] || [ $1 == "install" ] || [ $1 == "remove" ] || [ $1 == "start" ] || [ $1 == "stop" ] || [ $1 == "info" ] || [ $1 = "uninstall" ] || [ $1 = "help" ]
then
        echo "Usage : install | remove | start | stop | info | uninstall | help"
        exit
fi

case $1 in 
     install)
     
INST_ERR = false
sudo apt-get -y update && \
sudo apt-get -y remove docker docker-engine docker.io && \
sudo apt-get -y install docker.io && \
sudo systemctl enable docker && \
sudo systemctl start docker && \
sudo apt-get -y install python3-pip && \
sudo pip3 install pyopenssl docker-compose && \
sudo $STARTDIR/docker-compose up -d || INST_ERR = true

if [ $INST_ERR ]
then
echo "Errors occurred during installation"
exit
else
echo "Installation was successful"
echo "In order to connect website use following ports:"
sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'  wordpress-site
echo "-----------------"
echo "In order to connect phpmyadmin use following ports:"
sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'  wordpress_phpmyadmin_1
echo "-----------------"
echo "In order to connect database use following ports:"
sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'  wordpress_db_1
fi
;;

case $1 in 
     remove)

echo "All Docker containers will be removed!"
echo "y|N"
read ANS
if [ $ANS == "y" || $ANS == "Y" ]
then 
sudo docker container stop $(sudo docker container ls -aq)
sudo docker container rm $(sudo docker container ls -aq)
sudo docker system prune
else
exit
fi
;;

case $1 in 
     start)
     
START_ERR = false
sudo $STARTDIR/docker-compose up -d || START_ERR = true

if [ $INST_ERR ]
then
echo "Errors occurred during start up. Check if environment is installed"
exit
else
echo "Start up was successful"
echo "In order to connect website use following ports:"
sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'  wordpress-site
echo "-----------------"
echo "In order to connect phpmyadmin use following ports:"
sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'  wordpress_phpmyadmin_1
echo "-----------------"
echo "In order to connect database use following ports:"
sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'  wordpress_db_1
fi
;;

case $1 in 
     stop)
     
sudo docker container stop $(sudo docker container ls -aq)
;;

case $1 in 
     info)
docker -v
echo "------------------" 
docker-compose --version
echo "------------------"
sudo docker ps
;;

case $1 in 
     uninstall)
     
echo "The following packages will be removed:"
echo "docker.io, python3-pip"
echo "y|N"
read ANS
if [ $ANS == "y" || $ANS == "Y" ]
then 

sudo docker container stop $(sudo docker container ls -aq)
sudo docker container rm $(sudo docker container ls -aq)
sudo docker system prune	
sudo apt-get -y remove docker.io
sudo pip3 uninstall -y pyopenssl docker-compose
sudo apt-get remove python3-pip

else
exit
fi
;;

case $1 in 
     help)
     
echo "Docker Wordpress developer's environment script"
echo "Usage:"
echo "run.sh install - Install all required sofware packges and start up containers"
echo "run.sh uninstall - Shut down all containers, remove all images and uninstall all previously installed packges"
echo "run.sh start - Start up all containers"
echo "run.sh stop - Shut down all containers"
echo "run.sh info - Information about installed components and running containers"
;;
esac
