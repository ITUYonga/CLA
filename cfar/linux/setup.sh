#!/bin/bash
# Bir kez calistir: gerekli paketler, u-dma-buf modulu, overlay ve sunucu derlemesi
set -e
cd "$(dirname "$0")"

sudo apt update
sudo apt install -y build-essential git device-tree-compiler linux-headers-$(uname -r)

if [ ! -d udmabuf ]; then
    git clone https://github.com/ikwzm/udmabuf.git
fi
make -C udmabuf

dtc -@ -I dts -O dtb -o radar.dtbo radar.dtso
gcc -O2 -Wall -o radar_server radar_server.c

echo "setup tamam"
