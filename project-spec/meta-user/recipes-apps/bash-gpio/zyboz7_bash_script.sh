gpioPath="/sys/class/gpio/"
exp="export"
uexp="unexport"

leds=(1012 1013 1014 1015)
switches=(1016 1017 1018 1019)

# Called on reception of interrupt signal for user. This function
# unexports all gpio interfaces exported at the beggining of the script
function interrupt {
	echo "\nUser interrupt - cleaning:"
	for led in ${leds[@]}; do
		closePort $led
	done
	for switch in ${switches[@]}; do
		closePort $switch
	done
	exit
}

# Define the kind of interrupt and the function that should handle it
trap interrupt SIGINT
trap interrupt SIGSTP

# Writes a value to a specific gpio port
# Takes two parameters:
# port (int) - number of the gpio port to be written
# value (int) - 0 or 1, the value to be written to the "value" register
# of the specified port
function writeGpio() {
	port=$1
	value=$2

	path=$gpioPath"gpio"$port"/value"
	echo $value > $path
}

# Reads the gpio received as argument and returns the result
# port (int) - POrt to read the value from
# The return value is either 0 or 1. 
function readGpio() {
	port=$1

	return $( cat $gpioPath"gpio"$port"/value" )
}

# Opens a port as output
# Takes the name of the port and exports it.
# Then, it sets the "direction" register to "out"
# port (int) - number of the gpio port to open
function openOutPort() {
	port=$1

	dirPath=$gpioPath"gpio"$port"/direction"

	echo $port > $gpioPath$exp
	echo out > $dirPath  
}

# Opens a port as input
# Takes the name of the port and exports it.
# Then, it sets the "direction" register to "in"
# port (int) - number of the gpio port to open
function openInPort() {
	port=$1

	dirPath=$gpioPath"gpio"$port"/direction"

	echo $port > $gpioPath$exp
	echo in > $dirPath  
} 

# Closes port passed as function argument
# port (int) - port to close
function closePort() {
	port=$1

	echo $port > $gpioPath$uexp
}

# Opens all ports that we will need
function openAllPorts() {
	#LEDs
	openOutPort 1012
	openOutPort 1013
	openOutPort 1014
	openOutPort 1015

	echo "Opening switches\n"
	#Switches
	openInPort 1016
	openInPort 1017
	openInPort 1018
	echo "Opening last switch\n"
	openInPort 1019
}

openAllPorts

#Infinite while --------------------
while true; do
	for i in ${!leds[@]}; do
		readGpio ${switches[$i]}
		# $? is the value of the returned variable
		if [ $? -eq 1 ]
		then
			writeGpio ${leds[$i]} 1
		else
			writeGpio ${leds[$i]} 0
		fi
	done
done
