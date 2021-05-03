#FROM cimafoundation/wps-da.run:v2.0.4
FROM cimafoundation/wps-da.run:latest
ADD namelists namelists
ENV WPS_INPUT IFS
CMD bash common-start.sh
