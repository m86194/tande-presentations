rem Install Docker for Windows first!
rem
rem https://github.com/jagregory/pandoc-docker
rem docker run jagregory/pandoc
rem 
rem NOTE:  Docker needs share access to your drive, look for Windows notifications asking when docker hangs.
rem
rem docker run -v %CD%:/source jagregory/pandoc -s -f markdown_github  -t pptx README.md  -o presentation.pptx
docker run -v %CD%:/source jagregory/pandoc -s -f markdown_github -t slidy README.md  -o presentation.html

