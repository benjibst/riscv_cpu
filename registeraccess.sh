#!/bin/bash
set -e
ghdl -a multiplexer.vhdl register_file.vhdl register_access.vhdl
ghdl -e RegisterAccessTB
ghdl -r RegisterAccessTB --vcd=wave --stop-time=1000ns
gtkwave wave