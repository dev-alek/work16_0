
/*------------------------------------------------------------------------
    File        : getAsiDataAgent.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : SSlivenko
    Created     : Fri Nov 08 17:27:55 AST 2019
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define output parameter p-file-name as character no-undo .


{ gbl/db-attr.i }

define temp-table tt-place no-undo
  field loc1          as character  label "№ резервуара"
  field pl-code       as integer    label "Код резервуара"
  field gds-code      as integer    label "Код продукта"
  field gds-name      as character  label "НАИМЕНОВАНИЕ ПРОДУКТА"
  field level-total   as decimal    label "Общий уровень (см)"
  field level-water   as decimal    label "Уровень воды (см)"
  field total-vol     as decimal    label "Общий объем (л)"
  field avrg-temp     as decimal    label "Средняя Т"
  field t1            as decimal    label "T1"
  field t2            as decimal    label "T2"
  field t3            as decimal    label "T3"
  field density       as decimal    label "Плотность (кг/л)"
  field mass          as decimal    label "Масса (кг)"
  field vapor-density as decimal    label "Плотность СУГ (кг/л)"
  field vapor-pressure as decimal   label "Давление СУГ (мПа)"
  index pi as primary unique
    loc1
.

define variable v-parsesub        as character  no-undo .
define variable hDoc              as handle     no-undo .
define variable hRoot             as handle     no-undo .
define variable good              as logical    no-undo .

define variable curl-path         as character  no-undo .
define variable v-command         as character  no-undo .
define variable v-addr            as character  no-undo .
define variable v-log-file-name   as character  no-undo .

define variable v-asi-ip  as character no-undo .
define variable v-asi-port as character no-undo .
define variable v-attr-type as character no-undo .
  

/* ***************************  Main Block  *************************** */

p-file-name = "revis.agnt" .
v-log-file-name = substitute('&1rvs.log', ibs.th.gbl.gbl-inipar:logDir) .

find first sys-ctrl no-lock.
run db-attr-value(sys-ctrl.db,"AsiIp",output v-asi-ip,output v-attr-type).
run db-attr-value(sys-ctrl.db,"AsiPort",output v-asi-port,output v-attr-type).

v-addr = v-asi-ip + ":" + v-asi-port + "/getmeas/?loclist=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" .
v-command = substitute ('&1 --connect-timeout 5 "&3" >&2', search ("exe/curl.exe"), "asidata.xml", v-addr).

os-command silent value(v-command) .
output to value (  v-log-file-name  ) append .
put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Запрос  " v-command skip .
output close .

file-info:file-name = "asidata.xml" .
if file-info:file-size = 0
then do :
  return error "Не могу получить ответ от агента АСИ" .
end.
empty temp-table tt-place .
run parse-xml (input "asidata.xml") .
os-delete value("asidata.xml") no-error .

output to value (p-file-name) .

for each tt-place no-lock :
  put unformatted ("TANK = " + tt-place.loc1 ) skip .
  if tt-place.level-total <> ? then
    put unformatted ("LEVEL_TOTAL = " + string(tt-place.level-total / 10, ">>>>>9.9<<<")) skip .
  if tt-place.level-water <> ? then
    put unformatted ("LEVEL_WATER = " + string(tt-place.level-water / 10, ">>>>>9.9<<<")) skip .
  if (tt-place.level-total - tt-place.level-water) <> ? then
    put unformatted ("LEVEL_OIL = " + string((tt-place.level-total - tt-place.level-water) / 10, ">>>>>9.9<<<")) skip .
  if tt-place.avrg-temp <> ? then
    put unformatted ("TEMPERATURE = " + string(tt-place.avrg-temp, "->>>>>9.9<<<")) skip .
  if tt-place.density <> ? then
    put unformatted ("DENSITY = " + string(tt-place.density, ">>>>>9.9<<<")) skip .
  if tt-place.total-vol <> ? then
    put unformatted ("VOLUME_TOTAL = " + string(tt-place.total-vol, ">>>>>9.9<<<")) skip .
  if tt-place.mass <> ? then
    put unformatted ("MASS_TOTAL = " + string(tt-place.mass, ">>>>>9.9<<<")) skip .
  if tt-place.t1 <> ? then
    put unformatted ("T1 = " + string(tt-place.t1, "->>>>>9.9<<<")) skip .
  if tt-place.t2 <> ? then
    put unformatted ("T2 = " + string(tt-place.t1, "->>>>>9.9<<<")) skip .
  if tt-place.t3 <> ? then
    put unformatted ("T3 = " + string(tt-place.t3, "->>>>>9.9<<<")) skip .
  if tt-place.vapor-density <> 0 and tt-place.vapor-density <> ? then
    put unformatted ("VAPOR_DENSITY = " + string(tt-place.vapor-density, ">>>>>9.9<<<")) skip .
  if tt-place.vapor-pressure <> 0 and tt-place.vapor-pressure <> ? then
    put unformatted ("VAPOR_PRESSURE = " + string(tt-place.vapor-pressure, ">>>>>9.9<<<")) skip .
end.

output close .

output to value (  v-log-file-name  ) append .
put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Данные  " skip .
output close .
os-append value(p-file-name) value(v-log-file-name).

output to value (  v-log-file-name  ) append .
put unformatted skip .
output close .

procedure parse-xml :
  define input parameter p-file as character .
  
  CREATE X-DOCUMENT hDoc.
  CREATE X-NODEREF hRoot.
     
  hDoc:LOAD("file",p-file,FALSE).
     
  hDoc:GET-DOCUMENT-ELEMENT(hRoot).
      
  RUN GetChildren(hRoot, 1).
  
  DELETE OBJECT hDoc.
  DELETE OBJECT hRoot.
  
end procedure .

PROCEDURE GetChildren:
DEFINE INPUT PARAMETER hParent AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER level AS INTEGER NO-UNDO.

DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE hNoderef AS HANDLE NO-UNDO.
DEFINE VARIABLE hText AS HANDLE NO-UNDO.
define variable client as character no-undo.

CREATE X-NODEREF hNoderef.
CREATE X-NODEREF hText .


REPEAT i = 1 TO hParent:NUM-CHILDREN:
    good = hParent:GET-CHILD(hNoderef,i).
    IF NOT good THEN 
        LEAVE.
    IF hNoderef:SUBTYPE <> "element" THEN
        NEXT.
    
    hNoderef:GET-CHILD(hText, 1) no-error .    
    
        
    IF hNoderef:NAME = "Tank"
    then do :
      find first tt-place where tt-place.loc1 = hText:node-value no-error .
      if not available tt-place
      then do :
        create tt-place .
        assign tt-place.loc1 = hText:node-value no-error .
        assign
          tt-place.t1             = ?
          tt-place.t2             = ?
          tt-place.t3             = ?
          tt-place.level-total    = ?   
          tt-place.level-water    = ?   
          tt-place.total-vol      = ? 
          tt-place.avrg-temp      = ?  
          tt-place.density        = ? 
          tt-place.mass           = ?
          tt-place.vapor-density  = ?
          tt-place.vapor-pressure = ?
        .
      end.
    end.
    
    IF hNoderef:NAME = "LevelTotal" then assign tt-place.level-total = decimal(hText:node-value) no-error .
    IF hNoderef:NAME = "LevelWater" then assign tt-place.level-water = decimal(hText:node-value) no-error .
    IF hNoderef:NAME = "Temperature" then assign tt-place.avrg-temp = decimal(hText:node-value) no-error .
    IF hNoderef:NAME = "Density" then assign tt-place.density = decimal(hText:node-value) no-error .
    IF hNoderef:NAME = "VolumeTotal" then assign tt-place.total-vol = decimal(hText:node-value) no-error .
    IF hNoderef:NAME = "MassTotal" then assign tt-place.mass = decimal(hText:node-value) no-error .
    IF hNoderef:NAME = "VaporDensity" then assign tt-place.vapor-density = decimal(hText:node-value) no-error .
    IF hNoderef:NAME = "VaporPressure" then assign tt-place.vapor-pressure = decimal(hText:node-value) no-error .
    IF hNoderef:NAME = "Temperature1" then assign tt-place.t1 = decimal(hText:node-value) no-error .
    IF hNoderef:NAME = "Temperature2" then assign tt-place.t2 = decimal(hText:node-value) no-error .
    IF hNoderef:NAME = "Temperature3" then assign tt-place.t3 = decimal(hText:node-value) no-error .
           
    RUN GetChildren(hNoderef, (level + 1)).
END.

DELETE OBJECT hNoderef.
DELETE OBJECT hText.
END PROCEDURE.