onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib sram_i64o64_d256_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {sram_i64o64_d256.udo}

run -all

quit -force
