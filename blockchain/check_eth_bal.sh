#!/usr/bin/env bash

MJ_APIKEY_PUBLIC="85b2cef15b0bf92ac23af43b9d38e44b"
MJ_APIKEY_PRIVATE="bc4ff03b29955d740fb3bec1d958dc53"
CURR_BALANCE=.00337203

result=$(curl -s "https://api.etherscan.io/api?module=account&action=balance&address=0x135D7a30f8523A57d7DAac932aEC00f11AE5Ef96&tag=latest&apikey=6P7A3WYIGU8ADT3MPU19W5UWGKUPDGDFHR")

gwei=$(echo $result | cut -f4 -d":" | cut -f2 -d"\"")
echo $gwei

eth=$(bc <<< "scale=8;$gwei/1000000000000000000")
echo $eth

json="{\"FromEmail\":\"sharjeelbinkhalid@gmail.com\",\"FromName\":\"Me\",\"Subject\":\"Saad Eth Balance\",\"Text-part\":\"Eth Balance: $eth\",\"Recipients\":[{\"Email\":\"sharjeelbinkhalid@gmail.com\"}]}"

json2="{\"FromEmail\":\"sharjeelbinkhalid@gmail.com\",\"FromName\":\"Me\",\"Subject\":\"Saad Eth Balance\",\"Text-part\":\"Eth Balance: $eth\",\"Recipients\":[{\"Email\":\"syedsaads@gmail.com\"}]}"

message=$(date)
message="$message --- ETH Balance is $eth"
echo $message >> eth_balance.log

if [ "$(echo $eth '>' $CURR_BALANCE | bc -l)" -eq 1 ]
then

message=$(date)
message="$message --- ETH BALANCE HAS INCREASED. LOOK AT PREVIOUS MESSAGE"
echo $message >> eth_balance.log

curl -s \
  -X POST \
  --user "$MJ_APIKEY_PUBLIC:$MJ_APIKEY_PRIVATE" \
  https://api.mailjet.com/v3/send \
  -H 'Content-Type: application/json' \
  -d "$json"

curl -s \
  -X POST \
  --user "$MJ_APIKEY_PUBLIC:$MJ_APIKEY_PRIVATE" \
  https://api.mailjet.com/v3/send \
  -H 'Content-Type: application/json' \
  -d "$json2"

fi
