TP2: Multitarea con desalojo
========================

static_assert
-------------
¿cómo y por qué funciona la macro static_assert que define JOS?


env_return
----------
- al terminar un proceso su función umain() ¿dónde retoma la ejecución el kernel? Describir la secuencia de llamadas desde que termina umain() hasta que el kernel dispone del proceso.

- ¿en qué cambia la función env_destroy() en este TP, respecto al TP anterior?


sys_yield
---------
- explicar la salida de make qemu-nox

[00000000] new env 00001000
[00000000] new env 00001001
[00000000] new env 00001002
Hello, I am environment 00001000.
Hello, I am environment 00001001.
Hello, I am environment 00001002.
Back in environment 00001000, iteration 0.
Back in environment 00001001, iteration 0.
Back in environment 00001002, iteration 0.
Back in environment 00001000, iteration 1.
Back in environment 00001001, iteration 1.
Back in environment 00001002, iteration 1.
Back in environment 00001000, iteration 2.
Back in environment 00001001, iteration 2.
Back in environment 00001002, iteration 2.
Back in environment 00001000, iteration 3.
Back in environment 00001001, iteration 3.
Back in environment 00001002, iteration 3.
Back in environment 00001000, iteration 4.
All done in environment 00001000.
[00001000] exiting gracefully
[00001000] free env 00001000
Back in environment 00001001, iteration 4.
All done in environment 00001001.
[00001001] exiting gracefully
[00001001] free env 00001001
Back in environment 00001002, iteration 4.
All done in environment 00001002.
[00001002] exiting gracefully
[00001002] free env 00001002
No runnable environments in the system!


contador_env
------------

- ¿qué ocurrirá con esa página en env_free() al destruir el proceso?

pp->ref es incrementado en el page_insert y luego decrementado en page_decref
pp->ref es 0 entonces va a page_free y causa un panic porque pp->link no es NULL.


- ¿qué código asegura que el buffer VGA físico no será nunca añadido a la lista de páginas libres?

page_init -> inicializar pp->ref a 1 (o cualquier numero mayor)


envid2env
---------
- en JOS, si un proceso llama a sys_env_destroy(0)
Destruye el env actual

- en Linux, si un proceso llama a kill(0, 9)
man 2 kill -> kill(process id, signal)
If pid equals 0, then sig is sent to every process in the process group of the calling process.
signal 9 -> SIGKILL

- JOS: sys_env_destroy(-1)
error?

- Linux: kill(-1, 9)
If pid equals -1, then sig is sent to every process for which the calling  process  has  permission  to  send signals,  except for process 1 (init)
signal 9 -> SIGKILL


dumbfork
---------
- Si, antes de llamar a dumbfork(), el proceso se reserva a sí mismo una página con sys_page_alloc() ¿se propagará una copia al proceso hijo? ¿Por qué?

Depende, el dumbfork copia el espacio de direcciones por encima de UTEXT hasta end, y sys_page_alloc() permite alocar por debajo de UTOP, mientras este entre esos se propagara, si la pagina fue mapeada por debajo de UTEXT (por ej en UTEMP) no sera copiada.

- ¿Se preserva el estado de solo-lectura en las páginas copiadas? Mostrar, con código en espacio de usuario, cómo saber si una dirección de memoria es modificable por el proceso, o no.

No, en duppage cuando se aloca la pagina y se mapea en el dstenv, se hace siempre con permiso de escritura.

- Describir el funcionamiento de la función duppage().

Recibe un envid_t (dstenv) y una va (addr)
-reserva una pagina en el espacio de direcciones de dstenv, y la mapea a la va addr
-hace que la va UTEMP (en el espacio de direcciones del env actual) y mapee a al misma pagina fisica que la va addr
-copia la pagina mapeada en la va addr (en el espacio de direcciones del env actual) a la va UTEMP (en el espacio de direcciones del env actual)
-desmapea la va UTEMP (en el espacio de direcciones del env actual)

De esta forma queda un pagina mapeada a la direccion addr en el espacio de direcciones de dstenv, con el mismo contenido que la pagina mapeada en la direccion addr en el espacio de direcciones del env actual


- Supongamos que se añade a duppage() un argumento booleano que indica si la página debe quedar como solo-lectura en el proceso hijo:
indicar qué llamada adicional se debería hacer si el booleano es true
describir un algoritmo alternativo que no aumente el número de llamadas al sistema, que debe quedar en 3 (1 × alloc, 1 × map, 1 × unmap).
   
Una llamada adicional a sys_page_map

sys_page_map(dstenv, addr, dstenv, addr, PTE_P|PTE_U) 

Se chequea el boleano, si es con escritura, realizamos el duppage que esta ahi, sino hacer sys_page_map(0, addr, dstenv, addr, PTE_P|PTE_U) 
Asi addr mapea a la misma pagina fisica desde los 2 espacios de direcciones, como es solo lectura la comparten.


- ¿Por qué se usa ROUNDDOWN(&addr) para copiar el stack? ¿Qué es addr y por qué, si el stack crece hacia abajo, se usa ROUNDDOWN y no ROUNDUP?



