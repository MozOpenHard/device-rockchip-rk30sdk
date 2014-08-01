#!/system/bin/sh
while [ true ];do
    status=`getprop init.svc.dhcpcd_wlan0`
    if [ "running" != "$status" ];then
        iwlist wlan0 scan | grep -E "Address|ESSID|Encryption|IE" > /mnt/sdcard/scan_result.txt
    fi
    sleep 10
done
