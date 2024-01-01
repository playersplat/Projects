#A Wireless Bluetooth Mouse using an esp32c3 board
Contents:
Board Movement -- portion of code used to read the gyroscope of the board
BLE Moving Mouse Left and Right -- code used to integrate Bluetooth connectivity and moving the mouse cursor when connected to the computer
BLE Mouse with ESP32 -- Integrated portions of the previous folders into one complete build, esp32c3 acts as the mouse that you can move using the gyroscope feature built in. Connected to bluetooth on a computer/laptop and is able to move the cursor around the screen

#Build and Run
idf.py set-target esp32c3

cd build

ninja

idf.py flash
idf.py monitor
