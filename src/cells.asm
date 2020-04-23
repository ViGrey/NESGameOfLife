ReadCurrentState:
  lda #$00
  sta cursorXTmp
  sta cursorYTmp
ReadCurrentStateLoop:
  jsr GetCursorTmpCellByteOffset
  jsr GetNeighborCount
  lda cellNeighbors
  cmp #$03
  beq ReadCurrentStateNextStateAlive
    ; Neighbors not 3
    cmp #$02
    bne ReadCurrentStateNextStateDead
      ; Neighbors are 2
      ldx cellOffsetByte
      lda currentState, X
      and cellOffsetBitLittleEndian
      beq ReadCurrentStateNextStateDead
        ; State was alive
        jmp ReadCurrentStateNextStateAlive
ReadCurrentStateNextStateDead:
  lda #$FF
  eor cellOffsetBitLittleEndian
  sta cellOffsetBitLittleEndianNOT
  ldx cellOffsetByte
  lda nextState, X
  and cellOffsetBitLittleEndianNOT
  sta nextState, X
  jmp ReadCurrentStateIncCursorTmp
ReadCurrentStateNextStateAlive:
  lda #$FF
  eor cellOffsetBitLittleEndian
  sta cellOffsetBitLittleEndianNOT
  ldx cellOffsetByte
  lda nextState, X
  and cellOffsetBitLittleEndianNOT
  clc
  adc cellOffsetBitLittleEndian
  sta nextState, X
ReadCurrentStateIncCursorTmp:
  inc cursorXTmp
  lda cursorXTmp
  cmp #40
  bcc ReadCurrentStateIncCursorXTmpContinue:
    jsr PollController
    jsr CheckStartNMIDisabled
    cmp #$01
    beq ReadCurrentStateStartPress
      lda #$00
      sta cursorXTmp
      inc cursorYTmp
      lda cursorYTmp
      cmp #40
      bcs ReadCurrentStateDone
        jmp ReadCurrentStateLoop
ReadCurrentStateStartPress:
  lda #$00
  sta running
  rts
ReadCurrentStateIncCursorXTmpContinue:
  jmp ReadCurrentStateLoop
ReadCurrentStateDone:
  jsr NextStateToCurrentState
  rts



NextStateToCurrentState:
  ldx #$00
NextStateToCurrentStateLoop
  lda nextState, X
  sta currentState, X
  inx
  cpx #200
  bne NextStateToCurrentStateLoop
    rts


GetNeighborCount:
  lda #$00
  sta cellNeighbors
GetNeighborCountTopRow:
  lda cellOffsetByte
  sec
  sbc #$05
  sta cellOffsetByte
  tax
  dex
  lda currentState, X
  sta currentCellBuffer
  inx
  lda currentState, X
  sta (currentCellBuffer + 1)
  inx
  lda currentState, X
  sta (currentCellBuffer + 2)
  ldx #$07
GetNeighborCountTopRowLoop:
  asl (currentCellBuffer + 2)
  rol (currentCellBuffer + 1)
  rol currentCellBuffer
  dex
  bne GetNeighborCountTopRowLoop
    ldx cellOffsetBit
GetNeighborCountTopRowOffsetBitLoop:
  cpx #$00
  beq GetNeighborCountTopRowContinue
    asl (currentCellBuffer + 2)
    rol (currentCellBuffer + 1)
    rol currentCellBuffer
    dex
    jmp GetNeighborCountTopRowOffsetBitLoop
GetNeighborCountTopRowContinue:
  lda currentCellBuffer
  and #%11100000
  ora cellNeighbors
  sta cellNeighbors
GetNeighborCountMiddleRow:
  lda cellOffsetByte
  clc
  adc #$05
  sta cellOffsetByte
  ldx cellOffsetByte
  dex
  lda currentState, X
  sta currentCellBuffer
  inx
  lda currentState, X
  sta (currentCellBuffer + 1)
  inx
  lda currentState, X
  sta (currentCellBuffer + 2)
  ldx #$07
GetNeighborCountMiddleRowLoop:
  asl (currentCellBuffer + 2)
  rol (currentCellBuffer + 1)
  rol currentCellBuffer
  dex
  bne GetNeighborCountMiddleRowLoop
    ldx cellOffsetBit
GetNeighborCountMiddleRowOffsetBitLoop:
  cpx #$00
  beq GetNeighborCountMiddleRowContinue
    asl (currentCellBuffer + 2)
    rol (currentCellBuffer + 1)
    rol currentCellBuffer
    dex
    jmp GetNeighborCountMiddleRowOffsetBitLoop
GetNeighborCountMiddleRowContinue:
  lda currentCellBuffer
  and #%10000000
  lsr
  lsr
  lsr
  ora cellNeighbors
  sta cellNeighbors
  lda currentCellBuffer
  and #%00100000
  lsr
  lsr
  ora cellNeighbors
  sta cellNeighbors
GetNeighborCountBottomRow:
  lda cellOffsetByte
  clc
  adc #$05
  sta cellOffsetByte
  tax
  dex
  lda currentState, X
  sta currentCellBuffer
  inx
  lda currentState, X
  sta (currentCellBuffer + 1)
  inx
  lda currentState, X
  sta (currentCellBuffer + 2)
  ldx #$07
GetNeighborCountBottomRowLoop:
  asl (currentCellBuffer + 2)
  rol (currentCellBuffer + 1)
  rol currentCellBuffer
  dex
  bne GetNeighborCountBottomRowLoop
    ldx cellOffsetBit
GetNeighborCountBottomOffsetBitLoop:
  cpx #$00
  beq GetNeighborCountBottomRowContinue
    asl (currentCellBuffer + 2)
    rol (currentCellBuffer + 1)
    rol currentCellBuffer
    dex
    jmp GetNeighborCountBottomOffsetBitLoop
GetNeighborCountBottomRowContinue:
  lda currentCellBuffer
  and #%11100000
  lsr
  lsr
  lsr
  lsr
  lsr
  ora cellNeighbors
  sta cellNeighbors
GetNeighborCountCheckBorder:
  lda cursorXTmp
  bne GetNeighborCountCheckBorderNotX0
    lda cellNeighbors
    and #%01101011
    sta cellNeighbors
GetNeighborCountCheckBorderNotX0:
  lda cursorXTmp
  cmp #39
  bne GetNeighborCountCheckBorderNotX39
    lda cellNeighbors
    and #%11010110
    sta cellNeighbors
GetNeighborCountCheckBorderNotX39:
  lda cursorYTmp
  bne GetNeighborCountCheckBorderNotY0
    lda cellNeighbors
    and #%00011111
    sta cellNeighbors
GetNeighborCountCheckBorderNotY0:
  lda cursorYTmp
  cmp #39
  bne GetNeighborCountCheckBorderNotY39
    lda cellNeighbors
    and #%11111000
    sta cellNeighbors
GetNeighborCountCheckBorderNotY39:
  lda cellNeighbors
  ldy #$08
  ldx #$00
GetNeighborCountBitsToCellNeighborsLoop:
  rol cellNeighbors
  bcc GetNeighborCountBitsToCellNeighborsLoopContinue
    inx
GetNeighborCountBitsToCellNeighborsLoopContinue:
  dey
  bne GetNeighborCountBitsToCellNeighborsLoop
    stx cellNeighbors
GetNeighborCountDone:
  lda cellOffsetByte
  sec
  sbc #$05
  sta cellOffsetByte
  rts
