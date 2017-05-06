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
1-
Luego del mvl, %esp apunta al inicio del trap frame.

2-
Antes de iret %esp esta apuntando a tf_eip, entonces 8(%esp) estaria dentro del codigo del enviroment.

3-
El nivel de privilegio esta seteado en el code segment register (CS), en los 2 bits mas bajos.

gdb_hello
---------
(qemu) info registers
EAX=003bc000 EBX=f01b5000 ECX=f03bc000 EDX=00000205
ESI=00010094 EDI=00000000 EBP=f0117fd8 ESP=f0117fbc
EIP=f0102ca9 EFL=00000092 [--S-A--] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
CS =0008 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]
SS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
DS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
FS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
GS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
LDT=0000 00000000 00000000 00008200 DPL=0 LDT
TR =0028 f0174a20 00000067 00408900 DPL=0 TSS32-avl
GDT=     f011a320 0000002f
IDT=     f0174200 000007ff
CR0=80050033 CR2=00000000 CR3=003bc000 CR4=00000000
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000 
DR6=ffff0ff0 DR7=00000400
EFER=0000000000000000
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80

(gdb) p tf
$1 = (struct Trapframe *) 0xf01b5000

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

(qemu) info registers
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000000
ESI=00000000 EDI=00000000 EBP=00000000 ESP=f01b5030
EIP=f0102cb8 EFL=00000096 [--S-AP-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
CS =0008 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]
SS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
DS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
FS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
GS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
LDT=0000 00000000 00000000 00008200 DPL=0 LDT
TR =0028 f0174a20 00000067 00408900 DPL=0 TSS32-avl
GDT=     f011a320 0000002f
IDT=     f0174200 000007ff
CR0=80050033 CR2=00000000 CR3=003bc000 CR4=00000000
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000 
DR6=ffff0ff0 DR7=00000400
EFER=0000000000000000
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80


(gdb) p $pc
$2 = (void (*)()) 0x800020


(gdb) symbol-file obj/user/hello
¿Cargar una tabla de símbolos nueva desde «obj/user/hello»? (y or n) y
Leyendo símbolos desde obj/user/hello...hecho.
(gdb) p $pc
$4 = (void (*)()) 0x800020 <_start>


(qemu) info registers
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000000
ESI=00000000 EDI=00000000 EBP=00000000 ESP=eebfe000
EIP=00800020 EFL=00000002 [-------] CPL=3 II=0 A20=1 SMM=0 HLT=0
ES =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
CS =001b 00000000 ffffffff 00cffa00 DPL=3 CS32 [-R-]
SS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
DS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
FS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
GS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
LDT=0000 00000000 00000000 00008200 DPL=0 LDT
TR =0028 f0174a20 00000067 00408900 DPL=0 TSS32-avl
GDT=     f011a320 0000002f
IDT=     f0174200 000007ff
CR0=80050033 CR2=00000000 CR3=003bc000 CR4=00000000
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000 
DR6=ffff0ff0 DR7=00000400
EFER=0000000000000000
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80


(gdb) tbreak syscall
=> 0x00800a10 <+29>:	int    $0x30

(qemu) info registers
EAX=00000000 EBX=00000000 ECX=0000000d EDX=eebfde88
ESI=00000000 EDI=00000000 EBP=eebfde40 ESP=eebfde18
EIP=00800a10 EFL=00000096 [--S-AP-] CPL=3 II=0 A20=1 SMM=0 HLT=0
ES =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
CS =001b 00000000 ffffffff 00cffa00 DPL=3 CS32 [-R-]
SS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
DS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
FS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
GS =0023 00000000 ffffffff 00cff300 DPL=3 DS   [-WA]
LDT=0000 00000000 00000000 00008200 DPL=0 LDT
TR =0028 f0174a20 00000067 00408900 DPL=0 TSS32-avl
GDT=     f011a320 0000002f
IDT=     f0174200 000007ff
CR0=80050033 CR2=00000000 CR3=003bc000 CR4=00000000
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000 
DR6=ffff0ff0 DR7=00000400
EFER=0000000000000000
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000 XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000


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
SS =0000 00000000 0000ffff 00009300
DS =0000 00000000 0000ffff 00009300
FS =0000 00000000 0000ffff 00009300
GS =0000 00000000 0000ffff 00009300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008b00
GDT=     00000000 0000ffff
IDT=     00000000 0000ffff
CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000 
DR6=ffff0ff0 DR7=00000400
EFER=0000000000000000
FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000 XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000 XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000 XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000 XMM07=00000000000000000000000000000000
(qemu) 














