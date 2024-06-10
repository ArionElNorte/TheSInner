## 1.	Introducción

Un Sistema Operativo. Junto con el hardware, forma la estructura esencial de cualquier sistema informático y por ello es también donde se encuentran las primeras vulnerabilidades.

En el desarrollo de la ciberseguridad es imprescindible el estudio de los SSOO (Sistemas Operativos) y sus vulnerabilidades, y para probar su funcionamiento y posibles formas de mitigación o prevención se utilizan laboratorios.

Para conocer el funcionamiento de estos laboratorios y algunas herramientas relacionadas existen soluciones como Metaesploitable, unas máquinas virtuales previamente configuradas con diferentes servicios vulnerables que además son fáciles de implantar y utilizar. Son muy útiles para iniciarse, pero por desgracia vienen ya cerradas en unas configuraciones específicas y no cuentan con ninguna opción para reconfigurarlas, más allá de las propias configuraciones manuales de Linux. 

¿No sería útil poder crear una de estas máquinas con las vulnerabilidades que nosotros necesitemos fácilmente? Una distribución, sencilla, fácil de instalar y que contase con una herramienta que instalase los servicios que necesitemos y los configurase de forma automática. ¿Podría incluso permitir que se instalasen varias versiones del mismo servicio de forma simultánea? Por si se quisiera hacer un análisis histórico, o una clase de ciberseguridad dedicada a un servicio concreto, o un estudio de vulnerabilidades de versiones desactualizadas por un caso en que se requiriera proteger un sistema anticuado que no se pueda actualizar por requisitos o incompatibilidades.

Esta es la idea de este proyecto.
 
## 2.	Briefing

An Operating System. Together with the hardware, this forms the essential structure of any computer system and is therefore also where the first vulnerabilities are found.

In the development of cybersecurity, the study of OS’s (Operating Systems) and their vulnerabilities is essential, and laboratories are used to test their functioning and possible ways of mitigation or prevention.

To learn how these labs and some related tools work, there are solutions such as Metaesploitable, virtual machines previously configured with different vulnerable services that are also easy to implement and use. They are very useful for getting started, but, unfortunately they come already locked in specific configurations and do not have any option to reconfigure them, beyond the manual Linux configurations. 

Wouldn't it be useful to be able to easily create one of these machines with the vulnerabilities we need? A simple, easy-to-install distribution with a tool to install the services we need and configure them automatically. Could even allow several versions of the same service to be installed simultaneously? In case you wanted to do a historical analysis, or a cybersecurity class dedicated to a specific service, or a vulnerability study of outdated versions for a case in which you need to protect an outdated system that cannot be updated due to requirements or incompatibilities.

This is the idea of this project.
 
## 3.	Alcance del Proyecto

El objetivo de este proyecto es desarrollar una herramienta que permita instalar y configurar hasta el punto funcional al menos un servicio para hacer pruebas en un laboratorio de ciberseguridad. También permitirá instalar de manera que puedan funcionar simultáneamente diferentes versiones del mismo servicio y se encargará de hacer las configuraciones necesarias para que no se solapen durante su ejecución.

Una vez creada esta herramienta se modificará una ISO de un sistema Ubuntu Server para que contenga la propia herramienta y otra serie de configuraciones, con la intención de facilitar la creación de las máquinas al estar ya la herramienta integrada en el sistema y asegurando las compatibilidades entre herramienta y sistema.

El proyecto concluye con un ejercicio práctico de la implantación de este sistema, la instalación y configuración de varias versiones del mismo servicio y un ataque de prueba para mostrar un caso útil.

La memoria de este proyecto también se podrá encontrar en mi perfil de GitHub junto con la ISO, y su hash correspondiente para asegurar su veracidad, y una VDI de la máquina utilizada en la demostración.

## 4.	Precedentes y planteamiento de soluciones alternativas

Durante la investigación para este proyecto he estudiado las opciones que suelen utilizarse para montar este tipo de laboratorios. No he encontrado ninguna que cumpla exactamente con la idea con la que partía en este proyecto. Sin embargo, he querido analizarlas con la posibilidad de replantearlo.

La primera opción que he encontrado ha sido Docker. Gracias a los repositorios de DockerHub la implementación de contenedores en un laboratorio puede facilitar mucho la tarea de instalar diferentes servicios y es bastante versátil. Sin embargo, no me ha llegado a convencer porque se aleja de la sencillez de encontrar todo en una sola ISO. Incluso en los sistemas que tienen las funciones de Docker directamente integradas sin mayores instalaciones, como Fedora CoreOs por ejemplo, tienen la complejidad de aprender a manejar el propio Docker, lo cual considero que es otra traba para el usuario final. Además, aunque como decía hay versatilidad en la elección del contenedor gracias a los repositorios la maleabilidad de cada uno de ellos no es mayor que la de un sistema normal, por lo que al final requiere también hacer muchas configuraciones manuales. Por estas razones, aunque creo que es una buena solución, la descarté.

Por otro lado, herramientas de administración o configuración como Ansible sí que las he visto bastante cercanas a lo que yo buscaba. Aunque estas herramientas suelen instalarse en un dispositivo distinto al que se va a configurar y se usan en remoto también pueden utilizarse localmente. En este caso las descarté principalmente por la complejidad para el usuario. De nuevo considero que implican aprender demasiado para realizar una tarea sencilla, lo que en realidad tiene sentido porque son herramientas que tienen muchas más capacidades de las necesarias para esta función. Por tanto, el problema podría ser que están sobrecualificadas. 

Por último, volví a encontrarme con las Metaesploitable y regresé a la primera opción que me había planteado. Desarrollar un programa o script que funcione con una interfaz sencilla y accesible al usuario. Esta solución permite que la máquina sea configurable completamente desde cero, fácilmente y sin exigir demasiado conocimiento al usuario al centrarse solo en la tarea para la que está dedicada, pidiéndole a este solo la información imprescindible. Esta es la solución que he escogido. Además, me permite adentrarme más en el funcionamiento interno del sistema y los servicios, lo cual me parece muy interesante en un proyecto de investigación y valoro a título personal.

## 5.	Pliego de requisitos

Esta solución puede tener un alcance muy amplio, dado que puede llegar a permitir gran cantidad de servicios y cada uno de ellos se instala (y sobre todo se configura) de forma diferente, por lo que para las dimensiones de este proyecto he definido los requisitos entorno al desarrollo de un prototipo funcional. Una vez hayan sido cumplidos estos requisitos se puede valorar incluir más servicios y otro tipo de mejoras, pero las funcionalidades básicas ya se habrán asegurado. Dicho esto, los requisitos serán los siguientes:


### Pliego de Requisitos para el Desarrollo de una DISTRIBUCIÓN DE LINUX PARA FACILITAR LA CREACIÓN DE LABORATORIOS DE CIBERSEGURIDAD

#### Alcance:
  -	Desarrollo del script/programa.
  -	Integración del script/programa como un comando del sistema.
  -	Creación de una ISO personalizada de Ubuntu Server.
  -	Demostración de la instalación y uso del sistema modificado.
  -	Publicación del proyecto en GitHub.
#### Especificaciones Técnicas
    1.	Desarrollo del Script/Programa
      -	Funcionalidades:
        - Instalación de Servicios:
        -	Permitir la instalación de un servicio especificando la versión y el puerto.
        -	Soportar múltiples instalaciones del mismo servicio en diferentes versiones.
        -	Desinstalación de Servicios:
        -	Permitir la eliminación de cualquier versión instalada del servicio.
        -	Visualización de Servicios:
        -	Mostrar una lista con todos los servicios instalados.
        -	Configuración:
        -	Asegurar que las múltiples versiones del servicio puedan funcionar simultáneamente sin interferencias.
      -	Requisitos Técnicos:
        -	Lenguaje de programación: Python o Bash.
        - Compatibilidad con Ubuntu Server 22.04 LTS.
    2.	Integración como Comando del Sistema
        - Requisitos:
        -	El script/programa debe ser accesible como un comando ejecutable desde cualquier terminal de la máquina.
    3.	Creación de la ISO Personalizada
      -	Proceso:
        -	Crear una imagen ISO personalizada del sistema Ubuntu Server que incluya el script/programa preinstalado y las configuraciones necesarias para su correcto funcionamiento.
    4.	Demostración
      -	Pasos:
        -	Instalar una nueva máquina con la ISO personalizada.
        -	Conectar la máquina a una red.
        -	Utilizar el script/programa para instalar varias versiones de un servicio.
        -	Desinstalar una versión del servicio.
        -	Verificar el funcionamiento simultáneo de las versiones instaladas.
        -	Realizar una prueba de ataque controlado.
      -	Resultados Esperados:
        -	Todas las versiones del servicio deben funcionar correctamente sin conflictos.
        -	Las instalaciones y desinstalaciones deben ser exitosas y detectables desde otra máquina.
        -	La prueba de ataque debe demostrar el correcto funcionamiento y la utilidad de la herramienta.

## 6.	 Diseño de la solución

El diseño de este proyecto se puede dividir en dos grandes partes. El desarrollo de la herramienta y la creación de la ISO (incluyendo en esta parte la instalación de paquetes, la integración del comando en el sistema y en definitiva todas las acciones que deben estar realizadas para que el script y el resto del sistema funcionen bien).

Sinstool

Sinstool (Service INStaller TOOL) es el nombre de la aplicación principal del proyecto. Como curiosidad la coincidencia entre “Sins” (Service INStaler) y “sins”, ( “pecado” en inglés) y su relación con la instalación de “demonios” (los “daemons” de Linux) son lo que da nombre a su vez a la distribución entera de “The Sinner”, “El pecador” en inglés. 

Haciendo pruebas como parte del diseño pude comprobar que, si bien “apt” cuenta con un parámetro para escoger versión, los repositorios de “apt” no tienen más que una versión disponible. Esto me exigió la búsqueda de un nuevo método para instalar los servicios y tras investigar la posibilidad de añadir un repositorio “ppa” y no encontrar ninguno oficial que contase con estas versiones decidí hacerlo por compilador directamente, obteniendo los archivos desde un servidor “ftp” de OpenBSD. Esto complica el proceso de instalación y genera algunas dificultades a la hora del desarrollo, sin embargo, permite una mayor versatilidad para la instalación de diferentes versiones que deban funcionar de manera simultánea.
 
A continuación, se muestra un diagrama de flujo del funcionamiento de Sinstool:

 
Figura 6.1.: Diagrama de flujo de la “Sinstool”.
 

The Sinner

A continuación, se encuentra un diagrama que muestra la ubicación de archivos y directorios importantes para este proyecto junto con una leyenda que incluye los paquetes necesarios para el correcto funcionamiento de la aplicación y el sistema:

 
Figura 6.2.: Árbol de directorios de “The Sinner”.

Paquetes
-	Build-essential: Es un conjunto de herramientas necesarias	 para la construcción de software. Incluye el compilador de “C” y “C++”, así como “make”, y otros utilitarios necesarios para compilar y construir programas a partir de su código fuente.
-	Zlib1g-dev: Este es el paquete de desarrollo para “zlib”, una biblioteca de compresión de datos.
-	Libssl-dev: Este paquete contiene los archivos de desarrollo para OpenSSL. 
-	Autoconf: Es una herramienta para crear scripts de configuración (configure) que son utilizados para preparar el código fuente de software para la compilación.
-	Automake: Es una herramienta que sirve para genera archivos “Makefile”. Son los que permiten la creación de los archivos de instalación en “Sinstool”.
-	Libtool: Es una herramienta para manejar la creación de bibliotecas compartidas
-	Net-tools: Este paquete incluye una colección de utilidades para la administración de redes, como ifconfig, netstat, route, arp, hostname, iptunnel, mii-tool, y nameif.
-	Nmap: Es una herramienta de código abierto para el escaneo de redes.
-	Rlwrap: Es una utilidad que proporciona capacidades de edición de línea y de historial
-	Openvswitch-switch: Es un paquete contiene un software de switch virtual que a veces es requerido por algunas versiones de Ubuntu. Su instalación en este caso es preventiva.
Archivos
-	/usr/bin/sinstool : Es el ejecutable de la herramienta principal de este sistema.
-	/usr/local/bin/ssh$(version) : Es la ruta y el formato en la que se almacenan los ejecutables de las versiones instaladas de OpenSSH.
-	/etc/systemd/system/sshd$(version).service :Es la ruta y el formato de los archivos de unidad de cada una de las versiones instaladas de OpenSSH.
-	/etc/systemd/system/getty@tty.service : Contiene un mandato que hace que root se inicie por defecto siempre que se acceda al terminal “tty1”, es decir siempre que se inice el sistema.
-	/root/.bashrc : Es un archivo que se ejecuta siempre al iniciar sesión “root”. Lo utilizo para que se acceda automáticamente a “Sinstool” nada más iniciar y para instalar los paquetes necesarios y establecer la contraseña la primera vez que inicia. 
Directorios
-	/usr/local/etc/openssh-$(version) : Es la ruta y el formato en la que se almacenan los directorios principales de cada versión de OpenSSH instalada.
-	/var/log/sinstool : Es el directorio que almacena los logs que se crean durante la ejecución de “Sinstool”
-	/tmp/sinswd : Es el directorio de trabajo de “Sinstool”. “wd” significa en este caso “Working Directory”.
