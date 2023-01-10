onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib fir250_45_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {fir250_45.udo}

run -all

quit -force
