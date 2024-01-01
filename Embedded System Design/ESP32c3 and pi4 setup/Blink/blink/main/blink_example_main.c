/* Blink Example

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/
#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include "esp_log.h"
#include "led_strip.h"
#include "sdkconfig.h"

static const char *TAG = "example";

/* Use project configuration menu (idf.py menuconfig) to choose the GPIO to blink,
   or you can edit the following line and set a number here.
*/
#define BLINK_GPIO 2

static uint8_t s_led_state = 0;

#ifdef CONFIG_BLINK_LED_RMT



void blink_task(void *pvParams)
{
    ESP_LOGI(TAG, "Example configured to blink GPIO LED!");
    gpio_reset_pin(BLINK_GPIO);
    /* Set the GPIO as a push/pull output */
  
    esp_rom_gpio_pad_select_gpio(BLINK_GPIO);
    gpio_set_direction(BLINK_GPIO, GPIO_MODE_OUTPUT);
    /* If the addressable LED is enabled */
    while(1) {
      ESP_LOGI(TAG, "Turning the LED %s!", s_led_state == true ? "ON" : "OFF");
      s_led_state = !s_led_state;
      vTaskDelay(CONFIG_BLINK_PERIOD / portTICK_PERIOD_MS);
      gpio_set_level(BLINK_GPIO, s_led_state);
      }
    
}

#endif

void app_main(void)
{
    xTaskCreate(
                &blink_task,
                "blink_task",
                2048,
                NULL,
                5,
                NULL);

}
