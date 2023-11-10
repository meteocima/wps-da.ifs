FROM cimafoundation/wps-da.run:v3.2.1
ADD namelists namelists
ENV WPS_INPUT IFS
CMD bash common-start.sh
