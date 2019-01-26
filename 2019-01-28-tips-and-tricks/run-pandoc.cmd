rem https://github.com/jagregory/pandoc-docker
rem docker run jagregory/pandoc
docker run -v %CD%:/source jagregory/pandoc -f markdown -t html5 myfile.md -o myfile.html

