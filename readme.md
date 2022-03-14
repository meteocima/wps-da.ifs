# wps-da.ifs
docker container that allows to run WPS workflow using IFS dataset as input.



## How to obtain the docker image

The pre-build image is publicly [available on Docker Hub](https://hub.docker.com/repository/docker/cimafoundation/wps-da.ifs) 

## Run ifs container

This container expect three volumes to be mounted
under /output, /input and /geogrid. 

You must put gfs files under /input; static geo
data under /geogrid; /output will contains resulting file.

The procedure within the container also make use of three
environment variables:

- WPS_START_DATE - start date and time gor the main forecast
- WPS_HOURS - duration of the main forecast, defaults to 48


- WPS_MODE - type of simulation you want to prepare. It can assume following values:
'WARMUP', 'WARMUPDA', 'WRF' or 'WRFDA'

    * WRF mode - preprocess the data needed to run a WRF simulation without data    assimilation. It's actually used by Continuum and numtech simulation.

    * WRFDA mode - preprocess the data needed to run a WRFDA simulation with data assimilation. It includes in the preprocessed data instant WPS_START_DATE-3HOUR and WPS_START_DATE-6HOUR, that are used during data assimilation. It will be used by Continuum and Numtech simulations when data assimilation will be used.

    * WARMUP mode - preprocess the data needed to run three WRF simulation, without data assimilation. Two of this WPS execution preprocess the data to run two WRF simulation for days WPS_START_DATE-1 and WPS_START_DATE-2.
    These two set of data are the "warmup" data.
    The other WPS execution prepares the normal WRF simulation from $WPS_START_DATE to $WPS_END_DATE. Warmup data it's actually used by Risico simulation.

    * WARMUPDA mode - preprocess the data needed to run three WRF simulation, with data assimilation. Two of this WPS execution preprocess the data to run two WRF simulation (with no assimilation) for days WPS_START_DATE-1 and WPS_START_DATE-2.
    These two set of data are the "warmup" data.
    The other WPS execution prepares the normal WRF simulation (with assimilation) from $WPS_START_DATE to $WPS_END_DATE. Warmup data it's actually used by Risico simulation.
   

## Example

This example shows how to run the workflow for the date 
2020073100, mounting output, input and geogrid 
volumes under respective subdirectories of working dir.

output directory must be empty.
input directory should 
contains GFS input data under directory 2020/07/30/1800:

```
2020073018_anl_daita.grb  
2020073018_f011_daita.grb  
2020073018_f023_daita.grb

...

2020073018_f035_daita.grb  
2020073018_f047_daita.grb
```

geogrid directory should contains static geogrid data.

Given these three folder content, you can run the container using this command:

```bash
docker run -it \
    --shm-size=64G \
    -v $PWD/output:/output \
    -v $PWD/input/:/input \
    -v $PWD/geogrid/:/geogrid \
    -e "WPS_START_DATE=2020073100" \
    -e "WPS_HOURS=48" \
    -e "WPS_MODE=WRFDA" \
    cimafoundation/wps-da.gfs
```

If the container completes successfully, you should see
on stdout the message "RUN FOR DATE 2020073100 COMPLETED"

The output directory will contains following files:

output/
output/20200731
output/20200731/wrfbdy_d01_da03
output/20200731/wrfbdy_d01_da02
output/20200731/wrfinput_d01
output/20200731/wrfbdy_d01_da01
output/20200731/wrfinput_d03
output/20200731/wrfinput_d02
output/arguments.txt

You can copy the output directory as-is to the HPC environment
in order to run the WRFDA simulation.

arguments.txt contains the config path to use on HPC, and
a list of the dates to run (that's the main ones you requested, plus 
warmup runs where needed for warmup).

For each of this dates, a separate subdirectory
of output is produced (output/20200731 in the example), 
that contains start conditions for the three domains (files wrfinput_d<NN>)
and boundary conditions for the three phases of assimilation
for domain 1 (files wrfbdy_d01_da<NN>)
