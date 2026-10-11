#!/bin/bash
# Her acilista bir kez calistir: bitstream'i yukler, DMA tamponunu acar
set -e
cd "$(dirname "$0")"
APP=radar

for f in radar.bit.bin radar.dtbo shell.json; do
    [ -f "$f" ] || { echo "$f yok"; exit 1; }
done

sudo mkdir -p /lib/firmware/xilinx/$APP
sudo cp radar.bit.bin radar.dtbo shell.json /lib/firmware/xilinx/$APP/
sudo cp radar.bit.bin /lib/firmware/

if command -v xmutil >/dev/null 2>&1; then
    sudo xmutil unloadapp || true
    sudo xmutil loadapp $APP
else
    OVL=/sys/kernel/config/device-tree/overlays
    [ -d $OVL ] || sudo mount -t configfs none /sys/kernel/config
    for d in $OVL/*; do [ -d "$d" ] && sudo rmdir "$d"; done
    sudo mkdir $OVL/$APP
    sudo sh -c "cat radar.dtbo > $OVL/$APP/dtbo"
fi

if ! lsmod | grep -q u_dma_buf; then
    sudo insmod udmabuf/u-dma-buf.ko udmabuf0=1048576
fi
ls -l /dev/udmabuf0
cat /sys/class/u-dma-buf/udmabuf0/phys_addr
sudo dmesg | tail -n 8
echo "yukleme tamam, simdi: sudo ./radar_server"
