`timescale 10ns / 1ns

module procesamiento#(
		parameter n = 120,  // Filas
		parameter m = 160,  // columas
		parameter AW = 15,		 // Cantidad de bits  de la direccion.
	    parameter DW = 12		 // Cantidad de Bits de los datos.
		
		)
		(
		//entradas
		clk, // Reloj de 100 MHz
		rst, // Reset
		regwrite,		  	 // Enable del módulo cámara
		addr_in, // Dirreciones en la que se guardan en el módulo buffer ram
	    data_in, // Datos que salén de la cámara.
	    
	    // Mapa de memoria
            // entradas
            // Cada vez que es 1 inicia el procesamiento, debe hacerse mínimo cada 1.6 ms
        init_procesamiento, 

            // Salidas
	    color, // 1: Rojo, 2:Verde, 3 Azul
	    figure,// 1: Triángulo, 2:Círculo, 3 Cuadrado
	    done // Indica cuando ya se realizó el procesamiento de una imagen
	    
   );
        input clk;
		input rst;
		input init_procesamiento;
		input regwrite;		  	 // Enable.
		input [AW-1: 0] addr_in; // Dirección entrada dada por el capturador.
	    input [DW-1: 0] data_in; // Datos que entran de la cámara.
	    
	
		output reg [1:0] color; 
		output reg [1:0] figure;
		output reg  done;
		
		initial begin
		color=0; // Ninguno
		figure=0; // Ninguno
		done=0;
		end


localparam CHECK=1,ADD_COL=2,SEL_COL=3,ADD_ACH_MAY=4,DONE=5,imaSiz=19199;
reg Done=0,Add_Anc_May=0, Sel_Col=0, Add_Col=0; 
reg [2:0]status=0;

reg was_init_procesamiento=0; // Habilita volver a procesar
reg aux_init_procesamiento=0; //Guarda la orden de inicio de procesamiento
reg primer_pixel=0;
reg enable=0;
reg [7:0] col=0;
reg [6:0] fil=1;

reg [7:0] ancho_actual=0;
reg [7:0] ancho_anterior=0;
reg [6:0] ancho_mayor=0;
reg [6:0] fila_valida=0;
//reg [6:0] limite_superior=0;
//reg [6:0] limite_inferior=0;


reg [DW-1:0] pixel;
integer R=0;
integer G=0;
integer B=0;


always @(posedge clk) begin
    if(~rst)begin
        if (~was_init_procesamiento)begin
        aux_init_procesamiento<=init_procesamiento;
            if(init_procesamiento) was_init_procesamiento<=1;
        end
     end 
end


always @(negedge clk)begin
    if(~rst) begin
        if(Done) begin
        done=1;
        was_init_procesamiento=0;
        aux_init_procesamiento=0;
        // Se hace necesaria la última comparación
        if(ancho_actual>3)begin 
                fila_valida<=fila_valida+1;
                if(ancho_anterior<ancho_actual)ancho_mayor<=ancho_mayor+1;
            end
        
        // Para el color
        if(R>G&R>B) color=1; // Color Rojo
        else if(G>R&G>B) color=2; // Color Verde
        else if(B>R&B>G) color=3; // Color Azul
        
        // Para la Figura
       //fila_valida-(fila_valida>>4) Se hacen 4 corrimiento a derecha lo que equivale al 1/2^2 porciento de error admitido
       //(fila_valida+(fila_valida>>4))>>1 hace referencia al 50 porciento de las filas validas mas un error. 
        if(fila_valida>=ancho_mayor&ancho_mayor>(fila_valida-(fila_valida>>2))) figure=1; // Tri�ngulo
        else if(((fila_valida+(fila_valida>>2))>>1)>ancho_mayor&ancho_mayor>((fila_valida-(fila_valida>>2))>>1)) figure=2; // c�rculo
        else if(fila_valida>0) figure=3; // cuadrado
        end
        
        else if (Add_Anc_May)begin
        fil=fil+1;
        col=0;
            if(ancho_actual>3)begin 
                fila_valida<=fila_valida+1;
                if(ancho_anterior<ancho_actual)ancho_mayor<=ancho_mayor+1;
            end
        ancho_anterior=ancho_actual;
        ancho_actual=0;       
        end
        
        else if (Sel_Col)begin
        ancho_actual=ancho_actual+1;
        R=R+pixel[11:8];
        G=G+pixel[7:4];
        B=B+pixel[3:0];
        end
        else if (Add_Col)begin
        col=col+1; 
        end
        
    end    
end

always @(posedge regwrite)begin
 if (rst) begin
    // Salidas
    color=0; 
	figure=0;
	done=0;
		
    
    enable=0;
    col=1;
    fil=1;
    
    ancho_actual=0;
    ancho_anterior=0;
    ancho_mayor=0;
    fila_valida=0;
    
    pixel=0;
    R=0;
    G=0;
    B=0;
 end 
 else if(aux_init_procesamiento&addr_in==1) begin
 
 // Salidas
    color=0; 
	figure=0;
	done=0;
		
    
    enable=1;
    col=1;
    fil=1;
    
    ancho_actual=0;
    ancho_anterior=0;
    ancho_mayor=0;
    fila_valida=0;
    
    pixel<=data_in;
    R=0;
    G=0;
    B=0;
 
    primer_pixel=1;
 
 end
 else if(primer_pixel==1)begin
     enable=1;
     pixel<=data_in;
 end 

end

always @(posedge clk)begin
    if(rst)begin
    status<=0;
    end
    else begin
     case (status)
         CHECK:begin 
            Done=0;
            Add_Anc_May=0;
            Sel_Col=0;
            Add_Col=0;
            if(~enable) status<=CHECK;
            else if(fil*(col+1)>=imaSiz)begin
            status<=DONE;
            end
            else begin
            status<=ADD_COL;
            end
               
         end
         
         ADD_COL:begin
         enable=0;
         
         Done=0;
         Add_Anc_May=0;
         Sel_Col=0;
         Add_Col=1;
         
         if((col+1)%m==0)begin
         status<=ADD_ACH_MAY;
         end
         else if((col+1)%m!=0&(data_in[11:8]+data_in[7:4]+data_in[3:0]>=15))status<=SEL_COL;
         else status=CHECK;
         end
         
         ADD_ACH_MAY:begin
            Done=0;
            Add_Anc_May=1;
            Sel_Col=0;
            Add_Col=0;
            if(data_in[11:8]+data_in[7:4]+data_in[3:0]>=15) status<=SEL_COL;
            else status<=CHECK;
            
         end
         
         SEL_COL:begin
            Done=0;
            Add_Anc_May=0;
            Sel_Col=1;
            Add_Col=0; 
            status<=CHECK;
         end
         
         DONE:begin
             primer_pixel=0;
             enable=0;
             Done=1;
             Add_Anc_May=0;
             Sel_Col=0;
             Add_Col=0;
             
             status<=CHECK;
         end
         
         default: status<=CHECK;
    endcase
 end
end
		

endmodule

