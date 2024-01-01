#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/adc.h"
#include "esp_adc_cal.h"
#include <string.h>
#define ADC_CHANNEL ADC_CHANNEL_0  // Assuming the photodiode is connected to GPIO36
#define DEFAULT_VREF 1100  // Default reference voltage for ADC calibration
#define NUM_SAMPLES   1000  // The number of samples to take in one second

// Character array to store Morse code
char morse[10];

// Function to add a dot or a dash to the morse code string
void add_to_morse(char c) {
    if (strlen(morse) < sizeof(morse) - 1) {
        strncat(morse, &c, 1);
    }
}

#include <string.h>

char morse_to_char(const char* morse) {
    struct morse_code {
        char* code;
        char letter;
    };

    struct morse_code morse_alphabet[] = {
        {".-", 'A'}, {"-...", 'B'}, {"-.-.", 'C'}, {"-..", 'D'}, {".", 'E'}, {"..-.", 'F'}, {"--.", 'G'}, {"....", 'H'}, {"..", 'I'}, {".---", 'J'}, {"-.-", 'K'}, {".-..", 'L'}, {"--", 'M'}, {"-.", 'N'}, {"---", 'O'}, {".--.", 'P'}, {"--.-", 'Q'}, {".-.", 'R'}, {"...", 'S'}, {"-", 'T'}, {"..-", 'U'}, {"...-", 'V'}, {".--", 'W'}, {"-..-", 'X'}, {"-.--", 'Y'}, {"--..", 'Z'}, {"-----", '0'}, {".----", '1'},{"..---", '2'}, {"...--", '3'},{"....-", '4'}, {".....", '5'}, {"-....", '6'}, {"--...", '7'},{"---..", '8'}, {"----.", '9'}, {"/", ' '}
    };

    for (int i = 0; i < sizeof(morse_alphabet)/sizeof(morse_alphabet[0]); i++) {
        if (strcmp(morse, morse_alphabet[i].code) == 0) {
            return morse_alphabet[i].letter;
        }
    }
    return '?';  // Return '?' if Morse code not recognized
}


// Task to sample ADC and detect Morse code
void adc_task(void* arg) {
    adc1_channel_t channel = ADC_CHANNEL;
    adc1_config_width(ADC_WIDTH_BIT_12);
    adc1_config_channel_atten(channel, ADC_ATTEN_DB_11);
    esp_adc_cal_characteristics_t characteristics;
    esp_adc_cal_characterize(ADC_UNIT_1, ADC_ATTEN_DB_11, ADC_WIDTH_BIT_12, DEFAULT_VREF, &characteristics);

    TickType_t start_time = xTaskGetTickCount();  // Start time of the current signal
    uint32_t signal_duration = 0;  // Duration of the current signal
    uint32_t pause_duration = 0;  // Duration of the pause between signals
    uint32_t voltage_threshold = 2000;  // Adjust this threshold based on your hardware setup
    
    while (1) {
        uint32_t adc_reading = 0;
        for (int i = 0; i < NUM_SAMPLES; i++) {
            adc_reading += adc1_get_raw(channel);
        }
        adc_reading /= NUM_SAMPLES;
        uint32_t voltage = esp_adc_cal_raw_to_voltage(adc_reading, &characteristics);

        // Check if the LED is on (voltage > threshold) or off (voltage < threshold)
        if (voltage > voltage_threshold) {
            signal_duration += pdMS_TO_TICKS(100);  // Increase the signal duration by 100 ms
            pause_duration = 0;  // Reset the pause duration
            
            // Check for dash or dot
            if (signal_duration >= pdMS_TO_TICKS(600)) {
                add_to_morse('-');
                signal_duration = 0;  // Reset the signal duration
            } else if (signal_duration >= pdMS_TO_TICKS(200)) {
                add_to_morse('.');
                signal_duration = 0;  // Reset the signal duration
            }
        } else {
            pause_duration += pdMS_TO_TICKS(100);  // Increase the pause duration by 100 ms
            
            // Check for end of dot or dash or end of character
            if (pause_duration >= pdMS_TO_TICKS(200)) {
                if (signal_duration > 0) {
                    char character = morse_to_char(morse);
                    // Print the received character
                    printf("%c", character);
                    fflush(stdout);
                    memset(morse, 0, sizeof(morse));  // Reset the morse array
                }
                pause_duration = 0;  // Reset the pause duration
            } else if (pause_duration >= pdMS_TO_TICKS(600)) {
                if (signal_duration > 0) {
                    char character = morse_to_char(morse);
                    // Print the received character
                    printf("%c", character);
                    fflush(stdout);
                    memset(morse, 0, sizeof(morse));  // Reset the morse array
                }
                signal_duration = 0;  // Reset the signal duration
                pause_duration = 0;  // Reset the pause duration
            }
        }

        // Check if the elapsed time exceeds 10 seconds, and exit the task if true
        TickType_t elapsed_time = xTaskGetTickCount() - start_time;
        if (elapsed_time >= pdMS_TO_TICKS(10000)) {
            break;
        }

        vTaskDelay(pdMS_TO_TICKS(100));  // Delay for 100 ms
    }
}


void app_main(void) {
    xTaskCreate(adc_task, "ADC task", 4096, NULL, 5, NULL);
}

