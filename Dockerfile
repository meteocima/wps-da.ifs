FROM cimafoundation/wps-da.run:v2.0.2
ADD namelists namelists
ENV WPS_INPUT IFS
CMD bash 
