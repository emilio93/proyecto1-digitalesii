curDir="$(pwd)"
echo ${curDir}

mkdir -p ${curDir}/build
mkdir -p ${curDir}/gtkws


cd ${curDir}/bloques
iverilog ${curDir}/paraleloSerial_tb.v -o ${curDir}/build/paraleloSerial_tb
cd ${curDir}
vvp -M ~/.local/install/ivl/lib/ivl ${curDir}/build/paraleloSerial_tb
