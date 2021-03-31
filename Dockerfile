FROM cimafoundation/wps-da.run
ADD namelists namelists
ENV WPS_INPUT IFS
CMD bash 
