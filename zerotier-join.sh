zerotier-cli join $ZTNETWORK 
zerotier-cli -j info > zt-info
ZTADDRESS=$(cat zt-info|jq ".address"| tr -d '"')
if [ -n "$SLACK_WEBHOOK_URL" ]; then slack -u $HOSTNAME -e $ICON_EMOJI "My ZeroTier address is $ZTADDRESS" ; fi
if [ -n "$ZTIP" ]; then curl -H "Authorization: bearer $ZTAPI" -H "Content-Type: application/json" -X POST -d '{ "config":{ "ipAssignments":{ "${ZTIP}" } } }' https://my.zerotier.com/api/network/$ZTNETWORK/member/$ZTADDRESS
curl -H "Authorization: bearer $ZTAPI" -H "Content-Type: application/json" -X POST -d '{ "config":{ "ip": true } }' https://my.zerotier.com/api/network/$ZTNETWORK/member/$ZTADDRESS
curl -H "Authorization: bearer $ZTAPI" -H "Content-Type: application/json" -X POST -d '{ "name":"'$(hostname)'" }' https://my.zerotier.com/api/network/$ZTNETWORK/member/$ZTADDRESS
# curl -H "Authorization: bearer $ZTAPI" https://my.zerotier.com/api/network/$ZTNETWORK/member/$ZTADDRESS > zt-member
# ZTIP=$(cat zt-member | jq ".config.ipAssignments" | tr -d '[]" \n')

COUNTER=9

while [  $COUNTER -gt 0 ] && [ -z "$ZTIP" ]; do
  ZTIP=$(ip addr show zt0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
  if [ -n "$ZTIP" ]; then
    if [ -n "$SLACK_WEBHOOK_URL" ]; then slack -u $HOSTNAME -e $ICON_EMOJI "My ZeroTier IP is $ZTIP. VM customization Complete." ; fi
    echo ZeroTier IP: $ZTIP
  fi
  sleep 10
  let COUNTER-=1
done

if [ -z "$ZTIP" ]; then
  if [ -n "$SLACK_WEBHOOK_URL" ]; then slack -u $HOSTNAME -e $ICON_EMOJI "Could not determine ZeroTier IP. VM customization complete." ; fi
fi

rm zt-info
rm zt-member