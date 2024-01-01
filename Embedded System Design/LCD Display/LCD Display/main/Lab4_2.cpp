#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <driver/i2c.h>
#include <esp_log.h>
#include "sdkconfig.h"
#include "DFRobot_LCD.h"

#define LCD_COLS 16
#define LCD_ROWS 3

DFRobot_LCD lcd(LCD_COLS, LCD_ROWS, LCD_ADDRESS, RGB_ADDRESS);


extern "C" {
  void app_main();
}

void app_main() {
    lcd.init();
    lcd.setCursor(0,0);
    lcd.setRGB(0,255,255);
    lcd.printstr("Hello CSE121!");
    lcd.setCursor(0,1);
    lcd.printstr("BRIAN");
    while(true) {
        
        vTaskDelay(1000/portTICK_PERIOD_MS);
    }
    
}

