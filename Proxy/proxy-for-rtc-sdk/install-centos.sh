sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install python-pip
sudo yum -y install python-setuptools m2crypto
sudo pip install shadowsocks
sudo mv -v shadowsocks.json /etc/
echo "starting proxy server"
nohup ssserver -c /etc/shadowsocks.json > /tmp/ssserver.log &
nohup sslocal -c /etc/shadowsocks.json > /tmp/sslocal.log &
