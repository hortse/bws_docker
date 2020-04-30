#!/bin/bash
#Docker Wordpress environment v0.1

if [ "$EUID" -ne 0 ]
  then echo "Please run script with sudo"
  exit
fi

STARTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if ! [[ $# -ne 0 ]]
then
echo "Usage : install | remove | start | stop | info | uninstall | help"
        exit
fi

if  [[ $1 = "install" ]] ||  [[ $1 = "remove" ]] ||  [[ $1 = "start" ]] ||  [[ $1 = "stop" ]] || [[ $1 = "info" ]] || [[ $1 = "uninstall" ]] || [[ $1 = "help" ]] 
then

case "$1" in 
     install)
     
sudo apt-get -y update && \
sudo apt-get -y remove docker.io && \
sudo apt-get -y install docker.io && \
sleep 3 && \
sudo systemctl enable docker && \
sudo systemctl start docker && \
sleep 3 && \
sudo apt-get -y install python3-pip && \
sleep 3 && \
sudo pip3 install pyopenssl docker-compose && \
sleep 3 && \
cd "$STARTDIR" && \
sudo docker-compose up -d 

if [[ $(sudo docker ps -q | wc -l) != 3 ]]
then
echo "Errors occurred during installation"
exit
else
echo " "
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "Installation was successful"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo " "
echo "In order to connect website use following ports:"
sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'  wordpress-site
echo "-----------------"
echo "In order to connect phpmyadmin use following ports:"
sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'  bws_docker_wp_phpmyadmin_1
echo "-----------------"
fi
;;


     remove)

echo "All Docker containers will be removed!"
echo "y|N"
read -r ANS
if [[ $ANS = "y" ]] || [[ $ANS = "Y" ]]
then 
sudo docker container stop $(sudo docker container ls -aq)
sudo docker container rm $(sudo docker container ls -aq)
sudo docker system prune
else
exit
fi
;;


     start)
     
cd "$STARTDIR"
sudo docker-compose up -d

if [[ $(sudo docker ps -q | wc -l) != 3 ]]
then
echo "Errors occurred during start up. Check if environment is installed"
exit
else
echo " "
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "Start up was successful"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo " "
echo "In order to connect website use following ports:"
sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'  wordpress-site
echo "-----------------"
echo "In order to connect phpmyadmin use following ports:"
sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'  bws_docker_wp_phpmyadmin_1
echo "-----------------"
fi
;;

 
     stop)
     
sudo docker container stop $(sudo docker container ls -aq)
;;


     info)
docker -v
echo "------------------" 
docker-compose --version
echo "------------------"
sudo docker ps
;;


     uninstall)
     
echo "The following packages will be removed:"
echo "docker.io, python3-pip"
echo "y|N"
read -r ANS
if [[ $ANS = "y" ]] || [[ $ANS = "Y" ]]
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

else
echo "Usage : install | remove | start | stop | info | uninstall | help"
        exit
fi
