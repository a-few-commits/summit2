FROM ubuntu
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y r-base
RUN apt-get install -y wget
RUN apt-get install -y openjdk-8-jre
RUN apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev
RUN R -e "install.packages('shiny', repos='https://cran.rstudio.com/')"

RUN R CMD javareconf

RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('shinydashboard')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('highcharter')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('dplyr')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('NLP')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('tm')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('stringr')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('SnowballC')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('RColorBrewer')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('wordcloud2')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('tidytext')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('slam')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('tidyr')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('igraph')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('ggraph')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('widyr')"

RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('twitteR')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('rtweet')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('wordcloud')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('RWeka')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('syuzhet')"
RUN R -e "Sys.setenv(MAKE = \"make -j 8\"); install.packages('topicmodels')"


RUN apt-get install -y gdebi-core
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
RUN gdebi --non-interactive shiny-server-1.5.9.923-amd64.deb
ADD app /srv/shiny-server
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
