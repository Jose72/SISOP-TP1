TP2: Procesos de usuario
========================

env_alloc
---------

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
