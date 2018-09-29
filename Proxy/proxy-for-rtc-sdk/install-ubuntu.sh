sudo apt-get update
sudo apt-get install -y python-pip
sudo apt-get install -y python-setuptools m2crypto
sudo pip install shadowsocks
sudo mv -v shadowsocks.json /etc/
echo "starting proxy server"
nohup ssserver -c /etc/shadowsocks.json > /tmp/ssserver.log &
nohup sslocal -c /etc/shadowsocks.json > /tmp/sslocal.log &
