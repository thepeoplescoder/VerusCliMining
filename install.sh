#!/bin/sh
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install libcurl4-openssl-dev libjansson-dev libomp-dev git screen nano jq wget
wget http://ports.ubuntu.com/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_arm64.deb
sudo dpkg -i libssl1.1_1.1.0g-2ubuntu4_arm64.deb
rm libssl1.1_1.1.0g-2ubuntu4_arm64.deb
mkdir ~/ccminer
cd ~/ccminer
GITHUB_RELEASE_JSON=$(curl --silent "https://api.github.com/repos/Oink70/Android-Mining/releases?per_page=1" | jq -c '[.[] | del (.body)]')
GITHUB_DOWNLOAD_URL=$(echo $GITHUB_RELEASE_JSON | jq -r ".[0].assets | .[] | .browser_download_url")
GITHUB_DOWNLOAD_NAME=$(echo $GITHUB_RELEASE_JSON | jq -r ".[0].assets | .[] | .name")

echo "Downloading latest release: $GITHUB_DOWNLOAD_NAME"

wget ${GITHUB_DOWNLOAD_URL} -O ~/ccminer/ccminer
wget https://raw.githubusercontent.com/thepeoplescoder/VerusCliMining/main/config.json -O ~/ccminer/config.json
chmod +x ~/ccminer/ccminer

cat << EOF > ~/ccminer/start.sh
#!/bin/sh
~/ccminer/ccminer -c ~/ccminer/config.json
EOF

chmod +x start.sh

echo "setup nearly complete."
echo
echo "Config files in .json format exist in the ~/ccminer directory."
echo
echo "Once you make that directory the current directory, you can copy"
echo "any of the following files"
echo
(cd ~/ccminer && ls -1 config.*.json)
echo
echo "to config.json."
echo
echo "Edit the config with \"nano ~/ccminer/config.json\","
echo "and then replace:"
echo
echo "   YOUR_WALLET_ADDRESS with your wallet address"
echo "   YOUR_DEVICE_NAME with a name to identify this device when viewing pool stats"
echo
echo "use \"<CTRL>-x\" to exit and respond with"
echo "\"y\" on the question to save and \"enter\""
echo "on the name"
echo
echo "start the miner with \"cd ~/ccminer; ./start.sh\"."
echo
echo "Be sure that you copied one of the ~/ccminer/config.*.json files to ~/ccminer/config.json !!!!!"