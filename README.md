Docker for Shiny Server
=======================

This is a Dockerfile for Shiny Server on Debian "testing". It is based on the r-base image. It is a modified fork of the [Rocker Project's Shiny repository](https://github.com/rocker-org/shiny).

As of January 2017, the Shiny Server log is written to `stdout` and can be viewed using `docker logs`. The logs for individual apps are in the `/var/log/shiny-server` directory, as described in the [Shiny Server Administrator's Guide]( http://docs.rstudio.com/shiny-server/#application-error-logs)

## Usage with docker-compose

This repository includes an example `docker-compose` file, to facilitate using this container within docker networks.

### To run a container with Shiny Server:

First, place your Shiny app in the `mountpoints/apps/the-name-of-the-app` directory, replacing `the-name-of-the-app` with your app's name. You can install dependencies to the Shiny server by including the `packrat/src` file for that project (if you have [enabled Packrat](https://rstudio.github.io/packrat/rstudio.html)).

Then, run

```sh
docker-compose build
docker-compose up
```

Then visit `http://localhost` (i.e., `http://localhost:80`) in a web browser. If you have an app in `/srv/shinyapps/appdir`, you can run the app by visiting http://localhost/appdir/.

### Logs

The example `docker-compose` file will create a persistent volume for server logs, so that log data will persist across instances where the container is running. To access these logs, while the container is running, run `docker exec -it shiny bash` and then `ls /var/log/shiny-server` to see the available logs. To copy these logs to the host system for inspection, while the container is running, you can use, for example, `docker cp shiny:/var/log/shiny-server ./logs_for_inspection`.

### Detached mode

In a real deployment scenario, you will probably want to run the container in detached mode (`-d`):

```sh
docker-compose up -d
```

## Custom configuration

To add a custom configuration file, assuming the custom file is called `shiny-customized.config`, uncomment the line

```
COPY shiny-customized.config /etc/shiny-server/shiny-server.conf
```

in the `Dockerfile`, and then run `docker-compose build shiny` to rebuild the container. Inline comments above that line in the `Dockerfile` provide additional documentation.

## Trademarks

Shiny and Shiny Server are registered trademarks of RStudio, Inc. The use of the trademarked terms Shiny and Shiny Server and the distribution of the Shiny Server through the images hosted on hub.docker.com has been granted by explicit permission of RStudio. Please review RStudio's trademark use policy and address inquiries about further distribution or other questions to permissions@rstudio.com.
