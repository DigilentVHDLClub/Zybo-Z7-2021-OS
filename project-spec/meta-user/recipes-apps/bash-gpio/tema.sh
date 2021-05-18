cd /sys/class/gpio
echo 1012 > export
echo 1013 > export
echo 1014 > export
echo 1015 > export
echo 1020 > export
echo 1021 > export
echo 1022 > export
echo 1023 > export
echo out > gpio1012/direction
echo out > gpio1013/direction
echo out > gpio1014/direction
echo out > gpio1015/direction
echo in > gpio1020/direction
echo in > gpio1021/direction
echo in > gpio1022/direction
echo in > gpio1023/direction
while :
do
cat gpio1020/value > gpio1012/value
cat gpio1021/value > gpio1013/value
cat gpio1022/value > gpio1014/value
cat gpio1023/value > gpio1015/value
done

