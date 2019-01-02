FROM ubuntu
RUN apt-get update
RUN apt-get install -y r-base
RUN R -e "install.packages('shiny', repos='https://cran.rstudio.com/')"
RUN apt-get install gdebi-core
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
RUN gdebi --non-interactive shiny-server-1.5.9.923-amd64.deb

ADD app /srv/shiny-server
