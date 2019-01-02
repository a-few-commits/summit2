FROM ubuntu
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y r-base
RUN apt-get install -y wget
RUN apt-get install -y libcurl4-openssl-dev
RUN R -e "install.packages('shiny', repos='https://cran.rstudio.com/')"

RUN R -e "install.packages('twitteR')"
RUN R -e "install.packages('tm')"
RUN R -e "install.packages('rjson')"
RUN R -e "install.packages('wordcloud')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('ggplot2')"
RUN R -e "install.packages('RColorBrewer')"
RUN R -e "install.packages('stringr')"
RUN R -e "install.packages('syuzhet')"
RUN R -e "install.packages('scales')"
RUN R -e "install.packages('rbokeh')"
RUN R -e "install.packages('base64enc')"
RUN R -e "install.packages('SnowballC')"

RUN apt-get install -y gdebi-core
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
RUN gdebi --non-interactive shiny-server-1.5.9.923-amd64.deb
ADD app /srv/shiny-server
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
