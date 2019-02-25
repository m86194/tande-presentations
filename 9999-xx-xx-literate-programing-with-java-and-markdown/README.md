# Literate Programming with Java and Markdown

A very long time ago Donald Knuth found that he could write better
programs if he could _explain_ what he wanted to do in prose as _part_
of the program.  At the time he was writing a typesetting tool for his
Art of Computer Programming and found that instead of using a
conventional language like DEC PDP-10 Pascal, inventing a new language
for writing so-called "Literate Programs" was the best for him which
then was either processed into a typeset version of the program for
humans to read, or a Pascal program for the computer to run.






(history of WEB targetting Pascal) - https://www.tug.org/TUGboat/tb26-1/beebe.pdf
http://flint.cs.yale.edu/cs428/doc/HintsPL.pdf





Even though Java 8 will live for ever (existing programs cannot run unmodified on Java 11+) we will need to
have a migration strategy as only the newest JVM's will have good Docker support.

Status as of 2019-01-30:

* Maven 3.6.0 works well with Java 11.  All compilation related plugins _in the project_ must be upgraded to the latest version available.  Can compile Java 8 sources unmodified.
* I like to have Java 11 available at build time for tests and docker instances, and Java 8 for production code.  
* The new module system is _hard_ to get right and breaks functionality in unexpected places.  Everything in the same package should end up in the same jar.
* Jenkins does not run well Java 11 yet.  They are working on it: https://jenkins.io/blog/2018/12/14/java11-preview-availability/
