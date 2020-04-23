DrawBlankBoard:
  lda #$20
  sta ppuAddr
  lda #$A6
  sta (ppuAddr + 1)
  ldx #20
  ldy #20
DrawBlankBoardLoopPPUADDR:
  lda PPU_STATUS
  lda ppuAddr
  sta PPU_ADDR
  lda (ppuAddr + 1)
  sta PPU_ADDR
  lda #$10
DrawBlankBoardLoop:
  sta PPU_DATA
  dey
  bne DrawBlankBoardLoop
    ldy #20
    jsr IncPPUAddrLine
    dex
    bne DrawBlankBoardLoopPPUADDR
      rts


DrawCurrentState:
  jsr Blank
  lda #$20
  sta ppuAddr
  lda #$A6
  sta (ppuAddr + 1)
  lda #$00
  sta cursorXTmp
  sta cursorYTmp
  tax
DrawCurrentStateLoopPPUADDR:
  lda PPU_STATUS
  lda ppuAddr
  sta PPU_ADDR
  lda (ppuAddr + 1)
  sta PPU_ADDR
  ldy #$00
DrawCurrentStateLoop:
DrawCurrentStateBlock1:
  lda #$01
  sta cellTileValue
  lda currentState, X
  rol
  rol cellTileValue
  rol
  rol cellTileValue
  inx
  inx
  inx
  inx
  inx
  lda currentState, X
  rol
  rol cellTileValue
  rol
  rol cellTileValue
  lda cellTileValue
  sta PPU_DATA
  dex
  dex
  dex
  dex
  dex
DrawCurrentStateBlock2:
  lda #$01
  sta cellTileValue
  lda currentState, X
  rol
  rol
  rol
  rol cellTileValue
  rol
  rol cellTileValue
  inx
  inx
  inx
  inx
  inx
  lda currentState, X
  rol
  rol
  rol
  rol cellTileValue
  rol
  rol cellTileValue
  lda cellTileValue
  sta PPU_DATA
  dex
  dex
  dex
  dex
  dex
DrawCurrentStateBlock3:
  lda #$01
  sta cellTileValue
  lda currentState, X
  rol
  rol
  rol
  rol
  rol
  rol cellTileValue
  rol
  rol cellTileValue
  inx
  inx
  inx
  inx
  inx
  lda currentState, X
  rol
  rol
  rol
  rol
  rol
  rol cellTileValue
  rol
  rol cellTileValue
  lda cellTileValue
  sta PPU_DATA
  dex
  dex
  dex
  dex
  dex
DrawCurrentStateBlock4:
  lda #$01
  sta cellTileValue
  lda currentState, X
  rol
  rol
  rol
  rol
  rol
  rol
  rol
  rol cellTileValue
  rol
  rol cellTileValue
  inx
  inx
  inx
  inx
  inx
  lda currentState, X
  rol
  rol
  rol
  rol
  rol
  rol
  rol
  rol cellTileValue
  rol
  rol cellTileValue
  dex
  dex
  dex
  dex
  dex
  lda cellTileValue
  sta PPU_DATA
  inx
  iny
  cpy #$05
  bne DrawCurrentStateLine
    txa
    clc
    adc #$05
    tax
    cpx #200
    beq DrawCurrentStateDone
      ldy #$00
      ; Byte number in row is not 5
      lda (ppuAddr + 1)
      clc
      adc #$20
      sta (ppuAddr + 1)
      lda ppuAddr
      adc #$00
      sta ppuAddr
      jmp DrawCurrentStateLoopPPUADDR
DrawCurrentStateLine:
  jmp DrawCurrentStateLoop
DrawCurrentStateDone:
  rts




