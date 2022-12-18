#!/bin/bash
###################### take a port from user ########################
while true; do
re='^[0-9]+$'
read -p "give a free port : " port
if [[ -z $port ]]; then
  echo "you should give a free port, like 8956"
  elif ! [[ $port =~ $re ]] ; then
    echo "error: Not a number" >&2
  else
    break
fi
done
read -p "please set your password for client connection : " pass
####################################################################
hy=$HOME/hysteria
mkdir $HOME/hysteria
grep -i "ubuntu" /etc/os-release 1>/dev/null
if [ ! $? -eq 0 ]; then
    systemctl disable firewalld && systemctl stop firewalld
    else
    ufw disable
fi
wget https://github.com/apernet/hysteria/releases/download/v1.3.2/hysteria-linux-amd64 -P $hy
chmod 755 $HOME/hysteria/hysteria-linux-amd64
cd $hy
###################### create config.json and ssl ########################
openssl ecparam -genkey -name prime256v1 -out ca.key
openssl req -new -x509 -days 36500 -key ca.key -out ca.crt -subj "/CN=bing.com"
cat << EOF > $hy/config.json
{
 "listen": ":$port",
 "cert": "$hy/ca.crt",
 "key": "$hy/ca.key",
 "obfs": "$pass"
}
EOF
####################################################################
nohup $hy/hysteria-linux-amd64 server > $hy/hysteria.log 2>&1 &
echo "===================================================================================================================================================================="
echo "===================================================================================================================================================================="
echo "===================================================================================================================================================================="
echo "======================================================================= successful ================================================================================="
echo "===================================================================================================================================================================="
echo "===================================================================================================================================================================="
echo "===================================================================================================================================================================="
sleep 1
echo "you can now set this Parameters in Sagernet app to connect to your server : "
echo " "
sleep 1
# echo "ip address : `ip addr show | grep 'inet ' | grep -v 127 | awk '{print $2}' | cut -d "/" -f 1 | head -n 1`"
port_of_conn=`echo $port`
echo "ip address : `hostname -I`"
echo "port : $port_of_conn"
echo "password : $pass"
