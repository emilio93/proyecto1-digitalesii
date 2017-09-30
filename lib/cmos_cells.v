//usando tiempos de bajo a alto @ VCC = 5v

module BUF(A, Y);
input A;
output Y;
assign Y = A; //http://www.ti.com/lit/ds/sces596g/sces596g.pdf ns 3.3 v 25°c SN74AUP1G126
endmodule

module NOT(A, Y);
input A;
output Y;
 assign Y = ~A;//#(1:3.8:7.5,1:5.3:7.5)5v #(1:7.5:10.6,1:7.5:10.6) 3.3v ns 25 °C
endmodule

module NAND(A, B, Y);
input A, B;
output Y;
 assign Y = ~(A & B);//#(1.5:5:6.5,1.5:4.4:6.1)5v #(1.5:7.2:9.8,1.5:5.8:8.6) 3.3v ns 25 °C
endmodule

module NOR(A, B, Y);
input A, B;
output Y;
 assign Y = ~(A | B);//#(1:5.1:7.5,1:5.1:7.5)5v #(1.5:8.1:11.4,1:8.1:11.4) 3.3v ns 25 °C
endmodule

module DFF(C, D, Q);
input C, D;
output reg Q;
always @(posedge C)
	Q <= D; //#(1.5:5.4:7.5,1.5:5:6.9)5v #(1.5:7.7:10.5,1.5:7.5:9.7) 3.3v ns 25 °C
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
