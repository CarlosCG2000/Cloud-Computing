
# Cloud Native Applications, Paas e Iaas, Containers

## DÍA 1. 08/01/25
ENLACES (4):

TEORÍA: `https://migue.github.io/playframework-cloud/manual/instance/` ✅

Ó EN LOCAL: `http://127.0.0.1:8000/play-aws/` ✅

12 FACTORES (TEORÍA): `https://12factor.net/es/` ✅

ARRANQUE SERVIDOR: `http://localhost:9000/` ✅

AMAZON WEB SERVICE: `https://aws.amazon.com/es/` ✅

### 1. ¿Qué vamos a hacer en esta asignatura?
Como construir aplicaciones normalmente de Backend que no se ejecuten en el móvil sino en la nube.
En la anterior asignatura vimos una app que ofrece una serie de servicios de Endspoints o un Api para poder consumir o bien desde el móvil o desde cualquier otra parte,
lo que vamos a hacer es completar esa app.

Básicamente vamos a coger la app una vez ya la tenemos desarrollada (visto anterior asignatura) y desplegarla, lo que significa ponerla a funcionar en un sistema de producción, es decir en un sistema real.

Vamos a  aprender una serie de buenas prácticas que han de tenerse en cuenta cuando desplegamos aplicaciones y esta aplicación que veremos en esta asignatura va a permitirnos la introducción del mundo del Cloud Computing. Vamos a coger nuestra aplicación y desplegarla en un entorno de Cloud, de manera que una vez que trabajemos tengamos estos ciertos conocimientos en el mundo de sistemas o de como pongo en marcha mi aplicación.

La estructura de la asignatura:
1. Vamos a ver un manifesto (o manual) de unas 12 buenas prácticas.
12 FACTORES (TEORÍA): `https://12factor.net/es/`: entender cuales son y porque las tenemos que tener en cuenta a la hora de desplegar nuestra aplicación en entornos de Cloud Computing, pero realmente aplican para cualquier entorno.

2. Vamos a utilizar una app ya construida por el profesor (Miguel Angel) y paso a paso vamos a ver como desplegar esa aplicación.
- Simular nuestro entorno de desarrollo en nuestro ordenador.
- Desplegar la app en un proovedor Cloud, en este caso Amazon Web Service `https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1`
- Y paso a pone desde una interfaz de usuario vamos a ver que cosas tenemos que tener en cuenta para desplegar nuestra aplicación.
- Una vez tengamos todo eso, vamos a aprender a automatizar todo ese proceso y en lugar de realizar esa tarea manual de ir paso a paso a través de una interfaz de usuario vamos a usar herramientas de infractrustura como código para automatizar los despligues y realizar el mismo despliegue que hacemos de manera manual hacer de manera automatica sin mas que ejecutando uno o dos scripts.

La evaluación:
Vamos a construir los dos scripts que permiten automatizar todo el proceso en el que vosotros desplegais la aplicación que construis para la anterior asignatura y lo que se van a tener que entregar esos dos scripts (a parte del video que se obliga en el máster).

### 2. Información que se nos da (es este proyecto se encuentra en mi carpeta `3. Cloud Native Applications, Paas e Iaas, Containers/playframework-cloud-main`)
1. 'Playframework-cloud-main/docs': se encuentran las presentaciones básicamente es lo mismo que viene en la página web: `https://migue.github.io/playframework-cloud/manual/instance/`, pero en vez de tenerlo en la nube esta en local por si no tenemos internet, etc.

* Para poner en marcha la presentación en local:
Me redirigo a la directiva del proyecto 'playframework-cloud-main' (este proyecto)
- Creo un entorno virtual: `python3 -m venv my_env`
- Activa el entorno virtual: `source my_env/bin/activate`
- Instala MkDocs (dentro del entorno virtual): `pip install mkdocs`
- Instala el Mkdocs-material (dentro del entorno virtual): `pip install mkdocs-material`
- Ejecutar el servidor de desarrollo: `mkdocs serve`
Navegar a `http://127.0.0.1:8000/play-aws/`

- Salir del entorno virtual: `deactivate`
- Volver a entrar en el entorno virtual (desde el directorio donde se creo dicho entorno virtual, mismo punto que el 2.): `source my_env/bin/activate`
- Borrar para siempre el entorno virtual: `rm -rf my_env` (o bien borrar la carpeta directamente 'my_env')

2. 'Playframework-cloud-main/apps/agenda' es la aplicación (donde esta el README.MD) y donde se encuentra todo lo relacionado con la app ya desarrolla por el profesor.
Es una pequeña aplicacion que vamos a usar como base o nucleo de todas las cosas que vamos a aprender. Las cosas no vana estar ligadas a la aplicación, es decir no son particulares de ninguna aplicación, sino que son conceptos generales para constuir y desplegar la app en entornos Cloud. Esta app esta par ano tener que desarrollar una aplicación desde 0 y ya poder utilizar directamente la app y podernos centrar en el despliege.

### 3. Manifiesto de buenas prácticas (12 factor)
Página web: `https://12factor.net/es/`

- I. Código base (Codebase): Un código base sobre el que hacer el control de versiones y multiples despliegues
- II. Dependencias: Declarar y aislar explícitamente las dependencias
- III. Configuraciones: Guardar la configuración en el entorno (variables de entorno)
- IV. Backing services: Tratar a los “backing services” como recursos conectables
- V. Construir, desplegar, ejecutar: Separar completamente la etapa de construcción de la etapa de ejecución
- VI. Procesos: Ejecutar la aplicación como uno o más procesos sin estado
- VII. Asignación de puertos: Publicar servicios mediante asignación de puertos
- VIII. Concurrencia: Escalar mediante el modelo de procesos
- IX. Desechabilidad: Hacer el sistema más robusto intentando conseguir inicios rápidos y finalizaciones seguras
- X. Paridad en desarrollo y producción: Mantener desarrollo, preproducción y producción tan parecidos como sea posible
- XI. Historiales: Tratar los historiales como una transmisión de eventos
- XII. Administración de procesos: Ejecutar las tareas de gestión/administración como procesos que solo se ejecutan una vez

### 4. Despliegue de la app en local
Seguir los pasos `https://migue.github.io/playframework-cloud/manual/instance/`

Nos vamos al directorio de la agenda: 'playframework-cloud/apps/agenda'

* Instalar Homebrew, el gestor de paquetes para macOS y Linux:
- Ejecuta el instalador:`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Configurar el PATH manualmente (Apple Silicon (arm64)):
`echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc`
`source ~/.zshrc`

* Instalar sbt: `brew install sbt`
- Para ejecutar: `sbt clean run`

Ya esta arranca la aplicación y puesta a escuchar en el puerto 9000: `http://localhost:9000/`

Simplemente es un listado donde se pueden visualizar nombres y añadirlo a través de un formulario con un input text y un button submit. Tiene una BD en memoria que si se mata la aplicación y se vuelve a correr desaparecen los nombres antiguos de la lista.

### 5. La interfaz gráfica de AWS para crear una máquina virtual
La url para acceder: `https://eu-south-2.console.aws.amazon.com/console/home?region=eu-south-2#`

El primer servicio que vamos a realizar es desplegar nuestra app en una instancia de Amazon EC2 (servicios virtuales en la nube), que nos da la capacidad de crear máquinas virtuales:
1. Icono de cuadrado con puntitos (superior-izquierda) --> Informática --> EC2
2. Lanzar instancia:
- Nombre de la instancia: 'mi-agenda-servidor'
- Imágenes de aplicaciones y sistemas operativos: 'Ubuntu'
- Tipo de instancia: 't3.micro' (gratuita)
- Par de claves (inicio de sesión): --> Nombre: 'mi-clave' --> Tipo de par de claves: 'RSA' --> Formato de archivo de clave privada: 'pem' (si es MAC/Linux, sino .ppk)
- Configuraciones de red: (POR DEFECTO)
- Configuraciones almacenamiento: (POR DEFECTO)

* Una vez creada vamos a conectarnos a esa máquina virtual en la terminal:
Estamos en el directorio de agenda ('playframework-cloud/apps/agenda')
- En la terminal: `ssh -i /path/to/keypair.pem/DNS_IPv4_publica`.
En mi caso: `ssh -i /Users/carlosCG/Desktop/3. Cloud Native Applications, Paas e Iaas, Containers/mi-clave.pem/ubuntu@ec2-51-92-1-10.eu-south-2.compute.amazonaws.com`

- Dar permisos solo al propietario de ese archivo lo pueda leer: `chmod 700 /path/to/keypair.pem`.
En mi caso: `chmod 700 /Users/carlosCG/Desktop/3. Cloud Native Applications, Paas e Iaas, Containers/mi-clave.pem`

* Una vez dentro de la máquina con ubuntu, podemos ver varias cosas como:
- La descripción: `uname -a`
- Toda la información de l a máquina virtual: `cat /proc/cpuinfo`
- Toda la información de la memoria: `cat /proc/memoinfo`

Instalación del software necesario, el tiempo de ejecución de Java (dentro de la máquina virtual de ubuntu):
- `sudo apt-get update && sudo apt upgrade`
- `sudo apt-get install openjdk-21-jdk-headless unzip`

Recordar, siempre cuando lo dejemos tenemos que ir a la página web de AWS y tenemos que detener nuestra instancia.

## DÍA 2. 09/01/25
Volvemos a inicializar nuestra instancia en la página web en AWS.

Para volver en la terminal a la amquina virtual de ubuntu:
Lanzamos en el directorio de 'playframework-cloud':
- En la terminal: `ssh -i /path/to/keypair.pem/DNS_IPv4_publica`. (tener en cuenta que cada vez que inicializamos la instancia, se regenea la DNS Pública)
En mi caso: `ssh -i "/Users/carlosCG/Desktop/3. Cloud Native Applications, Paas e Iaas, Containers/mi-clave.pem" ubuntu@ec2-18-100-153-36.eu-south-2.compute.amazonaws.com`

Y ya estariamos en la maquina virtual en la terminal de nuevo como ayer.

Tenemos que ir a la aplicación saliendo ahora de la máquina virtual: `exit`
Vamos al directorio '/apps/agenda'
- Vamos a crear el entregable de nuestra aplicación: `sbt dist`
Y comprobamos que hemos creado el archivo zip: `ls -l target/universal/agenda-1.0-SNAPSHOT.zip`
Nos devuelve: '-rw-r--r--@ 1 carlosCG  staff  66671325 Jan  9 23:01 target/universal/agenda-1.0-SNAPSHOT.zip'

- Este archivo zip contiene todo lo necesario de nuestra app para ejecutar mi app: `unzip -l target/universal/agenda-1.0-SNAPSHOT.zip`

Vamos a al directorio 'playframework-cloud'
- Copiamos el archivo creado del zip en la maquina virtual: `scp -i /path/to/keypair.pem target/universal/agenda-1.0-SNAPSHOT.zip ubuntu@DNS_IPv4_publica:/home/ubuntu`
En mi caso: `scp -i "/Users/carlosCG/Desktop/3. Cloud Native Applications, Paas e Iaas, Containers/mi-clave.pem" apps/agenda/target/universal/agenda-1.0-SNAPSHOT.zip ubuntu@ec2-18-100-153-36.eu-south-2.compute.amazonaws.com:/home/ubuntu`

Volvemos a la máquina virtual.
- En la terminal otra vez: `ssh -i /path/to/keypair.pem/DNS_IPv4_publica`.
En mi caso: `ssh -i "/Users/carlosCG/Desktop/3. Cloud Native Applications, Paas e Iaas, Containers/mi-clave.pem" ubuntu@ec2-18-100-153-36.eu-south-2.compute.amazonaws.com`

- Vemos que si hacemos `ls -l`
Obtenemos el archivo: '-rw-r--r-- 1 ubuntu ubuntu 66671325 Jan  9 22:08 agenda-1.0-SNAPSHOT.zip'

- Tenemos que descomprimir el zip: `unzip agenda-1.0-SNAPSHOT.zip`
- Vemos que si hacemos `ls -l`
'total 65116
drwxrwxr-x 7 ubuntu ubuntu     4096 Jan  9 22:20 agenda-1.0-SNAPSHOT
-rw-r--r-- 1 ubuntu ubuntu 66671325 Jan  9 22:08 agenda-1.0-SNAPSHOT.zip'

Nos metemos en la directiva '/home/ubuntu/agenda-1.0-SNAPSHOT': `cd agenda-1.0-SNAPSHOT`
- Ejecutamos el comando agenda, que escuche en el puerto 80 y lo demás es una particularidad de play con una semilla: `sudo ./bin/agenda -Dhttp.port=80 -Dplay.http.secret.key="9gx9[jnPE>zTDmzAC^p<ETbLBsnljKEqhT1CSDDDYubCw?4^agPJX:2Rz1k2?h<AaUB"`

- Ahora vamos a la web y ponemos la url: `https://DNS_IPv4_publica`
En mi caso: `http://ec2-18-100-153-36.eu-south-2.compute.amazonaws.com/`

No va a funcionar porque el tráfico esta capado a nuestra instancia por defecto, por ello en la web de AWS:
En mi instancia vamos a la caracteristica de 'Seguridad' y a 'Grupos de seguridad' (en mi caso `sg-02f30ee61a9e8fe61 (launch-wizard-1)`). Esto es un conjunto de reglas que permiten el tráfico a nuestra instancia. Le pulsamos al  `sg-02f30ee61a9e8fe61 (launch-wizard-1)` y en la nueva pagina en 'Reglas de entrada' le damos a 'Editar reglas de entrada' y añadimos una nueva regla: donde pongamos la opción HTTP, en el puerto 80 y en cualquier origen 0.0.0.0/0.

- Para para el proceso, buscamos el pip de agenda: `ps aux | grep agenda`
Y matamos dicho pip (solo si existe, si no pasamos a la siguiente linea): `kill -9 <PID>`
Elimina el archivo RUNNING_PID para que la aplicación pueda iniciarse nuevamente: `rm -f /home/ubuntu/agenda-1.0-SNAPSHOT/RUNNING_PID`

- Ahora ponemos lo visto anteriormente para arrancar: `sudo ./bin/agenda -Dhttp.port=80 -Dplay.http.secret.key="9gx9[jnPE>zTDmzAC^p<ETbLBsnljKEqhT1CSDDDYubCw?4^agPJX:2Rz1k2?h<AaUB"`
- Y entramos en la web, vista tambien anteriormente: `https://DNS_IPv4_publica`
En mi caso: `http://ec2-18-100-153-36.eu-south-2.compute.amazonaws.com/`
Ya funcionaria la app en la web.

¿Qué pasa si paro el proceso en la terminal?
Ya no funcionaria la app en la web. Entonces vamos a hacer que el sistema operativo gestione ese proceso por nosotros, de manera que no tengamos qaue manualmente arrancar y parar la aplicación cada vez que necesitemos arrancar y parar la máquina virtual sino que sea el sistema operativo que gestione el ciclo de vida de nuestra aplicación por nosotros en esa instancia.

MIN 41:30