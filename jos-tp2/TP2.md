TP2: Procesos de usuario
========================

env_alloc
---------
El método de obtención del identificador de proceso son los siguientes pasos:
1) Toma el identificador del último proceso libre, para no repetir identificadores
2) Al valor anterior le suma 0x1000 (1 << ENVGENSHIFT)
3) Al resultado anterior le aplica: AND (NOT (cantidad de procesos que se pueden ejecutar)), de esta manera se asegura que a partir del identificador se pueda hallar el proceso dentro del array de procesos, mediante la macro ENVX
4) En caso de ser negativo el valor obtenido hasta el momento, se reinicia asignandole 0x1000 (1 << ENVGENSHIFT)
5) Por último se le aplica: OR (diferencia entre la dirección del proceso libre y la lista de procesos no libres). 

1-
El id que toma el primer proceso es el 0x1000, ya que inicialmente todos los identificadores libres están en 0, y que la dirección del primer proceso libre coincide con la de la lista de procesos por el el primer elemento.
El siguiente proceso tendra asignado el 0x1001, ya que inicialmente todos los identificadores libres están en 0, y la diferencia entre la dirección del proceso libre y la lista de procesos no libres es 1, ya que sólo fue asignado un proceso hasta ahora.
De la misma manera se pueden obtener los siguientes: 0x1002, 0x1003, 0x1004.

2-
En principio, el proceso liberado, asociado a envs[630], tiene el identificador 0x1275. Al finalizar el paso 3 tenemos el valor 0x275, por lo que el identificador final para el nuevo proceso será 0x275.

????? Revisar!!!


env_init_percpu
---------------
La función lgdt escribe hasta un maximo de 6 bytes, dependiendo del tamaño del operando que recive, si son 16 bits movera 5 bytes, si el operando es de 32 bits seran 6 bytes.
Estos bytes son cargados en el GDT register (o GDTR) , un registro de 48 bits que tiene informacion de la Global Descriptor Table (GDT). Los 16 bits mas bajos indican el tamaño de la tabla, mientras que los otros 32 bits dan su direccion en memoria.


env_pop_tf
----------

...


gdb_hello
---------
...
