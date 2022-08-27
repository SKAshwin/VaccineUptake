#! /bin/bash

wget https://downloads.skashwin.com/projects/VaccineUptake/VaccUptake_raw_data.zip
unzip VaccUptake_raw_data.zip -d .
rm VaccUptake_raw_data.zip

mkdir -p cleaned
mkdir -p regression_ready
mkdir -p temp