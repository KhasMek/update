#!/bin/bash

DEVICE=${1%}

if [ "$DEVICE" = "" ]; then
        echo "product is blank, fascinatemtd will be used"
        DEVICE=fascinatemtd
else
        echo "product is $DEVICE"
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
lunch full_"$DEVICE"-eng

./kernel/samsung/aries/build.sh "$DEVICE"
make -j$(grep processor /proc/cpuinfo | wc -l) bootimage 1> update/log/stdlog_"$DEVICE".log 2> update/log/errlog_"$DEVICE".log

cp out/target/product/"$DEVICE"/boot.img update/data
cp device/samsung/"$DEVICE"/bcm4329.ko update/data/system/lib/modules

cd update/data
ZIP="KernelUpdate-$DEVICE-`date +%m%d`.zip"
zip -r $ZIP .
mv -f $ZIP ../..
cd ../..

