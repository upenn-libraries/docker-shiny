#!/bin/sh

## Loop through all directories that contain a packrat directory.
## For each, install packages using packrat.

## Author: Jacob Levernier, University of Pennsylvania Libraries
## Year: 2018

## This approach comes from
## https://groups.google.com/forum/#!topic/packrat-discuss/66OJRXOqH9o

## Settings --------------------------------------------------------------------

server_apps_directory='/srv/shiny-server'

## Search app directories for packrat instances --------------------------------

original_directory=$(pwd)

packrat_directories=$(find "$server_apps_directory" -name "packrat" -type d | grep --invert-match --perl-regexp "(src|lib)")

for packrat_directory in $packrat_directories
do
  packrat_dirname=$(dirname "$packrat_directory")
  echo "Running packrat bootstrap from '$packrat_dirname'..."
  cd "$packrat_dirname"
  echo '' > blank_setup.R
  Rscript blank_setup.R --bootstrap-packrat

  ## Return to the original directory, for the next round in the loop
  cd "$original_directory"
done
