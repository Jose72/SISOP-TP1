TP1: Memoria virtual en JOS
===========================

page2pa
-------
Para obtener la pagina fisica se hace: (pp - pages) << PGSHIFT
Donde pp es el puntero a la informacion de la pagina (struct PageInfo), pages es un array
donde se guarda el estado de cada pagina fisica.
PGSHIFT es una constante de 12.
page2pa, resta al puntero del que queremos obtener su pagina fisica (pp), la direccion de inicio del array
de paginas fisicas (pages). Esto es debido a que 'pages' se encuentra en la mismo valor de direccion virtual
que fisica, por lo tanto esta indicando la base de donde comienzan ellas. De esta manera, restando esa base,
se obtiene un valor que cae en la pagina fisica que queremos obtener. Luego se hace un shift left de 12 para obtener el inicio de la pagina en si.

boot_alloc_pos
--------------

...


page_alloc
----------

...


