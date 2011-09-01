#!/bin/bash

DEVICE=${1%}

if [ "$DEVICE" != "vzwtabmtd" ]; then
        echo "product is blank blank or fascinatemtd compatible, fascinatemtd will be used"
        CONFIG=fascinatemtd
	if [ "$DEVICE" = "" ]; then
		DEVICE=fasinatemtd
	fi
else
        echo "product is $DEVICE"
	CONFIG=$DEVICE
fi

echo "rm out"
rm -rf out
echo "rm update/data/*.zip"
rm -rf update/data/*.zip
echo "rm update/log/*.log"
rm -rf update/log/*.log
echo "cleaning build directory"
rm -rf kernel/samsung/aries/build

source build/envsetup.sh
lunch full_"$CONFIG"-eng

./kernel/samsung/aries/build.sh "$CONFIG"
make -j$(grep processor /proc/cpuinfo | wc -l) bootimage 1> update/log/stdlog_"$DEVICE".log 2> update/log/errlog_"$DEVICE".log

cp out/target/product/"$CONFIG"/boot.img update/data
cp device/samsung/"$CONFIG"/bcm4329.ko update/data/system/lib/modules

cd update/data
ZIP="KernelUpdate-$DEVICE-`date +%m%d`.zip"
zip -r $ZIP .
mv -f $ZIP ../..
cd ../..

