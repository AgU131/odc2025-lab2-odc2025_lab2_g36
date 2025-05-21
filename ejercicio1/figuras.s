.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480

//----FUNCIONES AUXILIARES----

//usaremos x3 y x4 para las posiciones de X e Y respectivamente 
//Usaremos x9-15 registros temp para guardar en los stack (excluyendo x10, el cual esta reservado para los ccolores)

//funcion para calcular la posicion de los pixeles mediante la ecuacion dada

calc_pixel:
// x3 = X
// x4 = Y
// x0 = posicion del pixel en la pantalla
  mov x0, 640	        // x0 = 640
  mul x0, x0, x4	// x0 = (640 * y)	
  add x0, x0, x3	// x0 = (640 * y) + x
  lsl x0, x0, 2		// x0 = ((640 * y) + x) * 4
  add x0, x0, x20       // x0 = ((640 * y) + x) * 4 + (dirección de inicio)
  ret

rectangulo: 
// x1 = ancho
// x2 = largo
// x3 = X
// x4 = Y
// w10 = color

 SUB SP, SP, 40 										
 STUR x30, [SP, 32]
 STUR x13, [SP, 24]
 STUR x12, [SP, 16]
 STUR x11, [SP, 8]
 STUR x9,  [SP, 0]

 BL calc_pixel

//iniciamos el ciclo de dibujo del rectangulo

 mov x9, x2 // en x9 guardamos el alto del rertangulo
 mov x11, x0 // guardamos en x11 el pixel a pintar
 ciclo_filas:
    mov x12, x1    //guardamos en x12 el ancho del rectangulo
    mov x13, x11   //guardamos en x13 el pixel inicial de cada fila 
    ciclo_columnas:
         stur w10, [x11] //pintamos el pixel seleccionado
         add x11, x11, 4 //avanzamos al siguiente pixel
         sub x12, x12, 1 //restamos uhn pixel al contador del ancho
         cbnz x12, ciclo_columnas
         //seguimos pintando la misma fila mientras el contador sea distinto a 0
         mov x11, x13             // volver al inicio de la fila
         movz x14, 640, lsl 0     // SCREEN_WIDTH
         lsl x14, x14, 2          // x14 = SCREEN_WIDTH * 4 bytes
         add x11, x11, x14        // bajar una fila
         sub x9, x9, 1           // restamos 1 al contador de altura
         cbnz x9, ciclo_filas // mientras el alto del rectangulo sea disntinto de 0, seguimos pintando
    // restauramos registros del stack
    LDR x9,  [SP, 0]
    LDR x11, [SP, 8]
    LDR x12, [SP, 16]
    LDR x13, [SP, 24]
    LDR x30, [SP, 32]
    ADD SP, SP, 40
    ret
         
