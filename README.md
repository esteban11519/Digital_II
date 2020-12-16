# Digital_II
[![N|Solid](https://www.universidadesvirtuales.com.co/logos/original/logo-universidad-nacional-de-colombia.png)](https://www.universidadesvirtuales.com.co/logos/original/logo-universidad-nacional-de-colombia.png)

* >Jose Celis
* >Julian Pulido
* >Esteban Landino
* >Julian Escobar

## Motor paso a paso
Los motores paso a paso seran utilzados para el movimiento de las dos llantas principales del robot, cuando las llantas se mueven en la misma direccion permiten el desplazamiendo hacia delante o hacia atras, cuando una llanta queda bloqueada y la otra gira: logra hacer que el robot gire, según convenga, a la derecha o hacia la izquierda.
A continuación se muestran las  entradas y salidas del modulo: 

~~~
`timescale 1ns/1ps
module motor(
    input reset,
    input clk,
    input [1:0]direccion,   
    input [1:0]direccion2,
    output reg A, 
    output reg B,
    output reg C, 
    output reg D,
    output reg A1, 
    output reg B1,
    output reg C1, 
    output reg D1);
~~~
Las salidas **A**,**B**,**C**,**D** se necesitan para poder controlar uno de los motores y **A1**,**B1**,**C1**,**D1** para el otro.  
**direccion** y **direccion2** son estradas de 2 bits, lo que para nosotros representa 4 posibles estados de los motores:
* 1.) Giro Horario
* 2.) Giro Antihorario
* 3.) No girar
* 4.) No girar

Posteriormente se definen algunos parametros y algunos contadores:
```
    parameter divH = 50000; 
    parameter divL = 100000;
	integer  trigger;
	
//Contadores
	integer	countF;
	integer	cuen;
	integer	cuen1;
    //Condiciones iniciales: (TODOS LOS CONTADORES EN CERO 0 ) 
	initial countF = 0;
	initial cuen=0;
	initial cuen1=0;
	initial trigger=0;
 ```


Los parametros **divH** y **divL** se utilizan como tope para el correspondiente contador **countF**, en resumen: *En cada periodo del **clk** se aumenta en 1 el **countF**, cuando el **countF** es igual al valor de **divH** el **trigger** realiza un flanco de subida y cuando **countF** es igual al valor de **divL** entonces el trigger realiza un flanco de bajada, en este ultimo paso el **countF** se reinicia a 0*; asi que el **trigger** es ahora nuestro nuevo reloj; este divisor de frecuencia es necesario debido a que los motores y driver de nuestra referencia ([2byj-48][uln2003]) no funcionan a una frecuencia tan alta (100MHz). En este paso convertimos 100MHz en 1KHz. La formula es:
[![N|Solid](https://i.ibb.co/9r6H2By/imagen-2020-12-16-175106.png)](https://i.ibb.co/9r6H2By/imagen-2020-12-16-175106.png)


```
//Trigger
always @(posedge clk) begin 
	if (reset) 
		begin 
			countF <= 0;
			trigger <= 0;
		end 
	else 
		begin
			countF <= countF +1;
			if (countF < divH+1)
				begin
					trigger <= 1;
				end
			else
				if (countF < divL+1)
					begin
						trigger <= 0;
					end
				else 
					begin
						countF <= 0;
					end
		end
end
```
AA
```

	
	
always@(posedge  trigger) begin
	if(direccion==1)
		begin
			cuen  <= cuen +1;
			case(cuen)
				1:  begin A=0;B=1;C=1;D=1; end 
				2:  begin A=0;B=0;C=1;D=1; end //inicial
				3:  begin A=1;B=0;C=1;D=1; end //inicial
				4:  begin A=1;B=0;C=0;D=1; end //inicial
				5:  begin A=1;B=1;C=0;D=1; end //inicial
				6:  begin A=1;B=1;C=0;D=0; end //inicial
				7:  begin A=1;B=1;C=1;D=0; end //inicial
				8:  begin A=0;B=1;C=1;D=0;cuen<=0; end //inicial
			endcase
		end	
	else 
	if(direccion==2)	
		begin
			cuen  <= cuen +1;
			case(cuen)
				8:  begin A=0;B=1;C=1;D=1;cuen<=0; end 
				7:  begin A=0;B=0;C=1;D=1; end //inicial
				6:  begin A=1;B=0;C=1;D=1; end //inicial
				5:  begin A=1;B=0;C=0;D=1; end //inicial
				4:  begin A=1;B=1;C=0;D=1; end //inicial
				3:  begin A=1;B=1;C=0;D=0; end //inicial
				2:  begin A=1;B=1;C=1;D=0; end //inicial
				1:  begin A=0;B=1;C=1;D=0; end //inicial
			endcase
		end
	else
		cuen  <= 0;
		
	if(direccion2==2)
		begin
			cuen1  <= cuen1 +1;
			case(cuen1)
				1:  begin A1=0;B1=1;C1=1;D1=1; end 
				2:  begin A1=0;B1=0;C1=1;D1=1; end //inicial
				3:  begin A1=1;B1=0;C1=1;D1=1; end //inicial
				4:  begin A1=1;B1=0;C1=0;D1=1; end //inicial
				5:  begin A1=1;B1=1;C1=0;D1=1; end //inicial
				6:  begin A1=1;B1=1;C1=0;D1=0; end //inicial
				7:  begin A1=1;B1=1;C1=1;D1=0; end //inicial
				8:  begin A1=0;B1=1;C1=1;D1=0;cuen1<=0; end //inicial
			endcase
		end	
	else
	if(direccion2==1)	
		begin
			cuen1  <= cuen1 +1;
			case(cuen1)
				8:  begin A1=0;B1=1;C1=1;D1=1;cuen1<=0; end 
				7:  begin A1=0;B1=0;C1=1;D1=1; end //inicial
				6:  begin A1=1;B1=0;C1=1;D1=1; end //inicial
				5:  begin A1=1;B1=0;C1=0;D1=1; end //inicial
				4:  begin A1=1;B1=1;C1=0;D1=1; end //inicial
				3:  begin A1=1;B1=1;C1=0;D1=0; end //inicial
				2:  begin A1=1;B1=1;C1=1;D1=0; end //inicial
				1:  begin A1=0;B1=1;C1=1;D1=0; end //inicial	
			endcase
	
		end 
	else
		cuen1  <= 0;
	
end

	endmodule
```
