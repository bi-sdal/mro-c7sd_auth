FROM sdal/ldap-ssh-c7
MAINTAINER "Aaron D. Schroeder" <aschroed@vt.edu>

# Install R Package Prerequisites
RUN yum install -y openssl-devel && \
    yum groupinstall -y 'Development Tools' && \
    yum install -y postgresql-devel && \
    yum install -y libcurl libcurl-devel xml2 libxml2-devel

# Install additional tools
RUN yum install -y unzip wget

# Get Microsoft R Open
RUN \
  cd /tmp/ && \
  wget https://mran.microsoft.com/install/mro/3.4.0/microsoft-r-open-3.4.0.tar.gz && tar -xvzf microsoft-r-open-3.4.0.tar.gz

RUN /tmp/microsoft-r-open/install.sh -a -u

# Configure CRAN Repositories
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'https://cloud.r-project.org/'; options(repos = r);" > ~/.Rprofile

# Install R Packages
RUN Rscript -e "install.packages('DBI')"
RUN Rscript -e "install.packages('RPostgreSQL')"
RUN Rscript -e "install.packages('tidyverse')"
RUN Rscript -e "install.packages('ggthemes')"
RUN Rscript -e "install.packages('rmarkdown')"
RUN Rscript -e "install.packages('curl')"
RUN Rscript -e "install.packages('httr')"
RUN Rscript -e "install.packages('rio')"
RUN Rscript -e "install.packages('devtools')"

## Big data
RUN Rscript -e "install.packages('bigmemory')"
RUN Rscript -e "install.packages('biganalytics')"
RUN Rscript -e "install.packages('data.table')"

## Interactive Web Packages
RUN Rscript -e "install.packages('shiny')"
RUN Rscript -e "install.packages('shinydashboard')"
RUN Rscript -e "install.packages('flexdashboard')"
RUN Rscript -e "install.packages('DT')"
RUN Rscript -e "install.packages('leaflet')"
RUN Rscript -e "install.packages('highcharter')"

## github packages
RUN Rscript -e "devtools::install_github('bwlewis/rthreejs')"
RUN Rscript -e "devtools::install_github('bi-sdal/sdalr')"

# check for latest updates
RUN Rscript -e "update.packages(ask = FALSE)"

CMD ["/usr/sbin/init"]
