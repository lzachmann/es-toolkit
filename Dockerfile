FROM rocker/geospatial:3.4.0

# Toolchain
RUN apt-get update \
    && apt-get -y install build-essential

# X11 Server Installation
# RUN apt-get -y install xorg openbox

# Configuration (personal Makevars file)
RUN mkdir -p $HOME/.R/ \
    && echo "\nCXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function\n" >> $HOME/.R/Makevars \
    && echo "\nCXXFLAGS+=-flto -ffat-lto-objects  -Wno-unused-local-typedefs\n" >> $HOME/.R/Makevars

# Installation
RUN install2.r --repo http://cloud.r-project.org/ --deps TRUE --error \
    rstan \
    leaflet \
    lme4

# Text editor
RUN apt-get install nano

# Install pip (package manager)
RUN apt-get -y install python-pip

# Install Google APIs Client Library
RUN pip install google-api-python-client

# Install the Earth Engine Python API
RUN pip install earthengine-api

# Upgrade pyasn1 to resolve version conflict
RUN pip install pyasn1 --upgrade

# Hugo installation
RUN cd ~ \
    && wget https://github.com/spf13/hugo/releases/download/v0.20.7/hugo_0.20.7_Linux-64bit.deb \
    && dpkg -i hugo*.deb \
    && rm hugo*.deb

# Install additional R packages
RUN R -e "devtools::install_github('rstudio/blogdown')"
RUN R -e "devtools::install_github('adletaw/captioner')"
RUN R -e "devtools::install_github('ropensci/plotly')"

