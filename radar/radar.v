`timescale 10ns/1ns
 module radar( input reset, input clk, input echo, input [1:0] boton_cambiar_grados, output done, output trigger,
 output [15:0] distance, output PWM, output high1,output high2, output low,  input ultra);

assign  high1=1;
assign  high2=1;
assign  low=0;


always @(posedge clk) begin
 
 
 if(ultra)
 begin
 
 
end 
 end
 
 
 
 
 	
	
 
 
 
 
 servo   servo( .clk (clk), .PWM(PWM), .boton_cambiar_grados(boton_cambiar_grados));
 ultrasonido1 ultrasonido2( .reset(reset), .clk(clk),  .echo(echo), .done(done), .trigger(trigger),.distance(distance), .enc(ultra));

 
 endmodule