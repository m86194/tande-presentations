# Live Java in Markdown documents.

In 1973 C. A. Hoares held the keynote address at ACM SIGPLAN
presenting his philosophy of design and evaluation of programming
languages, with their primary purpose are to help the programmer in
the practice of his art.

> *Programming documentation.* The purpose of program documentation is
> to explain to a human reader the way in which a program works so that
> it can be successfully adapted after it goes into service, to meet the
> changing requirements of its users, or to improve it in the light of
> increased knowledge, or just to remove latent errors and
> oversights. The view that documentation is something that is added to
> a program after it has been commissioned seems to be wrong in
> principle and counter-productive in practice. Instead, documentation
> must be regarded as an integral part of the process of design and
> coding. A good programming language will encourage and assist the
> programmer to write clear self-documenting code, and even perhaps to
> develop and display a pleasant style of writing.  The readability of
> programs is immeasurably more important than their writeability.

http://flint.cs.yale.edu/cs428/doc/HintsPL.pdf

# 2019

Most public Java projects today live on Github (or similar).

Github has a killer feature for project documentation, namely that a
suitably formatted `README` file in the root of the repository is
rendered _on the fly_ when viewing the repository in a browser.
Several formats are supported; Markdown appears currently to be the
most popular.  Additionally code snippets are syntax highlighted!
Markdown is relatively easy to write and read, and powerful "enough"
for simple documentation tasks.

Unfortunately, neither Markdown nor Java are designed with the other
one in mind, but as will be shown in the following it is possible.

My initial proof of concept:
https://github.com/ravn/dagger2-hello-world

# Mixing the two?

How can we make a single file that is:

1. Valid source file _as-is_ ignoring Markdown.
1. Valid Markdown _as-is_ with the Java source in code blocks.

That is, no preprocessor step as neither `javac` nor Github rendering
supports this.

# Easy!

1. Put Markdown in `/* .... */` blocks.
1. Java code must be enclosed in "FOUR BACKQUOTES" blocks, as we
cannot rely on the indentation which may be changed at any time.

