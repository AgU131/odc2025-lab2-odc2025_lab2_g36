Nombre y apellido 
Integrante 1: Santino Jose Gaiero
Integrante 2: Agustin Heredia Urbinatti
Integrante 3: Pedro Joaquin Cano
Integrante 4: Joaquin Gregorio Aguero Gonzalez


Descripción ejercicio 1: 


Descripción ejercicio 2:


Justificación instrucciones ARMv8:
En el ejericio 1 utilizamos UDIV (Unsigned DIVide) para lograr un fondo de amanecer.
Este en particular está calculando la proporción de avance de cada fila en la pantalla (desde 0 en la parte superior hasta 255 en la parte inferior).
En el codigo x3 despues del uDIV contiene un valor entre 0 y 255, que indica qué tan abajo estás en la pantalla. Osea basicamente convierte la posición vertical (Y) en un valor entre 0 y 255 para despues poder calcular colores intermedios y lograr un buen degradé.


