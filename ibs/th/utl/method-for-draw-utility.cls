 
 /*------------------------------------------------------------------------
    File        : method-for-draw-utility
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Wed Oct 10 15:30:57 MSK 2018
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Json.ObjectModel.*. 

block-level on error undo, throw.

class ibs.th.utl.method-for-draw-utility final: 
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  { gbl/getcntxt.i def }
  define public variable Obj-type      as character  no-undo.
  define public variable Obj-code      as integer    no-undo.
  define public variable v-host-code as integer no-undo .
  { cmp/library.i class}
  define property parparentproc as handle no-undo
  get.
  set(input iH as handle):
       parparentproc = iH.
     { gbl/getcntxt.i get }
     { gbl/hostcode.i v-cntxt-obj-type v-cntxt-obj-code v-host-code }
    Obj-code = v-cntxt-obj-code.
    Obj-type = v-cntxt-obj-type.
  end.
  define public variable mAddr         as character no-undo.
  //define public variable mlogHand      as handle no-undo. 
  
  
 
  {cmp/str-glbl.i class}
  &glob defined_parparentproc = yes 

  {str/nozzleav.i class} 
  { str/nzpl-spl.i class} 
  { trg/cplgdspm.i class}
  
  { gbl/attr-lib.i class}
  define variable g#language as character no-undo init "rus".
  { str/doc-code.i class}
  define temp-table tt-gds-prod
    field gds-code as integer
    field b-str as character
    index pi as primary unique  gds-code
.
define temp-table tt-place          like ub.place .
define temp-table tt-place-attr     like ub.place-attr .
define temp-table tt-pump           like ub.pump .
define temp-table tt-nozzle         like ub.nozzle .
define temp-table tt-pl-pump        like ub.pl-pump .
define temp-table tt-pump-nozzle    like ub.pump-nozzle .
define temp-table tt-pl-pump-nozzle like ub.pl-pump-nozzle .
define temp-table tt-pl-level       like ub.pl-level .
define temp-table tt-pl-gds         like ub.pl-gds .
define temp-table tt-pl-gds-pump    like ub.pl-gds-pump .
define temp-table tt-cash-desk like ub.cash-desk .
define temp-table tt-cash-desk-attr like ub.cash-desk-attr
  field attr-value as character 
.
define temp-table tt-rvs-doc          like ub.rvs-doc 
    field Findex as logical
    index pi FINdex.
define temp-table tt-rvs-doc-attr     like ub.rvs-doc-attr 
field Findex as logical
index pi FINdex.
define temp-table tt-rvs-line-attr    like ub.rvs-line-attr 
    field Findex as logical
    index pi FINdex.
define temp-table tt-rvs-line         like ub.rvs-line 
field loc1 as character 
    field Findex as logical
    index pi FINdex.
define temp-table tt-rvs-pump        like ub.rvs-pump
    field Findex as logical
    index pi FINdex.
define temp-table tt-rvs-pump-attr        like ub.rvs-pump-attr
    field Findex as logical
    index pi FINdex.
 define temp-table tt-rvs-line-pump-attr         like ub.rvs-line-pump-attr
    field loc1 as character 
     field Findex as logical
     index pi FINdex.  
define temp-table tt-rvs-line-pump like rvs-line-pump
    field loc1 as character 
    field Findex as logical
    index pi FINdex.

define temp-table tt-gds-mapping
  field gds-code15 as integer
  field gds-code16 as integer
  index pi as primary 
    gds-code15
.
define temp-table tt-gds-price
  field gds-code as integer
  field price as decimal
  index pi as primary unique
    gds-code
.
define temp-table tt-place-loc
  field pl-code as integer
  field loc1 as character
  index pi as primary unique
    pl-code
.

define temp-table tt-icnt-doc like ub.icnt-doc .
define temp-table tt-icnt-line like ub.icnt-line .
{utl/imp-parts.i }
{utl/imp-parts-ptrl.i }


{ utl/tt301.i    }




define variable mJsonObj       as JsonObject           no-undo.
define variable mParser        as ObjectModelParser    no-undo.
define variable results-array   as JsonArray            no-undo.
define variable myResultObj     as JsonObject           no-undo.
define variable mplacelib       as class ibs.th.str.placelib no-undo.
define stream lsIN.
define stream lsOUT.
&glob namelogfile    value(substitute("&1darw_util_&2.log", ibs.th.gbl.gbl-inipar:logDir,v-cntxt-obj-code))    
&glob namelogfileerr value(substitute("&1darw_util_&2.err", ibs.th.gbl.gbl-inipar:logDir,v-cntxt-obj-code))
  constructor public method-for-draw-utility (  ):
    super ().
    mplacelib = new ibs.th.str.placelib().
    mParser = new ObjectModelParser().
   /* output to {&namelogfile} .
    output close.*/
  end constructor.

  destructor public method-for-draw-utility ( ):
      delete object mJsonObj no-error.
      delete object mParser  no-error.
      delete object mplacelib.
  end destructor.
 define public event write-log 
    signature void ( input pcCustName as character ).   
method public void put-log (iText as character ):
  /*if valid-handle(mlogHand)
  then
     run pcall-log-file in mlogHand (Itext).*/
  put-log-all(Itext).
  publish "write-log" from parparentproc (Itext ).
  write-log:PUBLISH (iText).
end method.

method public void put-err-log (iText as character ):
  /*if valid-handle(mlogHand)
  then
     run pcall-log-file-err in mlogHand (Itext).*/
  publish "write-log-err" from parparentproc (Itext ).
  put-log-all(Itext).
end method. 

method public void put-log-all(itext as char):
   output to {&namelogfile} append.
   if itext = ""
   then
      put unformatted skip(1) .
   else
      put unformatted itext skip .
   output close.
end.  
method public void put-log-allerr(itext as char):
   output to {&namelogfileerr} append.
   if itext = ""
   then
      put unformatted skip(1) .
   else
      put unformatted itext skip .
   output close.
end.
  
method private void pumpav(
  parobj-type  like ub.clients.obj-type,
  parobj-code  like ub.clients.obj-code,
  parpump-code like ub.pump.pump-code 
):
  define buffer bf_clients for ub.clients.
  define buffer bf_pump    for ub.pump.
  { str/ptrlv.i "ov+"}
  /*Проверяем то, что нет еще такого ТРК*/
  find first bf_pump no-lock
    where bf_pump.obj-type  = parobj-type
      and bf_pump.obj-code  = parobj-code
      and bf_pump.pump-code = parpump-code
    no-error.
  if available bf_pump then do:
    return error substitute("Уже есть ТРК с номером &1", parpump-code) {&str-obj}.
  end.
  create bf_pump.
  assign
    bf_pump.obj-type  = parobj-type
    bf_pump.obj-code  = parobj-code
    bf_pump.pump-code = parpump-code
  .
end method.

method private void pumpnzav(
parobj-type    like ub.clients.obj-type,
parobj-code    like ub.clients.obj-code,
parpump-code   like ub.pump.pump-code,
parnozzle-code like ub.nozzle.nozzle-code,
paris-meas     like ub.pump-nozzle.is-meas,
paref-nid      like ub.pump-nozzle.ef-nid
):
define buffer bf_clients     for ub.clients.
define buffer bf_pump        for ub.pump.
define buffer bf_nozzle      for ub.nozzle.
define buffer bf_pump-nozzle for ub.pump-nozzle.
define buffer bf_rvs-doc     for ub.rvs-doc.
define buffer bf_icnt-doc    for ub.icnt-doc.
{ str/ptrlv.i "ov+"       }
{ str/ptrlv.i "ppv+"      }
{ str/ptrlv.i "nv+"       }
{ str/ptrlv.i "rvs-doc-"  }
{ str/ptrlv.i "icnt-doc-" }
/*Проверяем то, что нет еще такой записи ТРК-пистолет*/
find first bf_pump-nozzle where bf_pump-nozzle.obj-type    = parobj-type    and
                                bf_pump-nozzle.obj-code    = parobj-code    and
                                bf_pump-nozzle.pump-code   = parpump-code   and
                                bf_pump-nozzle.nozzle-code = parnozzle-code no-lock no-error.
if available bf_pump-nozzle then
             return error substitute ("Уже есть запись ТРК-пистолет с номером ТРК &1 и номером пистолета &2", parpump-code, parnozzle-code) {&str-obj}.
create bf_pump-nozzle.
assign bf_pump-nozzle.obj-type    = parobj-type
       bf_pump-nozzle.obj-code    = parobj-code
       bf_pump-nozzle.pump-code   = parpump-code
       bf_pump-nozzle.nozzle-code = parnozzle-code
       bf_pump-nozzle.is-meas     = paris-meas
       bf_pump-nozzle.ef-nid      = paref-nid
       .
end method.

method private void plpumpav(
  parobj-type  like ub.clients.obj-type,
  parobj-code  like ub.clients.obj-code,
  parpl-code   like ub.place.pl-code,
  parpump-code like ub.pump.pump-code
):
  define buffer bf_clients           for ub.clients.
  define buffer bf_pump              for ub.pump.
  define buffer bf_place             for ub.place.
  define buffer bf_pl-pump           for ub.pl-pump.
  define buffer bf_pl-gds            for ub.pl-gds.
  define buffer bf_goods             for ub.goods.
  define buffer bf_pl-gds-pump       for ub.pl-gds-pump.
  define buffer bf-other_pl-gds-pump for ub.pl-gds-pump.

  define variable varstatus as character no-undo.

  { str/ptrlv.i "ov+"}
  { str/ptrlv.i "ppv+"}
  { str/ptrlv.i "plv+"}
  /*Проверяем то, что нет еще такой записи резервуар-ТРК*/
  find first bf_pl-pump no-lock
    where bf_pl-pump.obj-type   = parobj-type
      and bf_pl-pump.obj-code   = parobj-code
      and bf_pl-pump.pl-code    = parpl-code
      and bf_pl-pump.pump-code  = parpump-code
    no-error.
  if available bf_pl-pump then do:
    return error substitute("Уже есть запись резервуар-ТРК с номером резервуара &1 и номером ТРК &2", parpl-code, parpump-code) {&str-obj}.
  end.
  /*Если есть в резервуаре бензин делаем проверку, что через данную ТРК не течет данный бензин
    и создаем связку с топливом*/
  find first bf_pl-gds no-lock
    where bf_pl-gds.obj-type = parobj-type
      and bf_pl-gds.obj-code = parobj-code
      and bf_pl-gds.pl-code  = parpl-code
    no-error.
  tr:
  do transaction
  on error undo tr, return error return-value
  :
    if available bf_pl-gds then do:
      find first bf_goods no-lock
        where bf_goods.gds-code = bf_pl-gds.gds-code
      .
      assign
        varstatus = {&current-status}
      .
      find first bf-other_pl-gds-pump no-lock
        where bf-other_pl-gds-pump.obj-type  = parobj-type
          and bf-other_pl-gds-pump.obj-code  = parobj-code
          and bf-other_pl-gds-pump.gds-code  = bf_goods.gds-code
          and bf-other_pl-gds-pump.pump-code = parpump-code
          and bf-other_pl-gds-pump.status_   = {&current-status}
        no-error.
      if available bf-other_pl-gds-pump
        and nzpl-spl(bf-other_pl-gds-pump.obj-type, bf-other_pl-gds-pump.obj-code) <> yes
      then do:
/*        message                                                                                                                                           */
/*          "Через ТРК с номером " parpump-code " уже продается топливо " bf_goods.artic " " bf_goods.prod-type " " bf_goods.prod-code " " bf_goods.gds-name*/
/*          " которое связано с резервуаром " bf-other_pl-gds-pump.pl-code "." skip                                                                         */
/*          "Данная привязка Резервуар-ТРК-Товар получит статус блокированный."                                                                             */
/*          view-as alert-box information.                                                                                                                  */
        assign
          varstatus = {&blocked-status}
        .
      end.
      create bf_pl-gds-pump.
      assign
        bf_pl-gds-pump.obj-type  = parobj-type
        bf_pl-gds-pump.obj-code  = parobj-code
        bf_pl-gds-pump.pl-code   = parpl-code
        bf_pl-gds-pump.gds-code  = bf_goods.gds-code
        bf_pl-gds-pump.pump-code = parpump-code
        bf_pl-gds-pump.status_   = varstatus
      .
       cplgdspm 
        ( input bf_pl-gds-pump.obj-type
         ,input bf_pl-gds-pump.obj-code
         ,input bf_pl-gds-pump.pl-code
         ,input bf_pl-gds-pump.gds-code
         ,input bf_pl-gds-pump.pump-code
         ,input bf_pl-gds-pump.status_
        ) no-error.
      if error-status:error then do:
        undo tr, return error substitute ("Ошибка при смене статуса записи резервуар-ТРК-пистолет: &1 &2.", return-value, error-status:get-message(1)).
      end.
    end.
    create bf_pl-pump.
    assign
      bf_pl-pump.obj-type   = parobj-type
      bf_pl-pump.obj-code   = parobj-code
      bf_pl-pump.pl-code    = parpl-code
      bf_pl-pump.pump-code  = parpump-code
    .
  end. /*transaction*/
end method. 

method private void plpmnzav(
  parobj-type    like ub.clients.obj-type  ,
  parobj-code    like ub.clients.obj-code  ,
  parpl-code     like ub.place.pl-code     ,
  parpump-code   like ub.pump.pump-code    ,
  parnozzle-code like ub.nozzle.nozzle-code 
):
  
    define buffer bf_clients              for ub.clients.
    define buffer bf_place                for ub.place.
    define buffer bf_pump                 for ub.pump.
    define buffer bf_nozzle               for ub.nozzle.
    define buffer bf_pl-pump              for ub.pl-pump.
    define buffer bf_pump-nozzle          for ub.pump-nozzle.
    define buffer bf_pl-pump-nozzle       for ub.pl-pump-nozzle.
    define buffer bf-other_pl-pump-nozzle for ub.pl-pump-nozzle.
    define buffer bf_rvs-doc              for ub.rvs-doc.
    define buffer bf_icnt-doc             for ub.icnt-doc.
    define buffer bf_pl-gds-pump          for ub.pl-gds-pump.
    define buffer bf-other_pl-gds-pump    for ub.pl-gds-pump.

    { str/ptrlv.i "ov+"       }
    { str/ptrlv.i "ppv+"      }
    { str/ptrlv.i "plv+"      }
    { str/ptrlv.i "nv+"       }
    { str/ptrlv.i "plppv+"    }
    { str/ptrlv.i "ppnv+"     }
    { str/ptrlv.i "rvs-doc-"  }
    { str/ptrlv.i "icnt-doc-" }
    /*Проверяем то, что нет еще такой связки резервуар-ТРК в журнале резервуар-ТРК-пистолет*/
/*    if nzpl-spl(parobj-type, parobj-code) <> yes then do:                                                                                                  */
/*      find first bf_pl-pump-nozzle no-lock                                                                                                                 */
/*        where bf_pl-pump-nozzle.obj-type   = parobj-type                                                                                                   */
/*          and bf_pl-pump-nozzle.obj-code   = parobj-code                                                                                                   */
/*          and bf_pl-pump-nozzle.pl-code    = parpl-code                                                                                                    */
/*          and bf_pl-pump-nozzle.pump-code  = parpump-code                                                                                                  */
/*        no-error.                                                                                                                                          */
/*      if available bf_pl-pump-nozzle then do:                                                                                                              */
/*        return error substitute("Резервуар &1 уже связан с ТРК &2, через пистолет &3", parpl-code, parpump-code, bf_pl-pump-nozzle.nozzle-code) {&str-obj}.*/
/*      end.                                                                                                                                                 */
/*    end.                                                                                                                                                   */
    do /*transaction*/
    on error undo, return error return-value
    :
      /*Если есть привязка к топливу*/
/*      find first bf_pl-gds-pump no-lock                                                                                                                                                                                                                                   */
/*        where bf_pl-gds-pump.obj-type  = parobj-type                                                                                                                                                                                                                      */
/*          and bf_pl-gds-pump.obj-code  = parobj-code                                                                                                                                                                                                                      */
/*          and bf_pl-gds-pump.pl-code   = parpl-code                                                                                                                                                                                                                       */
/*          and bf_pl-gds-pump.pump-code = parpump-code                                                                                                                                                                                                                     */
/*        no-error.                                                                                                                                                                                                                                                         */
/*      if available bf_pl-gds-pump then do:                                                                                                                                                                                                                                */
/*        /*Если есть еще резервуар который льет такое же топливо через эту же ТРК*/                                                                                                                                                                                        */
/*        find first bf-other_pl-gds-pump no-lock                                                                                                                                                                                                                           */
/*          where bf-other_pl-gds-pump.obj-type  = bf_pl-gds-pump.obj-type                                                                                                                                                                                                  */
/*            and bf-other_pl-gds-pump.obj-code  = bf_pl-gds-pump.obj-code                                                                                                                                                                                                  */
/*            and bf-other_pl-gds-pump.gds-code  = bf_pl-gds-pump.gds-code                                                                                                                                                                                                  */
/*            and bf-other_pl-gds-pump.pump-code = bf_pl-gds-pump.pump-code                                                                                                                                                                                                 */
/*            and bf-other_pl-gds-pump.pl-code  <> bf_pl-gds-pump.pl-code                                                                                                                                                                                                   */
/*          no-error.                                                                                                                                                                                                                                                       */
/*                                                                                                                                                                                                                                                                          */
/*        if available bf-other_pl-gds-pump then do:                                                                                                                                                                                                                        */
/*          if nzpl-spl(parobj-type, parobj-code) <> yes then do:                                                                                                                                                                                                           */
/*            /*А из какого резервуара он льет*/                                                                                                                                                                                                                            */
/*            find first bf-other_pl-pump-nozzle no-lock                                                                                                                                                                                                                    */
/*              where bf-other_pl-pump-nozzle.obj-type  = bf-other_pl-gds-pump.obj-type                                                                                                                                                                                     */
/*                and bf-other_pl-pump-nozzle.obj-code  = bf-other_pl-gds-pump.obj-code                                                                                                                                                                                     */
/*                and bf-other_pl-pump-nozzle.pl-code   = bf-other_pl-gds-pump.pl-code                                                                                                                                                                                      */
/*                and bf-other_pl-pump-nozzle.pump-code = bf-other_pl-gds-pump.pump-code                                                                                                                                                                                    */
/*              no-error.                                                                                                                                                                                                                                                   */
/*            if available bf-other_pl-pump-nozzle then do:                                                                                                                                                                                                                 */
/*              /*Из разных пистолетов на одной ТРК нельзя торговать одним и тем же топливом*/                                                                                                                                                                              */
/*              if bf-other_pl-pump-nozzle.nozzle-code <> parnozzle-code then do:                                                                                                                                                                                           */
/*                return error substitute ("На объекте &1 &2 ТРК &3 через пистолет &4 торгует топливом с внутренним кодом &5 из резервуара &6.&7"                                                                                                                           */
/*                                         + "КАСССА не возвращает номер пистолета в чеке, .&7"                                                                                                                                                                             */
/*                                         + "поэтому нельзя торговать одним и тем же топливом на одной ТРК через разные пистолеты.&7"                                                                                                                                      */
/*                                         , bf-other_pl-pump-nozzle.obj-type                                                                                                                                                                                               */
/*                                         , bf-other_pl-pump-nozzle.obj-code                                                                                                                                                                                               */
/*                                         , bf-other_pl-pump-nozzle.pump-code                                                                                                                                                                                              */
/*                                         , bf-other_pl-pump-nozzle.nozzle-code                                                                                                                                                                                            */
/*                                         , bf-other_pl-gds-pump.gds-code                                                                                                                                                                                                  */
/*                                         , bf-other_pl-gds-pump.pl-code                                                                                                                                                                                                   */
/*                                         , {&new-line}                                                                                                                                                                                                                    */
/*                                        ).                                                                                                                                                                                                                                */
/*              end.                                                                                                                                                                                                                                                        */
/*            end.                                                                                                                                                                                                                                                          */
/*          end.                                                                                                                                                                                                                                                            */
/*          else do:                                                                                                                                                                                                                                                        */
/*            find current bf_pl-gds-pump exclusive-lock.                                                                                                                                                                                                                   */
/*            assign                                                                                                                                                                                                                                                        */
/*              bf_pl-gds-pump.status_ = {&blocked-status}.                                                                                                                                                                                                                 */
/*          end.                                                                                                                                                                                                                                                            */
/*        end.                                                                                                                                                                                                                                                              */
/*        /*Идем по остальным резервуарам льющим через данный пистолет на данной ТРК*/                                                                                                                                                                                      */
/*        for each bf-other_pl-pump-nozzle where bf-other_pl-pump-nozzle.obj-type    = parobj-type                                                                                                                                                                          */
/*                                            and bf-other_pl-pump-nozzle.obj-code    = parobj-code                                                                                                                                                                         */
/*                                            and bf-other_pl-pump-nozzle.pump-code   = parpump-code                                                                                                                                                                        */
/*                                            and bf-other_pl-pump-nozzle.nozzle-code = parnozzle-code                                                                                                                                                                      */
/*                                            no-lock on error undo, return error return-value :                                                                                                                                                                            */
/*          find first bf-other_pl-gds-pump where bf-other_pl-gds-pump.obj-type  = bf-other_pl-pump-nozzle.obj-type                                                                                                                                                         */
/*                                            and bf-other_pl-gds-pump.obj-code  = bf-other_pl-pump-nozzle.obj-code                                                                                                                                                         */
/*                                            and bf-other_pl-gds-pump.pl-code   = bf-other_pl-pump-nozzle.pl-code                                                                                                                                                          */
/*                                            and bf-other_pl-gds-pump.pump-code = bf-other_pl-pump-nozzle.pump-code no-lock no-error.                                                                                                                                      */
/*          if available bf-other_pl-gds-pump then do:                                                                                                                                                                                                                      */
/*            if bf-other_pl-gds-pump.gds-code <> bf_pl-gds-pump.gds-code then do:                                                                                                                                                                                          */
/*              return error substitute ("На объекте &1 &2 ТРК &3 через пистолет &4 торгует топливом с внутренним кодом &5 из резервуара &6. Вы хотите торговать топливом с внутренним кодом &7. Разными видами топлива через один пистолет на одной ТРК торговать нельзя.",*/
/*                                        bf-other_pl-pump-nozzle.obj-type,                                                                                                                                                                                                 */
/*                                        bf-other_pl-pump-nozzle.obj-code,                                                                                                                                                                                                 */
/*                                        bf-other_pl-pump-nozzle.pump-code,                                                                                                                                                                                                */
/*                                        bf-other_pl-pump-nozzle.nozzle-code,                                                                                                                                                                                              */
/*                                        bf-other_pl-gds-pump.gds-code,                                                                                                                                                                                                    */
/*                                        bf-other_pl-gds-pump.pl-code,                                                                                                                                                                                                     */
/*                                        bf_pl-gds-pump.gds-code).                                                                                                                                                                                                         */
/*            end.                                                                                                                                                                                                                                                          */
/*          end.                                                                                                                                                                                                                                                            */
/*        end.                                                                                                                                                                                                                                                              */
/*      end.                                                                                                                                                                                                                                                                */

      create bf_pl-pump-nozzle.
      assign
        bf_pl-pump-nozzle.obj-type    = parobj-type
        bf_pl-pump-nozzle.obj-code    = parobj-code
        bf_pl-pump-nozzle.pl-code     = parpl-code
        bf_pl-pump-nozzle.pump-code   = parpump-code
        bf_pl-pump-nozzle.nozzle-code = parnozzle-code
      .
    end. /*transaction*/
  
end method.

// перенос топологии 
method public void load_schem (ifile-path as character):
  load_schem(mAddr, ifile-path).
end. 

method public void load_schem (iAddr as character, ifile-path as character ):
  define variable v-rep-rec as recid no-undo .
  define variable v-ok        as logical   no-undo.
  define variable cmd as character no-undo.
  
  load_gds_maping(ifile-path).
   
  empty temp-table tt-gds-prod .
  empty temp-table tt-place.
  empty temp-table tt-place-attr. 
  empty temp-table tt-pump. 
  empty temp-table tt-nozzle. 
  empty temp-table tt-pl-pump. 
  empty temp-table tt-pump-nozzle. 
  empty temp-table tt-pl-pump-nozzle. 
  empty temp-table tt-pl-level. 
  empty temp-table tt-pl-gds. 
  empty temp-table tt-pl-gds-pump. 
   cmd = substitute ("&1 &2/THGetInfo?GetSchem >&3", search ("exe/curl.exe"), iAddr, "schem-temp.json").
  os-command silent value (cmd).
  fix-codepage_and_SetJsonObj (input "schem-temp.json") .
  
  
  parse-json(input temp-table tt-place:default-buffer-handle, input "place") .
  parse-json(input temp-table tt-place-attr:default-buffer-handle, input "place-attr") .
  parse-json(input temp-table tt-pump:default-buffer-handle, input "pump") .
  parse-json(input temp-table tt-nozzle:default-buffer-handle, input "nozzle") .
  parse-json(input temp-table tt-pl-pump:default-buffer-handle, input "pl-pump") .
  parse-json(input temp-table tt-pump-nozzle:default-buffer-handle, input "pump-nozzle") .
  parse-json(input temp-table tt-pl-pump-nozzle:default-buffer-handle, input "pl-pump-nozzle") .
  parse-json(input temp-table tt-pl-level:default-buffer-handle, input "pl-level") .
  parse-json(input temp-table tt-pl-gds:default-buffer-handle, input "pl-gds") .
  parse-json(input temp-table tt-pl-gds-pump:default-buffer-handle, input "pl-gds-pump") .
  parse-json(input temp-table tt-gds-prod:default-buffer-handle, input "tt-gds-prod") .
  
  /* Delete all objects created by this procedure to avoid memory leaks */
  //  delete object myResultObj no-error.
  //delete object results-array no-error.
  
  for each tt-gds-prod no-lock :
    find first tt-gds-mapping no-lock where tt-gds-mapping.gds-code15 = tt-gds-prod.gds-code no-error .
    if not available tt-gds-mapping
    then do :
      undo, return error ("В файле соответсвий нет топлива " + string(tt-gds-prod.gds-code) + " с коротким кодом " + tt-gds-prod.b-str) .
    end.
    find first ub.goods no-lock where ub.goods.gds-code = tt-gds-mapping.gds-code16 no-error.
    if not available ub.goods
    then do :
      undo, return error ("Нет топлива с кодом " + string(tt-gds-mapping.gds-code16) + " . Код в v15.0 - " + string(tt-gds-mapping.gds-code15)) .
    end.
  end. 
  
  put-log(string (now) + "   Начинаем загрузку топологии...").
  
  for each tt-pump no-lock :
    put-log("ТРК №" + string(tt-pump.pump-code)).
    pumpav 
      ( input v-cntxt-obj-type
       ,input v-cntxt-obj-code
       ,input tt-pump.pump-code
      ) no-error.
    if error-status:error then do:
       undo, return error return-value.
    end.
  end.
  
  for each tt-nozzle no-lock :
    put-log( "Пистолет №" + string(tt-nozzle.nozzle-code)).
    nozzleav (input v-cntxt-obj-type,
                        v-cntxt-obj-code,
                        tt-nozzle.nozzle-code) no-error.
    if error-status:error then do:
      undo, return error return-value.
    end.
  end.
  
  for each tt-pump-nozzle no-lock :
    put-log( "Связка ТРК-Пистолет №" + string(tt-pump-nozzle.pump-code) +  "-" +  string(tt-pump-nozzle.nozzle-code)) .
    pumpnzav( input v-cntxt-obj-type
             ,input v-cntxt-obj-code
             ,input tt-pump-nozzle.pump-code
             ,input tt-pump-nozzle.nozzle-code
             ,input tt-pump-nozzle.is-meas
             ,input ""
            ) no-error.
    if error-status:error then do:
       undo, return error return-value.
    end.
  end.
  
  for each tt-place no-lock :
    if tt-place.status_ = "удал" then next . /* Удаленные не загружаем */
    put-log( "Резервуар координата1 " + string(tt-place.loc1)) .
    run ref/place01.p
      ( input-output v-rep-rec
      , input {&add-def}
      , input yes /*silent*/
      , input v-cntxt-obj-type
      , input v-cntxt-obj-code
      , input 0
      , input tt-place.loc1
      , input tt-place.loc2
      , input tt-place.loc3
      , input tt-place.loc4
      , input tt-place.pl-name
      , input tt-place.ps
      , input tt-place.add-qnty
      , input tt-place.is-meas
      , input tt-place.max-qnty
      , input tt-place.issue-year
      , input tt-place.start-date
      , input yes
      ) no-error.
    if error-status:error then 
    do:
      undo, return error return-value.
    end.
    find first ub.place no-lock where recid(ub.place) = v-rep-rec .
    
    for each tt-place-attr no-lock where tt-place-attr.obj-type = tt-place.obj-type
                                     and tt-place-attr.obj-code = tt-place.obj-code
                                     and tt-place-attr.pl-code  = tt-place.pl-code :
      mplacelib:placelib_write-attr  
        (input tt-place-attr.attr-code
        ,input v-cntxt-obj-code
        ,input v-cntxt-obj-type
        ,input ub.place.pl-code
        ,input tt-place-attr.attr-value
        ,output v-ok      )
      no-error.   
      if error-status:error then 
      do:
        undo, return error return-value.
      end.                              
    end.
    
    find first ub.place-attr no-lock where ub.place-attr.obj-type = v-cntxt-obj-type
                                       and ub.place-attr.obj-code = v-cntxt-obj-code
                                       and ub.place-attr.pl-code  = ub.place.pl-code
                                       and ub.place-attr.attr-code = "place-error-mass"
                                       no-error .
    if not available ub.place-attr
    then do :
      mplacelib:placelib_write-attr  
        (input "place-error-mass"
        ,input v-cntxt-obj-code
        ,input v-cntxt-obj-type
        ,input ub.place.pl-code
        ,input string(0.15)
        ,output v-ok      )
      no-error.   
      if error-status:error then 
      do:
        undo, return error return-value.
      end.
    end.         
    
    find first ub.place-attr no-lock where ub.place-attr.obj-type = v-cntxt-obj-type
                                       and ub.place-attr.obj-code = v-cntxt-obj-code
                                       and ub.place-attr.pl-code  = ub.place.pl-code
                                       and ub.place-attr.attr-code = "place-local"
                                       no-error .
    if not available ub.place-attr
    then do :
      mplacelib:placelib_write-attr  
        (input "place-local"
        ,input v-cntxt-obj-code
        ,input v-cntxt-obj-type
        ,input ub.place.pl-code
        ,input string(2)
        ,output v-ok      )
      no-error.   
      if error-status:error then 
      do:
        undo, return error return-value.
      end.
    end.                           
    
    for each tt-pl-level no-lock where tt-pl-level.obj-type = tt-place.obj-type
                                   and tt-pl-level.obj-code = tt-place.obj-code
                                   and tt-pl-level.pl-code  = tt-place.pl-code :
      create ub.pl-level.
      assign
        ub.pl-level.obj-type  = v-cntxt-obj-type
        ub.pl-level.obj-code  = v-cntxt-obj-code
        ub.pl-level.pl-code   = ub.place.pl-code
        ub.pl-level.pl-level  = tt-pl-level.pl-level
        ub.pl-level.pl-qnty   = tt-pl-level.pl-qnty
      .
    end.
     
    for each tt-pl-gds no-lock where tt-pl-gds.obj-type = tt-place.obj-type
                                 and tt-pl-gds.obj-code = tt-place.obj-code
                                 and tt-pl-gds.pl-code  = tt-place.pl-code,
    first tt-gds-mapping no-lock where tt-gds-mapping.gds-code15 = tt-pl-gds.gds-code  : 
      run trg/plgdpmvc.p (
          input  v-cntxt-obj-type,
          input  v-cntxt-obj-code,
          input  ub.place.pl-code,
          input  tt-gds-mapping.gds-code16,
          output v-ok) no-error.
      if error-status:error then 
      do:
/*          message                                            */
/*              "Ошибка при привязке товара к резервуару." skip*/
/*              return-value skip                              */
/*              error-status:get-message(1)                    */
/*              view-as alert-box error.                       */
          undo, return error return-value.
      end.
      if not v-ok then 
      do:
/*          if return-value <> "" then                       */
/*              message return-value view-as alert-box ERROR.*/
/*          undo , next .                                    */
      end.
      
    end. 
    
    for each tt-pl-pump no-lock where tt-pl-pump.obj-type   = tt-place.obj-type
                                  and tt-pl-pump.obj-code   = tt-place.obj-code
                                  and tt-pl-pump.pl-code    = tt-place.pl-code :
       put-log(  "Связка Резервуар-ТРК №" + string(ub.place.loc1) +  "-" + string(tt-pl-pump.pump-code) ) .                              
       plpumpav
               (input v-cntxt-obj-type,
                input v-cntxt-obj-code,
                input ub.place.pl-code,
                input tt-pl-pump.pump-code) no-error.  
      if error-status:error then do:
         undo, return error return-value.
      end.                                      
    end.  
    
    for each tt-pl-pump-nozzle no-lock where  tt-pl-pump-nozzle.obj-type   = tt-place.obj-type
                                          and tt-pl-pump-nozzle.obj-code   = tt-place.obj-code
                                          and tt-pl-pump-nozzle.pl-code    = tt-place.pl-code :     
/*      find first tt-pl-gds-pump where tt-pl-gds-pump.obj-type = tt-pl-pump-nozzle.obj-type and          */
/*                                              tt-pl-gds-pump.obj-code = tt-pl-pump-nozzle.obj-code and  */
/*                                              tt-pl-gds-pump.pl-code = tt-pl-pump-nozzle.pl-code and    */
/*                                              tt-pl-gds-pump.pump-code = tt-pl-pump-nozzle.pump-code and*/
/*                                              tt-pl-gds-pump.status_ = 'тек'                            */
/*                                              no-lock no-error.                                         */
/*      if not available tt-pl-gds-pump                                                                   */
/*      then do:                                                                                          */
/*        next. /* Переносим только текущие связки рез-трк-пистолет */                                    */
/*      end.                                                                                              */
      put-log( "Связка Резервуар-ТРК-Пистолет №" + string(ub.place.loc1) + "-" +  string(tt-pl-pump-nozzle.pump-code) + "-" + string(tt-pl-pump-nozzle.nozzle-code)). 
      plpmnzav 
        ( input v-cntxt-obj-type
         ,input v-cntxt-obj-code
         ,input ub.place.pl-code
         ,input tt-pl-pump-nozzle.pump-code
         ,input tt-pl-pump-nozzle.nozzle-code
        ) no-error.
      if error-status:error then do:
         undo, return error return-value.
      end.
    end.   
    
    for each tt-pl-gds-pump where tt-pl-gds-pump.obj-type = tt-place.obj-type and
                                  tt-pl-gds-pump.obj-code = tt-place.obj-code and
                                  tt-pl-gds-pump.pl-code = tt-place.pl-code,
    first tt-gds-mapping no-lock where tt-gds-mapping.gds-code15 = tt-pl-gds-pump.gds-code :
      find first pl-gds-pump exclusive-lock where pl-gds-pump.obj-type = v-cntxt-obj-type
                                              and pl-gds-pump.obj-code = v-cntxt-obj-code
                                              and pl-gds-pump.pl-code  = ub.place.pl-code  
                                              and pl-gds-pump.gds-code = tt-gds-mapping.gds-code16   
                                              and pl-gds-pump.pump-code = tt-pl-gds-pump.pump-code   
                                              no-error.
      if available pl-gds-pump
      then do :
        pl-gds-pump.status_ = tt-pl-gds-pump.status_ .
      end.                                                          
    end.
                                                                                                              
  end.
  
  put-log( string(now) + "   Топология загружена!" ).
end method.

method public logical Chek_Shem(

):
    define variable v-has-records as logical no-undo.  
    for each ub.place no-lock where ub.place.obj-type = v-cntxt-obj-type
                                and ub.place.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if not v-has-records
    then
    for each ub.place-attr no-lock where ub.place-attr.obj-type = v-cntxt-obj-type
                                     and ub.place-attr.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if not v-has-records
    then
    
    for each ub.pump no-lock where ub.pump.obj-type = v-cntxt-obj-type
                               and ub.pump.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if not v-has-records
    then
    
    for each ub.nozzle no-lock where ub.nozzle.obj-type = v-cntxt-obj-type
                                 and ub.nozzle.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if not v-has-records
    then
    
    for each ub.pump-nozzle no-lock where ub.pump-nozzle.obj-type = v-cntxt-obj-type
                                      and ub.pump-nozzle.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if not v-has-records
    then
    
    for each ub.pl-pump-nozzle no-lock where ub.pl-pump-nozzle.obj-type = v-cntxt-obj-type
                                         and ub.pl-pump-nozzle.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if not v-has-records
    then
    
    for each ub.pl-pump no-lock where ub.pl-pump.obj-type = v-cntxt-obj-type
                                  and ub.pl-pump.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if not v-has-records
    then
    
    for each ub.pl-gds no-lock where ub.pl-gds.obj-type = v-cntxt-obj-type
                                 and ub.pl-gds.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if not v-has-records
    then
    
    for each ub.pl-gds-pump no-lock where ub.pl-gds-pump.obj-type = v-cntxt-obj-type
                                      and ub.pl-gds-pump.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    return v-has-records.
end method. 
method public logical chek_cash_desk():
    
    define variable v-has-records as logical no-undo.
    for each ub.cash-desk no-lock where ub.cash-desk.db-num = v-cntxt-db-num-obj
                                    and ub.cash-desk.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if not v-has-records
    then
    for each ub.cash-desk-attr no-lock where ub.cash-desk-attr.db-num = v-cntxt-db-num-obj
                                         and ub.cash-desk-attr.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    return  v-has-records.
end method.
// Перенос справочника касс 
method public void load_cashdesk ():
  load_cashdesk(mAddr ).
end. 
 
method public void load_cashdesk(iAddr as character ) :
  define variable v-rid as recid no-undo .
  define variable vcmd  as character no-undo.
  
  empty temp-table tt-cash-desk.
  empty temp-table tt-cash-desk-attr.
 
  
  
  vcmd = substitute ("&1 &2/THGetInfo?GetCashDesk >&3", search ("exe/curl.exe"), iAddr, "cashdesk-temp.json").
  os-command silent value (vcmd).
  fix-codepage_and_SetJsonObj (input "cashdesk-temp.json") .
  
  
  parse-json(input temp-table tt-cash-desk:default-buffer-handle, input "cash-desk") .
  parse-json(input temp-table tt-cash-desk-attr:default-buffer-handle, input "cash-desk-attr") .
  
  /* Delete all objects created by this procedure to avoid memory leaks */
  
  put-log( string(now) + "   Начинаем загрузку касс...") .
  
  for each tt-cash-desk where not tt-cash-desk.is-del exclusive-lock :
    tt-cash-desk.addr-path = replace(tt-cash-desk.addr-path, "|", chr(4)) .
    for first tt-cash-desk-attr no-lock where tt-cash-desk-attr.db-num = tt-cash-desk.db-num
                                         and tt-cash-desk-attr.obj-code = tt-cash-desk.obj-code
                                         and tt-cash-desk-attr.pos-type = tt-cash-desk.pos-type
                                         and tt-cash-desk-attr.cash-num = tt-cash-desk.cash-num
                                         and tt-cash-desk-attr.attr-code = "fr-type" :
      tt-cash-desk.fr-type = tt-cash-desk-attr.attr-value .                                    
    end.          
     
    put-log(  "Касса " + tt-cash-desk.pos-type + " №" + string(tt-cash-desk.cash-num) + " IP: " + entry(2,tt-cash-desk.addr-path, chr(4))).       
                        
    run ref/cashdsk1.p (
     input-output v-rid
    ,input {&add-def}
    ,input v-cntxt-db-num-obj
    ,input v-cntxt-obj-code
    ,input tt-cash-desk.pos-type
    ,input tt-cash-desk.cash-num
    ,input tt-cash-desk.autonomy
    ,input tt-cash-desk.addr-path 
    ,input no
    ,input tt-cash-desk.cash-os
    ,input tt-cash-desk.is-del
    ,input tt-cash-desk.remote
    ,input tt-cash-desk.version
    ,input tt-cash-desk.registration-code
    ,input tt-cash-desk.serial-code
    ,input tt-cash-desk.fr-type
    ) no-error .
    if error-status:error then do:
      undo, return error return-value.
    end.
    for each tt-cash-desk-attr no-lock where tt-cash-desk-attr.db-num = tt-cash-desk.db-num
                                         and tt-cash-desk-attr.obj-code = tt-cash-desk.obj-code
                                         and tt-cash-desk-attr.pos-type = tt-cash-desk.pos-type
                                         and tt-cash-desk-attr.cash-num = tt-cash-desk.cash-num :
      case tt-cash-desk-attr.attr-code :
        when "last-check-params"
        then do :
          &scop proc-name cd-attr-write
          {&run_proc_attr-lib}
          (
                                 input v-cntxt-db-num-obj
                                ,input v-cntxt-obj-code
                                ,input tt-cash-desk-attr.pos-type
                                ,input tt-cash-desk-attr.cash-num
                                ,input "" /* (if tt-cash-desk-attr.pos-type = {&cd-type-ibm-xml}
                                         then {&cda-IBM-XML_operative}
                                         else {&cda-AUTOTANK_operative})*/
                                ,input " " /*(if tt-cash-desk-attr.pos-type = {&cd-type-IBM-XML}
                                        then {&cda-IBM-XML_operative_last-check-params}
                                        else {&cda-AUTOTANK_operative_last-check-params})*/
                                ,input tt-cash-desk-attr.attr-value
                                ,input ? /*p-date*/
                                ,input 0 /*p-decimal*/
                                ,input 0 /*p-integer*/
                                ,input no /*p-logical*/
                                ) no-error.
        end.
        when "FO-version"
        then do :
/*          run cd-attr-write in this-procedure (                                            */
/*                                  input v-cntxt-db-num-obj                                 */
/*                                ,input v-cntxt-obj-code                                    */
/*                                ,input tt-cash-desk-attr.pos-type                          */
/*                                ,input tt-cash-desk-attr.cash-num                          */
/*                                ,input  (if tt-cash-desk-attr.pos-type = {&cd-type-ibm-xml}*/
/*                                         then {&cda-IBM-XML_operative}                     */
/*                                         else {&cda-AUTOTANK_operative})                   */
/*                                ,input (if tt-cash-desk-attr.pos-type = {&cd-type-IBM-XML} */
/*                                        then {&cda-IBM-XML_operative_fo-version}           */
/*                                        else {&cda-AUTOTANK_operative_fo-version})         */
/*                                ,input tt-cash-desk-attr.attr-value                        */
/*                                ,input ? /*p-date*/                                        */
/*                                ,input 0 /*p-decimal*/                                     */
/*                                ,input 0 /*p-integer*/                                     */
/*                                ,input no /*p-logical*/                                    */
/*                                ) no-error.                                                */
        end.                        
      end case.                                   
    end.                                       
  end.
  
  put-log( string(now) + "   Кассы загружены!") .
   
end method.
method public void parse-json (
  pBuff as handle,
  p-array-name as character):
  define variable v-data-type as character no-undo .
  define variable vCount      as integer  no-undo.
  define variable vLength     as integer  no-undo.
  define variable vI as integer no-undo.
  
  results-array = mJsonObj:GetJsonArray(p-array-name) no-error.
  if error-status:error then return.
  vLength = results-array:LENGTH.
  do vCount = 1 to vLength:
      myResultObj = results-array:GetJsonObject(vCount).

      pBuff:buffer-create () .
      do vI = 1 to pBuff:num-fields:
        v-data-type = pBuff:buffer-field[vI]:data-type .
        case v-data-type :
          when "character" then do:
            pBuff:buffer-field[vI]:buffer-value = myResultObj:GetCharacter(pBuff:buffer-field[vI]:name) no-error .
          end.
          when "integer" then do:
            pBuff:buffer-field[vI]:buffer-value = integer(myResultObj:GetCharacter(pBuff:buffer-field[vI]:name)) no-error .
          end.
          when "decimal" then do:
            pBuff:buffer-field[vI]:buffer-value = decimal(myResultObj:GetCharacter(pBuff:buffer-field[vI]:name)) no-error .
          end.
          when "logical" then do:
            pBuff:buffer-field[vI]:buffer-value = logical(myResultObj:GetCharacter(pBuff:buffer-field[vI]:name)) no-error .
          end.
          when "date" then do:
            pBuff:buffer-field[vI]:buffer-value = date(myResultObj:GetCharacter(pBuff:buffer-field[vI]:name)) no-error .
          end.
        end.
      end.
  end.
  
end method .
 
method public logical chek_price(): 
  define variable v-has-records as logical no-undo. 
  for each ub.price-doc no-lock where ub.price-doc.obj-type = v-cntxt-obj-type
                                    and ub.price-doc.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.
    end.
    for each ub.price-list no-lock where ub.price-list.obj-type = v-cntxt-obj-type
                                     and ub.price-list.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.
    end.
  return v-has-records.  
end method.   

method public void load_gds_maping(ifile-path as character ):
    define variable v-line as character no-undo.
    define variable v-err-msg as character no-undo.
    file-info:file-name = ifile-path .
    if file-info:file-type = ? then do :
    v-err-msg = substitute("Отсутствует файл соответствия товаров &1", ifile-path) .
    message v-err-msg
    view-as alert-box.
       undo, throw new Progress.Lang.AppError (v-err-msg) .
     end .
    empty temp-table tt-gds-mapping .
    input from value(ifile-path) .
    repeat:
      import unformatted v-line.
      create tt-gds-mapping .
      tt-gds-mapping.gds-code15 = integer(trim(entry(1, v-line, ";"))) .
      tt-gds-mapping.gds-code16 = integer(trim(entry(2, v-line, ";"))) no-error .
      if error-status:error then leave .
    end.
end method.

method public void  load_price (ifile-path as character ):
  load_price (maddr,ifile-path ).
  
end method .   

method public void  load_price (iAddr as character,ifile-path as character ):
  
  load_gds_maping(ifile-path).
  
  define variable vcmd as character no-undo.
  define variable num-rec-ok as integer no-undo .
  
  define variable ii as integer no-undo initial 0 .
  define variable jj as integer no-undo initial 0 .
  
  vcmd = substitute ("&1 &2/THGetInfo?GetPrice >&3", search ("exe/curl.exe"), iaddr, "price-temp.json").
  os-command silent value (vcmd).
  fix-codepage_and_SetJsonObj(input "price-temp.json") .
  
  empty temp-table tt-gds-price.
     
  parse-json(input temp-table tt-gds-price:default-buffer-handle, input "tt-gds-price") .
  
  create temp-price-doc .
  assign
    temp-price-doc.doc-date = today
    temp-price-doc.doc-num  = 1
    temp-price-doc.line-num = 1
    temp-price-doc.obj-code = v-cntxt-obj-code
    temp-price-doc.obj-type = v-cntxt-obj-type
    temp-price-doc.doc-id   = "_"
  .
  
  put-log( string (now) +  "    Начинаем загрузку цен...").
  
  for each tt-gds-price no-lock :
    find first tt-gds-mapping no-lock where tt-gds-mapping.gds-code15 = tt-gds-price.gds-code no-error .
    if available tt-gds-mapping
    then do :
      if tt-gds-mapping.gds-code15 = 0 or tt-gds-mapping.gds-code15 = ?
      or tt-gds-mapping.gds-code16 = 0 or tt-gds-mapping.gds-code16 = ?
      then next .
      find first ub.goods no-lock where ub.goods.gds-code = tt-gds-mapping.gds-code16 no-error.
      if available ub.goods
      then do :
        create temp-price-list.
        assign
          temp-price-list.doc-num = 1
          temp-price-list.line-num = 1
          temp-price-list.gds-code = tt-gds-mapping.gds-code16
          temp-price-list.price-sale = tt-gds-price.price
        .
        put-log(
          "Код в 15.0 " +  string(tt-gds-price.gds-code) + " .Код в 16.0 " +  string(tt-gds-mapping.gds-code16) +
          " . Цена: " + string(tt-gds-price.price)) .
      end.
      else do :
        ii = ii + 1 .
        put-err-log(
          "Не найден товар с кодом " + string(tt-gds-mapping.gds-code16) + " .Код в 15.0 " + string(tt-gds-price.gds-code) +
          " . Цена: " + string(tt-gds-price.price) ).
          
      end. 
    end.
    else do :
      jj = jj + 1 .
      put-err-log(
        "В файле соответствия " + ifile-path + " нет данных по товару с кодом " + string(tt-gds-price.gds-code) +
        " . Цена: " + string(tt-gds-price.price)).
    end.
  end.
  
  run utl/ora-i301-draw-util.p (
    input parparentproc, //this-procedure ,
    input this-object , //this-procedure ,
    input table temp-price-doc ,
    input table temp-price-list ,
    output num-rec-ok
    ) no-error .
  if error-status:error
  then do :
    undo, return error return-value.
  end.
  if ii > 0 or jj > 0
  then do :
     put-log( substitute("Всего отвергнуто &1 записей при загрузке цен. Из них:",ii )).
     put-log( substitute("  нет соответствий по товарам &1", ii )).
     put-log( substitute("В файле соотвествия нет данных по &1 товаров.",jj)) .
  end.
  put-log( string( now) + "   Цены загружены!") .
  
  
  /*else do :
    message "Несоответсвий при загрузке цен нет!" view-as alert-box .
  end.*/
  
  put-log("").
  
end method .
method public void fix-codepage_and_SetJsonObj (p-file as character):
  define variable vline as char no-undo .
  define variable vline2 as char no-undo .
  define variable v-out-file as character no-undo .
  
  case p-file :
    when "schem-temp.json"      then v-out-file = "schem.json" .
    when "pumpdoc-temp.json"    then v-out-file = "pumpdoc.json" .
    when "cashdesk-temp.json"   then v-out-file = "cashdesk.json" .
    when "price-temp.json"      then v-out-file = "price.json" .
    when "rest-temp.json"       then v-out-file = "rest.json" .
    when "rest-ptrl-temp.json"  then v-out-file = "rest-ptrl.json" .
    when "rvs-temp.json"        then v-out-file = "rvs.json" .
  end case.
  
  input STREAM lsIN from value(search(p-file)) convert target "UTF-8" source "1251".
  output STREAM lsOUT to value(v-out-file).
  repeat:
    vline2 = vline.
    import stream lsIN unformatted vline.
    vLine = replace(vline, chr(4), "|") .
    if vline2 = vline and length(vline2) < 3 then leave.
    put stream lsOUT unformatted  vline skip .
  end.
  input STREAM lsIN close.
  output STREAM lsOUT close.
    delete object mJsonObj no-error.
  mJsonObj = cast(mParser:ParseFile(search(v-out-file)), JsonObject).
end method.

method public logical chek_pumpdoc ():
    define variable v-has-records as logical no-undo.
    for each ub.icnt-doc no-lock where ub.icnt-doc.obj-type = v-cntxt-obj-type
                                   and ub.icnt-doc.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.icnt-line no-lock where ub.icnt-line.obj-type = v-cntxt-obj-type
                                    and ub.icnt-line.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    return v-has-records.
end method.
method public void load_pumpdoc ( ) :
  load_pumpdoc (maddr).
end.
method public void load_pumpdoc (iaddr as character ) :
  define variable v-doc-code as character no-undo .
  define variable v-recid as recid no-undo .
  define variable vcmd as character no-undo.
  
  empty temp-table tt-gds-prod .
  empty temp-table tt-place-loc .
  empty temp-table tt-icnt-doc.
  empty temp-table tt-icnt-line.
  
  vcmd = substitute ("&1 &2/THGetInfo?GetPumpDoc >&3", search ("exe/curl.exe"), iaddr, "pumpdoc-temp.json").
  os-command silent value (vcmd).
  fix-codepage_and_SetJsonObj(input "pumpdoc-temp.json") .
  parse-json(input temp-table tt-icnt-doc:default-buffer-handle, input "icnt-doc") .
  parse-json(input temp-table tt-icnt-line:default-buffer-handle, input "icnt-line") .
  parse-json(input temp-table tt-gds-prod:default-buffer-handle, input "tt-gds-prod") .
  parse-json(input temp-table tt-place-loc:default-buffer-handle, input "tt-place-loc") .
  
  put-log(string( now) + "   Начинаем загрузку инвентаризации счётчиков ТРК...") .
      
  for each tt-icnt-doc no-lock :
    put-log( "Номер документа в 15.0   " + tt-icnt-doc.doc-code).
    for each tt-icnt-line exclusive-lock where tt-icnt-line.doc-code = tt-icnt-doc.doc-code :
      find first tt-gds-prod no-lock where tt-gds-prod.gds-code = tt-icnt-line.gds-code no-error.
      if not available tt-gds-prod
      then do :
        undo, return error "No gds-prod" .
      end.
       
      find first ub.prod-bc no-lock where ub.prod-bc.b-str = tt-gds-prod.b-str no-error.
      if not available ub.prod-bc
      then do :
        undo, return error "No short-code" .
      end.
      
      find first ub.bar-code no-lock where ub.bar-code.b-code = ub.prod-bc.b-code no-error.
      if not available ub.bar-code
      then do :
        undo, return error "No bar-code" .
      end.
      
      find first tt-place-loc no-lock where tt-place-loc.pl-code = tt-icnt-line.pl-code no-error.
      if not available tt-place-loc
      then do :
        undo, return error "No place-loc" .
      end.
      
      find first ub.place no-lock where ub.place.loc1 = tt-place-loc.loc1 no-error.
      if not available ub.place
      then do :
        undo, return error "No place" .
      end.
      
      assign
        tt-icnt-line.obj-code = v-cntxt-obj-code
        tt-icnt-line.obj-type = v-cntxt-obj-type
        tt-icnt-line.gds-code = ub.bar-code.gds-code
        tt-icnt-line.pl-code  = ub.place.pl-code
      .
    end.
    run str/icntdoc1.p (
                     input {&add-def}
                    ,input yes /*p-silent*/
                    ,input-output v-recid
                    ,input ""
                    ,input v-cntxt-obj-type
                    ,input v-cntxt-obj-code
                    ,input v-cntxt-host-code-obj
                    ,input {&icnt-doc}
                    ,input {&TDEICNT_Inv}
                    ,input tt-icnt-doc.wrkr
                    ,input tt-icnt-doc.agnt
                    ,input tt-icnt-doc.boss
                    ,input tt-icnt-doc.doc-date
                    ,input tt-icnt-doc.meas-el-cnt
                    ,input tt-icnt-doc.state-el-cnt
                    ,input tt-icnt-doc.state-mh-cnt
                    ,input tt-icnt-doc.PS
                    ,input tt-icnt-doc.creid
                    ,input '':U /*p-ptrlcheck*/
                    ,input table tt-icnt-line
                     ) no-error.
    if error-status:error then do:
      undo, return error return-value.
    end.
    run str/icntdoc2.p ( input v-recid
                 ,input yes /*p-silent*/
                 ) no-error.
    if error-status:error then do:
      undo, return error return-value.
    end.             
  end.
  
  put-log( string( now) +  "   Инвентаризация счётчиков ТРК загружена!" ) .
  put-log("").
end method.
method public logical chek-sht-open():
  define buffer open-shift         for ub.shift-obj .
  find last open-shift where
          open-shift.obj-type = v-cntxt-obj-type and
          open-shift.obj-code = v-cntxt-obj-code and
          open-shift.status_ = {&sht-current}
          use-index pi no-error.
  return  available open-shift. 

end method.  
  
method public void  sht-open(): // открытие смены
define variable vOk as logical no-undo.
    put-log("Открытие смены").
    run gbl/sht-open-bach.p (this-object,output vOk,parparentproc, input v-cntxt-obj-type, input v-cntxt-obj-code ).
    put-log(if chek-sht-open() then "Смены открыта" else "Смена не открыта").
    end method.

    method public logical chek_rvs():
  define buffer open-shift         for ub.shift-obj .
  define buffer buf_rvs-doc for ub.rvs-doc .
  find last open-shift where
            open-shift.obj-type = v-cntxt-obj-type and
            open-shift.obj-code = v-cntxt-obj-code and
            open-shift.status_ = {&sht-current}
            use-index pi no-error.
  if available open-shift
  then
     find first  buf_rvs-doc where buf_rvs-doc.obj-type eq v-cntxt-obj-type
                               and buf_rvs-doc.obj-code eq v-cntxt-obj-code
                               and buf_rvs-doc.shift-date eq open-shift.shift-date
                               and buf_rvs-doc.shift-num  eq open-shift.shift-num
                               no-lock no-error.
        return  available buf_rvs-doc. 

    end method.   

    method public void  rvs-auto(): // содание сверки
        define variable vOk as logical no-undo.
        put-log("Создание нулевой сверки").
        run str/rvs-auto-draw.p (this-object).
        put-log(if chek_rvs() then "Нулевая сверка создана" else "Нулевая сверка не создана").
        put-log("").
end method.

method public logical load_rest (
                              iosn-fname   as character,  // список соответствия поставщиков
                              iart-fname   as  character, // список соответствия товаров
                              iretry-fname as character   // файл для повторного импорта
                              ):
     return load_rest(maddr, iosn-fname, iart-fname, iretry-fname).
end method.                                
method public logical load_rest (iaddr as character,
                              iosn-fname   as character,  // список соответствия поставщиков
                              iart-fname   as  character, // список соответствия товаров
                              iretry-fname as character   // файл для повторного импорта
                              ):
  define variable vcmd as character no-undo.
  define variable vOk as logical no-undo.
  vcmd = substitute ("&1 &2/THGetInfo?GetRest >&3", search ("exe/curl.exe"), iaddr, "rest-temp.json").
  os-command silent value (vcmd).
  fix-codepage_and_SetJsonObj (input "rest-temp.json") .
  empty temp-table tt-imp-parts.
  
  parse-json(input temp-table tt-imp-parts:default-buffer-handle, input "tt-imp-parts") .
  
  

  put-log ( string(now) +  "   Начинаем загрузку остатков...") .
  
  define variable v-count-err as integer no-undo .
  run utl/imp-doc4cr-draw.p ( this-object
                       , iosn-fname // список соответствия поставщиков
                       , iart-fname // список соответствия товаров
                       , iretry-fname // файл для повторного импорта
                       , input table tt-imp-parts
                       ) .

// ?? Журналировать каждую загруженную строку ??
//        put stream log-stream unformatted
//          "Код в 15.0 " string(tt-gds-price.gds-code) " .Код в 16.0 " string(tt-gds-mapping.gds-code16)
//          " . Цена: " string(tt-gds-price.price) skip .
                         
//  &scop my-message substitute("Всего прочитано &1 записей. Из них отвергнуто &2", v-count-all, v-count-err )
//  {&display-message}.

  
  vok = yes.
  finally:
     vok = chek_rest() and vok.
     put-log( string( now) + if  vok then "   Остатки загружены!" else "   Остатки не загружены!") .
     put-log("").
     return vok.
  end finally.
end method .

method public logical load_rest_ptrl (
                              iosn-fname   as character,  // список соответствия поставщиков
                              iart-fname   as  character, // список соответствия товаров
                              iretry-fname as character   // файл для повторного импорта
                              ):
     return load_rest_ptrl (maddr, iosn-fname, iart-fname, iretry-fname).
end method.
                                
method public logical load_rest_ptrl (iaddr as character,
                              iosn-fname   as character,  // список соответствия поставщиков
                              iart-fname   as  character, // список соответствия товаров
                              iretry-fname as character   // файл для повторного импорта
                              ):
  define variable vcmd as character no-undo.
  define variable vOk as logical no-undo.
  vcmd = substitute ("&1 &2/THGetInfo?GetRestPtrl >&3", search ("exe/curl.exe"), iaddr, "rest-ptrl-temp.json").
  os-command silent value (vcmd).
  fix-codepage_and_SetJsonObj (input "rest-ptrl-temp.json") .
  empty temp-table tt-imp-parts-ptrl.
  
  parse-json(input temp-table tt-imp-parts-ptrl:default-buffer-handle, input "tt-imp-parts-ptrl") .
  
  

  put-log ( string(now) +  "   Начинаем загрузку остатков по топливу...") .
  
  define variable v-count-err as integer no-undo .
  run utl/imp-doc4cr-draw-ptrl.p ( this-object
                       , iosn-fname // список соответствия поставщиков
                       , iart-fname // список соответствия товаров
                       , iretry-fname // файл для повторного импорта
                       , input table tt-imp-parts-ptrl
                       ) .

// ?? Журналировать каждую загруженную строку ??
//        put stream log-stream unformatted
//          "Код в 15.0 " string(tt-gds-price.gds-code) " .Код в 16.0 " string(tt-gds-mapping.gds-code16)
//          " . Цена: " string(tt-gds-price.price) skip .
                         
//  &scop my-message substitute("Всего прочитано &1 записей. Из них отвергнуто &2", v-count-all, v-count-err )
//  {&display-message}.

  
  vok = yes.
  finally:
     vok = chek_rest() and vok.
     put-log( string( now) + if  vok then "   Остатки загружены!" else "   Остатки не загружены!") .
     put-log("").
     return vok.
  end finally.
end method .

method public logical sendcode(icode as integer ):
   run utl/sendcode.p(this-object,icode).
   put-log("").
   return yes.
end method.
method public logical  chek_rest():
    return can-find (first ub.trn-doc where ub.trn-doc.obj-type = v-cntxt-obj-type
                              and ub.trn-doc.obj-code = v-cntxt-obj-code).
end  method.
method public logical  load_rvs(ifile-path as character):
    return load_rvs(mAddr,ifile-path).
end  method.

method public logical load_rvs(iAddr as character,ifile-path as character  ):
  define variable vcmd as character no-undo.
  define variable v-rvs-code as character no-undo.
  define variable vOk  as logical no-undo.
    define buffer open-shift         for ub.shift-obj .
    define buffer buf_rvs-doc-prev         for ub.rvs-doc .
  
                                    put-log("Загрузка последней сменной сверки").
  find first tt-gds-mapping no-error.
  if not available tt-gds-mapping
  then do:
     load_gds_maping(ifile-path ).
     find first tt-gds-mapping no-error.
     if not available tt-gds-mapping
     then
        return error.
  end.   
  
  
  find last open-shift where
          open-shift.obj-type = v-cntxt-obj-type and
          open-shift.obj-code = v-cntxt-obj-code and
          open-shift.status_ = {&sht-current}
          use-index pi no-error.
  if available  open-shift
  then do:        
    for each tt-rvs-doc-attr:
        delete tt-rvs-doc-attr.
    end.
      for each tt-rvs-line-attr:
          delete tt-rvs-line-attr.
      end.
      for each tt-rvs-pump-attr:
          delete tt-rvs-pump-attr.
      end.
      for each tt-rvs-line-pump-attr:
          delete tt-rvs-line-attr.
      end.
      for each tt-rvs-line:
          delete tt-rvs-line-pump-attr.
      end.
      for each tt-rvs-pump:
          delete tt-rvs-pump.
      end.
      for each tt-rvs-line-pump:
          delete tt-rvs-line-pump.
      end. 
      for each tt-rvs-doc:
          delete tt-rvs-doc.
      end.   
    /*empty temp-table tt-rvs-doc-attr .
    empty temp-table tt-rvs-line no-error .
    empty temp-table tt-rvs-line-attr .
    empty temp-table tt-rvs-pump.
    empty temp-table tt-rvs-pump-attr.
    empty temp-table tt-rvs-line-pump.
    empty temp-table tt-rvs-line-pump-attr.
    empty temp-table tt-rvs-doc .
    */
    vcmd = substitute ("&1 &2/THGetInfo?GetRvs >&3", search ("exe/curl.exe"), iaddr, "rvs-temp.json").
    os-command silent value (vcmd).
    fix-codepage_and_SetJsonObj(input "rvs-temp.json") .
    parse-json(input temp-table tt-rvs-doc              :default-buffer-handle, input "rvs-doc") .
    parse-json(input temp-table tt-rvs-doc-attr         :default-buffer-handle, input "rvs-doc-attr") .
    parse-json(input temp-table tt-rvs-line             :default-buffer-handle, input "rvs-line") .
    parse-json(input temp-table tt-rvs-line-attr        :default-buffer-handle, input "rvs-line-attr") .
    parse-json(input temp-table tt-rvs-pump             :default-buffer-handle, input "rvs-pump") .
    parse-json(input temp-table tt-rvs-pump-attr        :default-buffer-handle, input "rvs-pump-attr") .
    parse-json(input temp-table tt-rvs-line-pump        :default-buffer-handle, input "rvs-line-pump") .
    parse-json(input temp-table tt-rvs-line-pump-attr   :default-buffer-handle, input "rvs-line-pump-attr") .
      
    find first  buf_rvs-doc-prev where buf_rvs-doc-prev.obj-type eq v-cntxt-obj-type
    and buf_rvs-doc-prev.obj-code eq v-cntxt-obj-code
    and buf_rvs-doc-prev.shift-date eq open-shift.shift-date
    and buf_rvs-doc-prev.shift-num  eq open-shift.shift-num
            no-lock no-error.
    if available  buf_rvs-doc-prev 
    then       
    // изменения от базы к базе
    for first tt-rvs-doc:
        if tt-rvs-doc.doc-date eq ? then  tt-rvs-doc.doc-date =  open-shift.shift-date.
      doc-code
      (  input 'main':U
      ,  input v-cntxt-obj-type
      ,  input v-cntxt-obj-code
      ,  input ?
      , output v-rvs-code
      ) . 
       for each tt-rvs-doc-attr where tt-rvs-doc-attr.rvs-code eq tt-rvs-doc.rvs-code:
          tt-rvs-doc-attr.rvs-code = v-rvs-code.
       end.
       for each tt-rvs-line where tt-rvs-line.rvs-code eq tt-rvs-doc.rvs-code:
          assign
            tt-rvs-line.obj-type      = v-cntxt-obj-type
            tt-rvs-line.obj-code      = v-cntxt-obj-code
            tt-rvs-line.rvs-code      = v-rvs-code
            tt-rvs-line.rvs-prev-code = buf_rvs-doc-prev.rvs-code
          .
          find first tt-gds-mapping where tt-gds-mapping.gds-code15 eq tt-rvs-line.gds-code
          no-lock no-error.
          if available tt-gds-mapping
          then do:
               find first goods where goods.gds-code eq tt-gds-mapping.gds-code16 no-lock no-error.
               if not available goods
               then 
               do:
                  put-log(substitute ("Отсутствует товар с кодом &1 в справочнике товаров БД вер.16",tt-gds-mapping.gds-code16)).
                  return error substitute ("Отсутствует товар с кодом &1 в справочнике товаров БД вер.16",tt-gds-mapping.gds-code16). 
               end.
               else
                  tt-rvs-line.gds-code = tt-gds-mapping.gds-code16.
          end.        
          else 
          do:
             put-log(substitute ("В файле соответствия отсутствует товар с кодом &1",tt-rvs-line.gds-code)).
             return error substitute ("В файле соответствия отсутствует товар с кодом &1",tt-rvs-line.gds-code).   
          end.
          find first ub.place where ub.place.loc1 eq tt-rvs-line.loc1
          no-lock no-error.  
          if available ub.place 
          then
             tt-rvs-line.pl-code = ub.place.pl-code.
       end.
       for each tt-rvs-line-attr where tt-rvs-line-attr.rvs-code eq tt-rvs-doc.rvs-code:
          assign
            tt-rvs-line-attr.obj-type = v-cntxt-obj-type
            tt-rvs-line-attr.obj-code = v-cntxt-obj-code
            tt-rvs-line-attr.rvs-code = v-rvs-code
            
          .
          find first tt-gds-mapping where tt-gds-mapping.gds-code15 eq tt-rvs-line-attr.gds-code
          no-lock no-error.
          if available tt-gds-mapping
          then do:
              find first goods where goods.gds-code eq tt-gds-mapping.gds-code16 no-lock no-error.
              if not available goods
              then do:
                  put-log(substitute ("Отсутствует товар с кодом  &1 в справочнике товаров БД вер.16",tt-gds-mapping.gds-code16)).
                  return error substitute ("Отсутствует товар с кодом &1 в справочнике товаров БД вер.16",tt-gds-mapping.gds-code16). 
              end.
              else
                 tt-rvs-line-attr.gds-code = tt-gds-mapping.gds-code16.
                 
          end.
          else 
          do:
              put-log(substitute ("В файле соответствия отсутствует товар с кодом &1",tt-rvs-line-attr.gds-code)).
              return error substitute ("В файле соответствия отсутствует товар с кодом &1",tt-rvs-line-attr.gds-code).   
          end.
          find first ub.place where ub.place.loc1 eq tt-rvs-line.loc1
          no-lock no-error.  
          if available ub.place 
          then
             tt-rvs-line.pl-code = ub.place.pl-code.
       end.  
       
       for each tt-rvs-pump where tt-rvs-pump.rvs-code eq tt-rvs-doc.rvs-code:
          assign
            tt-rvs-pump.obj-type = v-cntxt-obj-type
            tt-rvs-pump.obj-code = v-cntxt-obj-code
            tt-rvs-pump.rvs-code = v-rvs-code
          .
          find first tt-gds-mapping where tt-gds-mapping.gds-code15 eq tt-rvs-pump.gds-code
          no-lock no-error.
          if available tt-gds-mapping
          then  
          do:
              find first goods where goods.gds-code eq tt-gds-mapping.gds-code16 no-lock no-error.
              if not available goods
                  then 
              do:
                  put-log(substitute ("Отсутствует товар с кодом &1 в справочнике товаров БД вер.16",tt-gds-mapping.gds-code16)).
                  return error substitute ("Отсутствует товар с кодом &1 в справочнике товаров БД вер.16",tt-gds-mapping.gds-code16). 
              end.
              else
             tt-rvs-pump.gds-code = tt-gds-mapping.gds-code16.
           end.  
          else 
          do:
              put-log(substitute ("В файле соответствия отсутствует товар с кодом &1",tt-rvs-pump.gds-code)).
              return error substitute ("В файле соответствия отсутствует товар с кодом &1",tt-rvs-pump.gds-code).   
          end.   
       end.
       
       for each tt-rvs-pump-attr where tt-rvs-pump-attr.rvs-code eq tt-rvs-doc.rvs-code:
          assign
            tt-rvs-pump-attr.obj-type = v-cntxt-obj-type
            tt-rvs-pump-attr.obj-code = v-cntxt-obj-code
            tt-rvs-pump-attr.rvs-code = v-rvs-code
          .
          
       end.
       
       for each tt-rvs-line-pump where tt-rvs-line-pump.rvs-code eq tt-rvs-doc.rvs-code:
          assign
            tt-rvs-line-pump.obj-type      = v-cntxt-obj-type
            tt-rvs-line-pump.obj-code      = v-cntxt-obj-code
            tt-rvs-line-pump.rvs-code      = v-rvs-code
            tt-rvs-line-pump.rvs-prev-code = buf_rvs-doc-prev.rvs-code
          .
          find first tt-gds-mapping where tt-gds-mapping.gds-code15 eq tt-rvs-line-pump.gds-code
          no-lock no-error.
          if available tt-gds-mapping
          then 
          do:
              find first goods where goods.gds-code eq tt-gds-mapping.gds-code16 no-lock no-error.
              if not available goods
                  then 
              do:
                  put-log(substitute ("Отсутствует товар с кодом &1 в справочнике товаров БД вер.16",tt-gds-mapping.gds-code16)).
                  return error substitute ("Отсутствует товар с кодом &1 в справочнике товаров БД вер.16",tt-gds-mapping.gds-code16). 
              end.
              else
             tt-rvs-line-pump.gds-code = tt-gds-mapping.gds-code16.
          end.   
          else 
          do:
              put-log(substitute ("В файле соответствия отсутствует товар с кодом &1",tt-rvs-line-pump.gds-code)).
              return error substitute ("В файле соответствия отсутствует товар с кодом &1",tt-rvs-line-pump.gds-code).   
          end. 
             
          find first ub.place where ub.place.loc1 eq tt-rvs-line-pump.loc1
          no-lock no-error.  
          if available ub.place 
          then
             tt-rvs-line-pump.pl-code = ub.place.pl-code.
       end.
       
       for each tt-rvs-line-pump-attr where tt-rvs-line-pump-attr.rvs-code eq tt-rvs-doc.rvs-code:
          assign
            tt-rvs-line-pump-attr.obj-type = v-cntxt-obj-type
            tt-rvs-line-pump-attr.obj-code = v-cntxt-obj-code
            tt-rvs-line-pump-attr.rvs-code = v-rvs-code
          .
          find first tt-gds-mapping where tt-gds-mapping.gds-code15 eq tt-rvs-line-pump-attr.gds-code
          no-lock no-error.
          if available tt-gds-mapping
          then  
          do:
              find first goods where goods.gds-code eq tt-gds-mapping.gds-code16 no-lock no-error.
              if not available goods
                  then 
              do:
                  put-log(substitute ("Отсутствует товар с кодом &1 в справочнике товаров БД вер.16",tt-gds-mapping.gds-code16)).
                  return error substitute ("Отсутствует товар с кодом &1 в справочнике товаров БД вер.16",tt-gds-mapping.gds-code16). 
              end.
              else
             tt-rvs-line-pump-attr.gds-code = tt-gds-mapping.gds-code16.
          end.   
          else 
          do:
              put-log(substitute ("В файле соответствия отсутствует товар с кодом &1",tt-rvs-line-pump-attr.gds-code)).
              return error substitute ("В файле соответствия отсутствует товар с кодом &1",tt-rvs-line-pump-attr.gds-code).   
          end.
             
          find first ub.place where ub.place.loc1 eq tt-rvs-line-pump-attr.loc1
          no-lock no-error.  
          if available ub.place 
          then
             tt-rvs-line-pump-attr.pl-code = ub.place.pl-code.
       end.
       
         
       assign
          tt-rvs-doc.shift-date = open-shift.shift-date
          tt-rvs-doc.shift-num  = open-shift.shift-num
          tt-rvs-doc.shift-name = open-shift.shift-name
       tt-rvs-doc.doc-date = today
       tt-rvs-doc.fact-date = today
       tt-rvs-doc.fact-time = time
          tt-rvs-doc.obj-type   = v-cntxt-obj-type
          tt-rvs-doc.obj-code   = v-cntxt-obj-code
          tt-rvs-doc.rvs-code   = v-rvs-code
          tt-rvs-doc.status_    = {&g___new}
          tt-rvs-doc.fact-order = ?
          tt-rvs-doc.host-code  = v-host-code
          tt-rvs-doc.PS         = "Последняя сменная сверка из 15.0"
       .
       
    end.  
    
    for each tt-rvs-doc:
      create ub.rvs-doc.
      buffer-copy tt-rvs-doc to ub.rvs-doc.
    end.  
    
    for each tt-rvs-doc-attr:
      create ub.rvs-doc-attr.
      buffer-copy tt-rvs-doc-attr to ub.rvs-doc-attr.
    end.  
    
    for each tt-rvs-line:
      create ub.rvs-line.
      buffer-copy tt-rvs-line to ub.rvs-line.
    end.  
    
    for each tt-rvs-line-attr:
      create ub.rvs-line-attr.
      buffer-copy tt-rvs-line-attr to ub.rvs-line-attr.
    end.  
    
    for each tt-rvs-pump:
      create ub.rvs-pump.
      buffer-copy tt-rvs-pump to ub.rvs-pump.
    end.  
    
    for each tt-rvs-pump-attr:
      create ub.rvs-pump-attr.
      buffer-copy tt-rvs-pump-attr to ub.rvs-pump-attr.
    end.
    
    for each tt-rvs-line-pump:
      create ub.rvs-line-pump.
      buffer-copy tt-rvs-line-pump to ub.rvs-line-pump.
    end.  
    
    for each tt-rvs-line-pump-attr:
      create ub.rvs-line-pump-attr.
      buffer-copy tt-rvs-line-pump-attr to ub.rvs-line-pump-attr.
      end. 
  end.
  vOk = yes.                                  
  finally:
      vOk = chek_rvs-shift() and vok.
     put-log(if vOk then "Сверка загружена" else "Сверка не загружена").
     put-log("").
  return vOk .
  end finally. 
end method.   
    method public logical chek_rvs-shift():
        define buffer open-shift         for ub.shift-obj .
        define buffer buf_rvs-doc for ub.rvs-doc .
        find last open-shift where
            open-shift.obj-type = v-cntxt-obj-type and
            open-shift.obj-code = v-cntxt-obj-code and
            open-shift.status_ = {&sht-current}
            use-index pi no-error.
        if available open-shift
            then
            find first  buf_rvs-doc where buf_rvs-doc.obj-type eq v-cntxt-obj-type
                and buf_rvs-doc.obj-code eq v-cntxt-obj-code
                and buf_rvs-doc.shift-date eq open-shift.shift-date
                and buf_rvs-doc.shift-num  eq open-shift.shift-num
                and buf_rvs-doc.rvs-type eq {&rvs-shift}
                no-lock no-error.
        return  available buf_rvs-doc. 

    end method.
    method public logical close-rvs-all ():
        put-log("Закрытие сменной сверки и смены.").
        define variable vok as logical no-undo.
        vok = close-rvs ().
        if not vok
        then
            vok = close-rvs ().
        finally:
            vok =   chek_rvs-close() and vok.
            put-log(if vOk then "Сверка закрыта" else "Сверка не закрыта").
     
            return vok. 
    end.
    end method.    
   method public logical close-rvs ():
     define buffer buf_rvs-doc for ub.rvs-doc .
    define buffer open-shift         for ub.shift-obj .
     define variable vok as logical no-undo.
     find last open-shift where
        open-shift.obj-type = v-cntxt-obj-type and
        open-shift.obj-code = v-cntxt-obj-code and
        open-shift.status_ = {&sht-current}
        use-index pi no-error.
    if available open-shift
        then
        find first  buf_rvs-doc where buf_rvs-doc.obj-type eq v-cntxt-obj-type
            and buf_rvs-doc.obj-code eq v-cntxt-obj-code
            and buf_rvs-doc.shift-date eq open-shift.shift-date
            and buf_rvs-doc.shift-num  eq open-shift.shift-num
            and buf_rvs-doc.rvs-type eq {&rvs-shift}
            no-lock no-error.
  if available buf_rvs-doc
  then      
     run str/rvs-close.p (this-object,buf_rvs-doc.rvs-code) .
       vok = yes.
       finally:
           vok =   chek_rvs-close() and vok.
     
     
     return vok.
  end finally.   
end method.
    method public logical chek_rvs-close():
        define buffer open-shift         for ub.shift-obj .
        define buffer buf_rvs-doc for ub.rvs-doc .
            find first  buf_rvs-doc where buf_rvs-doc.obj-type eq v-cntxt-obj-type
                and buf_rvs-doc.obj-code   eq v-cntxt-obj-code
                and buf_rvs-doc.rvs-type   eq {&rvs-shift}
                and buf_rvs-doc.status_    <>  {&fact}
                no-lock no-error.
        return  not available buf_rvs-doc. 

    end method.
   
 
end class.
