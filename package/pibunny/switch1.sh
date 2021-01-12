#!/usr/bin/env bash
cd /root/udisk/switch1/
sed -i 's/\r$//' payload.txt
chmod +x payload.txt
./payload.txt
