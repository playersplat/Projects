#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <pigpio.h>

#define LED_PIN 10

const char* morse_code[128] = {0};

void init_morse_code() {
    morse_code['A'] = morse_code['a'] = ".-";
    morse_code['B'] = morse_code['b'] = "-...";
    morse_code['C'] = morse_code['c'] = "-.-.";
    morse_code['D'] = morse_code['d'] = "-..";
    morse_code['E'] = morse_code['e'] = ".";
    morse_code['F'] = morse_code['f'] = "..-.";
    morse_code['G'] = morse_code['g'] = "--.";
    morse_code['H'] = morse_code['h'] = "....";
    morse_code['I'] = morse_code['i'] = "..";
    morse_code['J'] = morse_code['j'] = ".---";
    morse_code['K'] = morse_code['k'] = "-.-";
    morse_code['L'] = morse_code['l'] = ".-..";
    morse_code['M'] = morse_code['m'] = "--";
    morse_code['N'] = morse_code['n'] = "-.";
    morse_code['O'] = morse_code['o'] = "---";
    morse_code['P'] = morse_code['p'] = ".--.";
    morse_code['Q'] = morse_code['q'] = "--.-";
    morse_code['R'] = morse_code['r'] = ".-.";
    morse_code['S'] = morse_code['s'] = "...";
    morse_code['T'] = morse_code['t'] = "-";
    morse_code['U'] = morse_code['u'] = "..-";
    morse_code['V'] = morse_code['v'] = "...-";
    morse_code['W'] = morse_code['w'] = ".--";
    morse_code['X'] = morse_code['x'] = "-..-";
    morse_code['Y'] = morse_code['y'] = "-.--";
    morse_code['Z'] = morse_code['z'] = "--..";
    morse_code['0'] = "-----";
    morse_code['1'] = ".----";
    morse_code['2'] = "..---";
    morse_code['3'] = "...--";
    morse_code['4'] = "....-";
    morse_code['5'] = ".....";
    morse_code['6'] = "-....";
    morse_code['7'] = "--...";
    morse_code['8'] = "---..";
    morse_code['9'] = "----.";
    morse_code[' '] = "/";
    morse_code['.'] = ".-.-.-";
    morse_code[','] = "--..--";
    morse_code['?'] = "..--..";
    morse_code['\''] = ".----.";
    morse_code['!'] = "-.-.--";
    morse_code['/'] = "-..-.";
    morse_code['('] = "-.--.";
    morse_code[')'] = "-.--.-";
    morse_code['&'] = ".-...";
    morse_code[':'] = "---...";
    morse_code[';'] = "-.-.-.";
    morse_code['='] = "-...-";
    morse_code['+'] = ".-.-.";
    morse_code['-'] = "-....-";
    morse_code['_'] = "..--.-";
    morse_code['"'] = ".-..-.";
    morse_code['$'] = "...-..-";
    morse_code['@'] = ".--.-.";
}


void flash_led(const char* code) {
    for (int i = 0; code[i] != '\0'; i++) {
        if (code[i] == '.') {
            gpioWrite(LED_PIN, 1);
            gpioDelay(200000); // 200 ms
            gpioWrite(LED_PIN, 0);
            gpioDelay(200000); // 200 ms
        }
        else if (code[i] == '-') {
            gpioWrite(LED_PIN, 1);
            gpioDelay(600000); // 600 ms
            gpioWrite(LED_PIN, 0);
            gpioDelay(200000); // 200 ms
        }
        else if (code[i] == '/') {
            gpioDelay(600000); // 600 ms
        }
    }
}

int main(int argc, char *argv[]) {
    init_morse_code();
    
    if (gpioInitialise() < 0) {
        printf("pigpio initialisation failed.\n");
        return 1;
    }

    gpioSetMode(LED_PIN, PI_OUTPUT);

    int repetitions = atoi(argv[1]);

    for (int i = 0; i < repetitions; i++) {
        for (int j = 2; j < argc; j++) {
            char *message = argv[j];
            for (int k = 0; message[k] != '\0'; k++) {
                flash_led(morse_code[toupper(message[k])]);
                gpioDelay(600000); // 600 ms between each character
            }
            if (j < argc - 1) { // If there's another word, flash the Morse code for space
                flash_led(morse_code[' ']);
            }
        }
        gpioDelay(1000000); // 1 second between repetitions
    }

    gpioTerminate();
    return 0;
}
