#/bin/bash
#Coded By AntiGov
#Enable Proxy For Entire SYstem

if [ $(id -u) -ne 0 ]; then
  echo "This script must be run as root";
  exit 1;
fi

if [ $# -eq 2 ]
  then

  gsettings set org.gnome.system.proxy mode 'manual' ;
  gsettings set org.gnome.system.proxy.http host $1;
  gsettings set org.gnome.system.proxy.http port $2;


  grep PATH /etc/environment > pxy.t;
  printf \
 "http_proxy=http://$1:$2/\n\
  https_proxy=http://$1:$2/\n\
  ftp_proxy=http://$1:$2/\n\
  no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain.com\"\n\
  HTTP_PROXY=http://$1:$2/\n\
  HTTPS_PROXY=http://$1:$2/\n\
  FTP_PROXY=http://$1:$2/\n\
  NO_PROXY=\"localhost,127.0.0.1,localaddress,.localdomain.com\"\n" >> pxy.t;

  cat pxy.t > /etc/environment;


  printf \
  "Acquire::http::proxy \"http://$1:$2/\";\n\
  Acquire::ftp::proxy \"ftp://$1:$2/\";\n\
  Acquire::https::proxy \"https://$1:$2/\";\n" > /etc/apt/apt.conf.d/95proxies;

  rm -rf pxy.t;
  else

  printf "Usage $0 <proxy_ip> <proxy_port>\n";

fi
