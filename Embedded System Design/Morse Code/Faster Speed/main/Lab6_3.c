#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"

#define GPIO_INPUT_PIN   GPIO_NUM_4  // GPIO pin number for input. Change if using a different pin

#define DOT_DURATION_MS   200
#define DASH_DURATION_MS  600
#define CHARACTER_SPACE_MS  600
#define WORD_SPACE_MS   1400

char morse_to_char(const char* morse) {
    // Define the Morse code to ASCII conversion table
    struct morse_code {
        const char* code;
        char character;
    };

    struct morse_code morse_alphabet[] = {
        {".-", 'A'}, {"-...", 'B'}, {"-.-.", 'C'}, {"-..", 'D'}, {".", 'E'},
        {"..-.", 'F'}, {"--.", 'G'}, {"....", 'H'}, {"..", 'I'}, {".---", 'J'},
        {"-.-", 'K'}, {".-..", 'L'}, {"--", 'M'}, {"-.", 'N'}, {"---", 'O'},
        {".--.", 'P'}, {"--.-", 'Q'}, {".-.", 'R'}, {"...", 'S'}, {"-", 'T'},
        {"..-", 'U'}, {"...-", 'V'}, {".--", 'W'}, {"-..-", 'X'}, {"-.--", 'Y'},
        {"--..", 'Z'}, {"-----", '0'}, {".----", '1'}, {"..---", '2'}, {"...--", '3'},
        {"....-", '4'}, {".....", '5'}, {"-....", '6'}, {"--...", '7'}, {"---..", '8'},
        {"----.", '9'}, {"/", ' '}
    };

    for (int i = 0; i < sizeof(morse_alphabet) / sizeof(morse_alphabet[0]); i++) {
        if (strcmp(morse, morse_alphabet[i].code) == 0) {
            return morse_alphabet[i].character;
        }
    }

    return '?';  // Return '?' if Morse code not recognized
}

void app_main(void) {
    gpio_pad_select_gpio(GPIO_INPUT_PIN);
    gpio_set_direction(GPIO_INPUT_PIN, GPIO_MODE_INPUT);

    TickType_t prev_time = 0;
    int dot_count = 0;
    int dash_count = 0;
    char morse[10];
    int morse_index = 0;

    while (1) {
        int input_state = gpio_get_level(GPIO_INPUT_PIN);
        TickType_t current_time = xTaskGetTickCount();

        if (input_state == 1) {
            // LED is on. Increase dot_count
            dot_count++;
        } else {
            // LED is off. Check if it's the end of a dot or dash
            if (dot_count > 0) {
                TickType_t duration = (current_time - prev_time) * portTICK_PERIOD_MS;

                if (duration >= DASH_DURATION_MS) {
                    // End of a dash
                    morse[morse_index] = '-';
                    dash_count++;
                } else if (duration >= DOT_DURATION_MS) {
                    // End of a dot
                    morse[morse_index] = '.';
                    dot_count++;
                }

                // Increment the morse_index for the next symbol
                morse_index++;

                // Reset dot_count for the next symbol
                dot_count = 0;
            }
        }

        // Check for the end of a character
        if (dash_count > 0 && dot_count == 0) {
            // End of a character
            morse[morse_index] = '\0';  // Null-terminate the morse string
            char character = morse_to_char(morse);

            if (character == '?') {
                // Print an error message if Morse code is not recognized
                printf("[Error] Unrecognized Morse code: %s\n", morse);
            } else {
                // Print the ASCII character
                printf("%c", character);
            }

            // Reset the morse string and morse_index for the next character
            memset(morse, 0, sizeof(morse));
            morse_index = 0;

            dash_count = 0;
        }

        // Check for the end of a word
        if ((current_time - prev_time) * portTICK_PERIOD_MS >= WORD_SPACE_MS) {
            // End of a word
            printf(" ");
            dot_count = 0;
            dash_count = 0;
        }

        prev_time = current_time;

        vTaskDelay(pdMS_TO_TICKS(10));  // Delay for 10 ms
    }
}

