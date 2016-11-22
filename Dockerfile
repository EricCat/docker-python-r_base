FROM ubuntu:14.04
MAINTAINER Wei.Liu <cats8.lw@gmail.com>

ENV R_BASE_VERSION 3.3.2

RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
    apt-get -qq update

# install requirments
RUN apt-get -y install r-base=${R_BASE_VERSION}* \
                       build-essential \
                       python \
                       python-dev \
                       libpq-dev \
                       python-pip \
                       libcurl4-openssl-dev \
                       libxml2-dev \
    && apt-get clean \
    && pip install --upgrade pip

# setup R configs
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e "install.packages('jsonlite')"
RUN Rscript -e "install.packages('lubridate')"
RUN Rscript -e "install.packages('xts')"
RUN Rscript -e "install.packages('outliers')"
RUN Rscript -e "install.packages('stlplus')"


# create root path
RUN mkdir -p /var/www/app
COPY . /var/www/app
WORKDIR /var/www/app

# setup python python
ENV PYTHONPATH='.'

# install python packages
RUN pip install -r requirements.txt