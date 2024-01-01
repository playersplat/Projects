#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/i2c.h"
#include "esp_log.h"
#include "sdkconfig.h"

#define ICM42670_ADDR 0x68 //ICM-42670-P I2C address
#define I2C_PORT I2C_NUM_0 //I2C port
#define SDA_PIN 10
#define SCL_PIN 8

#define TAG "board_inclination"
void i2c_master_init() {
    i2c_config_t conf = {
    .mode               = I2C_MODE_MASTER,
    .sda_io_num         = SDA_PIN,
    .sda_pullup_en      = GPIO_PULLUP_ENABLE,
    .scl_io_num         = SCL_PIN,
    .scl_pullup_en      = GPIO_PULLUP_ENABLE,
    .master.clk_speed   = 100000,
    };
    ESP_ERROR_CHECK(i2c_param_config(I2C_PORT, &conf));
    ESP_ERROR_CHECK(i2c_driver_install(I2C_PORT, conf.mode, 0, 0, 0));
}
void i2c_write(uint8_t reg, uint8_t data) {
    i2c_cmd_handle_t cmd = i2c_cmd_link_create();
    i2c_master_start(cmd);
    i2c_master_write_byte(cmd, (ICM42670_ADDR << 1) | I2C_MASTER_WRITE, true);
    i2c_master_write_byte(cmd, reg, true);
    i2c_master_write_byte(cmd, data, true);
    i2c_master_stop(cmd);
    i2c_master_cmd_begin(I2C_PORT, cmd, pdMS_TO_TICKS(1000));
    i2c_cmd_link_delete(cmd);
}

uint8_t i2c_read(uint8_t reg) {
    uint8_t data;
    i2c_cmd_handle_t cmd = i2c_cmd_link_create();
    i2c_master_start(cmd);
    i2c_master_write_byte(cmd, (ICM42670_ADDR << 1) | I2C_MASTER_WRITE, true);
    i2c_master_write_byte(cmd, reg, true);
    i2c_master_start(cmd);
    i2c_master_write_byte(cmd, (ICM42670_ADDR << 1) | I2C_MASTER_READ, true);
    i2c_master_read_byte(cmd, &data, I2C_MASTER_LAST_NACK);
    i2c_master_stop(cmd);
    i2c_master_cmd_begin(I2C_PORT, cmd, pdMS_TO_TICKS(1000));
    i2c_cmd_link_delete(cmd);
    return data;
}

void icm42670_init() {
    i2c_write(0x1F, 0b00011111); //Gyro configuration: +/-2000dps
}

void read_gyro() {
    int16_t data_x = (i2c_read(0x0B) << 8 | i2c_read(0x0C));
    int16_t data_y = (i2c_read(0x0D) << 8 | i2c_read(0x0E));
    int16_t data_z = (i2c_read(0x0F) << 8 | i2c_read(0x10));
    

    bool is_up = (data_y < -100);
    bool is_down = (data_y > 300);
    bool is_left = (data_x > 480);
    bool is_right = (data_z < 1950);
    if (is_up && is_left) {
        ESP_LOGI(TAG, "UP LEFT");
    } else if (is_up && is_right) {
        ESP_LOGI(TAG, "UP RIGHT");
    } else if (is_down && is_left) {
        ESP_LOGI(TAG, "DOWN LEFT"); 
    } else if (is_down && is_right) {
        ESP_LOGI(TAG, "DOWN RIGHT");
    } else if (is_up) {
        ESP_LOGI(TAG, "UP");
    } else if (is_down) {
        ESP_LOGI(TAG, "DOWN");
    } else if (is_left) {
        ESP_LOGI(TAG, "LEFT");
    } else if (is_right) {
        ESP_LOGI(TAG, "RIGHT");
    }
}

void app_main() {
    i2c_master_init();
    icm42670_init();
    
    while(1) {
        read_gyro();
        vTaskDelay(pdMS_TO_TICKS(100)); // Delay for 1 second
    }
}

