
# Cloud Native Applications, Paas e Iaas, Containers

## DIA 1. 08/01/25
ENLACES (4):

TEORÍA: `https://migue.github.io/playframework-cloud/manual/instance/` 
Ó EN LOCAL: `http://127.0.0.1:8000/play-aws/` ✅

12 FACTORES (TEORÍA): `https://12factor.net/es/` ✅

ARRANQUE SERVIDOR: `http://localhost:9000/`

AMAZON WEB SERVICE: `https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1` ✅


### ¿Qué vamos a hacer en esta asignatura?
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

### Información que se nos da (es este proyecto se encuentra en mi carpeta `3. Cloud Native Applications, Paas e Iaas, Containers/playframework-cloud-main`)
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

### Manifiesto de buenas prácticas (12 factor)
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
