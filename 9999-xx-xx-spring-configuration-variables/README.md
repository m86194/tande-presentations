# Spring Boot configuration and OpenShift

Spring Boot allows for externalizing the configuration, meaning that configuration values are stored outside the code itself.

This is very useful when deploying to different Liquid instances as this mean the same code can be deployed in multiple locations with different
configuration maps.


# Configuration sources

Spring Boot provides a very rich environment for reading configuration value pairs at start up time.   I suggest the following:

* `/config/application.properties` in the classpath (either jar or file system)
* System property, if needed to be set in code at runtime before invoking `SpringApplication.run` (like in Launchers)
* `--key=value` on the command line in location specific script.

Also, do not provide defaults in code but let the code fail if a given key is not defined.

For full details and much more advanced features, see 
https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html


# Using configuration values

There are several ways to access the configuration environment.

For Spring components (managed by Spring) the `@Value` annotation on a constructor parameter:

```java
@Component public class MyBean {
    public MyBean(@Value("${name}") String name) {
        ...
    }
}
```
(Note: With this syntax is is a runtime error if `name` is not a key in the environment)

Using the Spring Environment directly from the ApplicationContext.

```java
String name = context.getEnvironment().getProperty("name");
```

For very advanced needs, `@ConfigurationProperties` can be used to set all the fields of a given object to their corresponding configuration values.

---

# Providing configuration values in OpenShift

_Pending: ConfigMaps in OpenShift_
