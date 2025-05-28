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
        

dibujar_podio:

sub sp, sp, 8
stur x30, [sp, 0]

// ---------- SOMBRA --
movz x1, 7, lsl 0       // ancho
movz x2, 95, lsl 0       // alto
movz x3, 243, lsl 0      // x
movz x4, 315, lsl 0      // y
movz w10, 0x5050, lsl 0
movk w10, 0x0050, lsl 16
bl rectangulo

// ---------- PODIO --
movz x1, 75, lsl 0       // ancho
movz x2, 60, lsl 0       // alto
movz x3, 170, lsl 0      // x
movz x4, 350, lsl 0      // y
movz w10, 0xAAAA, lsl 0
movk w10, 0x00AA, lsl 16
bl rectangulo

// ---------- PODIO --
movz x1, 125, lsl 0       // ancho
movz x2, 95, lsl 0       // alto
movz x3, 250, lsl 0      // x
movz x4, 315, lsl 0      // y
movz w10, 0xAAAA, lsl 0
movk w10, 0x00AA, lsl 16
bl rectangulo 

ldr x30, [sp, 0]
add sp, sp, 8
ret

dibujar_copa:

//usamos x15 y x16 como posicion inicial para la copa, y luego usamos los add y sub para ir moviendonos entro los rectangulos de la copa y dibujar nuevos
sub sp, sp, 8
stur x30, [sp, 0]

    // --- Centro Nivel 1 ---
    movz x1, 30, lsl 0
    movz x2, 30, lsl 0
    mov x3, x15
    mov x4, x16
    movz w10, 0xA520, lsl 0
    movk w10, 0x00DA, lsl 16
    bl rectangulo

    // --- Centro Nivel 2 ---
    movz x1, 22, lsl 0
    movz x2, 38, lsl 0
    add x3, x15, #4
    sub x4, x16, #3
    bl rectangulo

    // --- Centro Nivel 3 ---
    movz x1, 38, lsl 0
    movz x2, 20, lsl 0
    sub x3, x15, #4
    add x4, x16, #5
    bl rectangulo

    // --- Brillo ---
    movz x1, 6, lsl 0
    movz x2, 4, lsl 0
    add x3, x15, #22
    add x4, x16, #7
    movz w10, 0xE680, lsl 0
    movk w10, 0x00FF, lsl 16
    bl rectangulo

    // --- Centro más fino ---
    movz x1, 14, lsl 0
    movz x2, 16, lsl 0
    add x3, x15, #8
    add x4, x16, #26
    movz w10, 0xA520, lsl 0
    movk w10, 0x00DA, lsl 16
    bl rectangulo

    // --- Tronco fino ---
    movz x1, 10, lsl 0
    movz x2, 70, lsl 0
    add x3, x15, #10
    mov x4, x16
    bl rectangulo

    // --- Tronco base ---
    movz x1, 18, lsl 0
    movz x2, 8, lsl 0
    add x3, x15, #6
    add x4, x16, #55
    bl rectangulo

    // --- Base verde arriba ---
    movz x1, 24, lsl 0
    movz x2, 4, lsl 0
    add x3, x15, #3
    add x4, x16, #63
    movz w10, 0x5000, lsl 0
    movk w10, 0x0000, lsl 16
    bl rectangulo

    // --- Base medio ---
    movz x1, 28, lsl 0
    movz x2, 4, lsl 0
    add x3, x15, #1
    add x4, x16, #67
    movz w10, 0xA520, lsl 0
    movk w10, 0x00DA, lsl 16
    bl rectangulo

    // --- Base abajo ---
    movz x1, 32, lsl 0
    movz x2, 5, lsl 0
    sub x3, x15, #1
    add x4, x16, #71
    movz w10, 0x5000, lsl 0
    movk w10, 0x0000, lsl 16
    bl rectangulo

ldr x30, [sp, 0]
add sp, sp, 8

    ret


dibujar_nube:

        sub sp, sp, 8
        stur x30, [sp, 0]
	// Dibuja una nube en la posición (x15, x16)

	mov x1, 60
	mov x2, 10
	mov x3, x15
	mov x4, x16
	movz w10, 0xD0D0, lsl 0
	movk w10, 0x00D0, lsl 16
	bl rectangulo

	mov x1, 40
	mov x2, 7
	add x3, x15, 10
	sub x4, x16, 7
	movz w10, 0xD0D0, lsl 0
	movk w10, 0x00D0, lsl 16
	bl rectangulo

	mov x1, 15
	mov x2, 8
	add x3, x15, 20
	sub x4, x16, 12 
        movz w10, 0xD0D0, lsl 0
        movk w10, 0x00D0, lsl 16
        bl rectangulo
        
       ldr x30, [sp, 0]
       add sp, sp, 8

	ret
