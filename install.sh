sudo apt -y update && sudo apt -y install build-essential libssl-dev libdb++-dev && sudo apt -y install libboost-all-dev libcrypto++-dev libqrencode-dev && sudo apt -y install libminiupnpc-dev libgmp-dev libgmp3-dev autoconf && sudo apt -y install autogen automake libtool autotools-dev pkg-config && sudo apt -y install bsdmainutils software-properties-common && sudo apt -y install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev && sudo add-apt-repository ppa:bitcoin/bitcoin -y && sudo apt-get update && sudo apt-get install libdb4.8-dev libdb4.8++-dev -y && sudo apt-get install unzip -y && sudo apt-get install -y pwgen
cd /usr/local/bin
wget https://github.com/axsgold/axs/releases/download/v4.0.0.2/axs-v4-precompiled-daemon.zip
unzip axs-v4-precompiled-daemon.zip
chmod -R 755 axsd
rm axs-v4-precompiled-daemon.zip
cd
mkdir /root/.axs4
chmod -R 755 /root/.axs4
GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`
echo -e "rpcuser=axsrpc\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=64\ndaemon=1\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}\naddnode=95.179.132.198:51711\naddnode=45.63.121.133:51711\naddnode=66.42.49.66:51711\naddnode=95.179.132.198:51711\naddnode=35.196.209.18:51711\naddnode=94.177.163.52:51711\naddnode=80.211.89.32:51711\naddnode=176.120.186.186:51711\naddnode=46.146.233.115:51711\naddnode=213.183.51.230:51711\naddnode=45.63.109.44:51711\naddnode=209.250.236.24:51711\naddnode=95.171.6.57:51711\naddnode=45.63.121.133:51711\naddnode=66.42.49.66:51711" > /root/.axs4/axs.conf
name=axs
daemon=axsd
cat << EOF | sudo tee /etc/systemd/system/axs@root.service
[Unit]
Description=axs daemon
[Service]
User=root
Type=forking
ExecStart=/usr/local/bin/axsd -daemon
Restart=always
RestartSec=20
[Install]
WantedBy=default.target
EOF
sudo systemctl enable axs@$USER
sleep 3
sudo systemctl start axs@$USER
sleep 10
masternodekey=$(axsd masternode genkey)
axsd stop
echo -e "masternode=1\nmasternodeprivkey=$masternodekey" >> /root/.axs4/axs.conf
axsd -daemon
echo ""
echo "Your Masternode IP address: ${IP_ADD}:33771"
echo "Masternode private key: $masternodekey"
echo ""
echo "-=####.1.####=- You can use type below for masternode.conf in your wallet - just add your 'transaction ID' and index (0/1):"
echo ""
echo ""
echo -e '\E[33;33m'"MN ${IP_ADD}:33771 $masternodekey "; tput sgr0
echo ""
echo "axsd getinfo | grep blocks"
echo ""
echo ""
echo "axsd masternode status"
sleep 120
axsd getinfo | grep blocks  
