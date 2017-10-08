`timescale 1ns/1ps

// Este módulo se encarga de generar las señales de reloj del
// dispositivo a partir de la señal de mayor frecuencia que se
// utilice(ej 2.5G, 5G).
module clks(
  clk, rst, enb,
  clk10, clk20, clk40
);

  input wire clk;
  input wire rst;
  input wire enb;

  output reg clk10;
  output reg clk20;
  output reg clk40;

  reg [2:0] cnt10;

  always @ (posedge clk) begin
    if (rst) begin
      cnt10 <= 3'd4;
      clk10 <= 1'b0;
      clk20 <= 1'b0;
      clk40 <= 1'b0;
    end else begin
      if (enb) begin
        if (cnt10 >= 3'd4) begin
          cnt10 <= 3'd0;
          clk10 <= ~clk10;
          if (~clk10) clk20 <= ~clk20;
          if (~clk20 & ~clk10) clk40 <= ~clk40;
        end else begin
          cnt10 <= cnt10 + 1'b1;
        end
      end
    end
  end

endmodule
