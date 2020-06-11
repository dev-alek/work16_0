&if "{1}" = "" 
&then

&if defined(globobjSrv) eq 0
&then 
&glob globobjSrv yes
def var objSrv as class ibs.th.gbl.sys.objsrv no-undo.
run gbl/getobjsrvhndl.p (input-output ObjSrv).
&endif
&endif
