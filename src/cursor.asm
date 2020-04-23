;;;;;;;;;;
;;
;; Cursor Management
;;
;;;;;;;;;;

CursorUp:
  lda cursorY
  beq CursorUpDone
    ldx #$00
    ldy #$04
CursorUpLoop:
  lda $200, X
  sec
  sbc #$04
  sta $200, X
  inx
  inx
  inx
  inx
  dey
  bne CursorUpLoop
    dec cursorY
CursorUpDone:
  rts


CursorDown:
  lda cursorY
  cmp #39
  beq CursorDownDone
    ldx #$00
    ldy #$04
CursorDownLoop:
  lda $200, X
  clc
  adc #$04
  sta $200, X
  inx
  inx
  inx
  inx
  dey
  bne CursorDownLoop
    inc cursorY
CursorDownDone:
  rts


CursorLeft:
  lda cursorX
  beq CursorLeftDone
    ldx #$00
    ldy #$04
CursorLeftLoop:
  lda $203, X
  sec
  sbc #$04
  sta $203, X
  inx
  inx
  inx
  inx
  dey
  bne CursorLeftLoop
    dec cursorX
CursorLeftDone:
  rts


CursorRight:
  lda cursorX
  cmp #39
  beq CursorRightDone
    ldx #$00
    ldy #$04
CursorRightLoop:
  lda $203, X
  clc
  adc #$04
  sta $203, X
  inx
  inx
  inx
  inx
  dey
  bne CursorRightLoop
    inc cursorX
CursorRightDone:
  rts


DisableCursor:
  lda #$FE
  sta $200
  sta $201
  sta $202
  sta $203
  sta $204
  sta $205
  sta $206
  sta $207
  sta $208
  sta $209
  sta $20A
  sta $20B
  sta $20C
  sta $20D
  sta $20E
  sta $20F
  rts


SetCursor:
  lda #$71
  sta $200
  lda #$01
  sta $201
  lda #$00
  sta $202
  lda #$7A
  sta $203
  lda #$71
  sta $204
  lda #$02
  sta $205
  lda #$00
  sta $206
  lda #$82
  sta $207
  lda #$79
  sta $208
  lda #$11
  sta $209
  lda #$00
  sta $20A
  lda #$7A
  sta $20B
  lda #$79
  sta $20C
  lda #$12
  sta $20D
  lda #$00
  sta $20E
  lda #$82
  sta $20F
  lda #20
  sta cursorX
  sta cursorY
  rts


;;;;;;;;;;
;;
;; Cell Management
;;
;;;;;;;;;;

FlipCell:
  ; TODO - Implement
  jsr GetCursorCellByteOffset
  ldx cellOffsetByte
  lda cellOffsetBitLittleEndian
  eor currentState, X
  sta currentState, X
  lda cellOffsetBitLittleEndian
  sta cellOffsetBitXOR
  lda cursorX
  sta cursorXTmp
  lda cursorY
  sta cursorYTmp
  jsr GetPPUTile
  rts


;;;;;;;;;;
;
; Set cursor offset
GetCursorTmpCellByteOffset:
  lda cursorXTmp
  and #%00000111
  sta cellOffsetBit
  tax
  inx
  lda #$00
  sec
GetCursorTmpCellOffsetBitLittleEndianLoop:
  ror
  dex
  bne GetCursorTmpCellOffsetBitLittleEndianLoop
    sta cellOffsetBitLittleEndian
    lda cursorXTmp
    ; Divide cursorXTmp by 8
    lsr
    lsr
    lsr
    ldx cursorYTmp
GetCursorYTmpCellByteOffsetLoop:
  cpx #$00
  beq GetCursorYTmpCellByteOffsetLoopDone
    clc
    adc #$05
    dex
    jmp GetCursorYTmpCellByteOffsetLoop
GetCursorYTmpCellByteOffsetLoopDone:
  tax
  stx cellOffsetByte
  rts


; Set cursor offset
GetCursorCellByteOffset:
  lda cursorX
  and #%00000111
  sta cellOffsetBit
  tax
  inx
  lda #$00
  sec
GetCursorCellOffsetBitLittleEndianLoop:
  ror
  dex
  bne GetCursorCellOffsetBitLittleEndianLoop
    sta cellOffsetBitLittleEndian
    lda cursorX
    ; Divide cursor X by 8
    lsr
    lsr
    lsr
    ldx cursorY
GetCursorYCellByteOffsetLoop:
  cpx #$00
  beq GetCursorYCellByteOffsetLoopDone
    clc
    adc #$05
    dex
    jmp GetCursorYCellByteOffsetLoop
GetCursorYCellByteOffsetLoopDone:
  tax
  stx cellOffsetByte
  rts



GetPPUTile:
  lda #$01
  sta cellTileValue
  ldx cellOffsetByte
  lda cursorYTmp
  and #%00000001
  beq GetPPUTileCursorYEven
    ; cursorYTmp is odd
    ; Go back 1 row
    dex
    dex
    dex
    dex
    dex
GetPPUTileCursorYEven:
  ; cursorYTmp is even
  lda cursorXTmp
  and #$01
  beq GetPPUTileCursorXEven
    ; cursorXTmp is odd
    ; Set cellOffsetBitLittleEndian left 1 % 8 bits
    asl cellOffsetBitLittleEndian
GetPPUTileCursorXEven:
  ; cursorXTmp is even
  ; Start tile identification
  lda currentState, X
  clc
  and cellOffsetBitLittleEndian
  beq GetPPUTileCellTLIsZero
    ; Top Left cell is on
    sec
GetPPUTileCellTLIsZero:
  ; Top Left cell is off
  ; Top Left Tile of 2x2 grid section is 0
  rol cellTileValue
  lsr cellOffsetBitLittleEndian
  lda currentState, X
  clc
  and cellOffsetBitLittleEndian
  beq GetPPUTileCellTRIsZero
    ; Top Right cell is on
    sec
GetPPUTileCellTRIsZero:
  ; Top Right cell is off
  ; Bottom Row of 2x2 grid section
  rol cellTileValue
  asl cellOffsetBitLittleEndian
  inx
  inx
  inx
  inx
  inx
  lda currentState, X
  clc
  and cellOffsetBitLittleEndian
  beq GetPPUTileCellBLIsZero
    ; Bottom Left cell is on
    sec
GetPPUTileCellBLIsZero:
  ; Bottom Left cell is off
  rol cellTileValue
  lsr cellOffsetBitLittleEndian
  lda currentState, X
  clc
  and cellOffsetBitLittleEndian
  beq GetPPUTileCellBRIsZero
    sec
GetPPUTileCellBRIsZero:
  rol cellTileValue
  jsr GetPPUTileLocation
  lda PPU_STATUS
  lda ppuAddr
  sta PPU_ADDR
  lda (ppuAddr + 1)
  sta PPU_ADDR
  lda cellTileValue
  sta PPU_DATA
  jsr ResetScroll
  rts
GetPPUTileLocation:
  lda #$20
  sta ppuAddr
  lda #$A6
  sta (ppuAddr + 1)
  lda cursorXTmp
  lsr
  clc
  adc (ppuAddr + 1)
  sta (ppuAddr + 1)
  lda #$00
  adc ppuAddr
  sta ppuAddr
  lda cursorYTmp
  and #%11111110
  lsr
  lsr
  lsr
  lsr
  clc
  adc ppuAddr
  sta ppuAddr
  lda cursorYTmp
  and #%11111110
  asl
  asl
  asl
  asl
  clc
  adc (ppuAddr + 1)
  sta (ppuAddr + 1)
  lda #$00
  adc ppuAddr
  sta ppuAddr
GetPPUTileLocationDone:
  rts
