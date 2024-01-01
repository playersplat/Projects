
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <driver/i2c.h>
#include <esp_log.h>
#include "sdkconfig.h"
#include "DFRobot_LCD.h"
static const char *TAG = "shtc3_prog";

#define I2C_MASTER_SCL_IO 8
#define I2C_MASTER_SDA_IO 10
#define I2C_MASTER_NUM I2C_NUM_0
#define I2C_MASTER_TX_BUF_DISABLE 0
#define I2C_MASTER_RX_BUF_DISABLE 0
#define I2C_MASTER_FREQ_HZ 100000
#define SHTC3_SENSOR_ADDR 0x70
#define SHTC3_CMD_READ_ID 0xEFC8
#define SHTC3_CMD_MEASURE 0x7866

#define LCD_COLS 16
#define LCD_ROWS 3

DFRobot_LCD lcd(LCD_COLS, LCD_ROWS, LCD_ADDRESS, RGB_ADDRESS);
extern "C" {
  void app_main();
}
static esp_err_t shtc3_read(uint16_t command, uint8_t *data, size_t size) {
    i2c_cmd_handle_t cmd = i2c_cmd_link_create();
    
    esp_err_t err;
#if 1
    i2c_master_start(cmd);
    i2c_master_write_byte(cmd, (SHTC3_SENSOR_ADDR << 1) | I2C_MASTER_WRITE, true);
    i2c_master_write_byte(cmd, command >> 8, true);
    i2c_master_write_byte(cmd, command & 0xFF, true);
    i2c_master_stop(cmd);
    err = i2c_master_cmd_begin(I2C_MASTER_NUM, cmd, pdMS_TO_TICKS(1000));
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Failed to 1st write %d", err);
        i2c_cmd_link_delete(cmd);
        return err;
    }
    
    vTaskDelay(pdMS_TO_TICKS(20));
    i2c_cmd_link_delete(cmd);
    cmd = i2c_cmd_link_create();
#endif
    i2c_master_start(cmd);
    i2c_master_write_byte(cmd, (SHTC3_SENSOR_ADDR << 1) | I2C_MASTER_READ, true);
    i2c_master_read(cmd, data, size, I2C_MASTER_LAST_NACK);
    i2c_master_stop(cmd);
    err = i2c_master_cmd_begin(I2C_MASTER_NUM, cmd, pdMS_TO_TICKS(1000));
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Failed to 2nd read %d", err);
        i2c_cmd_link_delete(cmd);
    }
    return err;
}
static float calculate_temperature(uint16_t raw_temperature) {
    return 175.0 * (float)raw_temperature / 65535.0 - 45.0;
}

static float calculate_humidity(uint16_t raw_humidity) {
    return 100.0 * (float)raw_humidity / 65535.0;
}


void shtc3_task(void *pvParameter) {
    uint8_t data[6];
    uint16_t raw_humidity, raw_temperature;
    while(1) {
        if(shtc3_read(SHTC3_CMD_MEASURE, data, 6) == ESP_OK) {
            static char humidity_output[50];
            static char temperature_output[50];
            raw_humidity = (data[3] << 8) | data[4];
            float humidity = calculate_humidity(raw_humidity);
            ESP_LOGI(TAG, "Humidity: %.2f %%", humidity);
            lcd.setCursor(5,1);
            sprintf(humidity_output, "%.2f %%", humidity);
            lcd.printstr(humidity_output);
            
            raw_temperature = (data[0] << 8) | data[1];
            float temperature = calculate_temperature(raw_temperature);
            ESP_LOGI(TAG, "Temperature: %.2f C", temperature);
            lcd.setCursor(5,0);
            sprintf(temperature_output, "%.2f C", temperature);
            lcd.printstr(temperature_output);
        } else {
            ESP_LOGE(TAG, "Failed to read data from SHTC3_sensor");
        }
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
    return;
}

void app_main(void){
    lcd.init();
    lcd.setCursor(0,0);
    lcd.setRGB(0,255,255);
    lcd.printstr("TEMP:");
    lcd.setCursor(0,1);
    lcd.printstr("HUM:");
    xTaskCreate(shtc3_task, "shtc3_task", 4096, NULL, 5, NULL);
}