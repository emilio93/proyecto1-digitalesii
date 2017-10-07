module decoder10to8(
	output reg [7:0] data8_out,
	output reg dec_e,dis_e,
	output reg rx_Dk,
	input wire clk,
	input wire [9:0] data10_in
);

/*
data10_in
j i h g f e d c b a 
9 8 7 6 5 4 3 2 1 0
*/

/*
k data8_out
K H G F E D C B A
8 7 6 5 4 3 2 1 0
*/



//bloque combinacional
//always (*) begin
//calculo de P3x y Px3 se usan para el calculo del error
wire P40=(data10_in[0])&(data10_in[1])&(data10_in[2])&(data10_in[3]);
wire P04=(~data10_in[0])&(~data10_in[1])&(~data10_in[2])&(~data10_in[3]);
wire P3x=((data10_in[0])&(data10_in[1])&(data10_in[2])) | 
	((data10_in[0])&(data10_in[1])&(data10_in[3])) | 
	((data10_in[0])&(data10_in[2])&(data10_in[3])) | 
	((data10_in[1])&(data10_in[2])&(data10_in[3]));
wire Px3=((~data10_in[0])&(~data10_in[1])&(~data10_in[2])) | 
	((~data10_in[0])&(~data10_in[1])&(~data10_in[3])) | 
	((~data10_in[0])&(~data10_in[2])&(~data10_in[3])) | 
	((~data10_in[1])&(~data10_in[2])&(~data10_in[3]));
wire P22=(P3x)&(Px3);

//calculo de  P2x y Px2 usados para definir la disparidad
wire P2x=(data10_in[0])&(data10_in[1]) | (data10_in[0])&(data10_in[2]) | (data10_in[1])&(data10_in[2]);
wire Px2=((!data10_in[0])&(!data10_in[1])) | ((!data10_in[0])&(!data10_in[2])) | ((!data10_in[1])&(data10_in[2]));

//decoded Bits A, B, C, D, E
//funciones intermedias
/*
n0 = (a’+b’)•c’•d•(e=i) = c’•d•(e=i)•n8
n1 = Px3•(d•i+e’)
n2 = a•b•e•i + c’•d’•e’•i’
n3 = c•d’•(e=i)•(a ≠ b)
n4 = a’•b•(c ≠ d)•(e=i)
n5 = e’•i’•(a’•b’+c’•d’)
n6 = a•b’•(c ≠ d)•(e = i)
n7 = Px3•(e’ + i’)
n8 = (a’+b’)
*/
wire n0= (n8 & (!data10_in[2])&(data10_in[3])&((data10_in[4]) == (data10_in[8])))==
	((!data10_in[2])&(data10_in[3]))&((data10_in[4])==(data10_in[8])) & n8;
wire n1= Px3 & (((data10_in[3])&(data10_in[8])) | (!data10_in[4]));
wire n2= ((data10_in[0])&(data10_in[1])&(data10_in[4])&(data10_in[8])) | ((!data10_in[2])&(!data10_in[3])&(!data10_in[4])&(!data10_in[8]));
wire n3= (data10_in[2])&(!data10_in[3])&((data10_in[4]) == (data10_in[8]))&((data10_in[0]) != (data10_in[1]));
wire n4= (!data10_in[0])&(data10_in[1])&((data10_in[2]) != (data10_in[3]))&((data10_in[4])==(data10_in[8]));
wire n5= (!data10_in[4])&(!data10_in[8])&((!data10_in[0])&(!data10_in[1])|(!data10_in[2])&(!data10_in[3]));
wire n6= (data10_in[0])&(!data10_in[1])&((data10_in[2]) != (data10_in[3]))&((data10_in[4])==(data10_in[8]));
wire n7= Px3&((!data10_in[4]) | (!data10_in[8]));
wire n8=((!data10_in[0]) | (!data10_in[1]));



// ternary expression
//a=condition ? if true : if false
/*
A=
B=
C=
D=
E=
*/
wire A=(n0|n1|P3x&(data10_in[8])|n2)?(!data10_in[0]):data10_in[0];
wire B=(n3|n1|P3x&(data10_in[8])|n2)?(!data10_in[1]):data10_in[1];
wire C=(n4|n1|P3x&(data10_in[8])|n5)?(!data10_in[2]):data10_in[2];
wire D=(n6|n1|P3x&(data10_in[8])|n2)?(!data10_in[3]):data10_in[3];
wire E=(n0|n7|n5)?(!data10_in[4]):data10_in[4];





//Logic Equation for invalid Vectors R6, INVR6

wire INVR6=P40|P04|(P3x&(data10_in[4])&(data10_in[8])) | (P3x&(!data10_in[4])&(!data10_in[8]));




//6B/5B Disparity Check Equations
/* Logic Equations for Required Input Disparity DRR6
bloques intermedios
n20 = (a•b•c)’•d’
n21 = (a’•b’•c’)’•d
*/
wire n20 = (!((data10_in[0])&(data10_in[1])&(data10_in[2])))&(!data10_in[3]);
wire n21 = (!((!data10_in[0])&(!data10_in[1])&(!data10_in[2])))&(data10_in[3]);

/*Logic Equations for Required Input Disparity DRR6
The terms PDRR6 and NDRR6 represent the R6 vectors which require a positive or
negative running disparity, respectively, at the start of the vector. Contrary to previous
implementations, all invalid vectors starting with P40 or P04 have been left out of the
equations because of their redundancy in the overall error checking scheme.
PDRR6 = Px3•(e’+i’) + a’•b’•c’ + e‘•i’•[Px2 + d’•(a•b•c)’]
NDRR6 = P3x•(e+i) + a • b • c + e•i•[P2x + d•(a’•b’•c’)’]
*/
wire PDRR6 = (Px3)&((!data10_in[4])|(!data10_in[8])) | (!data10_in[0])&(!data10_in[1])&(!data10_in[2]) | (!data10_in[4])&(!data10_in[8])&((Px2) | n20);
wire NDRR6 = (P3x)&((data10_in[4])|(data10_in[8])) | ((data10_in[0])&(data10_in[1])&(data10_in[2])) | (data10_in[4])&(data10_in[8])&((P2x) | n21);

/*
Logic Equations for the required Disparity at the Front of the R4 Vector
The terms PDRR4 and NDRR4 represent the required positive or negative disparity,
respectively, at the front of the R4 vector.
PDRR4 = f’•g’ + (f ≠g)•h’•j’
NDRR4 = f•g + (f ≠g)•h•j = f•g + m0
Logic Equations for the assumed ending Disparities PDUR4 and NDUR4
PDUR4 = h•j + f •g •(h ≠ j)
NDUR4 = h’•j’ + f’•g’ •(h ≠ j)
Logic Equation for invalid Vector R4, INVR4
*/



n22 = PDRR4•NDRR6’
n23 = NDRR4•PDRR6’

/*
k data8_out
K H G F E D C B A
8 7 6 5 4 3 2 1 0
*/
/*
data10_in
j i h g f e d c b a 
9 8 7 6 5 4 3 2 1 0
*/




/* Logic Equation for Monitoring Byte Disparity Violations
The disparity violation at a byte DVBY
The terms PDFBY and NDFBY represent a positive or negative running disparity,
respectively, at the front of the byte.

DVBY=NDFBY•(PDRR6+PDRR4•NDRR6’) + PDFBY•(NDRR6+NDRR4•PDRR6’)
*/




/* Logic Equations for the assumed ending Disparities PDUR6 and NDUR6
PDUR6 = P3x•(e+i) + d•e•i + P2x•e•i = P3x•(e+i) + e•i•(d + P2x)
NDUR6 = Px3 •(e’+i‘) + d’• e‘•i’ + Px2• e‘•i’ = Px3 •(e’+i‘) + e‘• i’•(d' + Px2)
*/


//// 4B/3B Decoder,

/*
data10_in
j i h g f e d c b a 
9 8 7 6 5 4 3 2 1 0
*/

/*
k data8_out
K H G F E D C B A
8 7 6 5 4 3 2 1 0
*/

//funciones intermedias
/*
m0 = (f ≠ g) • h •j
m7 = c’•d’•e’•i’•(h≠j)
m2 = f • g’• (h =j)


*/




//end

////Asignacion sincrona de la salida
//always @(negedge clk) begin
	//data8_out[7] <= H;
	//data8_out[6] <= G;
	//data8_out[5] <= F;
	//data8_out[4] <= E;
	//data8_out[3] <= D;
	//data8_out[2] <= C;
	//data8_out[1] <= B;
	//data8_out[0] <= A;

//end


endmodule
