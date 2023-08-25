
.include "/sdcard/FWC/assembly/codes/m328Pdef.inc"


ldi r16, 0b00000100 ; Configure PB2 (pin 10) as an output
out DDRB,r16

Start:
    ldi r17, 0b00000010 ; Load input value 00 for P and ¬P
    in r18, PINB        ; Read the current state of PINB (input value Q)
    
    ldi r19, 0b00000011 ; Load mask for input value 00
    and r18, r19        ; Mask r18 to keep only the lowest two bits
    
    ldi r20, 0b00000001 ; Load mask for ¬Q
    cpi r18, 0b00000000 ; Compare Q with 0
    breq set_mask       ; If Q is 0, set the mask for ¬Q
    
    cbr r20, 0b00000001 ; Clear the mask for ¬Q (Q is 0)
    
set_mask:
    cp r17, r18         ; Compare input value with masked PINB state
    breq is_input_P     ; Branch to is_input_P if input value P matches masked state
    
    call led_off        ; Call led_off to turn off the LED
    rjmp End            ; Jump to End
    
is_input_P:
    cpi r18, 0b00000010 ; Compare input value with P (01)
    breq led_on         ; Branch to led_on if input value is P (01)
    
    call led_off        ; Call led_off to turn off the LED
    rjmp End            ; Jump to End
    
led_on:
    call led_on_action  ; Call led_on_action to turn on the LED
    
End:
    rjmp Start          ; Jump back to Start

; Function to turn on the LED
led_on_action:
    sbi PORTB, PORTB2   ; Set PB2 to HIGH
    ret

; Function to turn off the LED
led_off:
    cbi PORTB, PORTB2   ; Clear PB2 to LOW
    ret

