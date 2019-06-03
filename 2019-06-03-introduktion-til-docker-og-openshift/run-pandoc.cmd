rem Install Docker for Windows first!
rem
rem https://github.com/jagregory/pandoc-docker
rem docker run jagregory/pandoc
rem 
rem NOTE:  Docker needs share access to your drive, look for Windows notifications asking when docker hangs.
rem
docker run -v %CD%:/source jagregory/pandoc -s -f markdown_github -t slidy README.md  -o README.html

