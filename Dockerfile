FROM sdal/ldap-ssh-c7
MAINTAINER "Aaron D. Schroeder" <aschroed@vt.edu>

# Install R Package Prerequisites
RUN yum install -y openssl-devel htop unzip wget htop && \
    yum groupinstall -y 'Development Tools' && \
    yum install -y postgresql-devel && \
    yum install -y libcurl libcurl-devel xml2 libxml2-devel && \
    yum install -y libjpeg-turbo-devel && \
    yum install -y gdal gdal-devel proj proj-devel proj-epsg && \
    yum install -y geos-devel v8-314-devel && \
    yum install -y openssl098e passwd pandoc && \
    yum install -y locales which && \
    yum install -y dejavu-sans-fonts dejavu-serif-font && \
    yum install -y ImageMagick ImageMagick-devel && \
    yum install -y libgfortran

# Get Microsoft R Open
RUN cd /tmp/ && \
    wget https://mran.microsoft.com/install/mro/3.4.0/microsoft-r-open-3.4.0.tar.gz && tar -xvzf microsoft-r-open-3.4.0.tar.gz

RUN /tmp/microsoft-r-open/install.sh -a -u

# Configure CRAN Repositories
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'https://cloud.r-project.org/'; options(repos = r);" >> ~/.Rprofile

COPY 01-setup_Rprofile_site.R 01-setup_Rprofile_site.R

RUN Rscript 01-setup_Rprofile_site.R

# Get java working for R
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel && \
    yum install -y R-java R-java-devel

RUN which java && \
    java -version && \
    R CMD javareconf

CMD ["/usr/sbin/init"]
