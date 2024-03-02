// BranchingFunctionsDelays.c Lab 6
// Runs on LM4F120/TM4C123
// Use simple programming structures in C to 
// toggle an LED while a button is pressed and 
// turn the LED on when the button is released.  
// This lab will use the hardware already built into the LaunchPad.
// Daniel Valvano, Jonathan Valvano
// January 15, 2016

// built-in connection: PF0 connected to negative logic momentary switch, SW2
// built-in connection: PF1 connected to red LED
// built-in connection: PF2 connected to blue LED
// built-in connection: PF3 connected to green LED
// built-in connection: PF4 connected to negative logic momentary switch, SW1

#include "TExaS.h"

#define GPIO_PORTF_DATA_R       (*((volatile unsigned long *)0x400253FC))
#define GPIO_PORTF_DIR_R        (*((volatile unsigned long *)0x40025400))
#define GPIO_PORTF_AFSEL_R      (*((volatile unsigned long *)0x40025420))
#define GPIO_PORTF_PUR_R        (*((volatile unsigned long *)0x40025510))
#define GPIO_PORTF_DEN_R        (*((volatile unsigned long *)0x4002551C))
#define GPIO_PORTF_AMSEL_R      (*((volatile unsigned long *)0x40025528))
#define GPIO_PORTF_PCTL_R       (*((volatile unsigned long *)0x4002552C))
#define SYSCTL_RCGC2_R          (*((volatile unsigned long *)0x400FE108))
#define SYSCTL_RCGC2_GPIOF      0x00000020  // port F Clock Gating Control
#define GPIO_PORTF_LOCK_R       (*((volatile unsigned long *)0x40025520))
#define GPIO_PORTF_CR_R         (*((volatile unsigned long *)0x40025524))

// basic functions defined at end of startup.s
void DisableInterrupts(void); // Disable interrupts
void EnableInterrupts(void);  // Enable interrupts
void PortF_Init(void);
void Delay(void);
unsigned long SW1; // Input from PF4
unsigned long Out; // output to PF2 (blue LED)
int main(void){ unsigned long volatile delay;
  TExaS_Init(SW_PIN_PF4, LED_PIN_PF2);  // activate grader and set system clock to 80 MHz
  // initialization goes here
	PortF_Init(); // Call initialization of port PF4 && PF2
  EnableInterrupts();           // enable interrupts for the grader
	
	GPIO_PORTF_DATA_R |= 0x04; // Initially turn on the blue LED
  while(1){
		Delay(); // Delay for about 100 ms
		SW1 = GPIO_PORTF_DATA_R & 0x10;
    if (!SW1) {
      GPIO_PORTF_DATA_R ^= 0x04; // Toggle the blue LED
		Delay(); // Additional delay to debounce and see the effect of toggle
		} 
		else {
      GPIO_PORTF_DATA_R |= 0x04; // Otherwise, turn the LED on
		
		}
	}
}

//Subroutine to initialize port F pins for input and output
// PF4 is input SW1 and PF2 is output Blue LED
// Inputs: None
// Outputs: None
void PortF_Init(void){ 
  volatile unsigned long delay;
  SYSCTL_RCGC2_R |= SYSCTL_RCGC2_GPIOF; // Activate clock for Port F
  delay = SYSCTL_RCGC2_R; // Allow time for clock to start
  GPIO_PORTF_LOCK_R = 0x4C4F434B; // Unlock GPIO Port F
  GPIO_PORTF_CR_R |= 0x1F; // Allow changes to PF4-0
  GPIO_PORTF_AMSEL_R = 0x00; // Disable analog on PF
  GPIO_PORTF_PCTL_R = 0x00000000; // PCTL GPIO on PF4-0
  GPIO_PORTF_DIR_R |= 0x04; // PF2 as output
  GPIO_PORTF_DIR_R &= ~0x10; // PF4 as input
  GPIO_PORTF_AFSEL_R = 0x00; // Disable alt funct on PF7-0
  GPIO_PORTF_PUR_R |= 0x10; // Enable pull-up on PF4
  GPIO_PORTF_DEN_R |= 0x14; // Enable digital I/O on PF2, PF4
}
// Color    LED(s) PortF
// dark     ---    0
// red      R--    0x02
// blue     --B    0x04
// green    -G-    0x08
// yellow   RG-    0x0A
// sky blue -GB    0x0C
// white    RGB    0x0E
// pink     R-B    0x06
void Delay(void){
  volatile unsigned long time;
  time = 800000;  // Approx 100ms delay at 80MHz
  while(time){
    time--;
  }
}
