rem https://github.com/jagregory/pandoc-docker
rem docker run jagregory/pandoc
rem 
rem NOTE:  Docker needs share access to your drive, look for Windows notifications asking when docker hangs.

rem docker run -v %CD%:/source jagregory/pandoc -f markdown -t beamer README.md -H make-code-smaller.tex --highlight-style=espresso -o presentation.pdf
docker run -v %CD%:/source jagregory/pandoc -s -f markdown_github -t slidy README.md  -o presentation.html

