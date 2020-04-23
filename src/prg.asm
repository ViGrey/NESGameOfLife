RESET:
  sei
  cld
  ldx #$40
  stx APU_FRAME_COUNTER
  ldx #$FF
  txs
  inx
  lda #%00000110
  sta PPU_MASK
  lda #$00
  sta PPU_CTRL
  stx $4010
  ldy #$00


InitialVWait:
  lda PPU_STATUS
  bpl InitialVWait
InitialVWait2:
  inx
  bne InitialVWait2NotIncY
    iny
InitialVWait2NotIncY:
  lda PPU_STATUS
  bpl InitialVWait2
    ldx #$00
    cpy #$09
    bne NotNTSC
      lda #60
      inx
      jmp InitialVWaitDone
NotNTSC:
  lda #50
  cpy #$0A
  bne NotPAL
    jmp InitialVWaitDone
NotPAL:
  ldx #$02
InitialVWaitDone:
  sta fps
  stx region

GetFPSDiv10:
  lda #5
  sta fpsDiv10
  lda fps
  cmp #50
  beq GetFPSDiv10Done
    inc fpsDiv10
GetFPSDiv10Done:


InitializeRAM:
  ldx #$00
InitializeRAMLoop:
  lda #$00
  cpx #fps
  beq InitializeRAMSkipZeroPage
    cpx #fpsDiv10
    beq InitializeRAMSkipZeroPage
      cpx #region
      beq InitializeRAMSkipZeroPage
        sta $0000, x
InitializeRAMSkipZeroPage:
  sta $0100, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  lda #$FE
  sta $0200, x
  inx
  bne InitializeRAMLoop
    jsr ClearPPURAM
    jsr SetPalette
    lda #$00
    sta screen
    jsr DisableCursor
    jsr DrawTitleScreen
    lda #$A6
    ora (lfsr + 1)
    sta (lfsr + 1)
    jsr LFSR
    jsr ResetScroll


Forever:
  jmp Forever


NMI:
  lda #$00
  sta PPU_OAM_ADDR
  lda #$02
  sta OAM_DMA
  lda PPU_STATUS
  jsr Draw
  ;jsr DrawFrame
  jsr ResetScroll
  jsr Update
NMIDone:
  rti


ResetScroll:
  lda #$00
  sta PPU_SCROLL
  sta PPU_SCROLL
  jsr EnableNMI
  rts


Draw:
  lda #%00011110
  sta PPU_MASK
  rts


DisableNMI:
  lda #$00
  sta PPU_CTRL
  rts


EnableNMI:
  lda #%10001000
  sta PPU_CTRL
  rts


Blank:
  lda #%00000110
  sta PPU_MASK
  jsr DisableNMI
  rts

DisableSpritesNMI:
  lda #%00001110
  sta PPU_MASK
  lda #%00001000
  sta PPU_CTRL
  rts

Update:
  jsr LFSR
  lda screen
  beq UpdateTitleScreen
    inc $50
    lda running
    beq UpdateContinue
      jsr DisableSpritesNMI
      jsr ReadCurrentState
      jsr DrawCurrentState
      jsr EnableNMI
      rts
UpdateContinue:
  jsr PollController
  jsr CheckUp
  jsr CheckDown
  jsr CheckLeft
  jsr CheckRight
  jsr CheckA
  jsr CheckStart
  jsr CheckSelect
  rts
UpdateTitleScreen:
  jsr PollController
  jsr CheckStart
  rts


IncPPUAddrLine:
  lda (ppuAddr + 1)
  clc
  adc #$20
  sta (ppuAddr + 1)
  lda ppuAddr
  adc #$00
  sta ppuAddr
  rts


ClearPPURAM:
  lda PPU_STATUS
  lda #$20
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR
  ldy #$04
  ldx #$00
  txa
ClearPPURAMLoop:
  sta PPU_DATA
  dex
  bne ClearPPURAMLoop
    ldx #$00
    dey
    bne ClearPPURAMLoop
      rts


SetPalette:
  lda PPU_STATUS
  lda #$3F
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR
  ldy #$00
SetPaletteLoop:
  lda #$0F
  sta PPU_DATA
  lda #$11
  sta PPU_DATA
  lda #$03
  sta PPU_DATA
  lda #$30
  sta PPU_DATA
  iny
  cpy #$14
  bne SetPaletteLoop
    rts


DrawGameOfLifeTitle:
  lda PPU_STATUS
  lda #$20
  sta PPU_ADDR
  lda #$65
  sta PPU_ADDR
  lda #<(Title)
  sta addr
  lda #>(Title)
  sta (addr + 1)
  ldy #$00
DrawGameOfLifeTitleLoop:
  lda (addr), y
  sta PPU_DATA
  iny
  cpy #21
  bne DrawGameOfLifeTitleLoop
    rts


DrawJohnConway:
  lda PPU_STATUS
  lda #$23
  sta PPU_ADDR
  lda #$45
  sta PPU_ADDR
  lda #<(JohnConway)
  sta addr
  lda #>(JohnConway)
  sta (addr + 1)
  ldy #$00
DrawJohnConwayLoop:
  lda (addr), y
  sta PPU_DATA
  iny
  cpy #22
  bne DrawJohnConwayLoop
    rts

DrawTitleScreen:
  lda PPU_STATUS
  lda #$20
  sta PPU_ADDR
  lda #$60
  sta PPU_ADDR
  lda #<(TitleScreen)
  sta addr
  lda #>(TitleScreen)
  sta (addr + 1)
  ldy #$00
DrawTitleScreenLoop:
  lda addr
  cmp #<(TitleScreenDone)
  bne DrawTitleScreenNotEndOfTitleScreenText
    lda (addr + 1)
    cmp #>(TitleScreenDone)
    bne DrawTitleScreenNotEndOfTitleScreenText
      rts
DrawTitleScreenNotEndOfTitleScreenText:
  lda (addr), Y
  sta PPU_DATA
  lda addr
  clc
  adc #$01
  sta addr
  lda (addr + 1)
  adc #$00
  sta (addr + 1)
  jmp DrawTitleScreenLoop
    rts


Title:
  .byte "Conway's Game of Life"

JohnConway:
  .byte "John Conway  1937-2020"



TitleScreen:
  .byte "     Conway's Game of Life      "
  .byte "                                "
  .byte "  Controls                      "
  .byte "                                "
  .byte "  * Up/Down/Left/Right:  Move   "
  .byte "    Cursor                      "
  .byte "  * A:  Flip Selected Cell      "
  .byte "  * Select:  Randomize/Clear    "
  .byte "    Game Grid                   "
  .byte "  * Start:  Run/Pause Game      "
  .byte "  * RESET:  Go Back to This     "
  .byte "    Screen                      "
  .byte "                                "
  .byte "                                "
  .byte "                                "
  .byte "   PRESS START to Start Game    "
  .byte "                                "
  .byte "                                "
  .byte "                                "
  .byte "   NES ROM Programmed in 2020   "
  .byte "    by Vi Grey  @ViGreyTech     "

TitleScreenDone:


.include "controllers.asm"
.include "cursor.asm"
.include "cells.asm"
.include "rng.asm"
.include "game.asm"
