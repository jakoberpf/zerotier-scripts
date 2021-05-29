# zerotier-installer
Simple ZeroTier install and configure for Ubuntu 16.04 (Xenial). This is for demo/PoC use only.

The following variables must be set before running the join and installer script
```zerotier-join.sh```
* ZTAPI = ZeroTier API Key
* ZTNETWORK = Network to join member node to
* (optional) ZTIP = IP address to assign to the member node
* (optional) SLACK_WEBHOOK_URL = Slack webhook url to post on

The leave script can be run without any variables. Note that the leave script will remove the node from all network which it is part of.

If python/pip is installed and the the environment variable SLACK_WEBHOOK_URL is set, this script will post output to slack.

If successful, this will join/authorize the host it is executed on to the ZeroTier network specified. There is no input validation or error checking done. Use at your own risk :smile:
