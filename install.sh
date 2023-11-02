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

wget ${GITHUB_DOWNLOAD_URL} -O ccminer
wget https://raw.githubusercontent.com/thepeoplescoder/VerusCliMining/main/config.luckpool.json # -O ~/ccminer/config.json
wget https://raw.githubusercontent.com/thepeoplescoder/VerusCliMining/main/config.verus_community.json # -O ~/ccminer/config.json
# chmod +x ~/ccminer/ccminer
chmod +x ccminer

cat << EOF > ~/ccminer/start.sh
#!/bin/sh
~/ccminer/ccminer -c ~/ccminer/config.json
EOF

chmod +x start.sh

COLOR_CYAN="\e[1;96m"
COLOR_RESET="\e[0m"

echo "setup nearly complete."
echo
echo "Config files in .json format exist in"
echo "the ~/ccminer directory."
echo
echo "Once you make that directory the current"
echo "directory, you can copy any of the"
echo "following files"
echo -en "$COLOR_CYAN"
    ls -1 config.*.json
echo -en "$COLOR_RESET"
echo "to config.json."
echo
echo "Edit the config with"
echo -e "   ${COLOR_CYAN}nano ~/ccminer/config.json${COLOR_RESET}"
echo
echo "and then replace:"
echo -e "   ${COLOR_CYAN}YOUR_WALLET_ADDRESS${COLOR_RESET} with your wallet"
echo "                       address"
echo -e "   ${COLOR_CYAN}YOUR_DEVICE_NAME${COLOR_RESET} with a name to identify"
echo "                    this device when viewing"
echo "                    pool stats"
echo
echo "use \"<CTRL>-x\" to exit and respond with"
echo "\"y\" on the question to save and \"enter\""
echo "on the name"
echo
echo "start the miner with"
echo -e "   ${COLOR_CYAN}cd ~/ccminer; ./start.sh${COLOR_RESET}"
echo
echo "Be sure that you copied one of"
echo -e "the ${COLOR_CYAN}~/ccminer/config.*.json${COLOR_RESET}"
echo -e "files to ${COLOR_CYAN}~/ccminer/config.json${COLOR_RESET}!!!!!"