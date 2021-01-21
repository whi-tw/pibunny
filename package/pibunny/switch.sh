#!/usr/bin/env bash
switch=${1}
echo -n ${switch} >/tmp/switchpos
for f in /opt/pibunny/functions.d/*.sh; do source $f; done
cd /root/udisk/${switch}/
sed -i 's/\r$//' payload.txt
bash ./payload.txt || /bin/LED FAIL3
