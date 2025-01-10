
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

Para volver en la terminal a la instancia de la máquina virtual de ubuntu:
Lanzamos en el directorio de 'playframework-cloud':
- 😸 En la terminal: `ssh -i /path/to/keypair.pem/DNS_IPv4_publica`. (tener en cuenta que cada vez que inicializamos la instancia, se regenea la DNS Pública)
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

Volvemos otra vez a la máquina virtual.
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
- 😸 Ejecutamos el comando agenda, que escuche en el puerto 80 y lo demás es una particularidad de play con una semilla: `sudo ./bin/agenda -Dhttp.port=80 -Dplay.http.secret.key="9gx9[jnPE>zTDmzAC^p<ETbLBsnljKEqhT1CSDDDYubCw?4^agPJX:2Rz1k2?h<AaUB"`

- 😸 Ahora vamos a la web y ponemos la url: `https://DNS_IPv4_publica`
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
Ya no funcionaria la app en la web. Entonces vamos a hacer que el sistema operativo gestione ese proceso por nosotros, de manera que no tengamos que manualmente arrancar y parar la aplicación cada vez que necesitemos arrancar y parar la máquina virtual sino que sea el sistema operativo que gestione el ciclo de vida de nuestra aplicación por nosotros en esa instancia.

Vamos a configurar nuestra aplicación dentro del sistema de gestión de servicios de Ubuntu que se llama SystemCTL.
- Ponemos: `sudo vim /etc/systemd/system/agenda.servicio` (recordar estamos en la directiva '/home/ubuntu/agenda-1.0-SNAPSHOT')

Y copiamos esta configuración:
'
[Unit]
Description="Agenda Play application"

[Service]
WorkingDirectory=/home/ubuntu/agenda-1.0-SNAPSHOT
ExecStart=/home/ubuntu/agenda-1.0-SNAPSHOT/bin/agenda -Dhttp.port=80 -Dplay.http.secret.key="9gx9[jnPE>zTDmzAC^p<ETbLBsnljKEqhT1CSDDDYubCw?4^agPJX:2Rz1k2?h<AaUB"
ExecStop=/bin/kill -TERM $MAINPID
Type=simple
Restart=always

[Install]
WantedBy=multi-user.target
'

- Guardar en Vim: `:w` y presiona 'Enter'.
- Salir en Vim: `:wq` y presiona 'Enter'.

- Recargar el 'daemon system' de iniciar el servicio:
`sudo systemctl daemon-reload`
`sudo systemctl enable agenda`

- Comprobación del estado del servicio. `sudo systemctl status agenda`
si me da error, la solución es:
`find . -name *.log`
`sudo rm -f ./logs/application.log`
`sudo systemctl start agenda`
`sudo journalctl -f -uagenda`

Y ya deberia de estar escuchando en el puerto 80

- Y entramos en la web, vista tambien anteriormente: `https://DNS_IPv4_publica`
En mi caso: `http://ec2-18-100-62-131.eu-south-2.compute.amazonaws.com/`

Y veriamos otro vez la app desplegada.
Ahora esta aplicacion esta gestionada por el sistema operativo,ahora si mi app se reinicia porque tiene un error,ante un a peticion concreta que produce un error no controlado o lo que sea, el servicio SystemCTL se va a cargar de reiniciarla o si me máquina se reinica por cualquier motivo el servicio va a arrancarla cuando se acabe de nuevo la máquina.

Cortamos la ejecucion en la terminal
Hacemos `sudo systemctl status agenda`

Resultado:
'
● agenda.service - "Agenda Play application"
     Loaded: loaded (/etc/systemd/system/agenda.service; enabled; preset: enabled)
     Active: active (running) since Fri 2025-01-10 08:20:10 UTC; 3min 50s ago
   Main PID: 2735 (java)
      Tasks: 30 (limit: 1078)
     Memory: 330.2M (peak: 331.5M)
        CPU: 16.873s
     CGroup: /system.slice/agenda.service
             └─2735 java -Duser.dir=/home/ubuntu/agenda-1.0-SNAPSHOT -Dhttp.port=80 "-Dplay.http.secret.key=9gx9[jnPE>zTDmzAC^p<>
'

Y vemos como la app sigue funcionando,aunque hallamos cortado la ejecución de la terminal.

- Si nos salimos de la instancia de la máquina virtual: `exit`
La app en la web seguira tambien funcionando sin ningun problema

Volvemos a la instancia de la maquina virtual: ``ssh -i /path/to/keypair.pem/DNS_IPv4_publica``
- Nuestra app usa una BD que esta en memoria, si ahora voy al servicio y lo reinicio: `sudo systemctl restart agenda`
Y hago ahora el `sudo journalctl -f -uagenda`, me vuelve a mostrar la app escuchando en el puerto 80, pero me ha borrado los nombres del listado (ha borrado la BD en memoria),esto solo nos serviria en desarrollo ya que en producción no tenia sentido.

Vamos ahora a conectar nuestra app a una BD mas robusta que cuando se reinicie la app no se pierda.
- Primero lo vamos a hacer en local.
Salimos de la ejecución y de la instancia de la máquina virtual luego `exit`
Vamos a instalar MySQL: `brew install mysql`
Vemos si esta en ejecución: `brew services info mysql`
Si no esta en ejecución lo ponemos en ejecución: `brew services start mysql`
Configuración del usuario (el root usuario): `mysqladmin -u root password 'root'` (no es lo mas conveniente poner la contraseña en texto directo aqui, pero bueno)
Ahora para entrar ponemos: `mysql -u root -p` y nos pedira la contraseña que hemos puesto 'root'
Y ya estamos dentro de MySQL y podemos crear la BD en local.

- BD en MySQL:

Ponemos en MySQL:
'
create database if not exists agenda default character set utf8 collate utf8_general_ci;
use agenda;
create table if not exists Person (id int unsigned not null AUTO_INCREMENT, name VARCHAR(100) NOT NULL, PRIMARY KEY (id) );
'

Ahora hacemos: `show databases;` y saldra entre las demás 'agenda'
Seleccionamos la BD: `use agenda;`
Vemos que no hay ningun usuario en la BD: `select * from Person;`
Y podemos ver como es la tabla Person: `show columns from Person;`

Ahora tenemos que conectar nuestra App a la BD:

Salimos del sql: `exit`
Y vamos al directorio de la 'apps/agenda'

Ponemos en la terminal: `vim conf/application.conf`
- En el Vim ponemos para poder editar `:syntax on` y pulsamos la letra 'i', esto hara que salga el modo -----insert-----
Ahora podemos editar en el Vim, por defecto esta la BD en memoria debemos comentara y descomentar la de MySQL real
'
db {
  #default.driver = org.h2.Driver
  #default.url = "jdbc:h2:mem:play"
  default.driver=com.mysql.cj.jdbc.Driver
  #default.url="jdbc:mysql://root:root@localhost/play_agenda"
  default.url="jdbc:mysql://root:root@localhost/agenda"
  #default.username="root"
  ...
'

Pulsamos el 'Esc' para salir de inserción y `:wq` para guardar y salir
- Y ahora lo ejecuto (en local): `sbt run`

Nos vamos en la web a: `http://localhost:9000/` donde vemos la app y añadimos personas al listado.

Ahora desde otro terminal en la directiva de '/agenda'
Ponemos: `mysql -u root -p`, la contraseña: 'root' y dentro de sql:  `use agenda;` y luego `select * from Person;` y vemos los usuarios añadidos

Ahora si en la terminal donde estoy ejecutando en local, paramos la ejecución y lo volvemos a correr de nuevo `sbt run`, ya no se pierde los usuarios escritos anteriormente.

- Para hacer la BD en producción en AWS, es decir para hacerlo en una BD persistente pero en producción tenemos que crear la BD en AWS.
Tenemos que ir al servicio de UF2, crear y conectarnos a una nueva instancia e instalar y configurar MySQL en esa nueva instancia.

Vamos a utilizar un servicio de BD, en la web AWS
Vamos a la caja de puntos (superior izquierda) --> Base de datos --> RDS (Servicio de BD relacionales administrativo)

Vamos a crear la BD (como hicimos en local antes pero ahora en producción)
Configuración:
- Elegir un método de creación de base de datos: Creación estándar
- Opciones del motor: MySQL
- Edición: Comunidad de MySQL
- Plantillas: Capa gratuita
- Configuración --> Identificador de instancias de bases de datos: database-agenda
- Configuración de credenciales --> Nombre de usuario maestro: admin
- Administración de credenciales: Autoadministrado
- Contraseña maestra: pass1234
- Configuración de la instancia: (por defecto)
- Conectividad: Conectarse a un recurso informático de EC2 --> mi-agenda-servidor (de esta manera ya directamente lo conectamos a nuestra instancia de máquina virtual)
(mucho mas abajo)
- Configuración adicional --> Nombre de base de datos inicial: agenda

En la terminal:
Volvemos a nuestra instancia de la máquina virtual de ubuntu:
Lanzamos en el directorio de 'playframework-cloud':
- En la terminal: `ssh -i /path/to/keypair.pem/DNS_IPv4_publica`. (tener en cuenta que cada vez que inicializamos la instancia, se regenea la DNS Pública)
En mi caso: `ssh -i "/Users/carlosCG/Desktop/3. Cloud Native Applications, Paas e Iaas, Containers/mi-clave.pem" ubuntu@ec2-18-100-59-116.eu-south-2.compute.amazonaws.com`

`cd agenda-1.0-SNAPSHOT/`

`vim conf/application.conf`

En el Vim comentamos la BD en memoria y configuramos la BD en AWS:
'
db {
  #default.driver = org.h2.Driver
  #default.url = "jdbc:h2:mem:play"
  default.driver=com.mysql.cj.jdbc.Driver
  default.url="jdbc:mysql://admin:pass1234@database-agenda.cfy4a64kmibe.eu-south-2.rds.amazonaws.com/agenda"
  #default.url="jdbc:mysql://localhost/agenda"
  #default.username="root"
'

- Donde 'default.url="jdbc:mysql://admin:pass1234@database-agenda.cfy4a64kmibe.eu-south-2.rds.amazonaws.com/agenda"':
* `admin`: nombre de usuario maestro
* `pass1234`: contraseña maestra
* `database-agenda.cfy4a64kmibe.eu-south-2.rds.amazonaws.com`: punto de enlace en la BD (database-agenda) de AWS (mirar en la web)
* `/agenda`: la app

Pulsamos el 'Esc' para salir de inserción y `:wq` para guardar y salir

Para llegar a BD: `telnet punto_enlace_BD Puerto_BD` (el puerto BD al igual que el punto_enlace_BD se ven en la BD (database-agenda) de AWS)
En mi caso: `telnet database-agenda.cfy4a64kmibe.eu-south-2.rds.amazonaws.com 3306`

Ahora tenemos que definir las tablas y todo lo que se encuentra en la DB:

Primero tenemos que instalar 'mySQL' en la instancia de la máquina virtual de ubuntu: `sudo apt install mysql-client-core-8.0`

Arrancamos mySQL: `sudo systemctl start mysql`
Comprobamos el estado de mySQL: `sudo systemctl status mysql`
Iniciamos sesión en mySQL sin su contraseña: `sudo mysql -u root`
Y ya estamos dentro en mySQL.

PERO NO QUEREMOS ESTAR EN ESE MYSQL.

Ponemos `exit` para salir.
Entramos ahora con: `mysql -u nombre_usuario_maestro -h punto_enlace_BD -p`
En mi caso: `mysql -u admin -h database-agenda.cfy4a64kmibe.eu-south-2.rds.amazonaws.com -p` y ponemos la contraseña: 'pass1234' (Contraseña maestra)
Y ya estamos conectados dentro de mi mySQL de la DB (database-agenda) de AWS

`create database if not exists agenda default character set utf8 collate utf8_general_ci;`
`use agenda;`
`create table if not exists Person (id int unsigned not null AUTO_INCREMENT, name VARCHAR(100) NOT NULL, PRIMARY KEY (id) );`

Y ya salimos de mySQL: `exit`

Ahora vamos a reinicar la app para que coga la nueva configuracion que hemos establecido:
`sudo systemctl restart agenda`
`sudo systemctl status agenda`

Vamos en internet a 'http://ec2-18-100-59-116.eu-south-2.compute.amazonaws.com/'
Y añadimos usuarios.

Paramos con 'control + c'

- Entramos ahora con: `mysql -u nombre_usuario_maestro -h punto_enlace_BD -p`
En mi caso: `mysql -u admin -h database-agenda.cfy4a64kmibe.eu-south-2.rds.amazonaws.com -p`
Ponemos la contraseña: 'pass1234' (Contraseña maestra)
En sql:
`use agenda;`
`select * from Person;`
Y hay vemos los registros de los usuarios, en nuestra BD ya real instalada en AWS y en producción.

En resumen: hoy hemos terminado de instalar nuestra aplicación en una máquina virtual (imaginamos como si tuviesemos un servidor físico nuestro y nos conectasemos a ese servidor e instalasemos alli nuestra aplicación), luego hemos modificado nuestro entorno de desarrollo para conectarnos a una BD mñas similar a lo que pueda ser de producción y hemos creado una BD en AWS.

En la próxima clase intentaremos ver comom escalar la app y tener multiples instancias de nuestro servicio agenda corriendo a la vez, pero que anuestro usuarios le parezca que solo hay un servicio corriendo, es decir que el usuario nos puede hacer peticiones a nuestro sistema pero el no sabe cuantas instancias hay corriendo. Y si nos da tiempo haremos esto mismo que hemos echo todos estos dias pero automatizado, es decir el proceso de creación y despliegue de todo esto que estamos haciendo mannualmente, que con solo la ejecución de un comando podamos tener todo corriendo en cuestión de minutos.

Recordar parar la instancia y borrar (no se pueden parar y volver a arrancar) la BD de AWS.


