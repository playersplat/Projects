#Hello World
contains a simple program to flash onto the esp32c3-dev and display Hello World on the PI4 UART


#Flashing LED on ESP32
contains the program to simply flash an LED that is connected to GPIO2 of the esp32c3-dev

#Build and Run
cd into either folder

idf.py set-target esp32c3

cd build

ninja

idf.py flash
idf.py monitor
