Nombre y apellido 
Integrante 1: Santino Jose Gaiero
Integrante 2: Agustin Heredia Urbinatti
Integrante 3: Pedro Joaquin Cano
Integrante 4: Joaquin Gregorio Aguero Gonzalez


Descripción ejercicio 1: 


Descripción ejercicio 2: Utilizamos la funcion dibujar fondo, dibujar copa y dibujar nube, para poder hacer la animación. Hicimos que las nubes del dibujo se muevan horizontalmente, y la copa suba y baje. Algunas nubes pasan por encima de la bandera, y la copa pasa por encima de las nubes y la bandera. Pusimos el cielo viejo que estabamos usando, ya que el cielo con degradado que utilizams en el ejercicio 1 nos daba problemas a la hora de hacer la animación. Intentamos solucionarlo usando el stack pero no pudimos y lo dejamos con el cielo completamente celeste.


Justificación instrucciones ARMv8:
uDIV:
En el ejericio 1 utilizamos UDIV (Unsigned DIVide) para lograr un fondo de amanecer.
Este en particular está calculando la proporción de avance de cada fila en la pantalla (desde 0 en la parte superior hasta 255 en la parte inferior).
En el codigo x3 despues del uDIV contiene un valor entre 0 y 255, que indica qué tan abajo estás en la pantalla. Osea basicamente convierte la posición vertical (Y) en un valor entre 0 y 255 para despues poder calcular colores intermedios y lograr un buen degradé.

MUL:
Utilizamos mul para multiplicar entre registros, y no el LSL ya que es mas eficiente el LSL para multiplicar por potencias de 2.


