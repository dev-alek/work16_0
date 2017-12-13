/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт сообщения с накладаной в 1С ERPRN check-fuel-docs

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

class ibs.th.bge.1crn.subjects.check-fuel-docs implements iexpsubject:

  { cmp/str-glbl.i class }

  define buffer buf_rvs-doc             for ub.rvs-doc .
  define buffer buf_c-rvs-doc           for ub.c-rvs-doc .
  define buffer buf_rvs-line            for ub.rvs-line .
  define buffer buf_c-rvs-line          for ub.c-rvs-line .
  define buffer buf_doc-attr            for ub.doc-attr .
  define buffer buf_c-doc-attr          for ub.c-doc-attr .
  define buffer buf_rvs-line-attr       for ub.rvs-line-attr .
  define buffer buf_rvs-line-pump       for ub.rvs-line-pump .
  define buffer buf_c-rvs-line-pump     for ub.c-rvs-line-pump .
  define buffer buf_parent_user-account for ub.user-account .
  define buffer buf_user-account        for ub.user-account .
  
  define TEMP-TABLE tt-rvs-doc like ub.c-rvs-doc
    field del-f as integer .
  
  define TEMP-TABLE tt-rvs-line like ub.c-rvs-line .
  define TEMP-TABLE tt-doc-attr like ub.doc-attr .
  define TEMP-TABLE tt-rvs-line-attr like ub.rvs-line-attr .
  define TEMP-TABLE tt-rvs-line-pump like ub.c-rvs-line-pump .
  
  
  define variable v-user-name as character no-undo .
  define variable v-autorvs   as integer   no-undo INIT 0 .
  define variable v-type      as character no-undo .
  define variable v-dnsty     as decimal   no-undo .
  define variable v-wght      as decimal   no-undo .
  define variable v-ex-df     as decimal   no-undo .

  define property Msg as character no-undo
    get.
    private set.
  
  define property DocCode as character no-undo
    get.
    set.

  define property InitSecTag as character no-undo init "check-fuel-docs"
    get.
    private set.
      
  define variable sw as handle no-undo.
  
  method public void CrContentToSW (insw as handle):

sw = insw .
        
    find first buf_rvs-doc no-lock where buf_rvs-doc.rvs-code = DocCode no-error.
    if AVAILABLE (buf_rvs-doc) then 
    do:
      BUFFER-COPY buf_rvs-doc to tt-rvs-doc .
      tt-rvs-doc.del-f = 0 .
    end.  
    else 
    do:
      find first buf_c-rvs-doc no-lock where buf_c-rvs-doc.rvs-code = DocCode no-error.
      if available (buf_c-rvs-doc) then 
      do:
        BUFFER-COPY buf_c-rvs-doc to tt-rvs-doc .
        tt-rvs-doc.del-f = 1 .
      end.
      else return.
    end. 
     
    find first buf_doc-attr no-lock where tt-rvs-doc.rvs-code = buf_doc-attr.doc-code and buf_doc-attr.attr-code = "rvs-auto" and buf_doc-attr.attr-value = "Yes" no-error. 
    if available buf_doc-attr then 
    do :
      v-autorvs = 1.
    end.
    else 
    do:
      find first buf_c-doc-attr no-lock where tt-rvs-doc.rvs-code = buf_c-doc-attr.doc-code and buf_c-doc-attr.attr-code = "rvs-auto" and buf_c-doc-attr.attr-value = "Yes" no-error. 
      if available buf_c-doc-attr then 
      do :
        v-autorvs = 1.
      end.
    end.  
      
    
    case tt-rvs-doc.rvs-type:
      when {&rvs-before-doc} then 
        do:
          v-type = "1" .
        end.
      when {&rvs-after-doc} then 
        do:
          v-type = "2" .
        end.
      when {&rvs-shift} then 
        do:
          v-type = "4" .
        end.
      when {&rvs-control} then 
        do:
          v-type = "3" .
        end.  
        
    end case.    

    find first buf_user-account no-lock
      where buf_user-account.user-id = tt-rvs-doc.creid
      no-error .
    if not available buf_user-account
      then 
    do:
      assign
        v-user-name = tt-rvs-doc.creid
        .
    end.
    else 
    do:
      if buf_user-account.check-parent = true
        then 
      do:
        find first buf_parent_user-account no-lock
          where buf_parent_user-account.user-id = buf_user-account.parent-user-id
          no-error .
        if not available buf_parent_user-account
          then 
        do:
          assign
            v-user-name = tt-rvs-doc.creid
            .
        end.
        else 
        do:
          assign
            v-user-name = buf_user-account.nik
            .
        end.
      end.
      else 
      do:
        assign
          v-user-name = buf_user-account.nik
          .
      end.
    end.
    if tt-rvs-doc.del-f = 0 then 
    do:
      for each buf_rvs-line no-lock where buf_rvs-line.rvs-code = tt-rvs-doc.rvs-code:
        create tt-rvs-line . 
        BUFFER-COPY buf_rvs-line to tt-rvs-line .
        for each buf_rvs-line-pump no-lock where buf_rvs-line-pump.gds-code = tt-rvs-line.gds-code and buf_rvs-line-pump.pl-code = tt-rvs-line.pl-code
          and buf_rvs-line-pump.rvs-code = tt-rvs-line.rvs-code and buf_rvs-line-pump.obj-code = tt-rvs-line.obj-code and buf_rvs-line-pump.obj-type = tt-rvs-line.obj-type:
            
          create tt-rvs-line-pump .      
          BUFFER-COPY buf_rvs-line-pump to tt-rvs-line-pump .

        end.
      end.      
    end.
    else 
    do:
      for each buf_c-rvs-line no-lock where buf_c-rvs-line.rvs-code = tt-rvs-doc.rvs-code and buf_c-rvs-line.chip-num = tt-rvs-doc.chip-num:
        create tt-rvs-line . 
        BUFFER-COPY buf_c-rvs-line to tt-rvs-line .
        for each buf_c-rvs-line-pump no-lock where buf_c-rvs-line-pump.gds-code = tt-rvs-line.gds-code and buf_c-rvs-line-pump.pl-code = tt-rvs-line.pl-code
          and buf_c-rvs-line-pump.rvs-code = tt-rvs-line.rvs-code and buf_c-rvs-line-pump.obj-code = tt-rvs-line.obj-code and buf_c-rvs-line-pump.obj-type = tt-rvs-line.obj-type
          and buf_c-rvs-line-pump.chip-num = tt-rvs-line.chip-num  :
            
          create tt-rvs-line-pump .      
          BUFFER-COPY buf_c-rvs-line-pump to tt-rvs-line-pump .

        end.
      end.    
    end.  

    /*    sw:start-element ("check-fuel-docs") .*/

    sw:start-element ("check-fuel-doc") .
    sw:write-data-element ("doc-code", if tt-rvs-doc.rvs-code = ? then "" else string(tt-rvs-doc.rvs-code)).
    sw:write-data-element ("doc-num", if tt-rvs-doc.rvs-code = ? then "" else string(tt-rvs-doc.rvs-code)).
    sw:write-data-element ("doc-date", if tt-rvs-doc.doc-date = ? then "" else iso-date(datetime(tt-rvs-doc.doc-date, tt-rvs-doc.sys-time-int))).
    sw:write-data-element ("doc-date-f", if tt-rvs-doc.fact-date = ? then "" else iso-date(date(tt-rvs-doc.fact-date))).
    sw:write-data-element ("del-f", if tt-rvs-doc.del-f = ? then "" else string(tt-rvs-doc.del-f)).
    sw:write-data-element ("doc-type", string(v-type)).
    sw:write-data-element ("shift-date", if tt-rvs-doc.shift-date = ? then "" else iso-date(tt-rvs-doc.shift-date)).
    sw:write-data-element ("shift-num", if tt-rvs-doc.shift-num = ? then "" else string(tt-rvs-doc.shift-num)).
    sw:write-data-element ("auto-cr", string(v-autorvs)).
    if tt-rvs-doc.out-code > "" then sw:write-data-element ("out-code", tt-rvs-doc.out-code). 
    else sw:WRITE-EMPTY-ELEMENT ("out-code").
    sw:write-data-element ("operator", if v-user-name = ? then "" else string(v-user-name)).
    sw:start-element ("tanks") .
    for each tt-rvs-line no-lock:
      sw:start-element ("tank") .
      sw:write-data-element ("tank-num"  , if tt-rvs-line.pl-code = ? then "0" else string(tt-rvs-line.pl-code)).
      sw:write-data-element ("gd-code"  , if tt-rvs-line.gds-code = ? then "0" else string(tt-rvs-line.gds-code)).
      sw:write-data-element ("tank-ost" , if tt-rvs-line.measure-qnty = ? then "0" else string(tt-rvs-line.measure-qnty)).
      sw:write-data-element ("tank-ost-tc" , if tt-rvs-line.measure-tc-qnty = ? then "0" else string-mth(tt-rvs-line.measure-tc-qnty)).
      sw:write-data-element ("tank-dnst" , if tt-rvs-line.density = ? then "0" else string-mth(tt-rvs-line.density)).
      sw:write-data-element ("pipeline-qnty" , if tt-rvs-line.add-qnty = ? then "0" else string-mth(tt-rvs-line.add-qnty)).
      sw:write-data-element ("tank-ost-br" , if tt-rvs-line.brutto-qnty = ? then "0" else string-mth(tt-rvs-line.brutto-qnty)).
      sw:write-data-element ("tank-ost-br-tc" , if tt-rvs-line.brutto-tc-qnty = ? then "0" else string-mth(tt-rvs-line.brutto-tc-qnty)).
      sw:write-data-element ("tank-wtr" , if (tt-rvs-line.brutto-qnty - tt-rvs-line.measure-qnty) = ? then "0" else string-mth(tt-rvs-line.brutto-qnty - tt-rvs-line.measure-qnty)).
      sw:write-data-element ("tank-wght" , if tt-rvs-line.measure-cli-qnty = ? then "0" else string-mth(tt-rvs-line.measure-cli-qnty)).
      sw:write-data-element ("tank-wght-br" , if tt-rvs-line.brutto-cli-qnty = ? then "0" else string-mth(tt-rvs-line.brutto-cli-qnty)).
      sw:write-data-element ("tank-wtr-wght" , if (tt-rvs-line.brutto-cli-qnty - tt-rvs-line.measure-cli-qnty) = ? then "0" else string-mth(tt-rvs-line.brutto-cli-qnty - tt-rvs-line.measure-cli-qnty)).
      sw:write-data-element ("tank-lvl" , if tt-rvs-line.level-petrol = ? then "0" else string-mth(tt-rvs-line.level-petrol)).
      sw:write-data-element ("tank-cmn-lvl" , if tt-rvs-line.level-total = ? then "0" else string-mth(tt-rvs-line.level-total)).
      sw:write-data-element ("tnk-wtr-lvl" , if tt-rvs-line.level-water = ? then "0" else string-mth(tt-rvs-line.level-water)).
      sw:write-data-element ("tnk-t" , if tt-rvs-line.temperature = ? then "0" else string-mth(tt-rvs-line.temperature)).
      sw:write-data-element ("tnk-t1" , if tt-rvs-line.temp-layer1 = ? then "0" else string-mth(tt-rvs-line.temp-layer1)).
      sw:write-data-element ("tnk-t2" , if tt-rvs-line.temp-layer2 = ? then "0" else string-mth(tt-rvs-line.temp-layer2)).
      sw:write-data-element ("tnk-t3" , if tt-rvs-line.temp-layer3 = ? then "0" else string-mth(tt-rvs-line.temp-layer3)).
      sw:write-data-element ("tnk-flng" , if tt-rvs-line.meas-cf-qnty = ? then "0" else string-mth(tt-rvs-line.meas-cf-qnty)).
      sw:write-data-element ("tank-ost-fact" , if tt-rvs-line.state-measure-qnty = ? then "0" else string-mth(tt-rvs-line.state-measure-qnty)).
      sw:write-data-element ("tank-ost-tc-fact" , if tt-rvs-line.state-measure-tc-qnty = ? then "0" else string-mth(tt-rvs-line.state-measure-tc-qnty)).
      sw:write-data-element ("tank-dnst-fact" , if tt-rvs-line.state-density = ? then "0" else string-mth(tt-rvs-line.state-density)).
      sw:write-data-element ("pipeline-qnty-fact" , if tt-rvs-line.state-add-qnty = ? then "0" else string-mth(tt-rvs-line.state-add-qnty)).
      sw:write-data-element ("tank-ost-br-fact" , if tt-rvs-line.state-brutto-qnty = ? then "0" else string-mth(tt-rvs-line.state-brutto-qnty)).
      sw:write-data-element ("tank-ost-br-tc-fact" , if tt-rvs-line.state-brutto-tc-qnty = ? then "0" else string-mth(tt-rvs-line.state-brutto-tc-qnty)).
      sw:write-data-element ("tank-wtr-fact" , if (tt-rvs-line.state-brutto-qnty - tt-rvs-line.state-measure-qnty) = ? then "0" else string-mth(tt-rvs-line.state-brutto-qnty - tt-rvs-line.state-measure-qnty)).
      sw:write-data-element ("tank-wght-fact" , if tt-rvs-line.state-measure-cli-qnty = ? then "0" else string-mth(tt-rvs-line.state-measure-cli-qnty)).
      sw:write-data-element ("tank-wght-br-fact" , if tt-rvs-line.state-brutto-cli-qnty = ? then "0" else string-mth(tt-rvs-line.state-brutto-cli-qnty)).
      sw:write-data-element ("tank-wtr-wght-fact" , if (tt-rvs-line.state-brutto-cli-qnty - tt-rvs-line.state-measure-cli-qnty) = ? then "0" else string-mth(tt-rvs-line.state-brutto-cli-qnty - tt-rvs-line.state-measure-cli-qnty)).
      sw:write-data-element ("tank-lvl-fact" , if tt-rvs-line.state-level-petrol = ? then "0" else string-mth(tt-rvs-line.state-level-petrol)).
      sw:write-data-element ("tank-cmn-lvl-fact" , if tt-rvs-line.state-level-total = ? then "0" else string-mth(tt-rvs-line.state-level-total)).
      sw:write-data-element ("tnk-wtr-lvl-fact" , if tt-rvs-line.state-level-water = ? then "0" else string-mth(tt-rvs-line.state-level-water)).
      sw:write-data-element ("tnk-t-fact" , if tt-rvs-line.state-temperature = ? then "0" else string-mth(tt-rvs-line.state-temperature)).
      sw:write-data-element ("tnk-t1-fact" , if tt-rvs-line.state-temp-layer1 = ? then "0" else string-mth(tt-rvs-line.state-temp-layer1)).
      sw:write-data-element ("tnk-t2-fact" , if tt-rvs-line.state-temp-layer2 = ? then "0" else string-mth(tt-rvs-line.state-temp-layer2)).
      sw:write-data-element ("tnk-t3-fact" , if tt-rvs-line.state-temp-layer3 = ? then "0" else string-mth(tt-rvs-line.state-temp-layer3)).
      sw:write-data-element ("tnk-flng-fact" , if tt-rvs-line.state-cf-qnty = ? then "0" else string-mth(tt-rvs-line.state-cf-qnty)).
      for each buf_rvs-line-attr no-lock
        where buf_rvs-line-attr.obj-code  = tt-rvs-line.obj-code
        and buf_rvs-line-attr.obj-type  = tt-rvs-line.obj-type
        and buf_rvs-line-attr.gds-code  = tt-rvs-line.gds-code
        and buf_rvs-line-attr.pl-code   = tt-rvs-line.pl-code
        and buf_rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code:
        case buf_rvs-line-attr.attr-code:
          when "izmer-density" then
            do:
              v-dnsty = decimal(buf_rvs-line-attr.attr-value) . 
            end.
          when "delta-mass-qnty" then
            do:
              v-wght = decimal(buf_rvs-line-attr.attr-value) .
            end.
          when "CriticalDif" then
            do:
              v-ex-df = decimal(buf_rvs-line-attr.attr-value) .
            end.
        end case .
      end.
      sw:write-data-element ("ms-dnsty" , string-mth(v-dnsty)).
      sw:write-data-element ("er-wght" , string-mth(v-wght)).
      sw:write-data-element ("ex-df" , string-mth(v-ex-df)).
      sw:end-element ("tank")  .
    end.
    sw:end-element ("tanks")  .
    find first tt-rvs-line-pump no-error .
    if AVAILABLE (tt-rvs-line-pump) then do:
    sw:start-element ("trk-ps") .
    for each tt-rvs-line-pump :
      sw:start-element ("trk-p") .
      sw:write-data-element ("tank-num" , if tt-rvs-line-pump.pl-code = ? then "0" else string-mth(tt-rvs-line-pump.pl-code)).
      sw:write-data-element ("trk-num" , if tt-rvs-line-pump.pump-code = ? then "0" else string-mth(tt-rvs-line-pump.pump-code)).
      sw:write-data-element ("trk-p-num" , if tt-rvs-line-pump.nozzle-code = ? then "0" else string-mth(tt-rvs-line-pump.nozzle-code)).
      sw:write-data-element ("cnt-el" , if tt-rvs-line-pump.meas-el-cnt = ? then "0" else string-mth(tt-rvs-line-pump.meas-el-cnt)).
      sw:write-data-element ("sum-cnt-el" , if tt-rvs-line-pump.meas-am-cnt = ? then "0" else string-mth(tt-rvs-line-pump.meas-am-cnt)).
      sw:write-data-element ("qnty" , if tt-rvs-line-pump.meas-cf-cnt = ? then "0" else string-mth(tt-rvs-line-pump.meas-cf-cnt)).
      sw:write-data-element ("cnt-meh" , if tt-rvs-line-pump.meas-mh-cnt = ? then "0" else string-mth(tt-rvs-line-pump.meas-mh-cnt)).
      sw:write-data-element ("cnt-ob" , if tt-rvs-line-pump.meas-mh-qnty = ? then "0" else string-mth(tt-rvs-line-pump.meas-mh-qnty)).
      sw:write-data-element ("sum-cnt-ob" , if tt-rvs-line-pump.meas-am-qnty = ? then "0" else string-mth(tt-rvs-line-pump.meas-am-qnty)).
      sw:write-data-element ("qnty-nal" , if tt-rvs-line-pump.meas-cf-qnty = ? then "0" else string-mth(tt-rvs-line-pump.meas-cf-qnty)).
      sw:write-data-element ("cnt-el-fact" , if tt-rvs-line-pump.state-el-cnt = ? then "0" else string-mth(tt-rvs-line-pump.state-el-cnt)).
      sw:write-data-element ("sum-fact" , if tt-rvs-line-pump.state-am-cnt = ? then "0" else string-mth(tt-rvs-line-pump.state-am-cnt)).
      sw:write-data-element ("qnty-fact" , if tt-rvs-line-pump.state-cf-cnt = ? then "0" else string-mth(tt-rvs-line-pump.state-cf-cnt)).
      sw:write-data-element ("cnt-meh-fact" , if tt-rvs-line-pump.state-mh-cnt = ? then "0" else string-mth(tt-rvs-line-pump.state-mh-cnt)).
      sw:write-data-element ("cnt-meh-ob" , if tt-rvs-line-pump.state-mh-qnty = ? then "0" else string-mth(tt-rvs-line-pump.state-mh-qnty)).
      sw:write-data-element ("sum-meh-ob" , if tt-rvs-line-pump.state-am-qnty = ? then "0" else string-mth(tt-rvs-line-pump.state-am-qnty)).
      sw:write-data-element ("qnty-nal-fact" , if tt-rvs-line-pump.state-cf-qnty = ? then "0" else string-mth(tt-rvs-line-pump.state-cf-qnty)).
      sw:end-element ("trk-p")  .
    end.
    sw:end-element ("trk-ps")  .
    end.  
  
    sw:END-ELEMENT ("check-fuel-doc") .
    /*    sw:END-ELEMENT ("check-fuel-docs") .*/
  end.
  method private character string-mth (inValue as decimal):
    
    def var v-str as character no-undo.
    def var v-stt as decimal   no-undo.
     
    if inValue = ?  then v-str = "0".
    if inValue < 0 then 
    do:
      v-stt = inValue .
      inValue = ABSOLUTE(v-stt).
    end.
    if string (inValue) begins "."
      then v-str = "0" + string (inValue).
    else v-str = string (inValue).
    if v-stt <> 0 then v-str = "-" + v-str.
    return v-str.
    
  end.
end class.
