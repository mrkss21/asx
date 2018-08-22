sudo apt -y update && sudo apt -y install build-essential libssl-dev libdb++-dev && sudo apt -y install libboost-all-dev libcrypto++-dev libqrencode-dev && sudo apt -y install libminiupnpc-dev libgmp-dev libgmp3-dev autoconf && sudo apt -y install autogen automake libtool autotools-dev pkg-config && sudo apt -y install bsdmainutils software-properties-common && sudo apt -y install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev && sudo add-apt-repository ppa:bitcoin/bitcoin -y && sudo apt-get update && sudo apt-get install libdb4.8-dev libdb4.8++-dev -y && sudo apt-get install unzip -y && sudo apt-get install -y pwgen
cd /usr/local/bin
wget https://github.com/axsgold/axs/releases/download/v2.0.0.1-FORK/axsd-precompiled-daemon-v2.zip
unzip axsd-precompiled-daemon-v2.zip
chmod -R 755 axsd
rm axsd-precompiled-daemon-v2.zip
cd
mkdir /root/.axs
chmod -R 755 /root/.axs
GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`
echo -e "rpcuser=axsrpc\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=64\ndaemon=1\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}\naddnode=209.250.251.252:33771\naddnode=217.69.0.8:33771\naddnode=209.250.239.117\naddnode=45.76.133.189:33771\naddnode=207.148.115.228:33771" > /root/.axs/axs.conf
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
echo -e "masternode=1\nmasternodeprivkey=$masternodekey" >> /root/.axs/axs.conf
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
