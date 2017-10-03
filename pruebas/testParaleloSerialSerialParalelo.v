`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clks/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/paraleloSerial-serialParalelo/paraleloSerial.v"
`include "../build/paraleloSerial-sintetizado.v"

`include "../bloques/paraleloSerial-serialParalelo/serialParalelo.v"
`include "../build/serialParalelo-sintetizado.v"

module testParaleloSerialSerialParalelo ();

reg clk;
reg rst;
reg enb;

reg [9:0] entradasPS;
wire salidaPS;

wire [9:0] salidasSP;

wire salidaPSSynth;
wire [9:0] salidasSPSynth;

wire clk10;
wire clk10Synth;
wire clk20;
wire clk20Synth;
wire clk40;
wire clk40Synth;

clks clkGen(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10), .clk20(clk20), .clk40(clk40)
);

clksSynth clkGenSynth(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10Synth), .clk20(clk20Synth), .clk40(clk40Synth)
);

paraleloSerial emisor(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10),
  .entradas(entradasPS),
  .salida(salidaPS)
);
paraleloSerialSynth emisorSynth(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10),
  .entradas(entradasPS),
  .salida(salidaPSSynth)
);

serialParalelo receptor(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10),
  .entrada(salidaPS),
  .salidas(salidasSP)
);

serialParaleloSynth receptorSynth(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10Synth),
  .entrada(salidaPSSynth),
  .salidas(salidasSPSynth)
);

always # 5 clk = ~clk;//inicio de la señal de reloj, cambia cada 10ns

initial begin
  enb <= 1;
  clk <= 0;
  rst <= 1'b1;
  entradasPS <= 10'b1010010101;

  @ (posedge clk);
  entradasPS <= 10'b0000000001;

  @ (posedge clk);
  entradasPS <= 10'b1111111110;

  @ (posedge clk);
  entradasPS <= 10'b0111111111;

  @ (posedge clk);
  entradasPS <= 10'b0000011111;

  @ (posedge clk);
  rst <= 1'b0;
  @ (posedge clk10);
  entradasPS <= 10'b1000011111;

  @ (posedge clk10);
  entradasPS <= 10'b0111111110;

  @ (posedge clk10);
  entradasPS <= 10'b1111100000;

  @ (posedge clk10);
  entradasPS <= 10'b0000011111;

  @ (posedge clk10);
  entradasPS <= 10'b1100101100;

  @ (posedge clk10);
  entradasPS <= 10'b1111100000;

  @ (posedge clk10);
  entradasPS <= 10'b0000011111;

  # 600
  $finish;

end

initial begin
  $dumpfile("gtkws/testParaleloSerialSerialParalelo.vcd");
  $dumpvars;
end


endmodule
