onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib afifo_i72o72_d2048_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {afifo_i72o72_d2048.udo}

run -all

quit -force
