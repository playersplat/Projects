// ***** 0. Documentation Section *****
// SwitchLEDInterface.c for Lab 8
// Runs on LM4F120/TM4C123
// Use simple programming structures in C to toggle an LED
// while a button is pressed and turn the LED on when the
// button is released.  This lab requires external hardware
// to be wired to the LaunchPad using the prototyping board.
// January 15, 2016
//      Jon Valvano and Ramesh Yerraballi

// ***** 1. Pre-processor Directives Section *****
#include "TExaS.h"
#include "tm4c123gh6pm.h"

// ***** 2. Global Declarations Section *****
#define SYSCTL_RCGC2_R          (*((volatile unsigned long *)0x400FE108))
#define GPIO_PORTA_DATA_R       (*((volatile unsigned long *)0x400043FC))
#define GPIO_PORTA_AMSEL_R      (*((volatile unsigned long *)0x40004528))
#define GPIO_PORTA_PCTL_R       (*((volatile unsigned long *)0x4000452C))
#define GPIO_PORTA_AFSEL_R      (*((volatile unsigned long *)0x40004420))
#define GPIO_PORTA_DEN_R        (*((volatile unsigned long *)0x4000451C))
#define PA3 (1U << 3)
#define PA2 (1U << 2) // Define PA2 bitmask
// FUNCTION PROTOTYPES: Each subroutine defined
void DisableInterrupts(void); // Disable interrupts
void EnableInterrupts(void);  // Enable interrupts
void Switch_Init(void);
unsigned long Switch_Input(void);
unsigned long Switch_Input2(void);
void Led_Init(void);
void Delay(void);
// ***** 3. Subroutines Section *****
// PE0, PB0, or PA2 connected to positive logic momentary switch using 10k ohm pull down resistor
// PE1, PB1, or PA3 connected to positive logic LED through 470 ohm current limiting resistor
// To avoid damaging your hardware, ensure that your circuits match the schematic
// shown in Lab8_artist.sch (PCB Artist schematic file) or 
// Lab8_artist.pdf (compatible with many various readers like Adobe Acrobat).
int main(void){ 
//**********************************************************************
// The following version tests input on PE0 and output on PE1
//**********************************************************************
  TExaS_Init(SW_PIN_PE0, LED_PIN_PE1, ScopeOn);  // activate grader and set system clock to 80 MHz
  Led_Init();
	Switch_Init();
  EnableInterrupts();           // enable interrupts for the grader
  unsigned long prevSwitchState = 1; // Assume switch is initially not pressed  unsigned long switchState;
  unsigned long switchState;
  while(1){
      switchState = Switch_Input(); // Read the current state of the switch
      
      if(switchState){ // Transition from pressed to not pressed
          GPIO_PORTA_DATA_R |= PA3; // Make sure LED is on when switch is released
      } 
      else if(!switchState){ // If switch is currently pressed
          if(prevSwitchState){ // If this is the first iteration after the switch was pressed
              GPIO_PORTA_DATA_R ^= PA3; // Toggle LED immediately to start toggling
          }
          Delay(); // Wait for about 100ms
          GPIO_PORTA_DATA_R ^= PA3; // Continue to toggle LED
      }
      else { // If switch is not pressed
          GPIO_PORTA_DATA_R |= PA3; // Ensure LED remains on
      }
      
      prevSwitchState = switchState; // Update previous state for next iteration
  }
  
}

void Led_Init(void){
    volatile unsigned long delay;
    SYSCTL_RCGC2_R |= 0x00000001;     // 1) activate clock for Port A
    delay = SYSCTL_RCGC2_R;           // allow time for clock to start
    GPIO_PORTA_AMSEL_R &= ~PA3;       // 2) disable analog on PA3
    GPIO_PORTA_PCTL_R &= ~0x0000F000; // 3) PCTL GPIO on PA3
    GPIO_PORTA_DIR_R |= PA3;          // 4) direction PA3 output
    GPIO_PORTA_AFSEL_R &= ~PA3;       // 5) PA3 regular port function
    GPIO_PORTA_DEN_R |= PA3;          // 6) enable PA3 digital port
}

void Switch_Init(void){
    volatile unsigned long delay;
    SYSCTL_RCGC2_R |= 0x00000001;     // 1) activate clock for Port A
    delay = SYSCTL_RCGC2_R;           // allow time for clock to start
    GPIO_PORTA_AMSEL_R &= ~PA2;       // 2) disable analog on PA2
    GPIO_PORTA_PCTL_R &= ~0x00000F00; // 3) PCTL GPIO on PA2
    GPIO_PORTA_DIR_R &= ~PA2;         // 4) direction PA2 input
    GPIO_PORTA_AFSEL_R &= ~PA2;       // 5) PA2 regular port function
    GPIO_PORTA_DEN_R |= PA2;          // 6) enable PA2 digital port
}
unsigned long Switch_Input(void){
  // Return 1 if switch is pressed, 0 otherwise
  return (GPIO_PORTA_DATA_R & PA2) ? 0 : 1; // Assuming a low signal indicates a press
}

unsigned long Switch_Input2(void){
  return (GPIO_PORTA_DATA_R&0x20); // 0x20(pressed) or 0(not pressed)
}

void Delay(void){
    volatile unsigned long time;
    time = 750000;  // Adjust this value based on your system's clock speed
    while(time){
        time--;
    }
}

