 processor 6502

	ORG $801
	.byte    $0E, $08, $0A, $00, $9E, $20, $28
	.byte   $32,$30,$36,$34
	.byte    $29, $00, $00, $00

	ORG $810

JoyTest
	jmp block25766
js1	dc.b	$0
js2	dc.b	$0
b1	dc.b	$0
b2	dc.b	$0
b1old	dc.b	$0
b2old	dc.b	$0
js1old	dc.b	$0
js2old	dc.b	$0
js1oldx	dc.b	$0
js1oldy	dc.b	$0
js2oldx	dc.b	$0
js2oldy	dc.b	$0
tx	dc.b	$0
ty	dc.b	$0
ti	dc.b	$0
TL	dc.b 32, 27, 29, 31, 33, 107, 109, 112
	dc.b 114, 31
TR	dc.b 32, 28, 30, 111, 34, 108, 110, 113
	dc.b 115, 30
BL	dc.b 32, 67, 69, 71, 73, 147, 149, 152
	dc.b 154, 73
BR	dc.b 32, 68, 70, 72, 74, 148, 150, 153
	dc.b 155, 74
j1posx	dc.b 0, 11, 11, 0, 8, 9, 9, 0
	dc.b 14, 13, 13, 0, 0, 0, 0, 0
	dc.b 
j2posx	dc.b 0, 27, 27, 0, 24, 25, 25, 0
	dc.b 30, 29, 29, 0, 0, 0, 0, 0
	dc.b 
jsposy	dc.b 0, 10, 16, 0, 13, 11, 15, 0
	dc.b 13, 11, 15, 0, 0, 0, 0, 0
	dc.b 
jsdir	dc.b 0, 3, 4, 0, 1, 5, 7, 0
	dc.b 2, 6, 8, 0, 0, 0, 0, 0
	dc.b 
	
	
	; ***********  Defining procedure : initjoystick
	;    Procedure type : Built-in function
	;    Requires initialization : no
	
joystickup .byte 0
joystickdown .byte 0
joystickleft .byte 0
joystickright .byte 0
joystickbutton .byte 0
callJoystick
	lda #0
	sta joystickup
	sta joystickdown
	sta joystickleft
	sta joystickright
	sta joystickbutton
	lda #%00000001 ; mask joystick up movement
	bit $50      ; bitwise AND with address 56320
	bne joystick_down       ; zero flag is not set -> skip to down
	lda #1
	sta joystickup
joystick_down
	lda #%00000010 ; mask joystick down movement
	bit $50      ; bitwise AND with address 56320
	bne joystick_left       ; zero flag is not set -> skip to down
	lda #1
	sta joystickdown
joystick_left
	lda #%00000100 ; mask joystick left movement
	bit $50      ; bitwise AND with address 56320
	bne joystick_right       ; zero flag is not set -> skip to down
	lda #1
	sta joystickleft
joystick_right
	lda #%00001000 ; mask joystick up movement
	bit $50      ; bitwise AND with address 56320
	bne joystick_button       ; zero flag is not set -> skip to down
	lda #1
	sta joystickright
joystick_button
	lda #%00010000 ; mask joystick up movement
	bit $50      ; bitwise AND with address 56320
	bne callJoystick_end       ; zero flag is not set -> skip to down
	lda #1
	sta joystickbutton
callJoystick_end
	rts
	rts
	
	
	; ***********  Defining procedure : initmoveto
	;    Procedure type : Built-in function
	;    Requires initialization : no
	
	jmp moveto71003
screenmemory =  $fe
screen_x = $4c
screen_y = $4e
SetScreenPosition
	sta screenmemory+1
	lda #0
	sta screenmemory
	ldy screen_y
	beq sydone
syloop
	clc
	adc #40
	bcc sskip
	inc screenmemory+1
sskip
	dey
	bne syloop
sydone
	ldx screen_x
	beq sxdone
	clc
	adc screen_x
	bcc sxdone
	inc screenmemory+1
sxdone
	sta screenmemory
	rts
moveto71003
	rts
	
	
	; ***********  Defining procedure : initprintstring
	;    Procedure type : Built-in function
	;    Requires initialization : no
	
print_text = $4c
print_number_text .dc "    ",0
printstring
	ldy #0
printstringloop
	lda (print_text),y
	beq printstring_done
	cmp #64
	bcc printstring_skip
	sec
	sbc #64
printstring_skip
	sta (screenmemory),y
	iny
	dex
	cpx #0
	beq printstring_done
	jmp printstringloop
printstring_done
	rts
 ; Temp vars section
 ; Temp vars section ends
block25766

	lda $d018
	and #%11110001
	ora #8
	sta $d018
	; Clear screen with offset
	lda #1
	ldx #$00
clearloop31626
	sta $0000+$d800,x
	sta $0100+$d800,x
	sta $0200+$d800,x
	sta $02e8+$d800,x
	dex
	bne clearloop31626
	lda #7
	sta screen_x
	lda #1
	sta screen_y
	lda #4
	jsr SetScreenPosition
	jmp printstring_call22868
printstring_text65806	dc.b	"JOYSTICK TESTER BY FIREBAY"
	dc.b	0
printstring_call22868
	clc
	lda #<printstring_text65806
	adc #0
	ldy #>printstring_text65806
	sta print_text+0
	sty print_text+1
	ldx #40 ; optimized, look out for bugs
	jsr printstring
	; Poke
	; Optimization: shift is zero
	lda #224
	sta $dc02
while57709
	; Binary clause: EQUALS
	lda #1
	; Compare with pure num / var optimization
	cmp #1
	; BC done
	bne binaryclausefailed50597
	lda #1; success
	jmp binaryclausefinished17085
binaryclausefailed50597
	lda #0 ; failed state
binaryclausefinished17085
	cmp #1
	beq ConditionalTrueBlock56659
	jmp elsedoneblock50144
ConditionalTrueBlock56659

	; Assigning single variable : js1
	; 8 bit binop
	; Add/sub right value is variable/expression
	; 8 bit binop
	; Add/sub where right value is constant number
	; Peek
	lda $dc01 + $0
	
	and #15
	 ; end add / sub var with constant
	
rightvarAddSub_var8718 = $54
	sta rightvarAddSub_var8718
	lda #15
	sec
	sbc rightvarAddSub_var8718
	
	sta js1
	; Assigning single variable : js2
	; 8 bit binop
	; Add/sub right value is variable/expression
	; 8 bit binop
	; Add/sub where right value is constant number
	; Peek
	lda $dc00 + $0
	
	and #15
	 ; end add / sub var with constant
	
rightvarAddSub_var41680 = $54
	sta rightvarAddSub_var41680
	lda #15
	sec
	sbc rightvarAddSub_var41680
	
	sta js2
	; Assigning single variable : tx
	; Load Byte array
	ldx js1
	lda j1posx,x
	
	sta tx
	; Assigning single variable : ty
	; Load Byte array
	ldx js1
	lda jsposy,x
	
	sta ty
	; Assigning single variable : ti
	; Load Byte array
	ldx js1
	lda jsdir,x
	
	sta ti
	; Binary clause Simplified: NOTEQUALS
	lda js1old
	; Compare with pure num / var optimization
	cmp js1
	beq elsedoneblock6895
ConditionalTrueBlock31753

	; Binary clause Simplified: GREATER
	lda js1oldx
	; Compare with pure num / var optimization
	sbc #0
	bcc elsedoneblock85296
ConditionalTrueBlock32852

	lda js1oldx
	sta screen_x
	lda js1oldy
	sta screen_y
	lda #4
	jsr SetScreenPosition
	; Tile tl,tr,bl,br, tileno, screen_width
	ldx #$0
	lda TL,x
	ldy #0
	sta (screenmemory),y
	lda TR,x
	ldy #1
	sta (screenmemory),y
	lda BL,x
	ldy #$28
	sta (screenmemory),y
	lda BR,x
	ldy #$29
	sta (screenmemory),y

elsedoneblock85296
	; Assigning single variable : js1oldx
	lda tx
	sta js1oldx
	; Assigning single variable : js1oldy
	lda ty
	sta js1oldy
	; Assigning single variable : js1old
	lda js1
	sta js1old
	; Binary clause Simplified: GREATER
	lda tx
	; Compare with pure num / var optimization
	sbc #0
	bcc elsedoneblock31059
ConditionalTrueBlock17556

	lda tx
	sta screen_x
	lda ty
	sta screen_y
	lda #4
	jsr SetScreenPosition
	; Tile tl,tr,bl,br, tileno, screen_width
	ldx ti
	lda TL,x
	ldy #0
	sta (screenmemory),y
	lda TR,x
	ldy #1
	sta (screenmemory),y
	lda BL,x
	ldy #$28
	sta (screenmemory),y
	lda BR,x
	ldy #$29
	sta (screenmemory),y

elsedoneblock31059

elsedoneblock6895
	; Assigning single variable : tx
	; Load Byte array
	ldx js2
	lda j2posx,x
	
	sta tx
	; Assigning single variable : ty
	; Load Byte array
	ldx js2
	lda jsposy,x
	
	sta ty
	; Assigning single variable : ti
	; Load Byte array
	ldx js2
	lda jsdir,x
	
	sta ti
	; Binary clause Simplified: NOTEQUALS
	lda js2old
	; Compare with pure num / var optimization
	cmp js2
	beq elsedoneblock26246
ConditionalTrueBlock69533

	; Binary clause Simplified: GREATER
	lda js2oldx
	; Compare with pure num / var optimization
	sbc #0
	bcc elsedoneblock81013
ConditionalTrueBlock59066

	lda js2oldx
	sta screen_x
	lda js2oldy
	sta screen_y
	lda #4
	jsr SetScreenPosition
	; Tile tl,tr,bl,br, tileno, screen_width
	ldx #$0
	lda TL,x
	ldy #0
	sta (screenmemory),y
	lda TR,x
	ldy #1
	sta (screenmemory),y
	lda BL,x
	ldy #$28
	sta (screenmemory),y
	lda BR,x
	ldy #$29
	sta (screenmemory),y

elsedoneblock81013
	; Assigning single variable : js2oldx
	lda tx
	sta js2oldx
	; Assigning single variable : js2oldy
	lda ty
	sta js2oldy
	; Assigning single variable : js2old
	lda js2
	sta js2old
	; Binary clause Simplified: GREATER
	lda tx
	; Compare with pure num / var optimization
	sbc #0
	bcc elsedoneblock2518
ConditionalTrueBlock61604

	lda tx
	sta screen_x
	lda ty
	sta screen_y
	lda #4
	jsr SetScreenPosition
	; Tile tl,tr,bl,br, tileno, screen_width
	ldx ti
	lda TL,x
	ldy #0
	sta (screenmemory),y
	lda TR,x
	ldy #1
	sta (screenmemory),y
	lda BL,x
	ldy #$28
	sta (screenmemory),y
	lda BR,x
	ldy #$29
	sta (screenmemory),y

elsedoneblock2518

elsedoneblock26246
	; Assigning single variable : b1
	; 8 bit binop
	; Add/sub where right value is constant number
	; Peek
	lda $dc01 + $0
	
	and #16
	 ; end add / sub var with constant
	
	sta b1
	; Assigning single variable : b2
	; 8 bit binop
	; Add/sub where right value is constant number
	; Peek
	lda $dc00 + $0
	
	and #16
	 ; end add / sub var with constant
	
	sta b2
	; Binary clause Simplified: NOTEQUALS
	lda b1old
	; Compare with pure num / var optimization
	cmp b1
	beq elsedoneblock23752
ConditionalTrueBlock10241

	; Binary clause Simplified: NOTEQUALS
	lda b1old
	; Compare with pure num / var optimization
	cmp #16
	beq elsedoneblock38571
ConditionalTrueBlock57989

	lda #11
	sta screen_x
	lda #13
	sta screen_y
	lda #4
	jsr SetScreenPosition
	; Tile tl,tr,bl,br, tileno, screen_width
	ldx #$0
	lda TL,x
	ldy #0
	sta (screenmemory),y
	lda TR,x
	ldy #1
	sta (screenmemory),y
	lda BL,x
	ldy #$28
	sta (screenmemory),y
	lda BR,x
	ldy #$29
	sta (screenmemory),y

elsedoneblock38571
	; Assigning single variable : b1old
	lda b1
	sta b1old
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #16
	beq elsedoneblock85292
ConditionalTrueBlock88594

	lda #11
	sta screen_x
	lda #13
	sta screen_y
	lda #4
	jsr SetScreenPosition
	; Tile tl,tr,bl,br, tileno, screen_width
	ldx #$9
	lda TL,x
	ldy #0
	sta (screenmemory),y
	lda TR,x
	ldy #1
	sta (screenmemory),y
	lda BL,x
	ldy #$28
	sta (screenmemory),y
	lda BR,x
	ldy #$29
	sta (screenmemory),y

elsedoneblock85292

elsedoneblock23752
	; Binary clause Simplified: NOTEQUALS
	lda b2old
	; Compare with pure num / var optimization
	cmp b2
	beq elsedoneblock67180
ConditionalTrueBlock5747

	; Binary clause Simplified: NOTEQUALS
	lda b2old
	; Compare with pure num / var optimization
	cmp #16
	beq elsedoneblock49285
ConditionalTrueBlock94972

	lda #27
	sta screen_x
	lda #13
	sta screen_y
	lda #4
	jsr SetScreenPosition
	; Tile tl,tr,bl,br, tileno, screen_width
	ldx #$0
	lda TL,x
	ldy #0
	sta (screenmemory),y
	lda TR,x
	ldy #1
	sta (screenmemory),y
	lda BL,x
	ldy #$28
	sta (screenmemory),y
	lda BR,x
	ldy #$29
	sta (screenmemory),y

elsedoneblock49285
	; Assigning single variable : b2old
	lda b2
	sta b2old
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #16
	beq elsedoneblock47235
ConditionalTrueBlock54645

	lda #27
	sta screen_x
	lda #13
	sta screen_y
	lda #4
	jsr SetScreenPosition
	; Tile tl,tr,bl,br, tileno, screen_width
	ldx #$9
	lda TL,x
	ldy #0
	sta (screenmemory),y
	lda TR,x
	ldy #1
	sta (screenmemory),y
	lda BL,x
	ldy #$28
	sta (screenmemory),y
	lda BR,x
	ldy #$29
	sta (screenmemory),y

elsedoneblock47235

elsedoneblock67180

	jmp while57709
elsedoneblock50144

EndSymbol
	org $2000
charset
	incbin "/Users/jartza/src/joycart///cusfont.bin"
