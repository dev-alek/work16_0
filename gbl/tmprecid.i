 define {1} temp-table tmprecid 
    field Frecid as int64 init ?
    field fnum as character
    field fTable as character
 index num  fnum Frecid
 index itable is primary unique fTable Frecid  
 .