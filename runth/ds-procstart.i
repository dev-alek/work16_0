define temp-table tt-procList no-undo serialize-name "ProcList"
    field FileName           as character 
    field Desc_              as character
    field RunFile            as logical 
    field Repaintrow         as logical init true
    index pi is primary unique
        FileName
.