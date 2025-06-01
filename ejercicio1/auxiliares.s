.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480

//----FUNCIONES AUXILIARES----

//usaremos x3 y x4 para las posiciones de X e Y respectivamente 

//Funcion para calcular la posicion de los pixeles mediante la ecuacion dada en el archivo
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

//funcion para hacer rectangulos y dibujar. Para llamarla en otras funciones movemos los numeros que querramos en los registros correspondientes (x1,x2,x3,x4).
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

dibujar_fondo:

 sub sp, sp, 8
 stur x30, [sp, 0]

// cargar divisor 255 en x30 (una sola vez)
mov x30, 255

mov x0, x20 // se restaura el puntero del framebuffer
mov x2, SCREEN_HEIGH
mov x9, SCREEN_HEIGH

fondo_loop_y:
    mov x3, x9
    sub x3, x3, x2
    mul x3, x3, x30
    udiv x3, x3, x9      // x3 = interpolación (0–255)

    // En x11 se guarda el top
    // en x12 se guarda el bottom	
    // === Canal R (189 → 50) ===
    mov x11, 255
    mov x12, 60
    sub x13, x12, x11
    mul x14, x3, x13
    udiv x14, x14, x30
    add x21, x11, x14    // x21 = R

    // === Canal G (203 → 80) ===
    mov x15, 180
    mov x16, 80
    sub x17, x16, x15
    mul x18, x3, x17
    udiv x18, x18, x30
    add x22, x15, x18    // x22 = G

    // === Canal B (243 → 150) ===
    mov x19, 100
    mov x23, 150
    sub x24, x19, x23
    mul x25, x3, x24
    udiv x25, x25, x30
    sub x23, x19, x25    // x23 = B (usamos x23 de nuevo)

    // construir color RGBA en x8
    mov x8, x23           // B
    lsl x8, x8, 8
    orr x8, x8, x22       // G
    lsl x8, x8, 8
    orr x8, x8, x21       // R
    lsl x8, x8, 8
    orr x8, x8, 0xFF      // A

    mov w10, w8

    mov x1, SCREEN_WIDTH
fondo_loop_x:
    stur w10, [x0]
    add x0, x0, 4
    sub x1, x1, 1
    cbnz x1, fondo_loop_x

    sub x2, x2, 1
    cbnz x2, fondo_loop_y

// --------- PASTO VERDE CLARO --
movz x1, 640, lsl 0        // ancho 
movz x2, 80, lsl 0         // altura         
movz x3, 0, lsl 0          // x inicial
movz x4, 400, lsl 0        // y inicial
movz w10, 0xFF00, lsl 0    // color
bl rectangulo


// --------- PASTO VERDE MEDIO --
movz x1, 640, lsl 0        // ancho
movz x2, 40, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 420, lsl 0        // y inicial
movz w10, 0x8000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE MEDIO (detalles)--
movz x1, 50, lsl 0        // ancho
movz x2, 10, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 410, lsl 0        // y inicial
bl rectangulo

movz x1, 53, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 415, lsl 0        // y inicial
bl rectangulo

movz x1, 44, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 405, lsl 0        // y inicial
bl rectangulo

// --------- PASTO VERDE OSCURO --
movz x1, 640, lsl 0        // ancho
movz x2, 30, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 450, lsl 0        // y inicial
movz w10, 0x6000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE CLARO DEL MEDIO --
movz x1, 340, lsl 0        // ancho
movz x2, 15, lsl 0         // altura
movz x3, 150, lsl 0          // x inicial
movz x4, 420, lsl 0        // y inicial
movz w10, 0xFF00, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE CLARO DEL MEDIO (detalles)--
movz x1, 5, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 145, lsl 0          // x inicial
movz x4, 420, lsl 0        // y inicial
bl rectangulo

// --------- PASTO VERDE CLARO DEL MEDIO (detalles)--
movz x1, 5, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 490, lsl 0          // x inicial
movz x4, 420, lsl 0        // y inicial
bl rectangulo

// --------- PASTO VERDE OSCURO (detalles) --
movz x1, 50, lsl 0        // ancho
movz x2, 20, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 440, lsl 0        // y inicial
movz w10, 0x6000, lsl 0    // color
bl rectangulo

movz x1, 25, lsl 0        // ancho
movz x2, 10, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 430, lsl 0        // y inicial
bl rectangulo

movz x1, 50, lsl 0        // ancho
movz x2, 20, lsl 0         // altura
movz x3, 590, lsl 0          // x inicial
movz x4, 440, lsl 0        // y inicial
bl rectangulo

movz x1, 25, lsl 0        // ancho
movz x2, 10, lsl 0         // altura
movz x3, 615, lsl 0          // x inicial
movz x4, 430, lsl 0        // y inicial
bl rectangulo

// --------- PASTO VERDE MEDIO (detalles) --
movz x1, 50, lsl 0        // ancho
movz x2, 10, lsl 0         // altura
movz x3, 590, lsl 0          // x inicial
movz x4, 410, lsl 0        // y inicial
movz w10, 0x8000, lsl 0    // color
bl rectangulo

movz x1, 53, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 587, lsl 0          // x inicial
movz x4, 415, lsl 0        // y inicial
bl rectangulo

movz x1, 44, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 596, lsl 0          // x inicial
movz x4, 405, lsl 0        // y inicial
bl rectangulo

// -------PODIO --

// ---------- SOMBRA --
movz x1, 7, lsl 0       // ancho
movz x2, 95, lsl 0       // alto
movz x3, 243, lsl 0      // x
movz x4, 315, lsl 0      // y
movz w10, 0x5050, lsl 0
movk w10, 0x0050, lsl 16
bl rectangulo

// ---------- PODIO IZQUIERDA--
movz x1, 75, lsl 0       // ancho
movz x2, 60, lsl 0       // alto
movz x3, 170, lsl 0      // x
movz x4, 350, lsl 0      // y
movz w10, 0xAAAA, lsl 0
movk w10, 0x00AA, lsl 16
bl rectangulo

// ---------- PODIO GRANDE--
movz x1, 125, lsl 0       // ancho
movz x2, 95, lsl 0       // alto
movz x3, 250, lsl 0      // x
movz x4, 315, lsl 0      // y
bl rectangulo 

// ------- PALO --
movz x1, 8, lsl 0        // ancho
movz x2, 135, lsl 0         // altura
movz x3, 250, lsl 0          // x inicial
movz x4, 180, lsl 0        // y inicial
movz w10, 0x4513, lsl 0    // MARRON
movk w10, 0x008B, lsl 16    // 
bl rectangulo

//-------PALO IZQUIERDA (el ancho, altura y color ya quedaron guardados en los registros en la llamada anterior)-------
movz x3, 173, lsl 0          // x inicial
movz x4, 215, lsl 0        // y inicial
bl rectangulo

//--------- BANDERA ARG -----------

movz x1, 100, lsl 0
movz x2, 45, lsl 0
movz x3, 258,lsl 0
movz x4, 185,lsl 0
MOVZ w10, 0xC3F7, lsl 0  //  CELESTE         
MOVK w10, 0x004F, lsl 16 
bl rectangulo

movz x1, 100,lsl 0
movz x2, 15, lsl 0
movz x3, 258,lsl 0
movz x4, 200,lsl 0
movz w10, 0xFFFF, lsl 0    //  BLANCO    
movk w10, 0x00FF, lsl 16 
bl rectangulo

movz x1, 9,lsl 0
movz x2, 9,lsl 0
movz x3, 302,lsl 0
movz x4, 203,lsl 0
MOVZ w10, 0xFF99, lsl 0  // AMARILLO        
MOVK w10, 0x00FF, lsl 16  
bl rectangulo

//-----BANDERA FRANCIA------

movz x1 , 26 ,lsl 0
movz x2 , 45 ,lsl 0
movz x3 , 180, lsl 0
movz x4 , 218, lsl 0
MOVZ w10, 0x55A4, lsl 0    // Color azul
MOVK w10, 0x0000, lsl 16  // 
bl rectangulo

movz x1 , 26 ,lsl 0
movz x2 , 45 ,lsl 0
movz x3 , 206, lsl 0
movz x4 , 218, lsl 0
MOVZ w10, 0xFFFF, lsl 0
MOVK w10, 0x00FF, lsl 16 // Color Blanco 
bl rectangulo

movz x1 , 26 ,lsl 0
movz x2 , 45 ,lsl 0
movz x3 , 232, lsl 0
movz x4 , 218, lsl 0
MOVZ w10, 0x4135, lsl 0    // Color Rojo
MOVK w10, 0x00EF, lsl 16  //  
bl rectangulo

// --- ODC 2025 --

// -- O --
movz w10, 0x0000, lsl 0
movk w10, 0x0000, lsl 16

// -- LINEA SUPERIOR  --
movz x1, 8, lsl 0
movz x2, 2, lsl 0
movz x3, 188, lsl 0
movz x4, 365, lsl 0
bl rectangulo

// --- LINEA INFERIOR ---
movz x3, 188, lsl 0
movz x4, 389, lsl 0
bl rectangulo

// -- LINEA IZQUIERDA -- 
movz x1, 2, lsl 0
movz x2, 24, lsl 0
movz x3, 194, lsl 0
movz x4, 365, lsl 0
bl rectangulo

// -- LINEA DERECHA --
movz x3, 188, lsl 0
movz x4, 365, lsl 0
bl rectangulo

// -- D -- 

// -- LINEA IZQUIERDA --
movz x1, 2, lsl 0
movz x2, 26, lsl 0
movz x3, 204, lsl 0
movz x4, 365, lsl 0
bl rectangulo

// --- LINEA SUPERIOR ---
movz x1, 7, lsl 0
movz x2, 2, lsl 0
movz x3, 206, lsl 0
movz x4, 365, lsl 0
bl rectangulo

// --- LINEA INFERIOR ---
movz x3, 206, lsl 0
movz x4, 389, lsl 0
bl rectangulo

// -- LINEA DERECHA --
movz x1, 2, lsl 0
movz x2, 23, lsl 0
movz x3, 212, lsl 0
movz x4, 366, lsl 0
bl rectangulo

// -- C -- 

// --- LINEA IZQUIERDA ---
movz x1, 2, lsl 0
movz x2, 25, lsl 0
movz x3, 222, lsl 0
movz x4, 366, lsl 0
bl rectangulo

// --- LINEA SUPERIOR ---
movz x1, 7, lsl 0
movz x2, 2, lsl 0
movz x3, 224, lsl 0
movz x4, 366, lsl 0
bl rectangulo

// --- LINEA INFERIOR ---
movz x3, 224, lsl 0
movz x4, 389, lsl 0
bl rectangulo

// --- 2 ----

// --- LÍNEA SUPERIOR ---
movz x1, 20, lsl 0        
movz x2, 2, lsl 0        
movz x3, 257, lsl 0       
movz x4, 366, lsl 0      
bl rectangulo

// --- LÍNEA MEDIA ---
movz x3, 257, lsl 0
movz x4, 377, lsl 0
bl rectangulo

// --- LÍNEA INFERIOR ---
movz x3, 257, lsl 0
movz x4, 389, lsl 0
bl rectangulo

// --- LINEA DERECHA SUPERIOR  ---
movz x1, 2, lsl 0
movz x2, 10, lsl 0
movz x3, 275, lsl 0     
movz x4, 367, lsl 0
bl rectangulo

// --- LINEA DERECHA IZQUIERDA ---
movz x3, 257, lsl 0
movz x4, 379, lsl 0
bl rectangulo

// --- 0 ---

// --- LÍNEA SUPERIOR ---
movz x1, 20, lsl 0
movz x2, 2, lsl 0
movz x3, 287, lsl 0      
movz x4, 366, lsl 0
bl rectangulo

// --- LÍNEA INFERIOR ---

movz x3, 287, lsl 0
movz x4, 389, lsl 0
bl rectangulo

// --- LADO IZQUIERDO ---
movz x1, 2, lsl 0
movz x2, 22, lsl 0     
movz x3, 287, lsl 0
movz x4, 367, lsl 0
bl rectangulo

// --- LADO DERECHO ---
movz x3, 305, lsl 0
movz x4, 367, lsl 0
bl rectangulo

// --- 2 ---

// --- LÍNEA SUPERIOR ---
movz x1, 20, lsl 0
movz x2, 2, lsl 0
movz x3, 317, lsl 0
movz x4, 366, lsl 0
bl rectangulo

// --- LÍNEA MEDIA ---
movz x3, 317, lsl 0
movz x4, 377, lsl 0
bl rectangulo

// --- LÍNEA INFERIOR ---
movz x3, 317, lsl 0
movz x4, 389, lsl 0
bl rectangulo

// --- LINEA DERECHA IZQUIERDA ---
movz x1, 2, lsl 0
movz x2, 10, lsl 0
movz x3, 317, lsl 0
movz x4, 379, lsl 0
bl rectangulo

// --- LINEA DERECHA SUPERIOR  ---
movz x3, 335, lsl 0
movz x4, 367, lsl 0
bl rectangulo

// --- 5 ---

// --- LÍNEA SUPERIOR ---
movz x1, 20, lsl 0
movz x2, 2, lsl 0
movz x3, 347, lsl 0       
movz x4, 366, lsl 0
bl rectangulo

// --- LÍNEA MEDIA ---
movz x3, 347, lsl 0
movz x4, 377, lsl 0
bl rectangulo

// --- LÍNEA INFERIOR ---
movz x3, 347, lsl 0
movz x4, 389, lsl 0
bl rectangulo

// --- LINEA IZQUIERDA ---
movz x1, 2, lsl 0
movz x2, 10, lsl 0
movz x3, 347, lsl 0
movz x4, 367, lsl 0
bl rectangulo

// --- LINEA DERECHA ---
movz x3, 365, lsl 0      
movz x4, 379, lsl 0
bl rectangulo

  ldr x30, [sp, 0]
  add sp, sp, 8
ret

