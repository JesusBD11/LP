# Interprete Logo3D

Este zip incluye:

   -Un fichero logo3d.py con el programa principal del interprete.

   -Un fichero logo3d.g con la gramática del LP.

   -Un fichero visitor.py con el visitor de l'AST.

   -Un fichero turtle3d.py que contiene la clase Turtle3D.

   -Una carpeta con diferentes Juegos de prueba.   





## Installation

Use the package manager [pip3](https://pip.pypa.io/en/stable/) to install vpython.

```bash
pip3 install vpython
```

## Ejecutar

Para ejecutar el programa debemos invocarlo con la siguiente comanda:

```bash
python3 logo3d.py programa.l3d
```

Siendo "programa.l3d" el código de los programas en Logo3D

Al ejecutar la comanda, dependiendo del fichero y del programa que sea, tendremos que estar atentos a la consola por si el programa requiere de inputs por parte del usuario.

Se ejecutará por defecto la función main al invocar al programa.

Toda función debe ser declarada antes del main.

## Juegos de prueba

El zip incluye varios juegos de prueba. Por ejemplo podemos ver en el fichero "test3.l3d" que una excepción al declarar un procedimiento ya existente. 

Otro ejemplo de excepción lo vemos en el fichero "test2.l3d", donde  si el segundo parámetro que introducimos es un cero, saltará una excepción al hacer un división por cero.


