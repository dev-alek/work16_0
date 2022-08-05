&if defined (tmprecid_i_def) eq 0
&then
&glob tmprecid_i_def yes
 define {1} temp-table tmprecid 
    field Frecid as recid init ?
    field fnum as character
    field fTable as character
 index num  fnum Frecid
 index itable is primary unique fTable Frecid  
 .
&endif