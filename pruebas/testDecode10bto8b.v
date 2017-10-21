`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clks/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/encoder-decoder/decoder.v"
`include "../build/decoder-sintetizado.v"

module testDecode10bto8b ();

reg clk;
reg enb;
reg rst;

reg [9:0] entradas;

wire clk10;
wire clk20;
wire clk40;
wire [7:0] salida;
wire k;
wire kSynth;
wire invalid_value;
wire invalid_valueSynth;

wire clk10Synth;
wire clk20Synth;
wire clk40Synth;
wire [7:0] salidaSynth;

clks clkGen(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10), .clk20(clk20), .clk40(clk40)
);

clksSynth clkGenSynth(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10Synth), .clk20(clk20Synth), .clk40(clk40Synth)
);
/*
decoder10to8(
	output reg [7:0] data8_out,
	output reg k_out,
	input wire clk,
	input wire [9:0] data10_in
);
*/

decoder emisor(
  .clk(clk),
  .data10_in(entradas),
  .data8_out(salida),
  .invalid_value(invalid_value),
  .rst(rst),
  .enb(enb),
  .k_out(k)
);
decoderSynth emisorSynth(
  .clk(clk),
  .data10_in(entradas),
  .data8_out(salidaSynth),
  .invalid_value(invalid_valueSynth),
  .rst(rst),
  .enb(enb),
  .k_out(kSynth)
);

always # 5 clk = ~clk;//inicio de la señal de reloj, cambia cada 10ns

reg error;
always @ ( * ) begin
  error = salida-salidaSynth;
end

initial begin
  $dumpfile("gtkws/testDecoder10to8.vcd");
  $dumpvars;
end
/*
k data8_out
K H G F E D C B A
8 7 6 5 4 3 2 1 0
*/
/*
data10_in
j h g f i e d c b a
9 8 7 6 5 4 3 2 1 0
*/
initial begin
  clk <= 0;
  enb <= 1;
  entradas <= 10'b0010000110; // 00000000 0
  rst <= 1'b1;

  # 100
  @ (posedge clk);
  entradas <= 10'b1001101110; // 00100001 x 0

  # 100
  @ (posedge clk);
  entradas <= 10'b0110100110; // 00100110 x 1

  # 100
  @ (posedge clk);
  entradas <= 10'b0011111100;  //  01111100 x 1


  # 100
  @ (posedge clk);
  entradas <= 10'h200; ////aasaaaaaaasdae\as

  # 100
  @ (posedge clk);
  rst <= 1'b0;
  @ (posedge clk10);
  entradas <= 10'h36c;

  # 100
  @ (posedge clk);
  entradas <= 10'h3e0;

  # 100
  @ (posedge clk);
  entradas <= 10'h01f;

  # 100
  @ (posedge clk);
  entradas <= 10'h36d;

  # 100
  @ (posedge clk);
  entradas <= 10'h3e0;

  # 100
  @ (posedge clk);
  entradas <= 10'h1d5;

  # 200

  $finish;
end
endmodule
