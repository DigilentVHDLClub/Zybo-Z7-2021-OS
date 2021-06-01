#!/bin/bash

# shamefully copied from other branch
# set leds as outputs
echo 1012 > /sys/class/gpio/export
echo 1013 > /sys/class/gpio/export
echo 1014 > /sys/class/gpio/export
echo 1015 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio1012/direction
echo out > /sys/class/gpio/gpio1013/direction
echo out > /sys/class/gpio/gpio1014/direction
echo out > /sys/class/gpio/gpio1015/direction

# set buttons as inputs
echo 1020 > /sys/class/gpio/export
echo 1021 > /sys/class/gpio/export
echo 1022 > /sys/class/gpio/export
echo 1023 > /sys/class/gpio/export
echo in > /sys/class/gpio/gpio1020/direction
echo in > /sys/class/gpio/gpio1021/direction
echo in > /sys/class/gpio/gpio1022/direction
echo in > /sys/class/gpio/gpio1023/direction

echo 1016 > /sys/class/gpio/export
echo 1017 > /sys/class/gpio/export
echo 1018 > /sys/class/gpio/export
echo 1019 > /sys/class/gpio/export
echo in > /sys/class/gpio/gpio1016/direction
echo in > /sys/class/gpio/gpio1017/direction
echo in > /sys/class/gpio/gpio1018/direction
echo in > /sys/class/gpio/gpio1019/direction

while true
do
	if [ $(cat /sys/class/gpio/gpio1016/value) -eq 1 ] 
	then 
		if [ $(cat /sys/class/gpio/gpio1020/value) -eq 1 ]
		then 
		 echo 0 > /sys/class/gpio/gpio1012/value
		else 
		 echo 1 > /sys/class/gpio/gpio1012/value
		fi
	else 
	echo "$(cat /sys/class/gpio/gpio1020/value)" > /sys/class/gpio/gpio1012/value
	fi
	
	if [ $(cat /sys/class/gpio/gpio1017/value) -eq 1 ] 
	then 
		if [ $(cat /sys/class/gpio/gpio1021/value) -eq 1 ]
		then 
		 echo 0 > /sys/class/gpio/gpio1013/value
		else 
		 echo 1 > /sys/class/gpio/gpio1013/value
		fi
	else 
	echo "$(cat /sys/class/gpio/gpio1021/value)" > /sys/class/gpio/gpio1013/value
	fi
	
	if [ $(cat /sys/class/gpio/gpio1018/value) -eq 1 ] 
	then 
		if [ $(cat /sys/class/gpio/gpio1022/value) -eq 1 ]
		then 
		 echo 0 > /sys/class/gpio/gpio1014/value
		else 
		 echo 1 > /sys/class/gpio/gpio1014/value
		fi
	else 
	echo "$(cat /sys/class/gpio/gpio1022/value)" > /sys/class/gpio/gpio1014/value
	fi
	
	if [ $(cat /sys/class/gpio/gpio1019/value) -eq 1 ] 
	then 
		if [ $(cat /sys/class/gpio/gpio1023/value) -eq 1 ]
		then 
		 echo 0 > /sys/class/gpio/gpio1015/value
		else 
		 echo 1 > /sys/class/gpio/gpio1015/value
		fi
	else 
	echo "$(cat /sys/class/gpio/gpio1023/value)" > /sys/class/gpio/gpio1015/value  
	fi
	
	

done