	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

        .include "figuras.s"

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0xC7, lsl 16
	movk x10, 0x1585, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4	   // Siguiente pixel
	sub x1,x1,1	   // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1	   // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto

	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10
	and w11, w10, 0b10

	// w11 será 1 si había un 1 en la posición 2 de w10, si no será 0
	// efectivamente, su valor representará si GPIO 2 está activo
	lsr w11, w11, 1
        

        // --------- FONDO CELESTE
movz x1, 640, lsl 0        // ancho 
movz x2, 400, lsl 0        // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 0, lsl 0          // y inicial
movz w10, 0xFFFF, lsl 0    // color cielo
bl rectangulo              // llama a la función

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

// --------- PASTO VERDE MEDIO --
movz x1, 50, lsl 0        // ancho
movz x2, 10, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 410, lsl 0        // y inicial
movz w10, 0x8000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE MEDIO --
movz x1, 53, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 415, lsl 0        // y inicial
movz w10, 0x8000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE MEDIO --
movz x1, 44, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 405, lsl 0        // y inicial
movz w10, 0x8000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE OSCURO --
movz x1, 640, lsl 0        // ancho
movz x2, 30, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 450, lsl 0        // y inicial
movz w10, 0x6000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE -- (verde claro del medio)
movz x1, 340, lsl 0        // ancho
movz x2, 15, lsl 0         // altura
movz x3, 150, lsl 0          // x inicial
movz x4, 420, lsl 0        // y inicial
movz w10, 0xFF00, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE --(verde claro del medio)
movz x1, 5, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 145, lsl 0          // x inicial
movz x4, 420, lsl 0        // y inicial
movz w10, 0xFF00, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE --(verde claro del medio)
movz x1, 5, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 490, lsl 0          // x inicial
movz x4, 420, lsl 0        // y inicial
movz w10, 0xFF00, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE OSCURO --
movz x1, 50, lsl 0        // ancho
movz x2, 20, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 440, lsl 0        // y inicial
movz w10, 0x6000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE OSCURO --
movz x1, 25, lsl 0        // ancho
movz x2, 10, lsl 0         // altura
movz x3, 0, lsl 0          // x inicial
movz x4, 430, lsl 0        // y inicial
movz w10, 0x6000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE OSCURO --
movz x1, 50, lsl 0        // ancho
movz x2, 20, lsl 0         // altura
movz x3, 590, lsl 0          // x inicial
movz x4, 440, lsl 0        // y inicial
movz w10, 0x6000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE OSCURO --
movz x1, 25, lsl 0        // ancho
movz x2, 10, lsl 0         // altura
movz x3, 615, lsl 0          // x inicial
movz x4, 430, lsl 0        // y inicial
movz w10, 0x6000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE MEDIO--
movz x1, 50, lsl 0        // ancho
movz x2, 10, lsl 0         // altura
movz x3, 590, lsl 0          // x inicial
movz x4, 410, lsl 0        // y inicial
movz w10, 0x8000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE MEDIO --
movz x1, 53, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 587, lsl 0          // x inicial
movz x4, 415, lsl 0        // y inicial
movz w10, 0x8000, lsl 0    // color
bl rectangulo

// --------- PASTO VERDE MEDIO --
movz x1, 44, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 596, lsl 0          // x inicial
movz x4, 405, lsl 0        // y inicial
movz w10, 0x8000, lsl 0    // color
bl rectangulo

// -------PODIO --

bl dibujar_podio

// ------- PALO --
movz x1, 8, lsl 0        // ancho
movz x2, 135, lsl 0         // altura
movz x3, 250, lsl 0          // x inicial
movz x4, 180, lsl 0        // y inicial
movz w10, 0x4513, lsl 0    // color
movk w10, 0x008B, lsl 16    // color
bl rectangulo

//-------PALO IZQUIERDA-------
movz x1, 8, lsl 0        // ancho
movz x2, 135, lsl 0         // altura
movz x3, 177, lsl 0          // x inicial
movz x4, 215, lsl 0        // y inicial
movz w10, 0x4513, lsl 0    // color
movk w10, 0x008B, lsl 16    // color
bl rectangulo


//--------- BANDERA ARG -----------

movz x1, 100, lsl 0
movz x2, 45, lsl 0
movz x3, 258,lsl 0
movz x4, 185,lsl 0
MOVZ w10, 0xC3F7, lsl 0           // bits 0–15
MOVK w10, 0x004F, lsl 16  // bits 16–23
bl rectangulo

movz x1, 100,lsl 0
movz x2, 15, lsl 0
movz x3, 258,lsl 0
movz x4, 200,lsl 0
movz w10, 0xFFFF, lsl 0           // bits 0–15
movk w10, 0x00FF, lsl 16  // bits 16–23
bl rectangulo

movz x1, 9,lsl 0
movz x2, 9,lsl 0
movz x3, 302,lsl 0
movz x4, 203,lsl 0
MOVZ w10, 0xFF99, lsl 0           // bits 0–15
MOVK w10, 0x00FF, lsl 16  // bits 16–23
bl rectangulo



// ------- COPA --
movz x1, 30, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 300, lsl 0          // x inicial
movz x4, 311, lsl 0        // y inicial
movz w10, 0xA520, lsl 0    // color
movk w10, 0x00DA, lsl 16
bl rectangulo

movz x1, 26, lsl 0        // ancho
movz x2, 5, lsl 0         // altura
movz x3, 302, lsl 0          // x inicial
movz x4, 307, lsl 0        // y inicial
movz w10, 0xA520, lsl 0    // color
movk w10, 0x00DA, lsl 16
bl rectangulo

movz x1, 22, lsl 0        // ancho
movz x2, 4, lsl 0         // altura
movz x3, 304, lsl 0          // x inicial
movz x4, 303, lsl 0        // y inicial
movz w10, 0xA520, lsl 0    // color
movk w10, 0x00DA, lsl 16
bl rectangulo

//------- NUBES ----------
// x1 = ancho
// x2 = alto 
// x3, x4 = x , y



movz x1, 60, lsl 0
movz x2, 10, lsl 0
movz x3, 150,lsl 0
movz x4, 42, lsl 0
movz w10, 0xD0D0, lsl 0    // Mueve los 16 bits bajos
movk w10, 0x00D0, lsl 16   // Mueve los 8 bits altos (rellena los bits 16–23)
bl rectangulo

movz x1, 40, lsl 0
movz x2, 7, lsl 0
movz x3, 160,lsl 0
movz x4, 35, lsl 0
movz w10, 0xD0D0, lsl 0    // Mueve los 16 bits bajos
movk w10, 0x00D0, lsl 16   // Mueve los 8 bits altos (rellena los bits 16–23)
bl rectangulo

movz x1, 15, lsl 0
movz x2, 8, lsl 0
movz x3, 170,lsl 0
movz x4, 30, lsl 0
movz w10, 0xD0D0, lsl 0    // Mueve los 16 bits bajos
movk w10, 0x00D0, lsl 16   // Mueve los 8 bits altos (rellena los bits 16–23)
bl rectangulo


//NUBE 2: (desplazado a la derecha en el eje x + 100px, y el eje y + 50px)
movz x1, 60, lsl 0
movz x2, 10, lsl 0
movz x3, 250, lsl 0
movz x4, 92, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

movz x1, 40, lsl 0
movz x2, 7, lsl 0
movz x3, 260, lsl 0
movz x4, 85, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

movz x1, 20, lsl 0
movz x2, 6, lsl 0
movz x3, 270, lsl 0
movz x4, 80, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo


//NUBE 3: (desplazado a la derecha en el eje x + 250px)
movz x1, 60, lsl 0
movz x2, 10, lsl 0
movz x3, 400, lsl 0
movz x4, 42, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

movz x1, 40, lsl 0
movz x2, 7, lsl 0
movz x3, 410, lsl 0
movz x4, 35, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

movz x1, 20, lsl 0
movz x2, 6, lsl 0
movz x3, 420, lsl 0
movz x4, 30, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo


//NUBE extremos Izquierdo: (desplazado a la derecha en el eje x + 100px, y el eje y + 50px)
movz x1, 60, lsl 0
movz x2, 10, lsl 0
movz x3, 50, lsl 0
movz x4, 92, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

movz x1, 40, lsl 0
movz x2, 7, lsl 0
movz x3, 60, lsl 0
movz x4, 85, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

movz x1, 20, lsl 0
movz x2, 6, lsl 0
movz x3, 70, lsl 0
movz x4, 80, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

//NUBE extremo Derecho: (desplazado a la derecha en el eje x + 100px, y el eje y + 50px)
movz x1, 60, lsl 0
movz x2, 10, lsl 0
movz x3, 500, lsl 0
movz x4, 92, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

movz x1, 40, lsl 0
movz x2, 7, lsl 0
movz x3, 510, lsl 0
movz x4, 85, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

movz x1, 20, lsl 0
movz x2, 6, lsl 0
movz x3, 520, lsl 0
movz x4, 80, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

//NUBES ABAJO DERECHA

movz x1, 60, lsl 0
movz x2, 10, lsl 0
movz x3, 145,lsl 0
movz x4, 185, lsl 0
movz w10, 0xD0D0, lsl 0    // Mueve los 16 bits bajos
movk w10, 0x00D0, lsl 16   // Mueve los 8 bits altos (rellena los bits 16–23)
bl rectangulo

movz x1, 40, lsl 0
movz x2, 7, lsl 0
movz x3, 155, lsl 0
movz x4, 178, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

movz x1, 20, lsl 0
movz x2, 6, lsl 0
movz x3, 165, lsl 0
movz x4, 172, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo


//NUBE ABAJO IZQUIERDA

movz x1, 60, lsl 0
movz x2, 10, lsl 0
movz x3, 450,lsl 0
movz x4, 210, lsl 0
movz w10, 0xD0D0, lsl 0    // Mueve los 16 bits bajos
movk w10, 0x00D0, lsl 16   // Mueve los 8 bits altos (rellena los bits 16–23)
bl rectangulo

movz x1, 40, lsl 0
movz x2, 7, lsl 0
movz x3, 460, lsl 0
movz x4, 203, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo

movz x1, 20, lsl 0
movz x2, 6, lsl 0
movz x3, 470, lsl 0
movz x4, 197, lsl 0
movz w10, 0xD0D0, lsl 0
movk w10, 0x00D0, lsl 16
bl rectangulo


	//---------------------------------------------------------------
	// Infinite Loop

InfLoop:
	b InfLoop
