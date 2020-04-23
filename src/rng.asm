;;;;;;;;;;
;;
;; MATH
;;
;;;;;;;;;;

LFSR:
  clc
  ldx #$08
  lda lfsr
LFSRLoop:
  asl
  rol (lfsr + 1)
  rol (lfsr + 2)
  rol (lfsr + 3)
  bcc LFSRNot1Shifted
    eor #$C5
LFSRNot1Shifted:
  dex
  bne LFSRLoop
    sta lfsr
    rts


SetZeroCurrentState:
  ldx #$00
  lda #$00
SetZeroCurrentStateLoop:
  sta currentState, X
  inx
  cpx #200
  bne SetZeroCurrentStateLoop
    lda #$00
    sta randomSet
    rts


SetRandomCurrentState:
  ldx #$00
SetRandomCurrentStateLoop:
  stx cellOffsetByteTmp
  jsr LFSR
  ldx cellOffsetByteTmp
  sta currentState, X
  inx
  cpx #200
  bne SetRandomCurrentStateLoop
    lda #$01
    sta randomSet
    rts
