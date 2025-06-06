	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

        .include "auxiliares.s"

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------
/* ESTO PARA QUE PINTE EL FUCSIA lo saco por el momento.
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
*/
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

//--- DIBUJAMOS LA IMAGEN ---//
bl dibujar_fondo



//--- ANIMACIÓN --
movz x15, 298, lsl 0
movz x16, 250, lsl 0     // Posición inicial de la copa
movz x29, 0, lsl 0       // Empezamos subiendo la copa
movz x17, 60, lsl 0      // Posición inicial de la nube
movz x18, 42, lsl 0

bucle_animacion:

    bl dibujar_fondo // llamamos a dibujar fondo en cada iteración para que no dejen "estela" aquello que se vaya a mover

    // --- Restaurar posición base de nubes ---
    mov x17, x21                     // x17 va a tomar la posicion base de x de las nubes
    mov x18, x22                     // x18 va a tomar la posicion base de y de las nubes


    // --- Empezamos a dibujar las nubes (las movemos de posicion con add o sub) ---
    // --- Además en cada iteración, comparamos x17 (X de cada nube) con 640 para ver si llego al final de la pantalla, en caso de no haber llegado, dibuja la nube en la                   posición que haya en x17, en caso de haber llegado a 640, le restamos 640 a x17, para que la nube vuelva a aparecer por la izquierda de la pantalla. (el 640 es editable, consideramos que en 640 quedaba bien)

    // --- Nube 1  ---
    cmp x17, 640
    b.lt nube1_dibujar
    sub x17, x17, 640
nube1_dibujar:
    bl dibujar_nube

    // --- Nube 2  ---
    add x17, x17, 100
    add x18, x18, 80
    cmp x17, 640
    b.lt nube2_dibujar   
    sub x17, x17, 640
nube2_dibujar:
    bl dibujar_nube

    // --- Nube 3  ---
    add x17, x17, 150
    sub x18, x18, 50
    cmp x17, 640
    b.lt nube3_dibujar
    sub x17, x17, 640
nube3_dibujar:
    bl dibujar_nube

    // --- Nube 4  ---
    sub x17, x17, 350
    add x18, x18, 50
    cmp x17, 640
    b.lt nube4_dibujar
    sub x17, x17, 640
nube4_dibujar:
    bl dibujar_nube

    // --- Nube 5  ---
    add x17, x17, 450
    cmp x17, 640
    b.lt nube5_dibujar
    sub x17, x17, 640
nube5_dibujar:
    bl dibujar_nube

    // --- Nube 6 ---
    sub x17, x17, 355
    add x18, x18, 93
    cmp x17, 640
    b.lt nube6_dibujar
    sub x17, x17, 640
nube6_dibujar:
    bl dibujar_nube

    // --- Nube 7 ---
    add x17, x17, 305
    add x18, x18, 25
    cmp x17, 640
    b.lt nube7_dibujar
    sub x17, x17, 640
nube7_dibujar:
    bl dibujar_nube

    // --- Nube 8  ---
    sub x17, x17, 100
    sub x18, x18, 38
    cmp x17, 640
    b.lt nube8_dibujar
    sub x17, x17, 640
nube8_dibujar:
    bl dibujar_nube

    // --- Movimiento nubes ---
    add x21, x21, 1      // las nubes apareceran 1 x a la derecha

    // Para el rebote de la copa, buscamos un registro (x29) en donde podamos guardar si la copa esta subiendo (x29 = 0), o esta bajando (x29 = 1) , y a partir de ahi hacer    el ciclo

    // --- Rebote de la copa ---
    cmp x29, 0              // Compara si la copa esta subiendo
    b.ne bajar_copa        // Si no es igual a 0, salta a bajar_copa, sino sigue normal

    sub x16, x16, 1         // Resta 1 al eje Y de la copa, por lo tanto sube
    cmp x16, 0              
    b.gt continuar_copa     // Mientras x16 sea distinto de 0 (superior de la pantalla), salta a continuar_copa y sigue.
    mov x29, 1              // Si llego al superior de la pantalla, queremos que empieze a bajar, por lo tanot ponemos x29 en 1
    b continuar_copa

bajar_copa:
    add x16, x16, 1         // Empieza a bajar la copa
    cmp x16, 240           // Fijamos 240 como el limite inferior hasta dnde queremos que baje, x16 sea menor que 240, va sibujando la copa en bajada
    b.lt continuar_copa
    mov x29, 0              // Llego al tope inferior, ponemos x29 en 0 para que sube
    
continuar_copa:
    bl dibujar_copa

    // --- Delay (se pueden editar las constantes para cambiar el tiempo de delay y la velocidad) ---
    movz x27, 170, lsl 0
    delay_externo:
        movz x28, 50000, lsl 0
    delay_interno:
        subs x28, x28, 1
        b.ne delay_interno
        subs x27, x27, 1
        b.ne delay_externo

    b bucle_animacion

	//---------------------------------------------------------------
	// Infinite Loop

InfLoop:
	b InfLoop
