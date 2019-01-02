FROM ubuntu
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y r-base
RUN apt-get install -y wget
RUN R -e "install.packages('shiny', repos='https://cran.rstudio.com/')"

RUN R -e "install.packages('twitteR', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('tm', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('rjson', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('wordcloud', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('dplyr', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('caret', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('ggplot2', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('RColorBrewer', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('stringr', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('syuzhet', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('scales', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('rbokeh', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('base64enc', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('SnowballC', repos='https://cran.rstudio.com/')"

RUN apt-get install -y gdebi-core
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
RUN gdebi --non-interactive shiny-server-1.5.9.923-amd64.deb
ADD app /srv/shiny-server
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
