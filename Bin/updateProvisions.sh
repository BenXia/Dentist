#!/bin/sh

############################
##change current directory
############################
if [ `echo $0 | grep -c  "/"` -gt 0 ];then
    cd ${0%/*}
fi

binPath=`pwd`

function rmOldProvisioningProfiles()
{
    cd ~/Library/MobileDevice/Provisioning\ Profiles/
    OLD_IFS=$IFS
IFS="
"
    for file in `grep -r -l "yayiabc" .`
    do
        rm ${file}
    done

    IFS=$OLD_IFS
}

rmOldProvisioningProfiles &
echo "\n请耐心等待3秒\c"
sleep 1
echo "\b\b\b2秒\c"
sleep 1
echo "\b\b\b1秒\c"
sleep 1
echo "\b\b\b\b\b\b\b\b\b\b\b\b\b已完成.........\n"

cd ${binPath}/../Provisioning\ Profiles/
open -a XCode ../Provisioning\ Profiles/developmentProvisionProfile.mobileprovision
open -a XCode ../Provisioning\ Profiles/adHocProvisionProfile.mobileprovision
open -a XCode ../Provisioning\ Profiles/productProvisionProfile.mobileprovision

