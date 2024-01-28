.var startupScreenChars = LoadBinary("export\\jumpman2 - Chars.bin")
.var charsetcolours = LoadBinary("export\\jumpman2 - CharAttribs.bin")
.var startupscreen = LoadBinary("screens\\startupscreen - Map (45x20).bin")

.const BORDERCOLOUR = $d020
.const BACKGROUNDCOLOUR = $d021
.const SCREEN = $0400
.const VICIICONTROLREG = $d018
.const COLORRAM=$D800

BasicUpstart2(Entry)

Entry:
	jsr Init
	jsr DisplayStartUpScreen
forever:
	jmp forever

Init:
	jsr ChangeScreenColour
	jsr ClearScreen
	lda VICIICONTROLREG
	and #240
	ora #12
	sta VICIICONTROLREG
	rts
	
DisplayStartUpScreen:
	lda #<theStartUpScreen //set our source memory address to copy from, $8060
	sta $FB
	lda #>theStartUpScreen //set our source memory address to copy from, $8060
	sta $FC
    lda #<$0400 //set our destination memory to copy to, $6300
    sta $FD
    lda #>$0400 //set our destination memory to copy to, $6300
    sta $FE	
	jmp CopyMemory
	rts

CopyMemory:
     ldy #$00 //reset x and y for our loop
     ldx #$00

 cpmloop:
     lda ($FB),y //indirect index source memory address, starting at $00
     sta ($FD),y //indirect index dest memory address, starting at $00
     inc $FB //increment low order source memory address byte by 1
     inc $FD //increment low order dest memory address byte by 1
     iny
     bne cpmloop //loop until our dest goes over 255

     inc $FC //increment high order source memory address, starting at $80
     inc $FE //increment high order dest memory address, starting at $63
     lda $FE //load high order mem address into a
     cmp #>theStartUpScreen+1000 //compare with the last address we want to write
     bne cpmloop //if we're not there yet, loop
     rts

ClearScreen:
		lda #$20
		ldx #$00
loop:   sta $0400,x
		sta $0500,x
		sta $0600,x
		sta $0700,x
		dex
		bne loop
		rts

ChangeScreenColour:
	// black out the screen
	lda #$00
	sta BORDERCOLOUR
	sta BACKGROUNDCOLOUR
	rts

theStartUpScreen: .fill startupscreen.getSize(), startupscreen.get(i)
*=$3000 "Screen chars" 
chars: .fill startupScreenChars.getSize(), startupScreenChars.get(i)
*=$D800; .fill charsetcolours.getSize(), charsetcolours.get(i)