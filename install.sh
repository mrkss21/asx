sudo apt -y update && sudo apt -y install build-essential libssl-dev libdb++-dev && sudo apt -y install libboost-all-dev libcrypto++-dev libqrencode-dev && sudo apt -y install libminiupnpc-dev libgmp-dev libgmp3-dev autoconf && sudo apt -y install autogen automake libtool autotools-dev pkg-config && sudo apt -y install bsdmainutils software-properties-common && sudo apt -y install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev && sudo add-apt-repository ppa:bitcoin/bitcoin -y && sudo apt-get update && sudo apt-get install libdb4.8-dev libdb4.8++-dev -y && sudo apt-get install unzip -y && sudo apt-get install -y pwgen
cd /usr/local/bin
sudo wget https://github.com/Arkturdev/Arktur-coin/releases/download/1.1.1/Arkturcoin-Ubuntu-daemon-1.1.1.tgz
sudo tar zxfv Arkturcoin-Ubuntu-daemon-1.1.1.tgz
sudo chmod -R 755 arktur*
sudo rm Arkturcoin-Ubuntu-daemon-1.1.1.tgz
mkdir /root/.arktur
chmod -R 755 /root/.arktur
GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`
echo -e "rpcuser=arkturrpc\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=64\ndaemon=1\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}" > /root/.arktur/arktur.conf
name=arktur
daemon=arkturd
cat << EOF | sudo tee /etc/systemd/system/arktur@root.service
[Unit]
Description=arktur daemon
[Service]
User=root
Type=forking
ExecStart=/usr/local/bin/arkturd -daemon
Restart=always
RestartSec=20
[Install]
WantedBy=default.target
EOF
sudo systemctl enable arktur@$USER
sleep 3
sudo systemctl start arktur@$USER
sleep 10
masternodekey=$(arktur-cli masternode genkey)
arktur-cli stop
echo -e "masternode=1\nmasternodeprivkey=$masternodekey" >> /root/.arktur/arktur.conf
arkturd -daemon
echo ""
echo "Your Masternode IP address: ${IP_ADD}:40001"
echo "Masternode private key: $masternodekey"
echo ""
echo "-=####.1.####=- You can use type below for masternode.conf in your wallet - just add your 'transaction ID' and index (0/1):"
echo ""
echo ""
echo -e '\E[33;33m'"MN ${IP_ADD}:40001 $masternodekey "; tput sgr0
echo ""
echo ""
echo "-=####.2.####=- Just wait for 15 confirms of your 10000.00 ARKT transaction, make sure that wallet sync and block is like in explorer. Use this command to check:"
echo ""
echo "arktur-cli getinfo | grep blocks"
echo ""
echo "-=####.3.####=- Start node on wallet and check status with this command:"
echo ""
echo "arktur-cli masternode status"
