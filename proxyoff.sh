#/bin/bash
#Coded By AntiGov
#Disable Proxy For Entire SYstem
if [ $(id -u) -ne 0 ]; then
  echo "This script must be run as root";
  exit 1;
fi

gsettings set org.gnome.system.proxy mode 'none' ;

grep PATH /etc/environment > pxy.t;
cat pxy.t > /etc/environment;

printf "" > /etc/apt/apt.conf.d/95proxies;

rm -rf pxy.t;
