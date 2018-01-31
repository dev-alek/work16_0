/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт сообщения с накладаной в 1С ERPRN tank

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
using ibs.th.str.placelib from propath .

class ibs.th.bge.1crn.subjects.tank implements iexpsubject:

  define variable placelib as class placelib no-undo .
  { cmp/str-glbl.i class }
  
&global-define place-type        "place-type"                /*тип резервуара(вертикальный,горизонтальный)*/
&global-define place-SI          "place-SI"                    /*средство измерения*/
&global-define place-diameter    "place-diameter"        /*диаметр резервуара(мм)*/
&global-define dead-balance       "dead-balance"        /*мертвый остаток*/
&global-define place-ratio-error "place-ratio-error"  /*относительная погрешность составления калибровочной таблицы резервуара*/
&global-define place-dens-prov         "dens-prov"         /*плотность при поверке резервуара*/
&global-define place-virtual     "place-virtual"     /*виртуальный резервуар*/
&global-define place-twice-code   "place-twice-code" /*Код сдвоенного резервуара*/
&global-define list-place-attr   'place-type,place-SI,place-diameter,dead-balance,place-ratio-error,dens-prov,place-virtual,place-twice-code':u /*список атрибутов резервуара*/
  

  define buffer buf_place      for ub.place .
  define buffer buf_c-place    for ub.c-place .
  define buffer buf_place-attr for ub.place-attr .
  define buffer buf_pl-level   for ub.pl-level .
  define buffer buf_c-pl-level for ub.c-pl-level .
  define buffer buf_pl-gds     for ub.pl-gds .
  define temp-table tt-place like ub.c-place 
  field gds-code as integer.
  define temp-table tt-pl-level like ub.c-pl-level .
  
  define variable ii      as integer   no-undo .
  define variable v-code  as character no-undo .
  define variable v-value as character no-undo .
  define variable v-ok    as logical   no-undo .
  define variable v-del   as logical   no-undo . 
  
  define temp-table tt-place-attr
    field pl-code         like place.pl-code
    field place-type      as character
    field place-Si        as integer
    field place-diameter  as decimal
    field dead-balance    as decimal
    field place-rel-error as decimal
    field pl-twice-code   like place.loc1
    field place-dens-prov as decimal
    index pi as primary unique
    pl-code
    .
  
  define property Msg as character no-undo
    get.
    private set.

  
  define property pl-code as character no-undo
    get.
    set.

  define variable sw as handle no-undo.
  

  define property InitSecTag as character no-undo init "tanks"
    get.
    private set.
  

  method public void CrContentToSW (insw as handle):
    
    sw = insw .
    
    placelib = new placelib().
    /*    sw:start-element ("tanks") .*/
    find first buf_place no-lock where buf_place.pl-code = INTEGER (pl-code) no-error .
    if AVAILABLE buf_place then 
    do:
      v-del = no .
      create tt-place .
      BUFFER-COPY buf_place to tt-place .
      find first buf_pl-gds no-lock where buf_pl-gds.pl-code = buf_place.pl-code no-error .
      if AVAILABLE (buf_pl-gds) then do:
        tt-place.gds-code = buf_pl-gds.gds-code .
      end.  
    end.  
    else 
    do:
      find first buf_place no-lock where buf_place.pl-code = INTEGER (pl-code) no-error .
      if AVAILABLE buf_place then 
      do:
        v-del = yes .
        create tt-place .
        BUFFER-COPY buf_place to tt-place .
        find first buf_pl-gds no-lock where buf_pl-gds.pl-code = buf_place.pl-code no-error .
        if AVAILABLE (buf_pl-gds) then 
        do:
          tt-place.gds-code = buf_pl-gds.gds-code .
        end.  
      end.  
      else 
      do:
        Msg = "Нет складкского места с кодом" + pl-code .
        return error.
      end.  
    end.
    find first buf_pl-level no-lock where buf_pl-level.pl-code = tt-place.pl-code and
      buf_pl-level.obj-code = tt-place.obj-code and
      buf_pl-level.obj-type = tt-place.obj-type no-error .
    if AVAILABLE buf_pl-level then 
    do:
      for each buf_pl-level no-lock where buf_pl-level.pl-code = tt-place.pl-code and
        buf_pl-level.obj-code = tt-place.obj-code and
        buf_pl-level.obj-type = tt-place.obj-type:
        create tt-pl-level .
        buffer-copy buf_pl-level to tt-pl-level .
      end.      
    end .
    else 
    do:
      for each buf_c-pl-level no-lock where buf_c-pl-level.pl-code = tt-place.pl-code and
        buf_c-pl-level.obj-code = tt-place.obj-code and
        buf_c-pl-level.obj-type = tt-place.obj-type:
        create tt-pl-level .
        buffer-copy buf_c-pl-level to tt-pl-level .
      end.      
    end.        
    
    
    for each tt-place where tt-place.pl-code = INTEGER (pl-code) no-lock :    
      find first tt-place-attr exclusive-lock where tt-place-attr.pl-code = tt-place.pl-code no-error.
      if not available tt-place-attr then 
      do :
        create tt-place-attr.
        tt-place-attr.pl-code = tt-place.pl-code.
        ii = 0.
        do ii = 1 to num-entries({&list-place-attr}):
          v-code = entry(ii,{&list-place-attr}) .
          placelib:placelib_get-attr (
            input v-code
            ,input tt-place.obj-code
            ,input tt-place.obj-type
            ,input tt-place.pl-code
            ,output v-value
            ,output v-ok      ) no-error.
          case v-code :
            when {&place-type} then 
              do :
                if v-ok then 
                do :
                  if integer(v-value) = 1 then tt-place-attr.place-type = "1"  .
                  if integer(v-value) = 2 then tt-place-attr.place-type = "2"  .
                end.
              end.
            when {&place-SI} then 
              do :
                if v-ok then tt-place-attr.place-Si = integer(v-value) .
              end.
            when {&place-diameter} then 
              do :
                if v-ok then tt-place-attr.place-diameter = decimal(v-value) .
              end.
            when {&dead-balance} then 
              do :
                if v-ok then tt-place-attr.dead-balance = decimal(v-value) .
              end.
            when {&place-ratio-error} then 
              do :
                if v-ok then tt-place-attr.place-rel-error = decimal(v-value) .
              end.
            when {&place-dens-prov} then 
              do :
                if v-ok then tt-place-attr.place-dens-prov = decimal(v-value) .
              end.
            when {&place-twice-code} then 
              do:
                if v-ok then tt-place-attr.pl-twice-code = v-value .
              end.
          end case.
        end.
      end.
      sw:start-element ("tank") .
      sw:write-data-element ("tank-code", string(tt-place.pl-code)).
      sw:write-data-element ("tank-num", string(tt-place.loc1)).
      sw:write-data-element ("del-l", if tt-place.status_ = {&deleted-status} then "1" else "0").
      sw:write-data-element ("del-f", if v-del then "1" else "0").
      sw:write-data-element ("name", if tt-place.pl-name = ? then "" else tt-place.pl-name).
      sw:write-data-element ("gs-code", string(tt-place.obj-code)).
      for each tt-place-attr no-lock where tt-place-attr.pl-code = tt-place.pl-code:
        sw:write-data-element ("tank-type", string(tt-place-attr.place-type)).
        sw:write-data-element ("pl-qnty"  , string(tt-place.add-qnty)).
        sw:write-data-element ("max-qnty" , string(tt-place.max-qnty)).
        sw:write-data-element ("d-qnty"   , string(tt-place-attr.dead-balance)).
        sw:write-data-element ("tank-d"   , string(tt-place-attr.place-diameter)).
        sw:write-data-element ("rel-er"   , string-mth (tt-place-attr.place-rel-error)).
        sw:write-data-element ("dnsty"    , string-mth (tt-place-attr.place-dens-prov)).
        sw:write-data-element ("mi-code"  , string(tt-place-attr.place-Si)).
      end.
      sw:write-data-element ("gds-code", string(tt-place.gds-code)).
      sw:write-data-element ("izm-pr", if tt-place.is-meas = yes then "1" else "0").
      find first tt-pl-level no-lock where tt-pl-level.pl-code = tt-place.pl-code and
        tt-pl-level.obj-code = tt-place.obj-code and
        tt-pl-level.obj-type = tt-place.obj-type no-error .
      if AVAILABLE (tt-pl-level) then 
      do:      
        sw:start-element ("cal-tbl") .
        for each tt-pl-level no-lock where tt-pl-level.pl-code = tt-place.pl-code and
          tt-pl-level.obj-code = tt-place.obj-code and
          tt-pl-level.obj-type = tt-place.obj-type:
          sw:start-element ("cal-tbl-line") .
          sw:write-data-element ("lvl"  , string(tt-pl-level.pl-level)).
          sw:write-data-element ("amnt" , string(tt-pl-level.pl-qnty)).
          sw:end-element ("cal-tbl-line")  .
        end.
        sw:end-element ("cal-tbl")  .  
      end.
      sw:END-ELEMENT ("tank") .  
    end.
  end.  
  method private character string-mth (inValue as decimal):
    
    def var v-str as character no-undo.
    
    if inValue = ?
      then v-str = "0".
    
    if string (inValue) begins "."
      then v-str = "0" + string (inValue).
    else v-str = string (inValue).
    return v-str.
    
  end.
end class.