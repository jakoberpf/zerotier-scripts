#!/bin/bash

isDocker(){
    local cgroup=/proc/1/cgroup
    test -f $cgroup && [[ "$(<$cgroup)" = *:cpuset:/docker/* ]]
}

isDockerBuildkit(){
    local cgroup=/proc/1/cgroup
    test -f $cgroup && [[ "$(<$cgroup)" = *:cpuset:/docker/buildkit/* ]]
}

isDockerContainer(){
    [ -e /.dockerenv ]
}

echo
echo '*** Enabling and starting ZeroTier service...'

if [ -e /usr/bin/systemctl -o -e /usr/sbin/systemctl -o -e /sbin/systemctl -o -e /bin/systemctl ]; then
	$SUDO systemctl enable zerotier-one
	$SUDO systemctl start zerotier-one
	if [ "$?" != "0" ]; then
		echo
		echo '*** Package installed but cannot start service! You may be in a Docker'
		echo '*** container or using a non-standard init service.'
		echo
		if [ isDockerContainer ]; then
			echo "Apparently you are running in Docker, ignoring initialization and trying to start daemon";
			$SUDO /usr/sbin/zerotier-one -d
		else
			exit 1
		fi
	fi
else
	if [ -e /sbin/update-rc.d -o -e /usr/sbin/update-rc.d -o -e /bin/update-rc.d -o -e /usr/bin/update-rc.d ]; then
		$SUDO update-rc.d zerotier-one defaults
	else
		$SUDO chkconfig zerotier-one on
	fi
	$SUDO /etc/init.d/zerotier-one start
fi

echo
echo '*** Waiting for identity generation...'

while [ ! -f /var/lib/zerotier-one/identity.secret ]; do
	sleep 1
done

echo
echo "*** Success! You are ZeroTier address [ `cat /var/lib/zerotier-one/identity.public | cut -d : -f 1` ]."
echo
