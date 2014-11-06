#!/bin/bash

###########################
### Author Vivek Singh Rai
### Version 1.1 -  Created 15-01-2014
###########################




clear
HOME_PATH=/home/sysadmin
printf "Do you want to add user '"sysadmin"' '"'Type yes or no '"':" ;
read User
if [ $User = "yes" ] ; then
useradd -d $HOME_PATH -m sysadmin
echo "sysadmin user added"
fi
if [ $User = "no" ] ; then
echo ""
fi
apt-get install libpcre3 -y
apt-get install libpcre3-dev -y
apt-get install git -y

git clone https://deploy-proptiger:D3pl0y-P0T@github.com/proptigercom/devops.git /opt/devops

ipaddress=`ifconfig eth1 | grep inet |awk '{print $2}' | cut -d ":" -f2 -`
echo "192.168.1.1 staging.nightly.proptiger-ws.com" >> /etc/hosts
####
clear




#press_enter
function press_enter
{
    echo ""
    echo -n "Press Enter to exit"
    read
    clear
}

selection=
clear
until [ "$selection" = "0" ]; do
    echo ""
    echo "PROGRAM MENU"
    echo "1 - Install LAMP"
    echo "2 - Install API"
    echo "3 - Install Nginx"
    echo "4 - Install Memcached"
    echo "5 - Install Redis Server"
    echo "6 - Install Nagios"
    echo "7 - Restore mysql database"
    echo "0 - exit program"
    echo ""
    echo -n "Enter selection: "
    read selection
    echo ""

    case $selection in

  1 ) clear;

####

# Installing LAMP
JDK=`apt-cache search openjdk |grep openjdk |awk '{print $1}' |cut -c 9 |tail -1`

if [ "$JDK" = "7" ]; then
apt-get install openjdk-7-jdk -y
        else
apt-get install openjdk-6-jdk -y
fi
sudo -u sysadmin -i git clone https://github.com/proptigercom/website.git nightly
apt-get install apache2 mysql-server php5 php5-memcache php5-mysql php-apc php5-curl php5-memcached php5-gd daemon -y
a2enmod proxy_ajp; service apache2 reload
a2enmod rewrite; service apache2 reload
#cd $HOME_PATH; wget http://192.168.1.1/public/apache-solr-4.0.0.tar.gz; tar -xzvf $HOME_PATH/apache-solr-4.0.0.tar.gz ; chown sysadmin.sysadmin $HOME_PATH/apache-solr-4.0.0
cd $HOME_PATH; wget http://staging.nightly.proptiger-ws.com/public/apache-solr-4.0.0.tar.gz; tar -xzvf $HOME_PATH/apache-solr-4.0.0.tar.gz ; chown sysadmin.sysadmin $HOME_PATH/apache-solr-4.0.0
sudo -u sysadmin cp -r /home/sysadmin/nightly/apache-solr-4.0.0/example/solr/collection1/conf/schema.xml /home/sysadmin/apache-solr-4.0.0/example/solr/collection1/conf/
cp /opt/devops/solr /etc/init.d/solr; chmod +x /etc/init.d/solr
mkdir /var/log/solr/ ;chmod 777 /var/log/solr
sudo -u sysadmin /etc/init.d/solr start
cd /home/sysadmin/nightly/ && sudo -u sysadmin php solrIndex.php deleteThenInsert
sleep 2
        echo ""
        echo "LAMP has been installed"
        echo ""
                sleep 2

;;
   2 ) clear;

#### Install API Server

tomcat=`apt-cache search tomcat |grep tomcat |awk '{print $1}' |cut -c 7 |tail -1`

if [ "$tomcat" = "7" ]; then
apt-get install tomcat7 -y
apt-get install maven2 -u
mkdir $HOME_PATH/dal_git;
cp -r /opt/devops/dal_config $HOME_PATH; chown -R sysadmin.sysadmin $HOME_PATH/dal_*
sudo -u sysadmin -i git clone https://github.com/proptigercom/MIDL.git $HOME_PATH/dal_git/dal
#p -r $HOME_PATH/dal_config/dal/data/src/main/resources/application.properties $HOME_PATH/dal_git/dal/data/src/main/resources/
cd $HOME_PATH/dal_git/dal/data && mvn clean install
rm -rf /var/lib/tomcat7/webapps/ROOT*
cp $HOME_PATH/dal_git/dal/data/target/dal.war /var/lib/tomcat7/webapps/ROOT.war
cp /opt/devops/server.xml  /etc/tomcat7/server.xml
service tomcat7 restart
sleep 2
        echo ""
        echo " tomcat7 has been installed"
        echo ""
sleep 2
	        else
apt-get install tomcat6 -y
apt-get install maven2 -y 
mkdir $HOME_PATH/dal_git;
cp -r /opt/devops/dal_config $HOME_PATH; chown -R sysadmin.sysadmin $HOME_PATH/dal_*
sudo -u sysadmin -i git clone https://github.com/proptigercom/MIDL.git $HOME_PATH/dal_git/dal
cp -r $HOME_PATH/dal_config/dal/data/src/main/resources/application.properties $HOME_PATH/dal_git/dal/data/src/main/resources/
cd $HOME_PATH/dal_git/dal/data && mvn clean install
rm -rf /var/lib/tomcat6/webapps/ROOT*
cp $HOME_PATH/dal_git/dal/data/target/dal.war /var/lib/tomcat6/webapps/ROOT.war
cp /opt/devops/server.xml  /etc/tomcat6/server.xml
service tomcat6 restart

sleep 2
        echo ""
        echo " tomcat6 has been installed"
        echo ""
sleep 2
fi

;;


   3 ) clear;

##Install Nginx

apt-get install nginx
sleep 2
        echo ""
        echo " nginx has been installed"
        echo ""
                sleep 2
;;

   4 ) clear;

### Install memcached

apt-get install memcached
sleep 2
        echo ""
        echo " memcached has been installed"
        echo ""
                sleep 2
;;



  5 ) clear;

#### Install Redis Server

apt-get install redis-server
sleep 2
        echo ""
        echo " redis server has been installed"
        echo ""
                sleep 2
;;

  

  6 ) clear;

### install nagios

apt-get install nagios-nrpe-server nagios-nrpe-plugin
aptitude -P install nagios-plugins-basic
sleep 2
        echo ""
        echo " nagios has been installed"
        echo ""
                sleep 2
;;

   7 ) clear 


### restore Mysql
ssh-keygen
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDh3sq56H2SVsiuQqbSTHem2SLu8ylxYNwk8irVAi9l4lfuY7nOLc3/hdl+r+1iE5MVWC9qf7Y33+PRfOPPJKxei7LmDRccOB6bhwMt4LFIfxKhfHzCjUQ+PiZFkjCiiNzJiXjog1lT8emRQvkA6aO+19TEvHOMtdb073qLKqxCNOyZBp0EJErsbcWf3GhAq26G1HdtufLoCF5GhylDOg0JepSF/cbDKh/EWy73jvu+PMFaKrwtvCaECThTmQJT69Dye0x9xllcOLKVIcOFVGVoWGdAnL06mRinVFavUtf+U+q9psBg6OP5A5OIsnVCNbyg8wXuHuivwF/VS29mkVEv root@proptiger" >> $HOME/.ssh/authorized_keys

today=`date +%d-%m-%Y`

printf "Please enter Database name ' '"'example "proptiger" '"':" ;

read database 
scp -r root@192.168.1.1:/home/proptiger/db-backup/$today-$database.tar.gz /opt/
cd /opt/ ; tar -C /opt -xzf /opt/$today-$database.tar.gz
mysql -uroot -p -e "create database $database";
mysql -uroot -p $database < /opt/$today-$database.sql

sleep 2
        echo ""
        echo " Database restored"
        echo ""
                sleep 2
;;

0 ) press_enter ;;

        * ) echo "Please enter 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, or 0"

    esac

done
