.thumb
.syntax unified

.include "gpio_constants.s"     // Register-adresser og konstanter for GPIO

.text
	.global Start

	LDR R0, =BUTTON_PORT
	LDR R1, =PORT_SIZE 
	LDR R2, =LED_PORT

	MUL R0, R1, R0 # R0 = PORT_SIZE * BUTTON_PORT
	MUL R2, R1, R2 # R2 = PORT_SIZE * LED_PORT

	LDR R1, =GPIO_BASE
	ADD R0, R1, R0 # R0 = GPIO_BASE + PORT_SIZE * BUTTON_PORT
	ADD R2, R1, R2 # R2 = GPIO_BASE + PORT_SIZE * LED_PORT

	LDR R1, =GPIO_PORT_DIN
	ADD R3, R1, R0 # R3 = GPIO_PORT_DIN + (GPIO_BASE + PORT_SIZE * BUTTON_PORT)

	LDR R1, =GPIO_PORT_DOUTSET
	ADD R5, R1, R2 # R5 = GPIO_PORT_DOUTSET + (GPIO_BASE + PORT_SIZE * LED_PORT)

	LDR R1, =GPIO_PORT_DOUTCLR
	ADD R4, R1, R2 # R4 = GPIO_PORT_DOUTCLR + (GPIO_BASE + PORT_SIZE * LED_PORT)


    # R3 is address of value of button
    # R4 is address of CLR register for LED
    # R5 is address of SET register for LED

	# prepare selectors
	MOV R0, #1
	LSL R1, R0, #BUTTON_PIN # Select button pin 
	LSL R2, R0, #LED_PIN	# Select set / clear pin

poll:
	LDR R0, [R3]    # Read value from button
	AND R0, R0, R1  # Mask read value from button
	CMP R0, #0	    # Compare to 0
	BEQ led_on 	    # Jump if the value is equal to 0 
	STR R2, [R4]    # Clear the light
	B poll

led_on:
	STR R2 , [R5]   # Set the light
	B poll

NOP // Behold denne på bunnen av fila
