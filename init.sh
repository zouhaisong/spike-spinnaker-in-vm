#!/bin/bash
##Description:spinnaker_init(include deck|nginx|haproxy)
##Version:0.1
##Author:tao
##Date:20161207
APP="$1"
WORKHOME=$(pwd)
SPINNAKERHOME="/opt/spinnaker"
PROGRAMHOME="/opt"
cat << EOF
 +--------------------------------------------------------------+
 |          ===  spinnaker init(include deck|nginx|haproxy) ===           |
 +--------------------------------------------------------------+
 +--------------------by tw-toc--------------------------+
EOF


##create spinnakerhome
test -d ${SPINNAKERHOME} || mkdir -p ${SPINNAKERHOME}
##init deck
deck () {
sudo apt-get install unzip -y
cp ${WORKHOME}/artifacts/${APP}.zip /tmp/
unzip /tmp/${APP}.zip -d ${SPINNAKERHOME}/
if [[ `ls -ltr ${SPINNAKERHOME}/${APP}` -ne 0 ]];then
echo "/n/n*****deck install finished****/n/n"
fi
}

##init nginx
nginx () {
sudo apt-get install libpcre3 libpcre3-dev zlib1g-dev libssl-dev build-essential -y
cp ${WORKHOME}/files/${APP}.zip /tmp/
unzip /tmp/${APP}.zip -d /tmp/
sudo tar -zxvf /tmp/${APP}/openssl-1.1.0c.tar.gz -C /usr/local/src/
cd /usr/local/src/openssl-1.1.0c
sudo ./config
sudo make && sudo make install
echo "/n/n*****openssl install finished****/n/n"
sleep 1
sudo tar -zxvf /tmp/${APP}/nginx-1.10.2.tar.gz -C /usr/local/src/
cd /usr/local/src/nginx-1.10.2
sudo ./configure --prefix=/opt/nginx --with-openssl=/usr/include/openssl
sudo make && sudo make install
cp /tmp/${APP}/nginx /etc/init.d/
yes|cp /tmp/${APP}/nginx.conf /opt/${APP}/conf/nginx.conf
chmod +x /etc/init.d/nginx
sudo update-rc.d nginx defaults
/etc/init.d/nginx start
echo "/n/n*****nginx install finished****/n/n"
}

#init haproxy
haproxy () {
sudo apt-get install unzip -y
cp ${WORKHOME}/files/${APP}.zip /tmp/
unzip /tmp/${APP}.zip -d /tmp/
sudo tar -zxvf /tmp/${APP}/haproxy-1.7.0.tar.gz -C /usr/local/src
test -d ${PROGRAMHOME}/${APP} || mkdir -p ${PROGRAMHOME}/${APP}
#cd /opt &&mv haproxy-1.7.0 ${APP}
cd /usr/local/src/haproxy-1.7.0 &&sudo make TARGET=linux26 PREFIX=/opt/haproxy
sudo make install PREFIX=${PROGRAMHOME}/${APP}
cp /tmp/${APP}/${APP}.cfg ${PROGRAMHOME}/${APP}/
/opt/haproxy/sbin/haproxy -f /opt/haproxy/haproxy.cfg

#PID=`ps -ef|grep haproxy|grep -v "grep|sh|bash" |awk '{print $1}'`
#if [[ ${PID} -ne 0 ]];then
#echo "/n/n*****haproxy install finished****/n/n"
#else
#echo "/n/n*****haproxy install failed****/n/n"
#fi
}

case ${APP} in
        deck)
                        deck
                        ;;
        nginx)
                        nginx
                        ;;
	haproxy)
			haproxy
			;;
        *)
                        echo -e "\033[41;37mError: You have an error.\033[0m"
                        echo "+----------------------------------------------------------+"
                        echo "|******Usage: sh $0 {deck|nginx|haproxy}******|"
                        echo "+----------------------------------------------------------+"
                        echo
esac
