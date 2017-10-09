module decoder10to8(
	output reg [7:0] data8_out,
	output reg k_out,
	output reg invalid_value,
	input wire clk,
	input wire [9:0] data10_in
);

/*
data10_in
j h g f i e d c b a
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
wire P04=(!data10_in[0])&(!data10_in[1])&(!data10_in[2])&(!data10_in[3]);
wire P3x=((data10_in[0])&(data10_in[1])&(data10_in[2])) |
	((data10_in[0])&(data10_in[1])&(data10_in[3])) |
	((data10_in[0])&(data10_in[2])&(data10_in[3])) |
	((data10_in[1])&(data10_in[2])&(data10_in[3]));
wire Px3=((!data10_in[0])&(!data10_in[1])&(!data10_in[2])) |
	((!data10_in[0])&(!data10_in[1])&(!data10_in[3])) |
	((!data10_in[0])&(!data10_in[2])&(!data10_in[3])) |
	((!data10_in[1])&(!data10_in[2])&(!data10_in[3]));
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
wire n0= (n8 & (!data10_in[2])&(data10_in[3])&((data10_in[4]) == (data10_in[5])))==
	((!data10_in[2])&(data10_in[3]))&((data10_in[4])==(data10_in[5])) & n8;
wire n1= Px3 & (((data10_in[3])&(data10_in[5])) | (!data10_in[4]));
wire n2= ((data10_in[0])&(data10_in[1])&(data10_in[4])&(data10_in[5])) | ((!data10_in[2])&(!data10_in[3])&(!data10_in[4])&(!data10_in[5]));
wire n3= (data10_in[2])&(!data10_in[3])&((data10_in[4]) == (data10_in[5]))&((data10_in[0]) != (data10_in[1]));
wire n4= (!data10_in[0])&(data10_in[1])&((data10_in[2]) != (data10_in[3]))&((data10_in[4])==(data10_in[5]));
wire n5= (!data10_in[4])&(!data10_in[5])&((!data10_in[0])&(!data10_in[1])|(!data10_in[2])&(!data10_in[3]));
wire n6= (data10_in[0])&(!data10_in[1])&((data10_in[2]) != (data10_in[3]))&((data10_in[4])==(data10_in[5]));
wire n7= Px3&((!data10_in[4]) | (!data10_in[5]));
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
assign A=(n0|n1|P3x&(data10_in[5])|n2) ? (!data10_in[0]):data10_in[0];
assign B=(n3|n1|P3x&(data10_in[5])|n2) ? (!data10_in[1]):data10_in[1];
assign C=(n4|n1|P3x&(data10_in[5])|n5) ? (!data10_in[2]):data10_in[2];
assign D=(n6|n1|P3x&(data10_in[5])|n2) ? (!data10_in[3]):data10_in[3];
assign E=(n0|n7|n5) ? (!data10_in[4]):data10_in[4];


//// 4B/3B Decoder,
/*funciones intermedias
m0 = (f ≠ g) • h •j
m7 = c’•d’•e’•i’•(h≠j)
m2 = f • g’• (h =j)
m10 = i•g•h•j + i’•g’•h’•j’
*/
wire m0 = ((data10_in[7]) != (data10_in[7])) & (data10_in[8]) &(data10_in[9]);
wire m7 = (!data10_in[2])&(!data10_in[3])&(!data10_in[4])&(!data10_in[5])&((data10_in[8])!=(data10_in[9]));
wire m2 = (data10_in[7]) & (!data10_in[7])& ((data10_in[8]) ==(data10_in[9]));
wire m10 = (data10_in[5])&(data10_in[7])&(data10_in[8])&(data10_in[9]) |
	(!data10_in[5])&(!data10_in[7])&(!data10_in[8])&(!data10_in[9]);

/* F,G,H:
CPLf = m0 + (f = g) • j + m7
CPLg = (f ≠ g) • h’ •j’ + (f=g) • j + m7
CPLh = m2 + (f =g) • j + m7
F = CPLf ? f’:f;
G = CPLg ? g’:g;
H = CPLh ? h’:h;
**********

*/
assign F = (m0 | ((data10_in[6]) == (data10_in[7])) & (data10_in[9]) | m7) ?
 	(!data10_in[6]):(data10_in[6]);
assign G = (((data10_in[6]) != (data10_in[7]))&(!data10_in[8])&(!data10_in[9]) |
 	((data10_in[6]) == (data10_in[7])) & (data10_in[9]) | m7) ?
 	(!data10_in[7]):(data10_in[7]);
assign H = (m2 | ((data10_in[6]) == (data10_in[7]))&(data10_in[9]) | m7) ?
 	(!data10_in[8]):(data10_in[8]);

/*Logic Equation for Control Bit K
//m10 = i•g•h•j + i’•g’•h’•j’
Kx7 = m10•(e ≠ i)
Kx.7 = (e≠ i)• (i= g=h=j)= kx7
K28 = c• d• e• i + c’• d’• e’• i’
m5 = K28•(f=g=h)
m6 = K28’•(i ≠ g=h=j)
K = (K28 + Kx.7) = (c=d=e=i) + (e ≠ i)•(i=g=h=j)
For reduced delay, the above equation is implemented as follows:
K = c•d•e•i + c’•d’•e’•i’ + (e ≠ i)•(i•g•h•j + i’•g’•h’•j’)
*/
wire Kx7 = (m10&((data10_in[4]) != (data10_in[5])));
wire K28 = ((data10_in[2])& (data10_in[3])& (data10_in[4])& (data10_in[5]) |
 	(!data10_in[2])& (!data10_in[3])& (!data10_in[4])& (!data10_in[5]));
//wire m5 = (K28&((data10_in[6])==(data10_in[7])==(data10_in[8])));
//wire m6 = ((!K28)&((data10_in[5]) != (data10_in[7])==(data10_in[8])==(data10_in[9])));
//revisar delay luego se usa: K= K28+Kx7;
assign K = K28 | Kx7 ? 1: 0;

/*******INVALID INPUT VECTORS*******/
//Logic Equation for invalid Vectors R6, INVR6
wire INVR6=P40|P04|(P3x&(data10_in[4])&(data10_in[5])) |
	(P3x&(!data10_in[4])&(!data10_in[5]));
// An invalid Kx.7 control character is recognized if the following conditions are met:
// VKx7 = (i•g•h•j + i’•g’•h’•j’) •(e ≠ i)•P22 = m10 •(e ≠ i)•P22
wire VKx7 =(m10&((data10_in[4]) != (data10_in[5])))&P22;
// Other invalid R4 vectors are lumped together in the signal INVR4:
// INVR4 = (f=g=h=j) + (e=i=f=g=h) + K28•(f=g=h) + K28’•(i ≠ g=h=j)
// Abbreviations:
// m5 = K28•(f=g=h)
// m6 = K28’•(i ≠ g=h=j)
// INVR4 = (f=g=h=j) + (e=i=f=g=h) + m5 + m6
wire m5 = K28&((data10_in[6])==(data10_in[7])==(data10_in[8]));
wire m6 = (!K28)&((data10_in[5]) != (data10_in[7]) == (data10_in[8])==(data10_in[9]));
wire INVR4 = ((data10_in[6])==(data10_in[7])==(data10_in[8])==(data10_in[9])) |
 	((data10_in[4])==(data10_in[5])==(data10_in[6])==(data10_in[7])==(data10_in[8])) | m5 | m6;

/* Un vector de entrada invalido generara un vector de salida invalido,
por lo que es posible genere un vector de salida distindo al que se codifico.
Al no tener control de paridad en el bloque de codificafion, es innecesario implementar
la logica de deteccion de paridad la cual en caso de no cumplirse se agregaria un termino mas PINVBY.
PINVBY = INVR6 | VKx7 | INVR4;
*/
assign PINVBY = INVR6 | VKx7 | INVR4;


/*INICIO_COMENTARIO

//6B/5B Disparity Check Equations
// Logic Equations for Required Input Disparity DRR6
// bloques intermedios
// n20 = (a•b•c)’•d’
// n21 = (a’•b’•c’)’•d

wire n20 = (!((data10_in[0])&(data10_in[1])&(data10_in[2])))&(!data10_in[3]);
wire n21 = (!((!data10_in[0])&(!data10_in[1])&(!data10_in[2])))&(data10_in[3]);


// Logic Equations for Required Input Disparity DRR6
// The terms PDRR6 and NDRR6 represent the R6 vectors which require a positive or
// negative running disparity, respectively, at the start of the vector. Contrary to previous
// implementations, all invalid vectors starting with P40 or P04 have been left out of the
// equations because of their redundancy in the overall error checking scheme.
// PDRR6 = Px3•(e’+i’) + a’•b’•c’ + e‘•i’•[Px2 + d’•(a•b•c)’]
// NDRR6 = P3x•(e+i) + a • b • c + e•i•[P2x + d•(a’•b’•c’)’]

wire PDRR6 = (Px3)&((!data10_in[4])|(!data10_in[5])) |
	(!data10_in[0])&(!data10_in[1])&(!data10_in[2]) |
	(!data10_in[4])&(!data10_in[5])&((Px2) | n20);
wire NDRR6 = (P3x)&((data10_in[4])|(data10_in[5])) |
	((data10_in[0])&(data10_in[1])&(data10_in[2])) |
	(data10_in[4])&(data10_in[5])&((P2x) | n21);


//  Logic Equations for the assumed ending Disparities PDUR6 and NDUR6
// PDUR6 = P3x•(e+i) + d•e•i + P2x•e•i = P3x•(e+i) + e•i•(d + P2x)
// NDUR6 = Px3 •(e’+i‘) + d’• e‘•i’ + Px2• e‘•i’ = Px3 •(e’+i‘) + e‘• i’•(d' + Px2)

wire PDUR6 =  P3x&((data10_in[4])|(data10_in[5])) |
	(data10_in[4])&(data10_in[5])&((data10_in[3]) | P2x);
wire NDUR6 =  Px3 &((!data10_in[4])|(!data10_in[5])) |
	(!data10_in[4])& (!data10_in[5])&((!data10_in[3]) | Px2);



// Logic Equations for the required Disparity at the Front of the R4 Vector
// The terms PDRR4 and NDRR4 represent the required positive or negative disparity,
// respectively, at the front of the R4 vector.
// PDRR4 = f’•g’ + (f ≠g)•h’•j’
// NDRR4 = f•g + (f ≠g)•h•j = f•g + m0
// Logic Equations for the assumed ending Disparities PDUR4 and NDUR4
// PDUR4 = h•j + f •g •(h ≠ j)
// NDUR4 = h’•j’ + f’•g’ •(h ≠ j)
// Logic Equation for invalid Vector R4, INVR4
// *********
// n22 = PDRR4•NDRR6’
// n23 = NDRR4•PDRR6’


wire PDRR4 = (!data10_in[6])&(!data10_in[7]) | ((data10_in[6]) != (data10_in[7]))&(!data10_in[8])&(!data10_in[9]);
wire NDRR4 = (data10_in[6])&(data10_in[7]) | m0;
wire PDUR4 = (data10_in[8])&(data10_in[9]) | (data10_in[6])&(data10_in[7])&((data10_in[8]) != (data10_in[9]));
wire NDUR4 = (!data10_in[8])&(!data10_in[9]) | (!data10_in[6])&(!data10_in[7])&((data10_in[8])!=(data10_in[9]));

wire n22 = PDRR4&(!NDRR6);
wire n23 = NDRR4&(!PDRR6);

//  Disparity Monitoring
// If either one or both of the vectors of a byte are disparity dependent, either PDUBY or
// PNDUBY are asserted to establish a positive or negative running disparity, respectively, at
// the end of the byte regardless of the running disparity at the front of the byte:
// PDUBY = PDUR4 + PDUR6•NDUR4'
// NDUBY = NDUR4 + NDUR6•PDUR4'Logic Equations for the Determination of the
// Disparity at the Start of the Byte
// PDFBY = PDUBY_LAST + PDFBY_LAST • NDUBY_LAST’
// Note that NDFBY and PDFBY are complementary: NDFBY = PDFBY’
// The values of PDUBY and NDUBY are exclusive, none or one alone can be true.



wire PDUBY = PDUR4 | PDUR6&(!NDUR4);
wire NDUBY = NDUR4 | NDUR6&(!PDUR4);
wire PDFBY = PDUBY_LAST | PDFBY_LAST & (!NDUBY_LAST);
wire NDFBY = !PDFBY;
//Codigooo Posible implementacion usando latch
//latch
// always @ (enable or x1 or x2 or x3 or x4)
//      if (enable)
//        y = !((x1 | x2) & (x3 | x4));
//      else
//        y = 1; // operand is a constant.



// Logic Equation for Monitoring Byte Disparity Violations
// The disparity violation at a byte DVBY
// The terms PDFBY and NDFBY represent a positive or negative running disparity,
// respectively, at the front of the byte.
// DVBY=NDFBY•(PDRR6+PDRR4•NDRR6’) + PDFBY•(NDRR6+NDRR4•PDRR6’)

/wire DVBY=(NDFBY&(PDRR6|PDRR4&(!NDRR6)) | PDFBY&(NDRR6|NDRR4&(!PDRR6)));

FIN_COMENTARIO*/

//end

//Asignacion sincrona de la salida
always @(posedge clk) begin
	data8_out[7] <= H;
	data8_out[6] <= G;
	data8_out[5] <= F;
	data8_out[4] <= E;
	data8_out[3] <= D;
	data8_out[2] <= C;
	data8_out[1] <= B;
	data8_out[0] <= A;
	k_out <= K;
	invalid_value <= PINVBY;

end


endmodule
