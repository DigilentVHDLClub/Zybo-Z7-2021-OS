#!/bin/bash


path="/sys/class/gpio/gpio10"


#export leds and set data direction OUT
for (( i=12; i<=15; i++ ))
do
	echo "10$i" > /sys/class/gpio/export
	echo out > "${path}${i}/direction"
done


#export buttons and switches and set data direction IN
for (( i=16; i<=23; i++ )) # 1016-1019 ->switches, 1020-1023 -> buttons 
do
	echo "10$i" > /sys/class/gpio/export
	echo in > "${path}${i}/direction"
done

dec=4
flag=0
for((; ; ))
do
	for (( i=20; i<=23; i++ ))  #1020-1023 -> buttons 
	do
		bval=$(cat "${path}${i}/value")
		if [[ $bval -eq 1 ]] #reverse direction
		then
			flag = $((1-flag))
		fi
		
	done
	for (( i=16; i<=19; i++ )) # 1016-1019 ->switches
	do

		
		var=$(cat "${path}${i}/value") 
		if [[ $flag -eq 1 ]]
		then
			var=$((1-var))
		fi
		echo $var > "${path}$((i-dec))/value"
		# cat "${path}${i}/value" > "${path}$((i-dec))/value"
	done
done










