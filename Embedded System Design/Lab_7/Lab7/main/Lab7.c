#include <stdio.h>

#include "driver/gpio.h"
#include "esp_timer.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/i2c.h"
#include "esp_log.h"

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

#define TRIG_GPIO    GPIO_NUM_0
#define ECHO_GPIO    GPIO_NUM_1

static esp_err_t i2c_master_init()
{
    i2c_config_t conf = {
    .mode = I2C_MODE_MASTER,
    .sda_io_num = I2C_MASTER_SDA_IO,
    .sda_pullup_en = GPIO_PULLUP_ENABLE,
    .scl_io_num = I2C_MASTER_SCL_IO,
    .scl_pullup_en = GPIO_PULLUP_ENABLE,
    .master.clk_speed = I2C_MASTER_FREQ_HZ,
    };
    
    esp_err_t err = i2c_param_config(I2C_MASTER_NUM, &conf);
    
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Failed to i2c_param_config %d", err);
        return err;
    }
    err = i2c_driver_install(I2C_MASTER_NUM, conf.mode, I2C_MASTER_RX_BUF_DISABLE, I2C_MASTER_TX_BUF_DISABLE,0);
    if( err!= ESP_OK) {
        ESP_LOGE(TAG, "Failed to i2c_driver_install %d", err);
        return err;
    }
    
    return err; 
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


void ultrasonic_sensor_task(void* arg)
{
    gpio_set_direction(TRIG_GPIO, GPIO_MODE_OUTPUT);
    gpio_set_direction(ECHO_GPIO, GPIO_MODE_INPUT);
    gpio_set_level(TRIG_GPIO, 0);
    
    uint8_t data[6];
    uint16_t raw_temperature;
    float temperature = 0.0;
    while(1)
    {
        // Send trigger pulse
        gpio_set_level(TRIG_GPIO, 1);
        esp_rom_delay_us(10);
        gpio_set_level(TRIG_GPIO, 0);

        // Wait for echo start
        while(gpio_get_level(ECHO_GPIO) == 0);

        // Measure how long the echo pin was held high (pulse width)
        uint32_t start = esp_timer_get_time();
        while(gpio_get_level(ECHO_GPIO) == 1);
        uint32_t time = esp_timer_get_time() - start;
        if(shtc3_read(SHTC3_CMD_MEASURE, data, 6) == ESP_OK) {
            raw_temperature = (data[0] << 8) | data[1];
            temperature = calculate_temperature(raw_temperature);

        }
        // Print distance
        float speedSound = 331.4 + 0.6 * temperature;
        float speedSound_cm = speedSound * 100 / 1000000;
        float distance = (time / 2.0) * speedSound_cm;
        
        printf("Distance: %.2f cm at %.2f C\n", distance, temperature);

        vTaskDelay(100 / portTICK_PERIOD_MS);
    }
}

void app_main(void)
{
    esp_err_t err = i2c_master_init();
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Failed to initialize I2C master");
        return;
    }
    xTaskCreate(ultrasonic_sensor_task, "ultrasonic_sensor_task", configMINIMAL_STACK_SIZE * 2, NULL, 5, NULL);
}


