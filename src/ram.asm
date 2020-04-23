.enum $0000
  cellTileValue                 dsb 1
  cellOffsetByte                dsb 1
  cellOffsetBit                 dsb 1
  running                       dsb 1
  randomSet                     dsb 1

  cellOffsetBitLittleEndian     dsb 1


  cellOffsetBitLittleEndianNOT  dsb 1
  cellOffsetBitXOR              dsb 1
  cellPPUPosition               dsb 1

  cellNeighbors                 dsb 1
  cellOffsetByteTmp             dsb 1
  cellOffsetBitTmp              dsb 1

  currentCellOffsetByte         dsb 1
  currentCellOffsetBit          dsb 1
  currentCellBuffer             dsb 3
  currentCellValue              dsb 1

  screen                        dsb 1
  lfsr                          dsb 4
  fps                           dsb 1
  fpsDiv10                      dsb 1
  region                        dsb 1
  addr                          dsb 2
  addrTmp                       dsb 2
.ende

.enum $0300
CurrentState:
  currentState            dsb 200
.ende

.enum $0400
NextState:
  nextState               dsb 200
.ende

.enum $0500
  drawBufferOffset        dsb 1
  drawBuffer              dsb 200
  draw                    dsb 1
  resumeDrawAddr          dsb 2
  ppuAddr                 dsb 2
  ppuAddrTmp              dsb 2
.ende

.enum $0600
  ; Controller Data
  controller1           dsb 1
  controller1D1         dsb 1
  controller1LastFrame  dsb 1

  cursorX               dsb 1
  cursorY               dsb 1

  cursorXTmp            dsb 1
  cursorYTmp            dsb 1



  upHold                dsb 1
  downHold              dsb 1
  leftHold              dsb 1
  rightHold             dsb 1
.ende
