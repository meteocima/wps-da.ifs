# wps-da.ifs
docker container that allows to run WPS workflow using IFS dataset as input.



## How to obtain the docker image

The pre-build image is publicly [available on Docker Hub](https://hub.docker.com/repository/docker/cimafoundation/wps-da.ifs) 

## Run ifs container

This container expect three volumes to be mounted
under /output, /input and /geogrid. 

You must put ifs files under /input; static geo
data under /geogrid; /output will contains resulting file.

The procedure within the container also make use of three
environment variables

- WPS_START_DATE - first date of the range you want to prepare
- WPS_END_DATE - last date of the range you want to prepare

> Beware: for each date in the range you choose, a set of files will be prepared to run a simulation in that date. 
> That means that if you need to prepare a single simulation, you have to specify one single date, even if the forecast itself last for more than one day.


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
   