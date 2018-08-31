FROM r-base:latest

MAINTAINER Winston Chang "winston@rstudio.com"

# Install dependencies and Download and install shiny server -------------------

## See https://www.rstudio.com/products/shiny/download-server/ for the
## instructions followed here.

RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxml2-dev \
    libxt-dev && \
    wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3838

# Install Shiny server ---------------------------------------------------------

COPY shiny-server.sh /usr/bin/shiny-server.sh

# Copy Shiny apps into the container -------------------------------------------

# Remove existing shiny apps:
RUN find /srv/shiny-server -d -type d -exec rm -rf '{}' \;

COPY mountpoints/apps/ /srv/shiny-server/

# Install packages for the Shiny apps, using packrat in those apps -------------

## The script below will loop through the apps copied on the server, looking
## through each for a packrat directory, and will install the packrat apps from
## each
COPY bootstrap_packrat_for_app.sh /tmp/
RUN /tmp/bootstrap_packrat_for_app.sh

# Confirm that all files are writable by the shiny user ------------------------

## This follows https://support.rstudio.com/hc/en-us/articles/216528108-Deploying-packrat-projects-to-Shiny-Server-Pro,

RUN chown -R shiny:shiny /srv/shiny-server/*

# Include a custom configuration file ------------------------------------------

## Uncomment the line below to include a custom configuration file. You can
## download the default file at
## https://raw.githubusercontent.com/rstudio/shiny-server/master/config/default.config
## (The line below assumes that you have downloaded the file above to
## ./shiny-customized.config)
## Documentation on configuration options is available at
## http://docs.rstudio.com/shiny-server/

COPY custom.config /etc/shiny-server/shiny-server.conf

# Run Shiny server -------------------------------------------------------------

CMD ["/usr/bin/shiny-server.sh"]
