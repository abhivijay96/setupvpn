echo "Creating client directory to accomodate $1"
mkdir -p ./clients/keys
echo "Done creating client keys directory"

echo "Changing directory to server"
cd ./EasyRSA-3.0.4_server/
echo "In server directory now"

echo "Generating client $1"
./easyrsa gen-req $1 nopass
echo "Done generating client.key"

echo "Moving client.key to clients/keys"
cp pki/private/$1.key ../clients/keys/
echo "Done moving"

echo "Copying $1.req file to CA"
cp pki/reqs/$1.req ../EasyRSA-3.0.4/
echo "Done copying"

echo "Changing to CA directory"
cd ../EasyRSA-3.0.4/
echo "In CA directory"

echo "Importing and signing $1.req"
./easyrsa import-req $1.req $1
./easyrsa sign-req client $1
rm $1.req
echo "Done importing and signing"

echo "Copying $1.crt to clients folder"
cp pki/issued/$1.crt ../clients/keys/
echo "Done copying"

echo "Copying CA's config to client"
cp ../EasyRSA-3.0.4_server/ta.key ../clients/keys/
sudo cp /etc/openvpn/ca.crt ../clients/keys/
echo "Done copying CA's config"


