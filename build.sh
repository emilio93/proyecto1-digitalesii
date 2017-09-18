mkdir -p build
mkdir -p gtkws
cd bloques
iverilog paraleloSerial_tb.v -o ../build/paraleloSerial_tb
cd ..
vvp -M ~/.local/install/ivl/lib/ivl build/paraleloSerial_tb
