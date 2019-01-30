# Migrate to Java 11

Even though Java 8 will live for ever (existing programs cannot run unmodified on Java 11+) we will need to
have a migration strategy as only the newest JVM's will have good Docker support.

Status as of 2019-01-30:

* Maven 3.6.0 works well with Java 11.  All compilation related plugins _in the project_ must be upgraded to the latest version available.  Can compile Java 8 sources unmodified.
* I like to have Java 11 available at build time for tests and docker instances, and Java 8 for production code.  
* The new module system is _hard_ to get right and breaks functionality in unexpected places.  Everything in the same package should end up in the same jar.
