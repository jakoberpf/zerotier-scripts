# zerotier-installer
Simple ZeroTier install and configure for Ubuntu 16.04 (Xenial). This is for demo/PoC use only.

The following variables must be set before running the script
* ZTAPI = ZeroTier API Key
* ZTNETWORK = Network to join member node to

If successful, this will join/authorize the host it is executed on to the ZeroTier network specified. There is no input validation or error checking done. Use at your own risk :smile:
