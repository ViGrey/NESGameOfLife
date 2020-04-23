# NES Conway's Game of Life

An NES implementation of Conway's Game of Life, albeit a slow implementation.

**_NES Conway's Game of Life was created by Vi Grey (https://vigrey.com) <vi@vigrey.com> and is licensed under the BSD 2-Clause License._**

### Description:

This is an 40x40 grid implementation of Conway's Game of Life - https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life - written from scratch in 6502 Assembly to run on the Nintendo Entertainment System (NES).

Because of the 40x40 grid size in this implementation along with likely nonoptimal code, it takes about 1.25 to 1.5 seconds to calculate the next board state.  I would like to apologize for how slow this program is and may look into improving the computation speed in the future.

### "MAKE" Platforms:
- Linux

### Build Dependencies:
- asm6 _(You'll probably have to build asm6 from source.  Make sure the asm6 binary is named **asm** and that the binary is executable and accessible in your PATH. The source code can be found at http://3dscapture.com/NES/asm6.zip or in **resources/asm6.zip** included in this repository)_

### Build NES ROM File:

From a terminal, go to the the main directory of this project (the directory this README.md file exists in), you can then build the file with the following command.

    $ make

The resulting file will be located in at **bin/NESGameOfLife.nes**.

### Cleaning Build Environment:

If you used `make` to build the NES ROM, you can run the following command to clean up the build environment.

    $ make clean

### Playing NES ROM File:

This NES ROM file can be played on an NES emulator or be put on a cartridge like an Everdrive or burned onto an NES-NROM-256 cartridge.

### Burning NES ROM to a Cartridge:

For anyone interested in burning this NES ROM to a cartridge, this NES ROM is built for the NES-NROM-256 cartridge board.

### Special Thanks

In Memory of John Horton Conway (1937-2020)

Sorry my tribute to you is so cliche.  Rest in peace.

### License:
    Copyright (C) 2020, Vi Grey
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:

        1. Redistributions of source code must retain the above copyright
           notice, this list of conditions and the following disclaimer.
        2. Redistributions in binary form must reproduce the above copyright
           notice, this list of conditions and the following disclaimer in the
           documentation and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS \`\`AS IS'' AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED. IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
    OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
    SUCH DAMAGE.
