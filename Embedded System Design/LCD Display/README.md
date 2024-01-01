#LCD Display
Displays Hello {Class Name} and {Last NAME} on a LCD display using an esp32c3

#LCD Temperature
Integrated temperature and humidty to change realtime onto the LCD display

#Build and Run
idf.py set-target esp32c3

cd build

ninja

idf.py flash
idf.py monitor
