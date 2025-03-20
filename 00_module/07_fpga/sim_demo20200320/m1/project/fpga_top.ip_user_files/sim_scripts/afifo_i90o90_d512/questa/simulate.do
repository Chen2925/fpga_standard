onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib afifo_i90o90_d512_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {afifo_i90o90_d512.udo}

run -all

quit -force
