`timescale 1ns/1ps

// Este módulo se encarga de generar las señales de reloj del
// dispositivo a partir de la señal de mayor frecuencia que se
// utilice(ej 2.5G, 5G).
module clks(clk, clk10, clk20, clk40, rst, enb);

  input wire clk;
  input wire rst;
  input wire enb;
  output reg clk10;
  output reg clk20;
  output reg clk40;

  reg [2:0] cnt10;
  reg [2:0] cnt20;
  reg [2:0] cnt40;

  always @ (posedge clk) begin
    if (rst) begin
      cnt10 <= 3'b000;
      clk10 <= 0;
      clk20 <= 0;
      clk40 <= 0;
    end else if (enb) begin
      if (cnt10 >= 3'd4) begin
        cnt10 <= 3'd0;
        clk10 <= ~clk10;
      end else begin
        cnt10 <= cnt10 + 1;
      end
    end else begin
      cnt10 <= 3'b000;
    end
  end

  always @ (posedge clk10) begin
    clk20 <= ~clk20;
  end

  always @ (posedge clk20) begin
    clk40 <= ~clk40;
  end

endmodule
