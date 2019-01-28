[//]: # (use pandoc to convert to presentation - https://pandoc.org/MANUAL.html#pandocs-markdown)

# Tips and tricks so far
Thorbjørn Ravn Andersen


<tande@tdc.dk>

2019-01-28

------

# Some of the things I have an opinion about:

* Spring Boot microservice quick overview
* Maven multi-modules
* Launchers (for lack of a better word)
* Java 11 for tests, Java 8 for production
* Tests that _know_ they live in a Maven module.
* Documentation (markdown is nice)
* Misc.

Feel free to ask at any time.  

-------

# Spring Boot

* Has all the parts for `java -jar`-based micro services in the cloud.
* Strongly opinionated defaults.
* Almost everything can be overridden.
* Provides the "are you ok?" health check functionality needed by Liquid, out of the box.

--------


# Spring Boot Microservice Highlights :

* main invokes `SpringBootApplication.run(X.class)` where X is annotated with `@SpringBootApplication`
* All classes in the package for X and "below" in the classpath are scanned by Spring to see if they are Spring components or not.
* `@RestController` classes contains endpoints - each method annotated with `@RestMapping` becomes one.
    * `@ResponseBody` identifies how the return value should be converted to the response sent to the client.  This is typically a simple JSON mapping.  
    * `@RequestParam` maps a method parameter to a request key-value pair.
* `@AutoWired` tells Spring to invoke the method/constructor.  Any parameters are "made available" recursively.
* `@Value('${foo.bar})` parameter annotations uses configuration value for `foo.bar`.  
* If a parameter can be provided by invoking a uniquely identifed bean, Spring will instantiate it.
* Will end up in a docker instance on Liquid (so we need to code for Linux) and code built by Jenkins.

Opinion:  Only use these things in constructors!

Fact: The Magic only works for beans created by Spring, not with `new`. 


-------

# Spring Boot configuration

```java
public InteractController(
        @Value("${nbo.interactcontroller.interact.uacioffertrackingcodeKey}") String uacioffertrackingcodeKey,
        @Value("${nbo.interactcontroller.interact.uaciresponsetypecodeKey}") String uaciresponsetypecodeKey,
        @Value("${nbo.interactcontroller.interact.uacicustomloggertablenameKey}") String uacicustomloggertablenameKey,
        InteractCall interactCaller
) {
    this.uacioffertrackingcodeKey = requireNonNull(uacioffertrackingcodeKey, "uacioffertrackingcodeKey");
    this.uaciresponsetypecodeKey = requireNonNull(uaciresponsetypecodeKey, "uaciresponsetypecodeKey");
    this.uacicustomloggertablenameKey = requireNonNull(uacicustomloggertablenameKey, "uacicustomloggertablenameKey");
    this.interactCaller = interactCaller;
}
```

Spring Boot looks in **17** different places to resolve `@Value`.

For most purposes a property file available as `/config/application.properties` in the classpath is sufficient.
(For values not available until runtime, see Launchers later)

```properties
...
nbo.update.filelog.interval.ms=14400000
nbo.interactcontroller.interact.uacioffertrackingcodeKey=UACIOfferTrackingCode
nbo.interactcontroller.interact.uaciresponsetypecodeKey=UACIResponseTypeCode
nbo.interactcontroller.interact.uacicustomloggertablenameKey=UACICustomLoggerTableName
nbo.interactcontroller.timeout.ms=10000
...
```

https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html#boot-features-external-config-application-property-files

------

# Maven multi-modules

Use for:
* Separation of code and configuration files according to needs.  
* Allows for different Java versions in the same project.  Opinion: as of 2019 building and testing with Java 11 and running in production with Java 8 is a sweet spot.
* Allows for different versions of configuration files, for e.g. development and automated tests.
* Super-duper-deluxe parent pom at top-most level is most IDE-friendly - we want to avoid e.g. Eclipse ProjectSets.
* Business Core team provides `dk.tdc.businescore:bc-java-microservices` parent pom for setting everything up.  Most dependency versions can be specified using a property.

----

# mvn org.qunix:structure-maven-plugin:modules

     interact-data-service-parent
                                \__ interact-data-service-development
                                :       |__ jars-not-in-maven-central
                                :       |__ tande-common-maven-helpers
                                :       |__ common-data-service-api
                                :       |__ click-data-service
                                :       |__ click-data-service-unittests
                                :       |__ interact-data-service
                                :       |__ interact-data-service-unittests
                                :       |__ interact-data-service-launcher
                                |__ interact-data-service-integrationtests
                                |__ interact-data-service-deployment

Anything under development is relevant to daily development and can be finished quickly.
The full project is allowed to be much slower. 

-------

# MavenProjects

Helper methods for e.g. localizing file resources when we _know_ that this code will always
be run from within an IDE or Maven itself.  Useful for localizing existing data files in the project file system,
or the Maven target folder to delegate the clean up process to Maven.  

Works by asking the JVM about the physical location of the byte code used to create the class.   


* `getRequiredPathTowardsRoot(this, "target")`
* `getTempFolderUnderPath(path)`

See `FileLogControllerTest`

-------

# Launcher

(Not immediately related to any other concept, it is just what I named this technique which was originally inspired 
by Eclipse Launch Configurations.  Suggestions for a better name are welcome)

* Sets up the environment before starting the actual application and cleans up afterwards.
* _Knows_ it runs in an IDE/Maven-invocation, and belongs to a Maven project present on disk.
* Can localize a data file containing known test data in the project and set up a configuration value pointing to it.
* Change current directory if needed to make relative references work.

See `InteractDataServiceLauncher`

-------

# Docker

Our code will end up in a docker instance.  For Liquid this we should aim for a OpenJDK 8 under Linux, as this
is what they provide. 
 
We can run the images built locally on developer machines using Windows 10 using Docker for Windows.

Locally:  `Dockerfile`
Local orchestration of multiple docker instances:  `docker-compose.yml`
OpenShift: `build.yml`  (typically very small as it just configures the Jenkins pipeline)

I have build the CIP sources using a suitable .NET Core docker instance in 2018-12. 

What is our Docker-experience?

-------

# Java 11 for tests

Much easier to create structures to provide as test data and to assert against afterwards

Also forces us
to figure out how to solve any problems related to the new module system introduced in Java 9 onwards without influencing 
production code.


* `var x = ....`
* `List.of(..)` + `Map.of(...)` + ´Set.of(...)`

Move unit tests from src/test to a sister project. 

(also the new jUnit 5 is quite nice)


--------

Documentation:
---

_What_ is what the code does.  We need to be better at capturing the answers to _why_ in the documentation!

For documentation _inside_ code, use javadoc (HTML sprinkled over the Java source and extracted by the javadoc tool).

For documentation _outside_ code, use the **MarkDown** format in e.g. "README.md" files.

Possible discussion:  How can we ensure that documentation is adequate and up to date in a way that would
work for all of us on a day to day basis?


-----------

```
In recent years there has been a need for a documentation format which could provide more than raw ASCII text
(most prefer URL's to be clickable) but simpler than HTML.   

1. Numbered lists are easy.
1. and it is readable in a normal text editor.

Github has made "markdown" popular, with their automatic rendering of README.md when browsing repository files.

* See https://github.com/ravn/dagger2-hello-world for an example
* And some inline code: `List<String> l = new ArrayList<String>();`
```

In recent years there has been a need for a documentation format which could provide more than raw ASCII text
(most prefer URL's to be clickable) but simpler than HTML.   

1. Numbered lists are easy.
1. and it is readable in a normal text editor.

Github has made "markdown" popular, with their automatic rendering of README.md when browsing repository files.

* See https://github.com/ravn/dagger2-hello-world for an example
* And some inline code: `List<String> l = new ArrayList<String>();`

(Works on Bitbucket too)

--------

# Miscellaneous

* Use `mvn` a lot from the command line.  This needs to work 100% correctly. (An easy way is to download and unpack an official Maven distribution and create a small `mvn.cmd` file which sets JAVA_HOME and invokes the unpacked mvn)
* `mvnw` in the project is getting traction.
* Eclipse doesn't emulate Maven classpath correctly.  `src/main/java` and `src/test/java` are not separate.


An experiment in documenting live Java code with Markdown: https://github.com/ravn/dagger2-hello-world/blob/master/README.md

-------

