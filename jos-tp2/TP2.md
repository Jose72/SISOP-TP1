TP2: Procesos de usuario
========================

env_alloc
---------
El metodo de obtencion del identificador de proceso son los siguientes pasos:
1) Toma el identificador del ultimo proceso libre, para no repetir identificadores
2) Al valor anterior le suma 1000 (1 << ENVGENSHIFT)
3) Al resultado anterior le aplica: AND (NOT (cantidad de procesos que se pueden ejecutar)), de esta manera se asegura que a partir del identificador se pueda hallar el proceso dentro del array de procesos, mediante la macro ENVX
4) En caso de ser negativo el valor, se le asigna 1000 (1 << ENVGENSHIFT)
5) Al valor obtenido se le aplica: OR (diferencia entre la direccion del proceso libre y la lista de procesos no libres). _(por que???)_

El id que toma el 1er proceso es el 1000, ya que inicialmente todos los identificadores estan en 0, y que la direccion del primer proceso libre coincide con la de la lista de procesos por el el primer elemento.

*completar con el resto* 

...


env_init_percpu
---------------
La función lgdt escribe hasta un maximo de 6 bytes, dependiendo del tamaño del operando que recive, si son 16 bits movera 5 bytes, si el operando es de 32 bits seran 6 bytes.
Estos bytes son cargados en el GDT register (o GDTR) , un registro de 48 bits que tiene informacion de la Global Descriptor Table (GDT). Los 16 bits mas bajos indican el tamaño de la tabla, mientras que los otros 32 bits dan su direccion en memoria.
...


env_pop_tf
----------

...


gdb_hello
---------

...
