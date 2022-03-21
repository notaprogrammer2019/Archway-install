#!/bin/bash

apt install wget jq bc build-essential -y && docker create -it --name archway archwaynetwork/archwayd:augusta && docker cp archway:/usr/bin/archwayd /usr/bin/archwayd && docker rm archway -f && docker rmi archwaynetwork/archwayd:augusta && . <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n archway_chain_id -v "augusta-1" && . <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n archway_moniker && . <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n archway_wallet_name && archwayd init "$archway_moniker" --chain-id "$archway_chain_id" && archwayd config chain-id augusta-1 && archwayd config keyring-backend file && archwayd keys add "$archway_wallet_name" --keyring-backend file && wget -qO- https://rpc.augusta-1.archway.tech/genesis | jq ".result.genesis" > $HOME/.archway/config/genesis.json && wget -qO $HOME/.archway/config/addrbook.json https://raw.githubusercontent.com/SecorD0/Archway/main/addrbook.json && sed -i -e "s%^moniker *=.*%moniker = \"$archway_moniker\"%; "\
"s%^seeds *=.*%seeds = \"2f234549828b18cf5e991cc884707eb65e503bb2@34.74.129.75:31076,c8890bcde31c2959a8aeda172189ec717fef0b2b@95.216.197.14:26656\"%; "\
"s%^persistent_peers *=.*%persistent_peers = \"1f6dd298271684729d0a88402b1265e2ae8b7e7b@162.55.172.244:26656\"%; "\
"s%^external_address *=.*%external_address = \"`wget -qO- eth0.me`:26656\"%; " $HOME/.archway/config/config.toml && printf "[Unit]
Description=Archway node
After=network-online.target

[Service]
User=$USER
ExecStart=`which archwayd` start --x-crisis-skip-assert-invariants
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/archwayd.service && . <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n archway_log -v "sudo journalctl -fn 100 -u archwayd" -a && . <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n archway_node_info -v ". <(wget -qO- https://raw.githubusercontent.com/SecorD0/Archway/main/node_info.sh) -l RU 2> /dev/null" -a
