# Migrate away from Lombok

I consider Lombok to be too magical for comfort, and we should use something else.  These are my notes for now.

The template project uses getters, setters, no-args constructor, all-args constructor, toString (and @Data)

Google presentation of AutoValue listing their (biased) view of Lombok:  
https://docs.google.com/presentation/d/14u_h-lMn7f1rXE1nDiLX0azS3IkgjGl5uxp5jGJ75RE/edit#slide=id.g2a5e9c4a8_0104

Blog entry comparing Lombok, Immutables and AutoValue (2016): http://marxsoftware.blogspot.com/2016/06/lombok-autovalue-immutables.html

interact-data-service test - Lombok beans are mutable, not directly replacable by AutoValue.  Builders get very messy if refactoring code that expects mutable beans.