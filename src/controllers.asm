;;;;;;;;;;
;;
;; Controller Polling
;;
;;;;;;;;;;

PollController:
  lda controller1
  sta controller1LastFrame
  ldx #$01
  stx CONTROLLER1
  dex
  stx CONTROLLER1
PollControllerLoop:
  ; $4016 Read (Player 1 and 3)
  lda CONTROLLER1
  lsr
  rol controller1
  lsr
  rol controller1D1
PollControllerEnd:
  inx
  cpx #$08
  bne PollControllerLoop
    lda controller1
    ora controller1D1
    sta controller1
    rts


;;;;;;;;;;
;;
;; Controller Checking
;;
;;;;;;;;;;

CheckUp:
  lda controller1
  and #(BUTTON_DOWN)
  bne CheckUpDone
    lda controller1
    and #(BUTTON_UP)
    beq CheckUpDone
      jsr HandleUp
CheckUpDone:
  rts


CheckDown:
  lda controller1
  and #(BUTTON_UP)
  bne CheckDownDone
    lda controller1
    and #(BUTTON_DOWN)
    beq CheckDownDone
      jsr HandleDown
CheckDownDone:
  rts


CheckLeft:
  lda controller1
  and #(BUTTON_RIGHT)
  bne CheckLeftDone
    lda controller1
    and #(BUTTON_LEFT)
    beq CheckLeftDone
      jsr HandleLeft
CheckLeftDone:
  rts


CheckRight:
  lda controller1
  and #(BUTTON_LEFT)
  bne CheckRightDone
    lda controller1
    and #(BUTTON_RIGHT)
    beq CheckRightDone
      jsr HandleRight
CheckRightDone:
  rts


CheckA:
  lda controller1
  and #(BUTTON_A)
  beq CheckADone
    lda controller1LastFrame
    and #(BUTTON_A)
    bne CheckADone
      ;jsr Blank
      jsr FlipCell
      ;jsr EnableNMI
CheckADone:
  rts


CheckStart:
  lda controller1
  and #(BUTTON_START)
  beq CheckStartDone
    lda controller1LastFrame
    and #(BUTTON_START)
    bne CheckStartDone
      lda screen
      bne CheckStartNotTitleScreen
        lda #$01
        sta screen
        lda #$00
        sta running
        jsr Blank
        jsr ClearPPURAM
        jsr SetPalette
        jsr DrawBlankBoard
        jsr DrawGameOfLifeTitle
        jsr DrawJohnConway
        jsr SetCursor
        jsr EnableNMI
        rts
CheckStartNotTitleScreen:
  lda #$01
  sta running
  jsr DisableSpritesNMI
  jsr ReadCurrentState
  jsr DrawCurrentState
  jsr EnableNMI
CheckStartDone:
  rts


CheckStartNMIDisabled:
  ldy #$00
  lda controller1
  and #(BUTTON_START)
  beq CheckStartNMIDisabledDone
    lda controller1LastFrame
    and #(BUTTON_START)
    bne CheckStartNMIDisabledDone
      iny
CheckStartNMIDisabledDone:
  tya
  rts


CheckSelect:
  lda controller1
  and #(BUTTON_SELECT)
  beq CheckSelectDone
    lda controller1LastFrame
    and #(BUTTON_SELECT)
    bne CheckSelectDone
      lda randomSet
      bne RandomIsSet
        jsr Blank
        jsr SetRandomCurrentState
        jsr DrawCurrentState
        jsr EnableNMI
        jmp CheckSelectDone
RandomIsSet:
  jsr Blank
  jsr SetZeroCurrentState
  jsr DrawCurrentState
  jsr EnableNMI
CheckSelectDone:
  rts


HandleUp:
  lda controller1LastFrame
  and #(BUTTON_UP)
  bne HandleUpPressedLastFrame
    ; Up not pressed last frame
    lda #$00
    sta upHold
    jmp DoUp
HandleUpPressedLastFrame:
  inc upHold 
  lda upHold
  asl
  cmp fps
  bne HandleUpDone
    lda upHold
    sec
    sbc fpsDiv10
    sta upHold
DoUp:
  jsr CursorUp
HandleUpDone:
  rts


HandleDown:
  lda controller1LastFrame
  and #(BUTTON_DOWN)
  bne HandleDownPressedLastFrame
    ; Down not pressed last frame
    lda #$00
    sta downHold
    jmp DoDown
HandleDownPressedLastFrame:
  inc downHold 
  lda downHold
  asl
  cmp fps
  bne HandleDownDone
    lda downHold
    sec
    sbc fpsDiv10
    sta downHold
DoDown:
  jsr CursorDown
HandleDownDone:
  rts


HandleLeft:
  lda controller1LastFrame
  and #(BUTTON_LEFT)
  bne HandleLeftPressedLastFrame
    ; Left not pressed last frame
    lda #$00
    sta leftHold
    jmp DoLeft
HandleLeftPressedLastFrame:
  inc leftHold 
  lda leftHold
  asl
  cmp fps
  bne HandleLeftDone
    lda leftHold
    sec
    sbc fpsDiv10
    sta leftHold
DoLeft:
  jsr CursorLeft
HandleLeftDone:
  rts


HandleRight:
  lda controller1LastFrame
  and #(BUTTON_RIGHT)
  bne HandleRightPressedLastFrame
    ; Right not pressed last frame
    lda #$00
    sta rightHold
    jmp DoRight
HandleRightPressedLastFrame:
  inc rightHold 
  lda rightHold
  asl
  cmp fps
  bne HandleRightDone
    lda rightHold
    sec
    sbc fpsDiv10
    sta rightHold
DoRight:
  jsr CursorRight
HandleRightDone:
  rts
