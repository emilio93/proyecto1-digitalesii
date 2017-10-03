`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clks/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/paraleloSerial-serialParalelo/serialParalelo.v"
`include "../build/serialParalelo-sintetizado.v"

module testSerialParalelo ();

reg clk;
reg enb;
reg rst;

reg entrada;
wire [9:0] salidas;

wire clk10;
wire clk20;
wire clk40;

wire [9:0] salidasSynth;
wire clk10Synth;
wire clk20Synth;
wire clk40Synth;

clks clkGen(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10), .clk20(clk20), .clk40(clk40)
);

clksSynth clkGenSynth(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10Synth), .clk20(clk20Synth), .clk40(clk40Synth)
);

serialParalelo receptor(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10),
  .entrada(entrada),
  .salidas(salidas)
);

serialParaleloSynth receptorSynth(
  .clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10Synth),
  .entrada(entrada),
  .salidas(salidasSynth)
);

always # 5 clk = ~clk;//inicio de la señal de reloj, cambia cada 10ns

reg [9:0] error;
always @ ( * ) begin
  error = salidas-salidasSynth;
end

initial begin
  $dumpfile("gtkws/testSerialParalelo.vcd");
  $dumpvars;
end

initial begin
  clk <= 0;
  entrada <= 1'b1;
  rst <= 1'b1;
  enb <= 0;

  # 10
  @ (posedge clk);
  entrada <= 1'b0;
  enb <= 1;

  # 10
  @ (posedge clk);
  entrada <= 1'b0;

  # 10
  @ (posedge clk);
  entrada <= 1'b1;

  //
  // SE APAGA rst
  //
  # 10
  @ (posedge clk);
  rst <= 1'b0;

  // 0110 0110 10
  @ (posedge clk10); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b0;

  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b0;

  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b0;

  @ (posedge clk10); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;

  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;

  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b1;

  @ (posedge clk10); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;

  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;

  @ (posedge clk); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b0;

  @ (posedge clk10); entrada <= 1'b0;
  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b1;

  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b1;

  @ (posedge clk); entrada <= 1'b1;
  @ (posedge clk); entrada <= 1'b1;

  @ (posedge clk10);  entrada <= 1'b1;
  @ (posedge clk10);  entrada <= 1'b0;

  @ (posedge clk10);
  rst <= 1'b1;

  # 20
  @ (posedge clk);
  entrada <= 1'b0;

  # 20
  @ (posedge clk);
  entrada <= 1'b1;

  # 20
  @ (posedge clk);
  entrada <= 1'b1;

  # 50
  $finish;
end

endmodule
