#! /bin/bash                     
                                
cd sys/class/gpio/             
#export leds + btn              
echo 1012 > ./export            
echo 1013 > ./export           
echo 1014 > ./export            
echo 1015 > ./export            
                               
echo 1020 > ./export            
echo 1021 > ./export            
echo 1022 > ./export           
echo 1023 > ./export            
                                
#set direction leds + btn       
                                
echo out > gpio1012/direction   
echo out > gpio1013/direction   
echo out > gpio1014/direction   
echo out > gpio1015/direction   
                                
                                
echo in > gpio1020/direction    
echo in > gpio1021/direction   
echo in > gpio1022/direction    
echo in > gpio1023/direction    
                               
while [ 1 -lt 2 ]               
do                              
                               
if [ $(cat gpio1020/value) = 1 ]
then                            
        echo 1 > gpio1012/value 
else                            
        echo 0 > gpio1012/value 
fi                              
                                
if [ $(cat gpio1021/value) = 1 ]
then                            
        echo 1 > gpio1013/value 
else                            
        echo 0 > gpio1013/value 
fi    

if [ $(cat gpio1022/value) = 1 ]
then                            
        echo 1 > gpio1014/value 
else                            
        echo 0 > gpio1014/value 
fi                              
                                
                                
if [ $(cat gpio1023/value) = 1 ]
then                            
        echo 1 > gpio1015/value 
else                            
        echo 0 > gpio1015/value 
fi                              
                                
done       
                          

