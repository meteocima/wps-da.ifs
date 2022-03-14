FROM cimafoundation/wps-da.run:v3.1.0
ADD namelists namelists
ENV WPS_INPUT IFS
CMD bash common-start.sh
