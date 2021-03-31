#!/bin/sh

docker run -it \
--shm-size=64G \
-v $PWD/output:/output \
-v $PWD/ifs/:/input \
-v $PWD/geogrid/:/geogrid \
-e "WPS_START_DATE=$1" \
-e "WPS_END_DATE=$2" \
-e "WPS_MODE=WRFDA" \
cimafoundation/wps-da.ifs
