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
En principio, el proceso liberado asociado a envs[630], tiene el identificador 0x1275. Siguiendo con los pasos antes mencionados, se termina obteniendo el identificador 0x2275 para el nuevo proceso.


env_init_percpu
---------------
La función lgdt escribe hasta un maximo de 6 bytes, dependiendo del tamaño del operando que recive, si son 16 bits movera 5 bytes, si el operando es de 32 bits seran 6 bytes.
Estos bytes son cargados en el GDT register (o GDTR) , un registro de 48 bits que tiene informacion de la Global Descriptor Table (GDT). Los 16 bits mas bajos indican el tamaño de la tabla, mientras que los otros 32 bits dan su direccion en memoria.


env_pop_tf
----------
1-
Luego del movl, %esp apunta al inicio del trap frame.

2-
Antes de iret %esp esta apuntando a tf_eip, entonces 8(%esp) estaria dentro del codigo del enviroment.

3-
El nivel de privilegio esta seteado en el code segment register (CS), en los 2 bits mas bajos.

gdb_hello
---------
Inicialmente los registros al saltar hasta la función env_pop_tf son:

EAX=003bc000 EBX=f01b5000 ECX=f03bc000 EDX=00000205
ESI=00010094 EDI=00000000 EBP=f0117fd8 ESP=f0117fbc
EIP=f0102ca9 EFL=00000092 [--S-A--] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
CS =0008 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]

Teniendo el siguiente Trapframe:
$1 = (struct Trapframe *) 0xf01b5000

Teniendo en cuenta que: sizeof(Trapframe) / sizeof(int) = 17
Obtenemos:

(gdb) x/17x tf
0xf01b5000:	0x00000000	0x00000000	0x00000000	0x00000000
0xf01b5010:	0x00000000	0x00000000	0x00000000	0x00000000
0xf01b5020:	0x00000023	0x00000023	0x00000000	0x00000000
0xf01b5030:	0x00800020	0x0000001b	0x00000000	0xeebfe000
0xf01b5040:	0x00000023

(gdb) x/17x $sp
0xf01b5000:	0x00000000	0x00000000	0x00000000	0x00000000
0xf01b5010:	0x00000000	0x00000000	0x00000000	0x00000000
0xf01b5020:	0x00000023	0x00000023	0x00000000	0x00000000
0xf01b5030:	0x00800020	0x0000001b	0x00000000	0xeebfe000
0xf01b5040:	0x00000023

Como era de esperarse, el stack pointer tiene en sus primeras posiciones el Trapframe.
Teniendo en cuenta la estructura de Trapframe, los primeros dos valores 0x00000023 son de tf_es y tf_ds, los cuales son inicializados en env_alloc. Siguiendo la estructura, 0x00800020 es el valor de tf_eip, que se configura en load_icode y representa la ubicación de la próxima dirección a ejecutar, y 0x0000001b el valor de tf_cs también inicializado en env_alloc. Por último, 0xeebfe000 y el último 0x00000023 son tf_esp y tf_ss respectivamente, ambos inicializados en env_alloc.


Antes de ejecutar la función iret, los registros han cambiado a:

EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000000
ESI=00000000 EDI=00000000 EBP=00000000 ESP=f01b5030
EIP=f0102cb8 EFL=00000096 [--S-AP-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
CS =0008 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]


Luego de ejecutar iret encontramos que el valor del program counter es 0x800020, el cual era el entry que se había seteado en load_icode.

(gdb) p $pc
$2 = (void (*)()) 0x800020

Al cargar los simbolos del programa, el program counter sigue siendo el mismo, pero podemos ver que ya referencia a la función _start, comienzo del programa.

(gdb) symbol-file obj/user/hello
Leyendo símbolos desde obj/user/hello...hecho.
(gdb) p $pc
$4 = (void (*)()) 0x800020 <_start>

En este punto, los registros cambian a:

EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000000
ESI=00000000 EDI=00000000 EBP=00000000 ESP=eebfe000
EIP=00800020 EFL=00000002 [-------] CPL=3 II=0 A20=1 SMM=0 HLT=0
ES =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
CS =001b 00000000 ffffffff 00cffa00 DPL=3 CS32 [-R-]


(gdb) tbreak syscall
=> 0x00800a10 <+29>:	int    $0x30

(qemu) info registers
EAX=00000000 EBX=00000000 ECX=0000000d EDX=eebfde88
ESI=00000000 EDI=00000000 EBP=eebfde40 ESP=eebfde18
EIP=00800a10 EFL=00000096 [--S-AP-] CPL=3 II=0 A20=1 SMM=0 HLT=0
ES =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
CS =001b 00000000 ffffffff 00cffa00 DPL=3 CS32 [-R-]


(gdb) si
aviso: A handler for the OS ABI "GNU/Linux" is not built into this configuration
of GDB.  Attempting to continue with the default i8086 settings.

Se asume que la arquitectura objetivo es i8086
[f000:e05b]    0xfe05b:	cmpl   $0x0,%cs:0x70c8
0x0000e05b in ?? ()

(qemu) info registers
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000663
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
EIP=0000e05b EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 00000000 0000ffff 00009300
CS =f000 000f0000 0000ffff 00009b00

kern_idt
--------

user_evilhello
--------------
