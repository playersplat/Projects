// Lab13.c
// Runs on LM4F120 or TM4C123
// Use SysTick interrupts to implement a 4-key digital piano
// edX Lab 13 
// Daniel Valvano, Jonathan Valvano
// December 29, 2014
// Port B bits 3-0 have the 4-bit DAC
// Port E bits 3-0 have 4 piano keys

#include "..//tm4c123gh6pm.h"
#include "Sound.h"
#include "Piano.h"
#include "TExaS.h"
#define SIN32 1

#define C16 9555 		// 80Mhz/(523.251*16)-1 = 9554.6435
#define D16 8512		// 80Mhz/(587.330*16)-1 = 8512.1017
#define E16 7583		// 80Mhz/(659.255*16)-1 = 7583.3187
#define G16 6377		// 80Mhz/(783.991*16)-1 = 6576.6242

#define C32 4777 		// 80Mhz/(523.251*32)-1 = 4776.8217
#define D32 4256		// 80Mhz/(587.330*32)-1 = 4255.5508
#define E32 3791		// 80Mhz/(659.255*32)-1 = 3791.1593
#define G32 3188		// 80Mhz/(783.991*32)-1 = 3187.8121

// basic functions defined at end of startup.s
void DisableInterrupts(void); // Disable interrupts
void EnableInterrupts(void);  // Enable interrupts
void delay(unsigned long msec);
int main(void){ // Real Lab13 
	// for the real board grader to work 
	// you must connect PD3 to your DAC output
  TExaS_Init(SW_PIN_PE3210, DAC_PIN_PB3210,ScopeOn); // activate grader and set system clock to 80 MHz
// PortE used for piano keys, PortB used for DAC        
  Sound_Init(); // initialize SysTick timer and DAC
  Piano_Init();
  EnableInterrupts();  // enable after all initialization are done
	unsigned long current;
  while(1){                
// input from keys to select tone
				current = Piano_In();
		if (0x01==current) {
			#if defined SIN_32
			Sound_Tone(C32);
			#else
			Sound_Tone(C16);
			#endif
		} else if (0x02==current) {
			#if defined SIN_32
			Sound_Tone(D32);
			#else
			Sound_Tone(D16);
			#endif
		} else if (0x04==current) {
			#if defined SIN_32
			Sound_Tone(E32);
			#else
			Sound_Tone(E16);
			#endif
		} else if (0x08==current) {
			#if defined SIN_32
			Sound_Tone(G32);
			#else
			Sound_Tone(G16);
			#endif
		} else {
			Sound_Off();
		}
		//previous = current;
		delay(10);
  }     

            
}

// Inputs: Number of msec to delay
// Outputs: None
void delay(unsigned long msec){ 
  unsigned long count;
  while(msec > 0 ) {  // repeat while there are still delay
    count = 16000;    // about 1ms
    while (count > 0) { 
      count--;
    } // This while loop takes approximately 3 cycles
    msec--;
  }
}

