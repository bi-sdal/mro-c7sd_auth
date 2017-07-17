FROM sdal/ldap-ssh-c7
MAINTAINER "Aaron D. Schroeder" <aschroed@vt.edu>

# Install R Package Prerequisites
RUN yum install -y openssl-devel unzip wget && \
    yum groupinstall -y 'Development Tools'

# Get Microsoft R Open
RUN cd /tmp/ && \
    wget https://mran.microsoft.com/install/mro/3.4.0/microsoft-r-open-3.4.0.tar.gz && tar -xvzf microsoft-r-open-3.4.0.tar.gz

RUN /tmp/microsoft-r-open/install.sh -a -u

# Configure CRAN Repositories
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'https://cloud.r-project.org/'; options(repos = r);" >> ~/.Rprofile

COPY 01-setup_Rprofile_site.R 01-setup_Rprofile_site.R
RUN Rscript 01-setup_Rprofile_site.R

# Install R Package Prerequisites
RUN yum install -y postgresql-devel && \
    yum install -y libcurl libcurl-devel xml2 libxml2-devel && \
    yum install -y libjpeg-turbo-devel librsvg2-devel && \
    yum install -y udunits2 udunits2-devel && \
    yum install -y geos-devel v8-314-devel && \
    yum install -y gsl-devel && \
    yum install -y openssl098e passwd pandoc && \
    yum install -y locales which && \
    yum install -y dejavu-sans-fonts dejavu-serif-font && \
    yum install -y ImageMagick ImageMagick-devel && \
    yum install -y libgfortran && \
    yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

# RUN yum install -y gdal gdal-devel proj proj-devel proj-epsg && \

RUN cd /tmp/ && \
    wget http://download.osgeo.org/gdal/2.2.0/gdal220.zip && \
    unzip gdal220.zip && \
    cd gdal-2.2.0 && \
    ./configure && \
    make && \
    make install

RUN cd /tmp/ && \
    wget http://download.osgeo.org/proj/proj-4.9.3.tar.gz && \
    tar xvf proj-4.9.3.tar.gz && \
    cd proj-4.9.3 && \
    ./configure && \
    make && \
    make install

# fix rgdal
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/R-dependencies-x86_64.conf && \
    ldconfig

RUN which java && \
    java -version && \
    R CMD javareconf

RUN Rscript -e "install.packages('udunits2', type = 'source', repo = 'cran.rstudio.com', configure.args = '--with-udunits2-include=/usr/include/udunits2 --with-udunits2-lib=/usr/local/lib')"

COPY Makeconf /usr/lib64/microsoft-r/3.4/lib64/R/etc/Makeconf

CMD ["/usr/sbin/init"]
