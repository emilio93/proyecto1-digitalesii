//Archivo que contiene la mitad de la interfaz PCIE que se encarga de
//recibir la señal del emisor.
//Se instancian todos los bloques necesarios:
//
//clks
//serialParalelo
//decoder
//k285Detector
//fromTo8Bit

//
`timescale 1ns/1ps
`define isRecibidor 1

`ifndef isTest
  `include "../../bloques/clks/clksReceptor.v"
  `include "../../bloques/to8bit-from8bit/from8bit.v"
  `include "../../bloques/encoder-decoder/decoder.v"
  `include "../../bloques/paraleloSerial-serialParalelo/serialParalelo.v"
  `include "../../bloques/k28.5/k285Detector.v"
  `include "../../bloques/sincronizador/sincronizador.v"
  `include "../../bloques/diferencial/diferencialReceptor.v"
`endif


module recibidor(
  output k_out,
  output error_probable,
  output esk285,
  output [7:0] dataOut8,
  output [15:0] dataOut16,
  output [31:0] dataOut32,
  input clkRx,
  input clkRstRx,
  input clkEnbRx,
  input enb,
  input rst,
  input serialIn,
  input [1:0] dataS
);

//Declaración de puertos:
//salidas
  wire k_out;
  wire error_probable;
  wire esk285;
  wire [7:0] dataOut8;
  wire [15:0] dataOut16;
  wire [31:0] dataOut32;
//entradas
  wire clkRx;
  wire clk10;
  wire clk20;
  wire clk40;
  wire enb;
  wire rst;
  wire serialIn;
  wire [1:0] dataS;

//cableado interno:
  wire invalido, dif_out, sinc_out;
  wire [9:0] parallel_Out;
  wire [7:0] decoder_Out;
  wire lectura_enb2;
//Instancias:

clksReceptor relojReceptor(
  .clk(clkRx),
  .rst(clkRstRx),
  .enb(clkEnbRx),
  .clk10(clk10),
  .clk20(clk20),
  .clk40(clk40)
);

from8bit expansorDe8bits(
  .rst(rst),
  .enb(lectura_enb2),
  .clk(clkRx),
  .clk8(clk10),
  .clk16(clk20),
  .clk32(clk40),
  .dataIn(decoder_Out),
  .dataOut(dataOut8),
  .dataOut16(dataOut16),
  .dataOut32(dataOut32),
  .dataS(dataS)
);


decoder decodificador(
  .data10_in(parallel_Out),
  .data8_out(decoder_Out),
  .invalid_value(error_probable),
  .k_out(k_out),
  .clk(clkRx),
  .rst(rst),
  .enb(lectura_enb2)
);

serialParalelo serialAParalelo(
  .clk(clkRx),
  .rst(rst),
  .enb(lectura_enb2),
  .clk10(clk10),
  .entrada(sinc_out),
  .salidas(parallel_Out)
);

k285Detector kDetector(
  .clk(clkRx),
  .rst(rst),
  .enb(enb),
  .entrada(sinc_out),// bit de entrada serial
  .esk285(esk285), // indica que se tiene k28.5
  .lectura(lectura_enb2)// indica estado de lectura
);


sincronizador sincroniza(
  .dataSync(sinc_out),  //salida sincronizada con el reloj del receptor
  .dataAsync(dif_out), //entrada asincronica desde el transmisor
  .clkRx(clkRx),     //reloj del receptor
  .enb(enb),
  .rst(rst)      //señal de reset
);

diferencialReceptor diferencialRec(
//  rst,
//  enb,
  .entrada(serialIn), // D+
  .salida(dif_out)  //bit de salida serial
  //TxElecIdle //se pone en 1 si detecta un voltaje de 0 en la entrada, en este modulo, z
);

endmodule
