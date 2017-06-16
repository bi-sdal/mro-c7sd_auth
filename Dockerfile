FROM sdal/ldap-ssh-c7
MAINTAINER "Aaron D. Schroeder" <aschroed@vt.edu>

# Install R Package Prerequisites
RUN yum install -y openssl-devel htop && \
    yum groupinstall -y 'Development Tools' && \
    yum install -y postgresql-devel && \
    yum install -y libcurl libcurl-devel xml2 libxml2-devel && \
    yum install -y libjpeg-turbo-devel && \
    yum install -y gdal gdal-devel proj proj-devel proj-epsg && \
    yum install -y geos-devel v8-314-devel

# Install additional tools
RUN yum install -y unzip wget

# Get Microsoft R Open
RUN cd /tmp/ && \
    wget https://mran.microsoft.com/install/mro/3.4.0/microsoft-r-open-3.4.0.tar.gz && tar -xvzf microsoft-r-open-3.4.0.tar.gz

RUN /tmp/microsoft-r-open/install.sh -a -u

# Configure CRAN Repositories
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'https://cloud.r-project.org/'; options(repos = r);" >> ~/.Rprofile && \
    echo ".libPaths('/rpkgs')" >> ~/.Rprofile

COPY add_rpkgs.R add_rpkgs.R

RUN Rscript add_rpkgs.R

CMD ["/usr/sbin/init"]
