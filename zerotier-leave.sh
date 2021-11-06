zerotier-cli join $ZTNETWORK 
zerotier-cli -j info > zt-info
ZTADDRESS=$(cat zt-info|jq ".address"| tr -d '"')
zerotier-cli -j networks > zt-networks
curl -H "Authorization: bearer $ZTAPI" -H "Content-Type: application/json" -X DELETE https://my.zerotier.com/api/network/$ZTNETWORK/member/$ZTADDRESS
# curl -H "Authorization: bearer $ZTAPI" https://my.zerotier.com/api/network/$ZTNETWORK/member/$ZTADDRESS > zt-member
# ZTIP=$(cat zt-member | jq ".config.ipAssignments" | tr -d '[]" \n')

rm zt-info
rm zt-networks