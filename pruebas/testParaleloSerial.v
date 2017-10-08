`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clks/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/paraleloSerial-serialParalelo/paraleloSerial.v"
`include "../build/paraleloSerial-sintetizado.v"

module testParaleloSerial ();

reg clk;
reg enb;
reg rst;

reg [9:0] entradas;

wire clk10;
wire clk20;
wire clk40;
wire salida;

wire clk10Synth;
wire clk20Synth;
wire clk40Synth;
wire salidaSynth;

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
  .clk10(clk10), .entradas(entradas),
  .salida(salida)
);
paraleloSerialSynth emisorSynth(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10Synth), .entradas(entradas),
  .salida(salidaSynth)
);

always # 5 clk = ~clk;//inicio de la señal de reloj, cambia cada 10ns

reg error;
always @ ( * ) begin
  error = salida-salidaSynth;
end

initial begin
  $dumpfile("gtkws/testParaleloSerial.vcd");
  $dumpvars;
end

initial begin
  clk <= 0;
  enb <= 1;
  entradas <= 10'h3ff;
  rst <= 1'b1;

  # 100
  @ (posedge clk);
  entradas <= 10'h000;

  # 100
  @ (posedge clk);
  entradas <= 10'h3fe;

  # 100
  @ (posedge clk);
  entradas <= 10'h001;

  # 100
  @ (posedge clk);
  entradas <= 10'h200;

  # 100
  @ (posedge clk);
  rst <= 1'b0;

  @ (posedge clk10); entradas <= 10'h36c;
  @ (posedge clk10); entradas <= 10'h3e0;
  @ (posedge clk10); entradas <= 10'h01f;
  @ (posedge clk10); entradas <= 10'h36d;
  @ (posedge clk10); entradas <= 10'h3e0;
  @ (posedge clk10); entradas <= 10'h1d5;

  # 200
  $finish;
end
endmodule
