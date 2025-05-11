#!/bin/bash
set -e
ghdl -a instruction_memory.vhdl program_counter.vhdl instruction_fetch.vhdl
ghdl -e InstructionFetchTB
ghdl -r InstructionFetchTB --vcd=wave --stop-time=1000ns
gtkwave wave