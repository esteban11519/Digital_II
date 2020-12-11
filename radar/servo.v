`timescale 10ns/1ns
module servo( input clk, output reg PWM, input [1:0]boton_cambiar_grados );

//wire [1:0] boton_cambiar_grados;
integer contador;
//integer auxContador;
//reg C;

initial begin
PWM=0; // El PWM del servo ancho de pulso es 20 ms
contador=0; // Contador PWM
//C=1;// Se encarga de cambiar entre estados
end


	

		
always@(posedge clk) begin


//PWM<=~boton_cambiar_grados;

////C<= boton_cambiar_grados;
//	auxContador=auxContador+1;
//	if(boton_cambiar_grados&&auxContador>50_000_000)
//	begin
//
//	C <= 1+C;
//	if(boton_cambiar_grados;==4) C<=1;
//	auxContador=0;
//
//	end

	if(boton_cambiar_grados==1)
		begin
				contador<= contador +1;                      
				if (contador<50_000)//  1ms/periodo FPGA
				begin
					PWM <= 1;
				end
				else
				if (contador < 950_000) //1ms-20ms/periodo FPGA
				begin
				PWM <= 0;
				end
	end			
	else
	if(boton_cambiar_grados==2)
		begin
				contador<= contador +1;                      
				if (contador<75_000) // 1.5ms/periodo FPGA
				begin
				
					PWM <= 1;
				end
				else
				if (contador < 925_000) //1.5ms-20ms/periodo FPGA
				begin
				PWM <= 0;
				end
		
	end	

			
	else if(boton_cambiar_grados==3)
		begin
				contador<= contador +1;                      
				if (contador<100_000)	//2ms/periodo FPGA
				begin
				
					PWM <= 1;
				end
				else
				if (contador < 900_000) //2ms-20ms/periodo FPGA
				begin
				PWM <= 0;
				end
		
				
	end

	if(contador >=1_000_000) // Se reinicia en 20 ms
	begin
		contador <= 0;
	end			
end
	
	
 endmodule 