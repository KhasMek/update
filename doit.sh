#!/bin/bash

rm -rf out
rm -rf update/data/*.zip
rm -rf kernel/samsung/aries/build

source build/envsetup.sh
lunch full_fascinatemtd-eng

./kernel/samsung/aries/build.sh fascinatemtd
make -j8 bootimage

cp out/target/product/fascinatemtd/boot.img update/data
cp device/samsung/fascinatemtd/bcm4329.ko update/data/system/lib/modules

cd update/data
ZIP="KernelUpdate-`date +%m%d`.zip"
zip -r $ZIP . 
mv -f $ZIP ../..
cd ../..

