#GDB debugging
lab2_image.elf file contains errors within it, debugged using GDB to figure out the Minimum free heap size and result of compute values

#Humidity and Temperature
Within the main folder, contains sensor.c configured to run on an esp32c3
Using FreeRTOS and task.h, reads inputs from i2c SCL_IO 8 and i2c SDA_IO 10 to calculate raw temperature and raw humidity. 

shtc3_task reads and displays humidity and temperature onto the monitor when running the project

#Build and Run
idf.py set-target esp32c3

cd build

ninja

idf.py flash
idf.py monitor
