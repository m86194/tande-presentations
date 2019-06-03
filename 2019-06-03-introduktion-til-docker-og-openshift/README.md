[//]: # (use pandoc to convert to presentation - https://pandoc.org/MANUAL.html#pandocs-markdown)

# Docker og OpenShift

En hurtig introduktion til Docker og OpenShift.

Thorbjørn Ravn Andersen

<tande@tdc.dk>

2019-06-03

---

# Baggrundshistorie

Behov for at idriftsætte en applikation:

* Isolering fra verden (eks: CSC mainframe)
* Skalerbarhed udover at købe større maskine
* Økonomi i ressourceforbrug
* Mest mulig automatisering




# Hvad er Docker?

* Virtualiseringsniveau:  Container 
* Filsystem i lag med _forskelle_ (plads, deling, kun øverste skrivbart)
* Hel "maskine" i et docker image på fx dockerhub
* Tilbyder afvikling i noget der LIGNER en Linuxmaskine men deler kerne med værten gennem emuleringslag.

---

# Hvad er OpenShift?

OpenShift er Redhats produktudgave af et Kubernetes cluster.  
* Webinterfaces til alle faciliteter.
* `oc` kommandolinieværktøj til at tale med openshift instanserne (TEST/PROD)


# Hvad er Kubernetes

Googles bud på skalerbar skyløsning for masserne.  Har kritisk masse.

* Vores kode kører i _pods_ (identiske, kan genstartes vilkårligt)
* _Services_ giver load-balancing af pods bag en URL.
 


Væg-til-væg YAML konfigurationsfiler.

---



# I gang med Docker

* Installer Docker for Windows (kræver måske Hyper-V aktiv da der kører en VM til formålet)
* Hvalen er på processlinien og kan højreklikkes
* Lav login på Dockerhub og fortæl det til den lokale Docker instans

# Docker Hello World

```dosbatch
C:\Users\m86194\git\tande-presentations\2019-06-03-introduktion-til-docker-og-openshift>docker run --rm hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete
Digest: sha256:0e11c388b664df8a27a901dce21eb89f11d8292f7fca1b3e3c4321bf7897bffe
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

(kør for at se det hele)

---

# Docker build via Dockerfile

```Dockerfile
#FROM - Image to start building on.
FROM ubuntu:14.04

#MAINTAINER - Identifies the maintainer of the dockerfile.
MAINTAINER ian.miell@gmail.com

#RUN - Runs a command in the container
RUN echo "Hello world" > /tmp/hello_world.txt

#CMD - Identifies the command that should be used by default when running the image as a container.
CMD ["cat", "/tmp/hello_world.txt"]
```

<https://github.com/ianmiell/simple-dockerfile>

---

# I gang med Openshift

* Hent nyeste `oc`
* Få adgang til <https://master.int.liquid.tdk.dk/console/projects>
* Login, og vælg fald-ned-menu på bruger-knap øverst til højre, og vælg "Copy Login Command"
* Indsæt kommandoen i en CMD.EXE eller Git Bash.
* Benyt `oc project X` til at skifte til det ønskede projekt.

Af sikkerhedshensyn skal man logge ind jævnligt.


# OpenShift - en guided tour.

* Vis applikationer
* Find og åben hak på "eoc-mail-master-dev"
* Følg route til installation og se fejlside
* Åben "/actuator/health" for at se JSON status.
* Vis "Image" -> internt registry
* Vis "Build" -> (start build, gå tilbage, vis log, vis rolling deployment)
* Vis at "-qa" build triggered og blev deployet.

# OpenShift - the Pipeline (TM)

TEST:  git -> -dev -> -qa -> registry
PROD: registry -> -qa -> -stage -> "" (prod)

Vis at metadata fra oprindeligt git commit er med ude på prod uden at gøre noget.


