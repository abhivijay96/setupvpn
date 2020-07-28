echo "Installing openvpn"
sudo apt update
sudo apt install openvpn
echo "Done Installing openvpn"

echo "Installing EasyRSA"
wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/EasyRSA-3.0.4.tgz
tar xvf EasyRSA-3.0.4.tgz

echo "Setting up server directory"
cp -r EasyRSA-3.0.4 ./EasyRSA-3.0.4_server
echo "Done setting up server directory"

echo "Setting up vars"
cd ./EasyRSA-3.0.4/
cp vars.example vars
echo "set_var EASYRSA_REQ_COUNTRY    \"US\"" >> vars
echo "set_var EASYRSA_REQ_PROVINCE   \"EAST\"" >> vars
echo "set_var EASYRSA_REQ_CITY       \"AZURE\"" >> vars
echo "set_var EASYRSA_REQ_ORG        \"VM\"" >> vars
echo "set_var EASYRSA_REQ_EMAIL      \"testing@example.com\"" >> vars
echo "set_var EASYRSA_REQ_OU         \"Community\"" >> vars
echo "Done setting up vars"

echo "./easyrsa init-pki"
./easyrsa init-pki
echo "done ./easyrsa init-pki"

echo "./easyrsa build-ca nopass"
./easyrsa build-ca nopass
echo "done ./easyrsa build-ca nopass"

echo "cd ../EasyRSA-3.0.4_server"
cd ../EasyRSA-3.0.4_server
echo "In Server folder now"

echo "./easyrsa init-pki"
./easyrsa init-pki
echo "done ./easyrsa init-pki"

echo "./easyrsa gen-req server nopass"
./easyrsa gen-req server nopass
echo "done ./easyrsa gen-req server nopass"

echo "Copying server.key file to /etc/openvpn"
sudo cp ./pki/private/server.key /etc/openvpn/
echo "done copying"

echo "Moving server.req to CA folder"
mv ./pki/reqs/server.req ../EasyRSA-3.0.4/
echo "Done moving"

echo "Changing directory to CA folder"
cd ../EasyRSA-3.0.4/
echo "In CA folder now"

echo "Importing server.req"
./easyrsa import-req ./server.req server
echo "done importing"

echo "Signing server.req"
./easyrsa sign-req server server
echo "done signing"

echo "Moving server certificate and CA certificate to /etc/openvpn"
sudo cp ./pki/issued/server.crt /etc/openvpn/
sudo cp ./pki/ca.crt /etc/openvpn/
echo "done moving"

echo "Changing directory to server"
cd ../EasyRSA-3.0.4_server
echo "In server folder"

echo "Generating and moving DH keys for the server"
./easyrsa gen-dh
openvpn --genkey --secret ta.key
sudo cp ./ta.key /etc/openvpn/
sudo cp ./pki/dh.pem /etc/openvpn/
echo "Done generating server keys and moving them to /etc/openvpn"

echo "Please run gen_client.sh to generate client certificates now"

