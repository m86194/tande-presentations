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
* Java 11 for tests, Java 8 for prod
* Tests that _know_ they live in a Maven module.
* Documentation (markdown is nice)
* Misc.

Feel free to ask at any time.  

-------

# Spring Boot micro service highlights:

1. main invokes `SpringBootApplication.run(X.class)` (X must be annotated with `@SpringBootApplicaiton`)
1. All classes in the package for X and "below" in the classpath are scanned by Spring to see if they are components or not.
1. `@RestController` contains endpoints - each method annotated with `@RestMapping` becomes one.
    * `@ResponseBody` identifies how the return value should be converted to the response sent to the client.  This is typically a simple JSON mapping.  
    * `@RequestParam` maps a method parameter to a key-value pair in the request.
1. `@AutoWired` tells Spring to invoke the method/constructor.  Any parameters are "made available" recursively.
1. If Spring needs to provide a parameter annotated with `@Value('${foo.bar})` the key `foo.bar` is looked up in the Spring Boot configuration and the corresponding value used.  
1. If a parameter can be provided by invoking a uniquely identifed bean, Spring will instantiate it.
1. Will end up in a docker instance on Liquid (i.e. Linux, not Windows) and code built by Jenkins.

I strongly suggest using only constructors with Spring (full name: Constructor based Dependency Injection).  It is much easier to write good
tests for.   

-------

# Spring Boot configuration

```java
    public InteractController(@Value("${nbo.interactcontroller.interact.uacioffertrackingcodeKey}") String uacioffertrackingcodeKey,
                              @Value("${nbo.interactcontroller.interact.uaciresponsetypecodeKey}") String uaciresponsetypecodeKey,
                              @Value("${nbo.interactcontroller.interact.uacicustomloggertablenameKey}") String uacicustomloggertablenameKey,
                              InteractCall interactCaller
    ) {
        this.uacioffertrackingcodeKey = requireNonNull(uacioffertrackingcodeKey, "uacioffertrackingcodeKey");
        this.uaciresponsetypecodeKey = requireNonNull(uaciresponsetypecodeKey, "uaciresponsetypecodeKey");
        this.uacicustomloggertablenameKey = requireNonNull(uacicustomloggertablenameKey,
            "uacicustomloggertablenameKey");
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
* Allows for different Java versions in the same project.  As of 2019 building and testing with Java 11 and running in production with Java 8 is a sweet spot.
* Allows for different versions of configuration files, for e.g. development and automated tests.
* Super duper deluxe parent pom at top-most level is most IDE-friendly
* Business Core team provides dk.tdc.businescore:bc-java-microservies parent pom for setting everything up.  Most dependency versions can be specified using a property.

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
be run from within an IDE or Maven itself.  Useful for localizing existing test files in the project file system,
or the Maven target folder to delegate the clean up process to Maven.  Works by asking the
JVM about the physical location of the byte code used to create the class.   


* `getRequiredPathTowardsRoot(this, "target")`
* `getTempFolderUnderPath(path)`

See `FileLogControllerTest`

-------

# Launcher

(Not immediately related to any other concept, it is just what I named this technique which was originally inspired by Eclipse Launch Configurations)

* Sets up the environment before starting the actual application and cleans up afterwards.
* _Knows_ it runs in an IDE/Maven-invocation, and belongs to a Maven project present on disk.
* Can localize a data file containing known test data in the project and set up a configuration value pointing to it.
* Change current directory if needed to make relative references work.

See `InteractDataServiceLauncher`

-------

# Docker

Our code will end up in a docker instance.  For liquid this we should aim for a OpenJDK 8 under Linux, as this
is what they provide.  We can run the images built locally on developer machines using Windows 10.

Locally:  `Dockerfile`
Local orchestration of multiple docker instances:  `docker-compose.yml`
OpenShift: `build.yml`  (typically very small as it just configures the Jenkins pipeline)

What is our Docker-experience?

-------

# Java 11 for tests

Much easier to create structures to provide as test data and to assert against afterwards, plus it forces us
to figure out how to solve any problems related to the new module system introduced in Java 9 onwards without influencing 
production code.


* `var x = ....`
* `List.of(..)` + `Map.of(...)` + ´Set.of(...)`

Move unit tests from src/test to a sister project. 

(also the new jUnit 5 is quite nice)

--------

# Miscellaneous

* Use `mvn` a lot from the command line.  This needs to work 100% correctly. (An easy way is to download and unpack an official Maven distribution and create a small `mvn.cmd` file which sets JAVA_HOME and invokes the unpacked mvn)
* `mvnw` in the project is getting traction.
* Eclipse doesn't emulate Maven classpath correctly.  `src/main/java` and `src/test/java` are not separate.

Use markdown for documentation of the form plain-text with links.  This is what projects on Github
use, which made it popular.  Bitbucket can too.

An experiment in documenting live Java code with Markdown: https://github.com/ravn/dagger2-hello-world/blob/master/README.md

-------

