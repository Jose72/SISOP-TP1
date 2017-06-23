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
(en algun lado tiene que estar salteando la pagina porque sino al entrar al page_decref la agregaria a las paginas libres -> imposhibleeee)

- ¿qué código asegura que el buffer VGA físico no será nunca añadido a la lista de páginas libres?
page_init -> entre las direcciones que saltea se encuentra la del buffer VGA

