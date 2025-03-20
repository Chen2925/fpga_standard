onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+afifo_i72o72_d2048 -L xpm -L fifo_generator_v13_2_5 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.afifo_i72o72_d2048 xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {afifo_i72o72_d2048.udo}

run -all

endsim

quit -force
