## need this to get tigris to download files correctly
##
## as well as installing github packages
## otherwise you'd get SSL CA cert  error
## https://github.com/walkerke/tigris/issues/40
install.packages(c("curl", "httr"))

install.packages(
    'udunits2', type = 'source', repo = 'cran.rstudio.com',
    configure.args = '--with-udunits2-include=/usr/include/udunits2 --with-udunits2-lib=/usr/local/lib'
)

pkgs_to_install <- c('Rcpp', 'rgdal', 'rgeos', 'tigris')

install.packages(pkgs_to_install)

for (p in pkgs_to_install) {
    if (require(p, character.only = TRUE)) {
        print(sprintf('Loaded: %s', p))
    } else {
        quit(save = "no", status = 1, runLast = TRUE)
    }
}
