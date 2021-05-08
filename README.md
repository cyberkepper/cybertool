# cybertool

- **cybertool** es una herramienta automatizada para pentesting básico.
- La idea un poco es crear una herramienta que englobe de forma automatizada las enumeraciones reconocimientos básicos de cualquier máquina.
- Automatizar tareas y comandos para agilizar el proceso de análisis inicial de la máquina.
- Incorporar nuevas herramientas y separarlas en menus para distintos tipos de pentesting.

* Esta herramienta esta destinada al Pentesting (Hacking ético) y Cyberseguridad. 

Requisitos previos
========
- Necesitareis tener instalado Kali o Parrot, ya que llevan la mayoría de programas que usamos en el script.

¿Cómo se usa?
======
```bash
./cybertool
```
- La opción 1 es la fase de RECONOCIMIENTO, donde nos pedirá introducir la ip del host remoto, se puede realizar el escaneo de una forma normal o rapida, luego podemos volver a la parte de reconocimiento y reconocer los servicios que estan asociados a los puertos abiertos que hemos encontrado.
- La opción 2 podemos enumerar con dos programas FFUF y Gobuster, si tenemos el puerto 80 abierto 
- La opción 3 nos da información para recordar la ip y los puertos abiertos
- La opción 4 nos da información de los servicios que hemos escaneado previamente.

Próximamente
====== 
- Se irán incorporando mas opciones.
