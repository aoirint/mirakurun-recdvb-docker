#!/bin/bash

rm -f /run/pcscd/pcscd.comm >/dev/null 2>&1

# --->
# Start pcscd
# https://github.com/Chinachu/Mirakurun/blob/00cd8f6d830d33a556b192e3a51506c73c0b42b8/docker/container-init.sh
# Apache License 2.0, (c) kanreisa, https://github.com/kanreisa
if [ -e "/etc/init.d/pcscd" ]; then
  while :; do
    echo "starting pcscd..."
    /etc/init.d/pcscd start
    sleep 1
    timeout 2 pcsc_scan | grep -A 50 "Using reader plug'n play mechanism"
    if [ $? = 0 ]; then
      break;
    fi
    echo "failed!"
  done
fi
# <---

echo "Start test recording"
recdvb --b25 --strip --sid hd 27 5 /work/test.m2ts
# TODO: check if error in m2ts
echo "$?"
echo "Finished test recording"

# --->
# Stop pcscd
# https://github.com/Chinachu/Mirakurun/blob/00cd8f6d830d33a556b192e3a51506c73c0b42b8/docker/container-init.sh
# Apache License 2.0, (c) kanreisa, https://github.com/kanreisa
if [ -e "/etc/init.d/pcscd" ]; then
  echo "stopping pcscd..."
  /etc/init.d/pcscd stop
  sleep 1
fi
# <---

# Execute the original launcher
cd /app
bash ./docker/container-init.sh

