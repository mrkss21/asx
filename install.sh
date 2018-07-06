sudo apt -y update && sudo apt -y install build-essential libssl-dev libdb++-dev && sudo apt -y install libboost-all-dev libcrypto++-dev libqrencode-dev && sudo apt -y install libminiupnpc-dev libgmp-dev libgmp3-dev autoconf && sudo apt -y install autogen automake libtool autotools-dev pkg-config && sudo apt -y install bsdmainutils software-properties-common && sudo apt -y install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev && sudo add-apt-repository ppa:bitcoin/bitcoin -y && sudo apt-get update && sudo apt-get install libdb4.8-dev libdb4.8++-dev -y && sudo apt-get install unzip -y && sudo apt-get install -y pwgen
cd /usr/local/bin
wget http://github.com/axsgold/axs/releases/download/1.0.0.1-DAEMON/axs-daemon-precompiled.zip
unzip axs-daemon-precompiled.zip
chmod -R 755 axsd
rm axs-daemon-precompiled.zip
cd
mkdir /root/.axs
chmod -R 755 /root/.axs
GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`
echo -e "rpcuser=axsrpc\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=64\ndaemon=1\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}\naddnode=95.163.106.119:33771\naddnode=149.28.161.222:33771\naddnode=45.63.114.114:33771\naddnode=45.77.171.22:33771\naddnode=207.148.123.87:33771\naddnode=90.156.157.70:33771\naddnode=45.32.43.39:33771\naddnode=199.247.30.131:33771\naddnode=217.69.4.206:33771\naddnode=217.69.7.66:33771\naddnode=45.76.112.143:33771\naddnode=45.32.147.196:33771\naddnode=90.156.139.81:33771\naddnode=45.77.21.139:33771\naddnode=217.69.2.81:33771\naddnode=199.247.1.198:33771\naddnode=202.182.117.253:33771\naddnode=149.28.166.7:33771\naddnode=95.179.149.159:33771\naddnode=108.61.167.34:33771" > /root/.axs/axs.conf
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
echo "asxd getinfo | grep blocks"
echo ""
echo ""
echo "asxd masternode status"
sleep 120
asxd getinfo | grep blocks
