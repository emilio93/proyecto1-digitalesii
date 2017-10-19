//usando tiempos de bajo a alto @ VCC = 5v

module BUF(A, Y);
parameter tpdmin = 0.082;
parameter tpdtyp = 0.082;
parameter tpdmax = 0.07;
input A;
output Y;
assign #(tpdmin:tpdtyp:tpdmax) Y = A;
endmodule

module NOT(A, Y);
parameter tpdmin = 0.094;
parameter tpdtyp = 0.094;
parameter tpdmax = 0.080;
input A;
output Y;
 assign #(tpdmin:tpdtyp:tpdmax) Y = ~A;//#(1:3.8:7.5,1:5.3:7.5)5v #(1:7.5:10.6,1:7.5:10.6) 3.3v ns 25 °C
endmodule

module NAND(A, B, Y);
parameter tpdmin = 0.104;
parameter tpdtyp = 0.104;
parameter tpdmax = 0.082;
input A, B;
output Y;
 assign Y = ~(A & B);//#(1.5:5:6.5,1.5:4.4:6.1)5v #(1.5:7.2:9.8,1.5:5.8:8.6) 3.3v ns 25 °C
endmodule

module NOR(A, B, Y);
parameter tpdmin = 0.093;
parameter tpdtyp = 0.093;
parameter tpdmax = 0.076;
input A, B;
output Y;
 assign #(tpdmin:tpdtyp:tpdmax) Y = ~(A | B);
endmodule

// FD1QD2
module DFF(C, D, Q);
reg cnt;
parameter tplhmin = 0.099;
parameter tphlmin = 0.082;
input C, D;
output reg Q;
initial cnt = 0;
always @(posedge C) begin
  if (Q != D) cnt = cnt + 1;
  if (D) begin
    # (tplhmin) Q <= D;
  end else begin
    # (tphlmin) Q <= D;
  end
end

`ifdef CALCULOPOTENCIA
  always @(posedge Q) testbench_P1.probador.m1.PwrCntr[0]<=testbench_P1.probador.m1.PwrCntr[0]+1;
`endif
endmodule

module DFFSR(C, D, Q, S, R);//que es esto?
input C, D, S, R;
output reg Q;
always @(posedge C, posedge S, posedge R)
	if (S)
		Q <= 1'b1;//inventados
	else if (R)
		Q <= 1'b0;
	else
		Q <= D;
endmodule
