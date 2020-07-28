echo "Setting up server.conf"
sudo cp ./configs/server.conf /etc/openvpn/server.conf

echo "Setting up sysctl.conf"
sudo sed -i '1inet.ipv4.ip_forward=1' /etc/sysctl.conf
sudo sysctl -p

echo "Setting up ufw before.rules"
cp prefix.ufw temp_.txt
sudo cat /etc/ufw/before.rules >> temp_.txt
sudo cp temp_.txt  /etc/ufw/before.rules
rm temp_.txt

echo "Setting up /etc/default/ufw"
sudo sed -i "s/FORWARD_POLICY=\"DROP\"/FORWARD_POLICY=\"ACCEPT\"/g" /etc/default/ufw
sudo ufw allow 1194/udp
sudo ufw allow OpenSSH

echo "Restarting ufw"
sudo ufw disable
sudo ufw enable

