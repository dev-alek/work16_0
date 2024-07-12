
/*------------------------------------------------------------------------
    File        : proc-pomi-rvs.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : user
    Created     : Fri Mar 01 18:03:17 MSK 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{ str/calibrationbelt.i }

/* ***************************  Main Block  *************************** */

procedure calc-pomi-rvs :
  define input parameter p-sec-num as integer no-undo .
  define input parameter p-doc-code as character no-undo .
  define input parameter p-gds-code as integer no-undo .
  define input-output parameter infoSectionTotal as class ibs.th.str.InfoSectionsTotal    no-undo .
  define output parameter p-tank-weight-rvs as decimal no-undo .
  define output parameter p-tank-vol-pomi-rvs as decimal no-undo .
  
  define buffer buf_place             for ub.place .
  define buffer buf2_place            for ub.place .
  define buffer buf_clob-bind         for ub.clob-bind .
  
  define buffer bf_goods              for ub.goods .
  
  define buffer bf_bef_rvs-doc        for ub.rvs-doc  .
  define buffer bf_aft_rvs-doc        for ub.rvs-doc  .
  define buffer bf_bef_rvs-line       for ub.rvs-line .
  define buffer bf_aft_rvs-line       for ub.rvs-line .
  define buffer bf_rvs-line-attr      for ub.rvs-line-attr .
  
  define buffer buf_sr-izmerenia      for sr-izmerenia .
  define buffer dens_sr-izmerenia     for sr-izmerenia .
  define buffer temp_sr-izmerenia     for sr-izmerenia .
  define buffer level_sr-izmerenia    for sr-izmerenia .
  define buffer temp-dens_sr-izmerenia for sr-izmerenia .
  
  define buffer water1_pl-level       for ub.pl-level .
  define buffer water2_pl-level       for ub.pl-level .
  define buffer total1_pl-level       for ub.pl-level .
  define buffer total2_pl-level       for ub.pl-level .
  define buffer buf_pl-level-attr     for ub.pl-level-attr .
  define buffer buf_pl-level          for ub.pl-level .
  
  define variable CalibTable               as character no-undo initial "".
  define variable CalibBelt                as character no-undo initial "".
  define variable DeltaOtn_K               as decimal no-undo.
  define variable DeltaOtn_N               as decimal no-undo init 0.05 .
  
  define variable ToolType1                as integer no-undo.
  define variable LevelToolType1           as integer no-undo.
  define variable DeltaAbs_H1              as decimal no-undo.
  define variable DeltaAbs_H_Water1        as decimal no-undo.
  define variable DeltaAbs_R1              as decimal no-undo.
  define variable DeltaAbs_Tv1             as decimal no-undo.
  define variable DeltaAbs_Tr1             as decimal no-undo.
  define variable DeltaOtn_H1              as decimal no-undo.
  define variable DeltaOtn_H_Water1        as decimal no-undo.
  define variable DeltaOtn_R1              as decimal no-undo.
  define variable ToolAutomationLevel_H1   as integer no-undo.
  define variable ToolAutomationLevel_H_Water1 as integer no-undo.
  define variable ToolAutomationLevel_R1   as integer no-undo.
  define variable ToolAutomationLevel_Tv1  as integer no-undo.
  define variable ToolAutomationLevel_Tr1  as integer no-undo.
  define variable DeltaAbs_H_CalcType1     as integer no-undo.
  define variable DeltaAbs_H_Water_CalcType1   as integer no-undo.
  
  define variable ToolType2                as integer no-undo.
  define variable LevelToolType2           as integer no-undo.
  define variable DeltaAbs_H2              as decimal no-undo.
  define variable DeltaAbs_H_Water2        as decimal no-undo.
  define variable DeltaAbs_R2              as decimal no-undo.
  define variable DeltaAbs_Tv2             as decimal no-undo.
  define variable DeltaAbs_Tr2             as decimal no-undo.
  define variable DeltaOtn_H2              as decimal no-undo.
  define variable DeltaOtn_H_Water2        as decimal no-undo.
  define variable DeltaOtn_R2              as decimal no-undo.
  define variable ToolAutomationLevel_H2   as integer no-undo.
  define variable ToolAutomationLevel_H_Water2 as integer no-undo.
  define variable ToolAutomationLevel_R2   as integer no-undo.
  define variable ToolAutomationLevel_Tv2  as integer no-undo.
  define variable ToolAutomationLevel_Tr2  as integer no-undo.
  define variable DeltaAbs_H_CalcType2     as integer no-undo.
  define variable DeltaAbs_H_Water_CalcType2   as integer no-undo.
  
  define variable v-temp-izm-vol1         as decimal no-undo .
  define variable v-temp-izm-vol2         as decimal no-undo .
  define variable place-SI                as integer no-undo .
  define variable v-place-type            as integer no-undo .
  define variable pl-rvd-dens-1           as logical no-undo .
  define variable pl-rvd-lvl-1            as logical no-undo .
  define variable pl-rvd-temp-1           as logical no-undo .
  define variable pl-rvd-dens-2           as logical no-undo .
  define variable pl-rvd-lvl-2            as logical no-undo .
  define variable pl-rvd-temp-2           as logical no-undo .
  define variable v-mi-lvl-1              as integer no-undo .
  define variable v-mi-lvl-2              as integer no-undo .
  define variable v-mi-dnst-1             as integer no-undo .
  define variable v-mi-dnst-2             as integer no-undo .
  define variable v-mi-tmp-1              as integer no-undo .
  define variable v-mi-tmp-2              as integer no-undo .
  define variable v-mi-tmp-dnst-1         as integer no-undo .
  define variable v-mi-tmp-dnst-2         as integer no-undo .
  
  define variable Tv1                     as decimal no-undo .
  define variable Tr1                     as decimal no-undo .
  define variable R1                      as decimal no-undo .
  define variable Tv2                     as decimal no-undo .
  define variable Tr2                     as decimal no-undo .
  define variable R2                      as decimal no-undo .
  
  define variable temp-for-pomi           as integer no-undo.
  define variable error-string            as character no-undo.
  define variable v-is-meas               as logical no-undo.
  define variable v-mm-density            as decimal no-undo.
  
  define variable v-mm as com-handle.
  define variable v-proc as character no-undo.
  define variable v-mm57 as com-handle.
  define variable v-pokmi-dll-version as character no-undo .
  define variable vAutomationDegree as integer no-undo extent 3 init [2,1,3].
  
  define variable v-com-tanks    as character no-undo init "":U .
  define variable v-pl-code-list as character no-undo init "":U .
  define variable ii             as integer   no-undo .
  define variable v-avg-temp     as decimal   no-undo .
  
  define variable v-ok as logical no-undo .
  define variable v-sec as character no-undo .
  define variable infoSecObj as class ibs.th.str.InfoSection no-undo .
  
  define variable v-value as character no-undo .
  
  _trpomi :
  do on error undo, return error :
    
    v-pokmi-dll-version = get-pokmi-dll-version() .
    if v-pokmi-dll-version = "error"
    then do :
      message 'Не удается подключиться к COM-серверу библиотеки для работы с ПОкМИ ' skip
      view-as alert-box error.
      undo _trpomi, return error .
    end .
    if v-pokmi-dll-version = "1.0.2.7"
    then do :
      message 'Данный функционал доступен только для библиотеки ПОкМИ MM.dll не ниже версии 1.0.5.6 !' skip
              'У вас установлена библиотека версии 1.0.2.7'
      view-as alert-box error.
      undo _trpomi, return error .
    end .
    
    infoSecObj = infoSectionTotal:GetInfoSectionProp(p-sec-num) .
      
    v-sec = infoSecObj:SectionName .
    
    find first bf_bef_rvs-doc no-lock where bf_bef_rvs-doc.rvs-type = {&rvs-before-doc}
                                        and bf_bef_rvs-doc.out-code = p-doc-code
                                        and num-entries(bf_bef_rvs-doc.rvs-code, "-") = 3
                                        and entry(2, bf_bef_rvs-doc.rvs-code, "-") = v-sec
                                        no-error .
    if not available bf_bef_rvs-doc
    then do :
      find first bf_bef_rvs-doc no-lock where bf_bef_rvs-doc.rvs-type = {&rvs-before-doc}
                                          and bf_bef_rvs-doc.out-code = p-doc-code
                                          and num-entries(bf_bef_rvs-doc.rvs-code, "-") = 2
                                          no-error .
    end .
    
    find first bf_aft_rvs-doc no-lock where bf_aft_rvs-doc.rvs-type = {&rvs-after-doc}
                                        and bf_aft_rvs-doc.out-code = p-doc-code
                                        and num-entries(bf_aft_rvs-doc.rvs-code, "-") = 3 
                                        and entry(2, bf_aft_rvs-doc.rvs-code, "-") = v-sec
                                        no-error .
    if not available bf_aft_rvs-doc
    then do :
      find first bf_aft_rvs-doc no-lock where bf_aft_rvs-doc.rvs-type = {&rvs-after-doc}
                                          and bf_aft_rvs-doc.out-code = p-doc-code
                                          and num-entries(bf_aft_rvs-doc.rvs-code, "-") = 2
                                          no-error .
    end .
    
    if not available bf_bef_rvs-doc
    or not available bf_aft_rvs-doc
    then do :
      if infoSecObj:AccMeth = 1
      and index(this-procedure:name, "in-ladd") > 0
      then do :
        message "Не найдены сверки по документу!" view-as alert-box error .
      end .
      undo _trpomi, return error .
    end .
    
    find first buf_place no-lock where buf_place.obj-type = infoSectionTotal:ObjType
                                   and buf_place.obj-code = infoSectionTotal:ObjCode
                                   and buf_place.loc1     = infoSecObj:ListTank
                                   and buf_place.status_  = ""
                                   no-error .
    if not available buf_place
    then do :
      message substitute("Не найден текущий резервуар с кодом &1!", infoSecObj:ListTank) view-as alert-box error .
      undo _trpomi, return error .
    end .
    
    assign v-pl-code-list = v-pl-code-list + string(buf_place.pl-code) + "," .
    
    run placelib_get-attr  ( input {&place-com-tanks}
                            ,input buf_place.obj-code
                            ,input buf_place.obj-type
                            ,input buf_place.pl-code
                            ,output v-value
                            ,output v-ok      )
                            no-error.
    if v-ok then v-com-tanks = v-value .
    if v-com-tanks > ""
    then do :
      do ii = 1 to num-entries(v-com-tanks) :
        find first buf2_place no-lock where buf2_place.obj-type = buf_place.obj-type
                                        and buf2_place.obj-code = buf_place.obj-code
                                        and buf2_place.loc1     = entry(ii, v-com-tanks)
                                        and buf2_place.status_  = ""
                                        no-error .
        if available buf2_place
        then do :
          assign v-pl-code-list = v-pl-code-list + string(buf2_place.pl-code) + "," .
        end .
      end .
    end .
    
    assign v-pl-code-list = trim(v-pl-code-list, ",") .
    assign
      p-tank-weight-rvs   = 0.0
      p-tank-vol-pomi-rvs = 0.0
    .
    
    do ii = 1 to num-entries(v-pl-code-list) :
      find first buf_place no-lock where buf_place.pl-code = integer(entry(ii, v-pl-code-list)) no-error .
      if not available buf_place
      then do :
        undo _trpomi, return error .
      end .
      
      run placelib_get-attr  ( input {&place-type}
                              ,input buf_place.obj-code
                              ,input buf_place.obj-type
                              ,input buf_place.pl-code
                              ,output v-value
                              ,output v-ok      )
                              no-error.
      if v-ok then v-place-type = integer(v-value) .
      
      v-proc = "ADMM.CMethodOfMetering7" .
      if v-ok
      and v-place-type = 1
      then
        v-proc = "ADMM.CMethodOfMetering14"
      .
       
      run placelib_get-attr  ( input {&place-SI}
                              ,input buf_place.obj-code
                              ,input buf_place.obj-type
                              ,input buf_place.pl-code
                              ,output v-value
                              ,output v-ok      ) no-error.
      if v-ok
      then place-si = integer(v-value) .
      else place-si = ? .
      
      find first bf_bef_rvs-line no-lock where bf_bef_rvs-line.rvs-code = bf_bef_rvs-doc.rvs-code
                                           and bf_bef_rvs-line.obj-type = bf_bef_rvs-doc.obj-type
                                           and bf_bef_rvs-line.obj-code = bf_bef_rvs-doc.obj-code
                                           and bf_bef_rvs-line.pl-code  = buf_place.pl-code
                                           and bf_bef_rvs-line.gds-code = p-gds-code
                                           no-error .
      if not available bf_bef_rvs-line
      then do :
        if infoSecObj:AccMeth = 1
        and index(this-procedure:name, "in-ladd") > 0
        then do :
          message "Не заполнена сверка До!" view-as alert-box error .
        end .
        undo _trpomi, return error .
      end .
      
      if bf_bef_rvs-line.state-measure-qnty = ?
      or bf_bef_rvs-line.state-measure-qnty <= 0
      or bf_bef_rvs-line.state-measure-cli-qnty = ?
      or bf_bef_rvs-line.state-measure-cli-qnty <= 0
      or bf_bef_rvs-line.state-level-total = ?
      or bf_bef_rvs-line.state-level-total <= 0
      or bf_bef_rvs-line.state-level-water = ?
      or bf_bef_rvs-line.state-temperature = ?
      then do :
        if infoSecObj:AccMeth = 1
        and index(this-procedure:name, "in-ladd") > 0
        then do :
          message "Не заполнена сверка До!" view-as alert-box error .
        end .
        undo _trpomi, return error .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "temp-izm-vol"
      :
        v-temp-izm-vol1 = decimal(bf_rvs-line-attr.attr-value) .
      end .
      
      find first bf_aft_rvs-line no-lock where bf_aft_rvs-line.rvs-code = bf_aft_rvs-doc.rvs-code
                                           and bf_aft_rvs-line.obj-type = bf_aft_rvs-doc.obj-type
                                           and bf_aft_rvs-line.obj-code = bf_aft_rvs-doc.obj-code
                                           and bf_aft_rvs-line.pl-code  = buf_place.pl-code
                                           and bf_aft_rvs-line.gds-code = p-gds-code
                                           no-error .
      if not available bf_aft_rvs-line
      then do :
        if infoSecObj:AccMeth = 1
        and index(this-procedure:name, "in-ladd") > 0
        then do :
          message "Не заполнена сверка После!" view-as alert-box error .
        end .
        undo _trpomi, return error .
      end .
      
      if bf_aft_rvs-line.state-measure-qnty = ?
      or bf_aft_rvs-line.state-measure-qnty <= 0
      or bf_aft_rvs-line.state-measure-cli-qnty = ?
      or bf_aft_rvs-line.state-measure-cli-qnty <= 0
      or bf_aft_rvs-line.state-level-total = ?
      or bf_aft_rvs-line.state-level-total <= 0
      or bf_aft_rvs-line.state-level-water = ?
      or bf_aft_rvs-line.state-temperature = ?
      then do :
        if infoSecObj:AccMeth = 1
        and index(this-procedure:name, "in-ladd") > 0
        then do :
          message "Не заполнена сверка После!" view-as alert-box error .
        end .
        undo _trpomi, return error .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "temp-izm-vol"
      :
        v-temp-izm-vol2 = decimal(bf_rvs-line-attr.attr-value) .
      end .
      
      if bf_bef_rvs-line.state-level-water > 0
      then do :
        find last water1_pl-level no-lock where water1_pl-level.pl-code  = bf_bef_rvs-line.pl-code
                                            and water1_pl-level.obj-code = bf_bef_rvs-line.obj-code
                                            and water1_pl-level.obj-type = bf_bef_rvs-line.obj-type
                                            and water1_pl-level.pl-level <= bf_bef_rvs-line.state-level-water
                                            no-error .
        if (available water1_pl-level 
        and water1_pl-level.pl-level <> bf_bef_rvs-line.state-level-water)
        or bf_bef_rvs-line.state-level-water < 1
        then do :
          find first water2_pl-level no-lock where water2_pl-level.pl-code  = bf_bef_rvs-line.pl-code
                                               and water2_pl-level.obj-code = bf_bef_rvs-line.obj-code
                                               and water2_pl-level.obj-type = bf_bef_rvs-line.obj-type
                                               and water2_pl-level.pl-level >= bf_bef_rvs-line.state-level-water
                                               no-error .
        end .
      end .  
      find last total1_pl-level no-lock where total1_pl-level.pl-code  = bf_bef_rvs-line.pl-code
                                          and total1_pl-level.obj-code = bf_bef_rvs-line.obj-code
                                          and total1_pl-level.obj-type = bf_bef_rvs-line.obj-type
                                          and total1_pl-level.pl-level <= bf_bef_rvs-line.state-level-total
                                          no-error . 
      if not available total1_pl-level
      then do :
        if bf_bef_rvs-line.state-level-total >= 1
        then do :
          find first bf_goods no-lock where bf_goods.gds-code = bf_bef_rvs-line.gds-code no-error .
          message 
            substitute( 'Для резервуара &1 (&2 &3) не заполнена градуировочная таблица. Запуск ПОкМИ невозможен.'
                       ,(if available buf_place then buf_place.loc1 else "?")
                       ,(if available bf_goods then string(bf_goods.gds-code) else "?")
                       ,(if available bf_goods then bf_goods.gds-name else "?") )
          view-as alert-box .
          undo _trpomi, return .
        end .
      end .
      DeltaOtn_K = ? .                                    
      for first buf_pl-level-attr no-lock where buf_pl-level-attr.pl-code  = total1_pl-level.pl-code
                                            and buf_pl-level-attr.obj-code = total1_pl-level.obj-code
                                            and buf_pl-level-attr.obj-type = total1_pl-level.obj-type
                                            and buf_pl-level-attr.pl-level = total1_pl-level.pl-level
                                            and buf_pl-level-attr.attr-code = "tarir-delta"
                                            :      
        DeltaOtn_K = decimal(buf_pl-level-attr.attr-value) . 
      end .   
      if DeltaOtn_K = ? then DeltaOtn_K = 0.25 .                              
      find first total2_pl-level no-lock where total2_pl-level.pl-code  = bf_bef_rvs-line.pl-code
                                          and total2_pl-level.obj-code = bf_bef_rvs-line.obj-code
                                          and total2_pl-level.obj-type = bf_bef_rvs-line.obj-type
                                          and total2_pl-level.pl-level > bf_bef_rvs-line.state-level-total
                                          no-error .   
      if not available total2_pl-level
      then do :
        find first bf_goods no-lock where bf_goods.gds-code = bf_bef_rvs-line.gds-code no-error .
        message 
          substitute( 'Для резервуара &1 (&2 &3) не заполнена градуировочная таблица. Запуск ПОкМИ невозможен.'
                     ,(if available buf_place then buf_place.loc1 else "?")
                     ,(if available bf_goods then string(bf_goods.gds-code) else "?")
                     ,(if available bf_goods then bf_goods.gds-name else "?") )
        view-as alert-box .
        undo _trpomi, return .
      end .      
      if available water2_pl-level
      then do :
        CalibTable = Substitute("&1=&2", water2_pl-level.pl-level, (water2_pl-level.pl-qnty / 1000)) + {&new-line} + CalibTable .
      end .                              
      if available water1_pl-level
      then do :
        CalibTable = Substitute("&1=&2", water1_pl-level.pl-level, (water1_pl-level.pl-qnty / 1000)) + {&new-line} + CalibTable .
      end . 
      if available total1_pl-level
      then do :
        CalibTable = CalibTable + Substitute("&1=&2", total1_pl-level.pl-level, (total1_pl-level.pl-qnty / 1000)) + {&new-line} . 
      end .
      CalibTable = CalibTable + Substitute("&1=&2", total2_pl-level.pl-level, (total2_pl-level.pl-qnty / 1000)) + {&new-line} .
  
      if bf_bef_rvs-line.state-level-total < 1
      or bf_bef_rvs-line.state-level-water < 1
      then do :
        find first buf_pl-level no-lock where buf_pl-level.pl-code  = bf_bef_rvs-line.pl-code
                                         and buf_pl-level.obj-code = bf_bef_rvs-line.obj-code
                                         and buf_pl-level.obj-type = bf_bef_rvs-line.obj-type
                                         and buf_pl-level.pl-level = 0
                                         no-error .
        if not available buf_pl-level
        then do :
          CalibTable = "0=0" + {&new-line} + CalibTable .
        end .                                  
      end .
      
      if bf_aft_rvs-line.state-level-water > 0
      and bf_aft_rvs-line.state-level-water <> bf_bef_rvs-line.state-level-water
      then do :
        find last water1_pl-level no-lock where water1_pl-level.pl-code  = bf_aft_rvs-line.pl-code
                                            and water1_pl-level.obj-code = bf_aft_rvs-line.obj-code
                                            and water1_pl-level.obj-type = bf_aft_rvs-line.obj-type
                                            and water1_pl-level.pl-level <= bf_aft_rvs-line.state-level-water
                                            no-error .
        if (available water1_pl-level 
        and water1_pl-level.pl-level <> bf_aft_rvs-line.state-level-water)
        or bf_aft_rvs-line.state-level-water < 1
        then do :
          find first water2_pl-level no-lock where water2_pl-level.pl-code  = bf_aft_rvs-line.pl-code
                                               and water2_pl-level.obj-code = bf_aft_rvs-line.obj-code
                                               and water2_pl-level.obj-type = bf_aft_rvs-line.obj-type
                                               and water2_pl-level.pl-level >= bf_aft_rvs-line.state-level-water
                                               no-error .
        end .
      end .  
      find last total1_pl-level no-lock where total1_pl-level.pl-code  = bf_aft_rvs-line.pl-code
                                          and total1_pl-level.obj-code = bf_aft_rvs-line.obj-code
                                          and total1_pl-level.obj-type = bf_aft_rvs-line.obj-type
                                          and total1_pl-level.pl-level <= bf_aft_rvs-line.state-level-total
                                          no-error . 
      if not available total1_pl-level
      then do :
        if bf_aft_rvs-line.state-level-total >= 1
        then do :
          find first bf_goods no-lock where bf_goods.gds-code = bf_aft_rvs-line.gds-code no-error .
          message 
            substitute( 'Для резервуара &1 (&2 &3) не заполнена градуировочная таблица. Запуск ПОкМИ невозможен.'
                       ,(if available buf_place then buf_place.loc1 else "?")
                       ,(if available bf_goods then string(bf_goods.gds-code) else "?")
                       ,(if available bf_goods then bf_goods.gds-name else "?") )
          view-as alert-box .
          undo _trpomi, return .
        end .
      end .
      DeltaOtn_K = ? .                                    
      for first buf_pl-level-attr no-lock where buf_pl-level-attr.pl-code  = total1_pl-level.pl-code
                                            and buf_pl-level-attr.obj-code = total1_pl-level.obj-code
                                            and buf_pl-level-attr.obj-type = total1_pl-level.obj-type
                                            and buf_pl-level-attr.pl-level = total1_pl-level.pl-level
                                            and buf_pl-level-attr.attr-code = "tarir-delta"
                                            :      
        DeltaOtn_K = decimal(buf_pl-level-attr.attr-value) . 
      end .   
      if DeltaOtn_K = ? then DeltaOtn_K = 0.25 .                              
      find first total2_pl-level no-lock where total2_pl-level.pl-code  = bf_aft_rvs-line.pl-code
                                          and total2_pl-level.obj-code = bf_aft_rvs-line.obj-code
                                          and total2_pl-level.obj-type = bf_aft_rvs-line.obj-type
                                          and total2_pl-level.pl-level > bf_aft_rvs-line.state-level-total
                                          no-error .   
      if not available total2_pl-level
      then do :
        find first bf_goods no-lock where bf_goods.gds-code = bf_aft_rvs-line.gds-code no-error .
        message 
          substitute( 'Для резервуара &1 (&2 &3) не заполнена градуировочная таблица. Запуск ПОкМИ невозможен.'
                     ,(if available buf_place then buf_place.loc1 else "?")
                     ,(if available bf_goods then string(bf_goods.gds-code) else "?")
                     ,(if available bf_goods then bf_goods.gds-name else "?") )
        view-as alert-box .
        undo _trpomi, return .
      end .                                    
      if available water2_pl-level
      then do :
        CalibTable = Substitute("&1=&2", water2_pl-level.pl-level, (water2_pl-level.pl-qnty / 1000)) + {&new-line} + CalibTable .
      end .  
      if available water1_pl-level
      then do :
        CalibTable = Substitute("&1=&2", water1_pl-level.pl-level, (water1_pl-level.pl-qnty / 1000)) + {&new-line} + CalibTable .
      end . 
      if available total1_pl-level
      then do :
        CalibTable = CalibTable + Substitute("&1=&2", total1_pl-level.pl-level, (total1_pl-level.pl-qnty / 1000)) + {&new-line} . 
      end .
      CalibTable = CalibTable + Substitute("&1=&2", total2_pl-level.pl-level, (total2_pl-level.pl-qnty / 1000)) .    
      
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "input-type-p"
      :
        if bf_rvs-line-attr.attr-value = "р"
        or bf_rvs-line-attr.attr-value = "ак"
        or bf_rvs-line-attr.attr-value = "фк"
        then do :
          pl-rvd-dens-1 = yes .
        end .
        else do :
          pl-rvd-dens-1 = no .
        end .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "input-type-p"
      :
        if bf_rvs-line-attr.attr-value = "р"
        or bf_rvs-line-attr.attr-value = "ак"
        or bf_rvs-line-attr.attr-value = "фк"
        then do :
          pl-rvd-dens-2 = yes .
        end .
        else do :
          pl-rvd-dens-2 = no .
        end .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "input-type-t"
      :
        if bf_rvs-line-attr.attr-value = "р"
        or bf_rvs-line-attr.attr-value = "ак"
        or bf_rvs-line-attr.attr-value = "фк"
        then do :
          pl-rvd-temp-1 = yes .
        end .
        else do :
          pl-rvd-temp-1 = no .
        end .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "input-type-t"
      :
        if bf_rvs-line-attr.attr-value = "р"
        or bf_rvs-line-attr.attr-value = "ак"
        or bf_rvs-line-attr.attr-value = "фк"
        then do :
          pl-rvd-temp-2 = yes .
        end .
        else do :
          pl-rvd-temp-2 = no .
        end .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "input-type-l"
      :
        if bf_rvs-line-attr.attr-value = "р"
        or bf_rvs-line-attr.attr-value = "ак"
        or bf_rvs-line-attr.attr-value = "фк"
        then do :
          pl-rvd-lvl-1 = yes .
        end .
        else do :
          pl-rvd-lvl-1 = no .
        end .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "input-type-l"
      :
        if bf_rvs-line-attr.attr-value = "р"
        or bf_rvs-line-attr.attr-value = "ак"
        or bf_rvs-line-attr.attr-value = "фк"
        then do :
          pl-rvd-lvl-2 = yes .
        end .
        else do :
          pl-rvd-lvl-2 = no .
        end .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "mi-lvl"
      :
        v-mi-lvl-1 = integer(bf_rvs-line-attr.attr-value) .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "mi-lvl"
      :
        v-mi-lvl-2 = integer(bf_rvs-line-attr.attr-value) .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "mi-dnst"
      :
        v-mi-dnst-1 = integer(bf_rvs-line-attr.attr-value) .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "mi-dnst"
      :
        v-mi-dnst-2 = integer(bf_rvs-line-attr.attr-value) .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "mi-tmp"
      :
        v-mi-tmp-1 = integer(bf_rvs-line-attr.attr-value) .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "mi-tmp"
      :
        v-mi-tmp-2 = integer(bf_rvs-line-attr.attr-value) .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "mi-tmp-dnst"
      :
        v-mi-tmp-dnst-1 = integer(bf_rvs-line-attr.attr-value) .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "mi-tmp-dnst"
      :
        v-mi-tmp-dnst-2 = integer(bf_rvs-line-attr.attr-value) .
      end .
      
      if pl-rvd-lvl-1 and v-mi-lvl-1 > 0 and pl-rvd-lvl-2 and v-mi-lvl-2 > 0
      and pl-rvd-dens-1 and v-mi-dnst-1 > 0 and pl-rvd-dens-2 and v-mi-dnst-2 > 0
      and pl-rvd-temp-1 and v-mi-tmp-1 > 0 and pl-rvd-temp-2 and v-mi-tmp-2 > 0
      then do : end .
      else do :
        if place-si = 0
        or place-si = ?
        then do :
          message
            substitute ("Для складского места &1 не заданно средство измерения",buf_place.pl-code)
          view-as alert-box error.
          undo _trpomi, return error.
        end.
        else do :
          find first buf_sr-izmerenia no-lock where buf_sr-izmerenia.node-code = place-si no-error.
          if not available buf_sr-izmerenia then do :
            message
            "Ошибка работы с библиотекой ПОкМИ"
            substitute( 'Не найдено средство измерения с кодом &1', place-si ) skip
            view-as alert-box error.
            undo _trpomi, return error.
          end.
          else do :
            assign
              ToolType1               = buf_sr-izmerenia.sr-type-id
              LevelToolType1          = buf_sr-izmerenia.sr-type-level-measuring
              ToolAutomationLevel_H1  = vAutomationDegree[buf_sr-izmerenia.sr-type-izm + 1]
              ToolAutomationLevel_H_Water1 = vAutomationDegree[buf_sr-izmerenia.sr-type-izm + 1]
              DeltaAbs_H1             = buf_sr-izmerenia.sr-abs-err-neft-water
              DeltaAbs_H_Water1       = buf_sr-izmerenia.sr-abs-err-water
              ToolAutomationLevel_R1  = vAutomationDegree[buf_sr-izmerenia.sr-type-izm + 1]
              DeltaAbs_R1             = buf_sr-izmerenia.sr-abs-err-dens
              ToolAutomationLevel_Tv1 = vAutomationDegree[buf_sr-izmerenia.sr-type-izm + 1]
              DeltaAbs_Tv1            = buf_sr-izmerenia.sr-abs-err-temp-vol
              ToolAutomationLevel_Tr1 = vAutomationDegree[buf_sr-izmerenia.sr-type-izm + 1]
              DeltaAbs_Tr1            = buf_sr-izmerenia.sr-abs-err-temp-dens
              DeltaOtn_H1             = buf_sr-izmerenia.sr-relative-err-neft-water
              DeltaOtn_H_Water1       = buf_sr-izmerenia.sr-relative-err-water
              DeltaOtn_R1             = buf_sr-izmerenia.sr-relative-err-dens
              DeltaAbs_H_CalcType1    = buf_sr-izmerenia.sr-type-level-measuring + 1
              DeltaAbs_H_Water_CalcType1 = buf_sr-izmerenia.sr-type-level-measuring + 1
              
              ToolType2               = buf_sr-izmerenia.sr-type-id
              LevelToolType2          = buf_sr-izmerenia.sr-type-level-measuring
              ToolAutomationLevel_H2  = vAutomationDegree[buf_sr-izmerenia.sr-type-izm + 1]
              ToolAutomationLevel_H_Water2 = vAutomationDegree[buf_sr-izmerenia.sr-type-izm + 1]
              DeltaAbs_H2             = buf_sr-izmerenia.sr-abs-err-neft-water
              DeltaAbs_H_Water2       = buf_sr-izmerenia.sr-abs-err-water
              ToolAutomationLevel_R2  = vAutomationDegree[buf_sr-izmerenia.sr-type-izm + 1]
              DeltaAbs_R2             = buf_sr-izmerenia.sr-abs-err-dens
              ToolAutomationLevel_Tv2 = vAutomationDegree[buf_sr-izmerenia.sr-type-izm + 1]
              DeltaAbs_Tv2            = buf_sr-izmerenia.sr-abs-err-temp-vol
              ToolAutomationLevel_Tr2 = vAutomationDegree[buf_sr-izmerenia.sr-type-izm + 1]
              DeltaAbs_Tr2            = buf_sr-izmerenia.sr-abs-err-temp-dens
              DeltaOtn_H2             = buf_sr-izmerenia.sr-relative-err-neft-water
              DeltaOtn_H_Water2       = buf_sr-izmerenia.sr-relative-err-water
              DeltaOtn_R2             = buf_sr-izmerenia.sr-relative-err-dens
              DeltaAbs_H_CalcType2    = buf_sr-izmerenia.sr-type-level-measuring + 1
              DeltaAbs_H_Water_CalcType2 = buf_sr-izmerenia.sr-type-level-measuring + 1
              
              DeltaOtn_N              = 0.05
            .
          end.
        end.
      end.
      
      if (pl-rvd-lvl-1
      and v-mi-lvl-1 > 0
      and v-mi-lvl-1 <> place-si)
      or not available buf_sr-izmerenia
      then do :
        find first level_sr-izmerenia no-lock where level_sr-izmerenia.node-code = v-mi-lvl-1 no-error.
        if not available level_sr-izmerenia then do :
          message
          "Ошибка работы с библиотекой ПОкМИ"
          substitute( 'Не найдено средство измерения с кодом &1', v-mi-lvl-1 ) skip
          view-as alert-box error.
          undo _trpomi, return error.
        end.
        else do :
          assign
            DeltaAbs_H1                  = level_sr-izmerenia.sr-abs-err-neft-water
            DeltaAbs_H_Water1            = level_sr-izmerenia.sr-abs-err-water
            DeltaOtn_H1                  = level_sr-izmerenia.sr-relative-err-neft-water
            DeltaOtn_H_Water1            = level_sr-izmerenia.sr-relative-err-water
            LevelToolType1               = level_sr-izmerenia.sr-type-level-measuring 
            ToolAutomationLevel_H1       = vAutomationDegree[level_sr-izmerenia.sr-type-izm + 1]
            ToolAutomationLevel_H_Water1 = vAutomationDegree[level_sr-izmerenia.sr-type-izm + 1]
            DeltaAbs_H_CalcType1         = level_sr-izmerenia.sr-type-level-measuring + 1
            DeltaAbs_H_Water_CalcType1   = level_sr-izmerenia.sr-type-level-measuring + 1
          .
        end.
      end .
      
      if (pl-rvd-lvl-2
      and v-mi-lvl-2 > 0
      and v-mi-lvl-2 <> place-si)
      or not available buf_sr-izmerenia
      then do :
        find first level_sr-izmerenia no-lock where level_sr-izmerenia.node-code = v-mi-lvl-2 no-error.
        if not available level_sr-izmerenia then do :
          message
          "Ошибка работы с библиотекой ПОкМИ"
          substitute( 'Не найдено средство измерения с кодом &1', v-mi-lvl-2 ) skip
          view-as alert-box error.
          undo _trpomi, return error.
        end.
        else do :
          assign
            DeltaAbs_H2                  = level_sr-izmerenia.sr-abs-err-neft-water
            DeltaAbs_H_Water2            = level_sr-izmerenia.sr-abs-err-water
            DeltaOtn_H2                  = level_sr-izmerenia.sr-relative-err-neft-water
            DeltaOtn_H_Water2            = level_sr-izmerenia.sr-relative-err-water
            LevelToolType2               = level_sr-izmerenia.sr-type-level-measuring 
            ToolAutomationLevel_H2       = vAutomationDegree[level_sr-izmerenia.sr-type-izm + 1]
            ToolAutomationLevel_H_Water2 = vAutomationDegree[level_sr-izmerenia.sr-type-izm + 1]
            DeltaAbs_H_CalcType2         = level_sr-izmerenia.sr-type-level-measuring + 1
            DeltaAbs_H_Water_CalcType2   = level_sr-izmerenia.sr-type-level-measuring + 1
          .
        end.
      end .
      
      if (pl-rvd-dens-1
      and v-mi-dnst-1 > 0
      and v-mi-dnst-1 <> place-si)
      or not available buf_sr-izmerenia
      then do :
        find first dens_sr-izmerenia no-lock where dens_sr-izmerenia.node-code = v-mi-dnst-1 no-error.
        if not available dens_sr-izmerenia then do :
          message
          "Ошибка работы с библиотекой ПОкМИ"
          substitute( 'Не найдено средство измерения с кодом &1', v-mi-dnst-1 ) skip
          view-as alert-box error.
          undo _trpomi, return error.
        end.
        else do :
          assign
            ToolType1               = dens_sr-izmerenia.sr-type-id
            DeltaAbs_R1             = dens_sr-izmerenia.sr-abs-err-dens
            DeltaOtn_R1             = dens_sr-izmerenia.sr-relative-err-dens
            ToolAutomationLevel_R1  = vAutomationDegree[dens_sr-izmerenia.sr-type-izm + 1]
          .
        end.
      end .
      
      if (pl-rvd-dens-2
      and v-mi-dnst-2 > 0
      and v-mi-dnst-2 <> place-si)
      or not available buf_sr-izmerenia
      then do :
        find first dens_sr-izmerenia no-lock where dens_sr-izmerenia.node-code = v-mi-dnst-2 no-error.
        if not available dens_sr-izmerenia then do :
          message
          "Ошибка работы с библиотекой ПОкМИ"
          substitute( 'Не найдено средство измерения с кодом &1', v-mi-dnst-2 ) skip
          view-as alert-box error.
          undo _trpomi, return error.
        end.
        else do :
          assign
            ToolType2               = dens_sr-izmerenia.sr-type-id
            DeltaAbs_R2             = dens_sr-izmerenia.sr-abs-err-dens
            DeltaOtn_R2             = dens_sr-izmerenia.sr-relative-err-dens
            ToolAutomationLevel_R2  = vAutomationDegree[dens_sr-izmerenia.sr-type-izm + 1]
          .
        end.
      end .
      
      if (pl-rvd-temp-1
      and v-mi-tmp-1 > 0
      and v-mi-tmp-1 <> place-si) 
      or not available buf_sr-izmerenia
      then do :
        find first temp_sr-izmerenia no-lock where temp_sr-izmerenia.node-code = v-mi-tmp-1 no-error.
        if not available temp_sr-izmerenia then do :
          message
          "Ошибка работы с библиотекой ПОкМИ"
          substitute( 'Не найдено средство измерения с кодом &1', v-mi-tmp-1 ) skip
          view-as alert-box error.
          undo _trpomi, return error.
        end.
        else do :
          assign
            DeltaAbs_Tv1            = temp_sr-izmerenia.sr-abs-err-temp-vol
            DeltaAbs_Tr1            = temp_sr-izmerenia.sr-abs-err-temp-dens
            ToolAutomationLevel_Tr1 = vAutomationDegree[temp_sr-izmerenia.sr-type-izm + 1]
            ToolAutomationLevel_Tv1 = vAutomationDegree[temp_sr-izmerenia.sr-type-izm + 1]
          .
        end.
      end .
      
      if (pl-rvd-temp-2
      and v-mi-tmp-2 > 0
      and v-mi-tmp-2 <> place-si) 
      or not available buf_sr-izmerenia
      then do :
        find first temp_sr-izmerenia no-lock where temp_sr-izmerenia.node-code = v-mi-tmp-2 no-error.
        if not available temp_sr-izmerenia then do :
          message
          "Ошибка работы с библиотекой ПОкМИ"
          substitute( 'Не найдено средство измерения с кодом &1', v-mi-tmp-2 ) skip
          view-as alert-box error.
          undo _trpomi, return error.
        end.
        else do :
          assign
            DeltaAbs_Tv2            = temp_sr-izmerenia.sr-abs-err-temp-vol
            DeltaAbs_Tr2            = temp_sr-izmerenia.sr-abs-err-temp-dens
            ToolAutomationLevel_Tr2 = vAutomationDegree[temp_sr-izmerenia.sr-type-izm + 1]
            ToolAutomationLevel_Tv2 = vAutomationDegree[temp_sr-izmerenia.sr-type-izm + 1]
          .
        end.
      end .
      
      if v-mi-tmp-dnst-1 > 0
      and v-mi-tmp-dnst-1 <> v-mi-tmp-1
      then do :
        for first temp-dens_sr-izmerenia no-lock where temp-dens_sr-izmerenia.node-code = v-mi-tmp-dnst-1 :
          assign 
            DeltaAbs_Tr1 = temp-dens_sr-izmerenia.sr-abs-err-temp-dens when temp-dens_sr-izmerenia.sr-abs-err-temp-dens > 0
            ToolAutomationLevel_Tr1 = vAutomationDegree[temp-dens_sr-izmerenia.sr-type-izm + 1]
          .
        end .
      end .
      
      if v-mi-tmp-dnst-2 > 0
      and v-mi-tmp-dnst-2 <> v-mi-tmp-2
      then do :
        for first temp-dens_sr-izmerenia no-lock where temp-dens_sr-izmerenia.node-code = v-mi-tmp-dnst-2 :
          assign 
            DeltaAbs_Tr2 = temp-dens_sr-izmerenia.sr-abs-err-temp-dens when temp-dens_sr-izmerenia.sr-abs-err-temp-dens > 0
            ToolAutomationLevel_Tr2 = vAutomationDegree[temp-dens_sr-izmerenia.sr-type-izm + 1]
          .
        end .
      end .
      
      CalibBelt = getCalibrationBelt( buf_place.obj-type, 
                                      buf_place.obj-code,
                                      buf_place.pl-code,
                                      bf_bef_rvs-line.state-level-total,
                                      bf_bef_rvs-line.state-level-water
                                     ).
      CalibBelt = CalibBelt + {&new-line} + getCalibrationBelt( buf_place.obj-type, 
                                                                buf_place.obj-code,
                                                                buf_place.pl-code,
                                                                bf_aft_rvs-line.state-level-total,
                                                                bf_aft_rvs-line.state-level-water
                                                               ).
      
      if DeltaAbs_H1       = ? then DeltaAbs_H1 = 0 .
      if DeltaAbs_H_Water1 = ? then DeltaAbs_H_Water1 = 0 .
      if DeltaAbs_R1       = ? then DeltaAbs_R1 = 0 .
      if DeltaAbs_Tv1      = ? then DeltaAbs_Tv1 = 0 .
      if DeltaAbs_Tr1      = ? then DeltaAbs_Tr1 = 0 .
      if DeltaOtn_H1       = ? then DeltaOtn_H1 = 0 .
      if DeltaOtn_H_Water1 = ? then DeltaOtn_H_Water1 = 0 .
      if DeltaOtn_R1       = ? then DeltaOtn_R1 = 0 .
      if LevelToolType1    = ? then LevelToolType1 = 0 .
      if ToolType1         = ? then ToolType1 = 0 .
      if ToolAutomationLevel_Tr1      = ? then ToolAutomationLevel_Tr1 =0.
      if ToolAutomationLevel_H1       = ? then ToolAutomationLevel_H1 = 0.
      if ToolAutomationLevel_H_Water1 = ? then ToolAutomationLevel_H_Water1 = 0.
      if ToolAutomationLevel_Tv1      = ? then ToolAutomationLevel_Tv1 = 0.
      if ToolAutomationLevel_R1       = ? then ToolAutomationLevel_R1 = 0.
      if DeltaAbs_H_CalcType1         = ? then DeltaAbs_H_CalcType1 = 0.
      if DeltaAbs_H_Water_CalcType1   = ? then DeltaAbs_H_Water_CalcType1 = 0.
      
      if DeltaAbs_H2       = ? then DeltaAbs_H2 = 0 .
      if DeltaAbs_H_Water2 = ? then DeltaAbs_H_Water2 = 0 .
      if DeltaAbs_R2       = ? then DeltaAbs_R2 = 0 .
      if DeltaAbs_Tv2      = ? then DeltaAbs_Tv2 = 0 .
      if DeltaAbs_Tr2      = ? then DeltaAbs_Tr2 = 0 .
      if DeltaOtn_H2       = ? then DeltaOtn_H2 = 0 .
      if DeltaOtn_H_Water2 = ? then DeltaOtn_H_Water2 = 0 .
      if DeltaOtn_R2       = ? then DeltaOtn_R2 = 0 .
      if LevelToolType2    = ? then LevelToolType2 = 0 .
      if ToolType2         = ? then ToolType2 = 0 .
      if ToolAutomationLevel_Tr2      = ? then ToolAutomationLevel_Tr2 =0.
      if ToolAutomationLevel_H2       = ? then ToolAutomationLevel_H2 = 0.
      if ToolAutomationLevel_H_Water2 = ? then ToolAutomationLevel_H_Water2 = 0.
      if ToolAutomationLevel_Tv2      = ? then ToolAutomationLevel_Tv2 = 0.
      if ToolAutomationLevel_R2       = ? then ToolAutomationLevel_R2 = 0.
      if DeltaAbs_H_CalcType2         = ? then DeltaAbs_H_CalcType2 = 0.
      if DeltaAbs_H_Water_CalcType2   = ? then DeltaAbs_H_Water_CalcType2 = 0.
      
      if bf_bef_rvs-line.state-level-water = 0
      then do :
        ToolAutomationLevel_H_Water1 = 0 .
        DeltaAbs_H_Water_CalcType1 = 0 .
        DeltaAbs_H_Water1 = 0 .
      end .
      
      if bf_aft_rvs-line.state-level-water = 0
      then do :
        ToolAutomationLevel_H_Water2 = 0 .
        DeltaAbs_H_Water_CalcType2 = 0 .
        DeltaAbs_H_Water2 = 0 .
      end .
      
      if LevelToolType1 > 0
      then do :
        RELEASE OBJECT v-mm57 NO-ERROR.
        v-mm57 = ?.
  
        CREATE value("ADMM.CMethodOfMetering57") v-mm57 no-error.
        IF ERROR-STATUS:ERROR
        OR NOT VALID-HANDLE(v-mm57)
        THEN DO:
          RELEASE OBJECT v-mm57 NO-ERROR.
          v-mm57 = ?.
          message substitute( 'Не удается подключиться к COM-серверу библиотеки для работы с ПОкМИ ' ) view-as alert-box .
          undo _trpomi, return error  .
        END.
        ELSE DO :
          assign
            v-mm57:H        = bf_bef_rvs-line.state-level-total * 10
            v-mm57:ToolType = LevelToolType1
          .
          OUTPUT stream outstream to value ("pomi.log") append.
          PUT STREAM outstream unformatted
                      "    " SKIP
                      "    " SKIP
                      cur-time-string()           FORMAT "x(16)"    SKIP
                      'Процедура             "ADMM.MethodOfMetering57"'       SKIP
                      'Версия dll: '            v-pokmi-dll-version   skip
                      'CODE_PL                = ' buf_place.pl-code                           SKIP
                      'H                      = ' v-mm57:H                  SKIP
                      'ToolType               = ' v-mm57:ToolType                                      SKIP
                          SKIP SKIP 
          .
          output stream outstream close.
          
          v-mm57:Exec() no-error.
          if v-mm57:Result <> 0 then do :
            error-string = v-mm57:ResultDetail .
            output stream outstream to value ("pomi.log")  append.
            put stream outstream error-string format "X(1024)" skip.
            RELEASE OBJECT v-mm57 NO-ERROR.
            v-mm57 = ?.
            output stream outstream close.
            message substitute('Ошибка работы библиотеки ПОкМИ &1',error-string) view-as alert-box .
            undo _trpomi, return error .
          end.
          else do :
            DeltaAbs_H1 = v-mm57:DeltaAbs_H .
            OUTPUT stream outstream to value ("pomi.log")  append.
            PUT STREAM outstream unformatted
                "v-mm:DeltaAbs_H = " v-mm57:DeltaAbs_H  SKIP
            .
            OUTPUT stream outstream close.
            RELEASE OBJECT v-mm57 NO-ERROR.
            v-mm57 = ?.
          end .
        end .
      end . /* LevelToolType1 > 0 */
      
      if LevelToolType2 > 0
      then do :
        RELEASE OBJECT v-mm57 NO-ERROR.
        v-mm57 = ?.
  
        CREATE value("ADMM.CMethodOfMetering57") v-mm57 no-error.
        IF ERROR-STATUS:ERROR
        OR NOT VALID-HANDLE(v-mm57)
        THEN DO:
          RELEASE OBJECT v-mm57 NO-ERROR.
          v-mm57 = ?.
          message substitute( 'Не удается подключиться к COM-серверу библиотеки для работы с ПОкМИ ' ) view-as alert-box .
          undo _trpomi, return error  .
        END.
        ELSE DO :
          assign
            v-mm57:H        = bf_aft_rvs-line.state-level-total * 10
            v-mm57:ToolType = LevelToolType2
          .
          OUTPUT stream outstream to value ("pomi.log") append.
          PUT STREAM outstream unformatted
                      "    " SKIP
                      "    " SKIP
                      cur-time-string()           FORMAT "x(16)"    SKIP
                      'Процедура             "ADMM.MethodOfMetering57"'       SKIP
                      'Версия dll: '            v-pokmi-dll-version   skip
                      'CODE_PL                = ' buf_place.pl-code                           SKIP
                      'H                      = ' v-mm57:H                  SKIP
                      'ToolType               = ' v-mm57:ToolType                                      SKIP
                          SKIP SKIP 
          .
          output stream outstream close.
          
          v-mm57:Exec() no-error.
          if v-mm57:Result <> 0 then do :
            error-string = v-mm57:ResultDetail .
            output stream outstream to value ("pomi.log")  append.
            put stream outstream error-string format "X(1024)" skip.
            RELEASE OBJECT v-mm57 NO-ERROR.
            v-mm57 = ?.
            output stream outstream close.
            message substitute('Ошибка работы библиотеки ПОкМИ &1',error-string) view-as alert-box .
            undo _trpomi, return error .
          end.
          else do :
            DeltaAbs_H2 = v-mm57:DeltaAbs_H .
            OUTPUT stream outstream to value ("pomi.log")  append.
            PUT STREAM outstream unformatted
                "v-mm:DeltaAbs_H = " v-mm57:DeltaAbs_H  SKIP
            .
            OUTPUT stream outstream close.
            RELEASE OBJECT v-mm57 NO-ERROR.
            v-mm57 = ?.
          end .
        end .
      end . /* LevelToolType2 > 0 */
      
      release object v-mm no-error .
      v-mm = ?.
  
      create value(v-proc) v-mm no-error.
      if error-status:error
      or not valid-handle(v-mm)
      then do:
        message
        "Не удается подключиться к COM-серверу библиотеки для работы с ПОкМИ "
        view-as alert-box error.
        release object v-mm no-error .
        v-mm = ?.
        undo _trpomi, return error .
      end.
      
      assign
        Tr1 = bf_bef_rvs-line.state-temperature
        Tv1 = if v-temp-izm-vol1 <> ? then v-temp-izm-vol1 else bf_bef_rvs-line.state-temperature 
        R1  = ( bf_bef_rvs-line.state-density * 1000 )
        
        Tr2 = bf_aft_rvs-line.state-temperature
        Tv2 = if v-temp-izm-vol2 <> ? then v-temp-izm-vol2 else bf_aft_rvs-line.state-temperature 
        R2  = ( bf_aft_rvs-line.state-density * 1000 )
      .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "Tr"
      :
        assign Tr1 = decimal(bf_rvs-line-attr.attr-value) .
      end .
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "Tv"
      :
        assign Tv1 = decimal(bf_rvs-line-attr.attr-value) .
      end .
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_bef_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_bef_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_bef_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_bef_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_bef_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "R"
      :
        assign R1 = decimal(bf_rvs-line-attr.attr-value) * 1000 .
      end .
      
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "Tr"
      :
        assign Tr2 = decimal(bf_rvs-line-attr.attr-value) .
      end .
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "Tv"
      :
        assign Tv2 = decimal(bf_rvs-line-attr.attr-value) .
      end .
      for first bf_rvs-line-attr no-lock where bf_rvs-line-attr.rvs-code  = bf_aft_rvs-line.rvs-code
                                           and bf_rvs-line-attr.obj-code  = bf_aft_rvs-line.obj-code
                                           and bf_rvs-line-attr.obj-type  = bf_aft_rvs-line.obj-type
                                           and bf_rvs-line-attr.gds-code  = bf_aft_rvs-line.gds-code
                                           and bf_rvs-line-attr.pl-code   = bf_aft_rvs-line.pl-code
                                           and bf_rvs-line-attr.attr-code = "R"
      :
        assign R2 = decimal(bf_rvs-line-attr.attr-value) * 1000 .
      end .
      
      assign
        v-mm:M1                      = bf_bef_rvs-line.state-measure-cli-qnty
        v-mm:M2                      = bf_aft_rvs-line.state-measure-cli-qnty
        v-mm:H1                      = bf_bef_rvs-line.state-level-total * 10
        v-mm:H2                      = bf_aft_rvs-line.state-level-total * 10
        v-mm:H1_water                = bf_bef_rvs-line.state-level-water * 10 when bf_bef_rvs-line.state-level-water <> ?
        v-mm:H2_water                = bf_aft_rvs-line.state-level-water * 10 when bf_aft_rvs-line.state-level-water <> ?
        v-mm:CalibrationTable        = CalibTable
        v-mm:CalibrationBelt         = CalibBelt
  /*      v-mm:Tv1                     = Tv1*/
  /*      v-mm:Tv2                     = Tv2*/
  /*      v-mm:Tr1                     = Tr1*/
  /*      v-mm:Tr2                     = Tr2*/
  /*      v-mm:R1                      = R1 */
  /*      v-mm:R2                      = R2 */
        v-mm:ToolType1               = ToolType1
        v-mm:ToolType2               = ToolType2
        v-mm:DeltaOtn_K              = DeltaOtn_K
        v-mm:OperDirection           = 2 /* приём продукта */
        v-mm:ToolAutomationLevel_H1  = ToolAutomationLevel_H1
        v-mm:ToolAutomationLevel_H2  = ToolAutomationLevel_H2
        v-mm:ToolAutomationLevel_H_Water1 = ToolAutomationLevel_H_Water1
        v-mm:ToolAutomationLevel_H_Water2 = ToolAutomationLevel_H_Water2
        v-mm:ToolAutomationLevel_R1  = ToolAutomationLevel_R1
        v-mm:ToolAutomationLevel_R2  = ToolAutomationLevel_R2
        v-mm:ToolAutomationLevel_Tv1 = ToolAutomationLevel_Tv1
        v-mm:ToolAutomationLevel_Tv2 = ToolAutomationLevel_Tv2
        v-mm:ToolAutomationLevel_Tr1 = ToolAutomationLevel_Tr1
        v-mm:ToolAutomationLevel_Tr2 = ToolAutomationLevel_Tr2
        v-mm:DeltaAbs_H_CalcType1    = DeltaAbs_H_CalcType1
        v-mm:DeltaAbs_H_CalcType2    = DeltaAbs_H_CalcType2
        v-mm:DeltaAbs_H_Water_CalcType1 = DeltaAbs_H_Water_CalcType1
        v-mm:DeltaAbs_H_Water_CalcType2 = DeltaAbs_H_Water_CalcType2
        v-mm:DeltaAbs_H1             = DeltaAbs_H1
        v-mm:DeltaAbs_H2             = DeltaAbs_H2
        v-mm:DeltaAbs_H_Water1       = DeltaAbs_H_Water1
        v-mm:DeltaAbs_H_Water2       = DeltaAbs_H_Water2
        v-mm:DeltaAbs_R1             = DeltaAbs_R1
        v-mm:DeltaAbs_R2             = DeltaAbs_R2
        v-mm:DeltaAbs_Tv1            = DeltaAbs_Tv1
        v-mm:DeltaAbs_Tv2            = DeltaAbs_Tv2
        v-mm:DeltaAbs_Tr1            = DeltaAbs_Tr1
        v-mm:DeltaAbs_Tr2            = DeltaAbs_Tr2
        v-mm:DeltaOtn_H1             = DeltaOtn_H1
        v-mm:DeltaOtn_H2             = DeltaOtn_H2
        v-mm:DeltaOtn_H_Water1       = DeltaOtn_H_Water1
        v-mm:DeltaOtn_H_Water2       = DeltaOtn_H_Water2
        v-mm:DeltaOtn_R1             = DeltaOtn_R1
        v-mm:DeltaOtn_R2             = DeltaOtn_R2
        v-mm:DeltaOtn_N              = DeltaOtn_N
      .
      
      v-mm:Set_Tv1(replace(string(Tv1), ".", ",")) no-error .
      if string(v-mm:Tv1) = ".0000000000"
      and Tv1 <> 0
      then do :
        v-mm:Set_Tv1(string(Tv1)) no-error .
      end .
      if string(v-mm:Tv1) = ".0000000000"
      and Tv1 <> 0
      then do :
        assign v-mm:Tv1 = Tv1 .
      end .
      if substring(string(v-mm:Tv1), length(string(v-mm:Tv1)) - 2) = "999"
      then do :
        v-mm:Set_Tv1(replace(string(Tv1 + 0.0000000001), ".", ",")) no-error .
        if string(v-mm:Tv1) = ".0000000000"
        and Tv1 <> 0
        then do :
          v-mm:Set_Tv1(string(Tv1 + 0.0000000001)) no-error .
        end .
      end .
      
      v-mm:Set_Tv2(replace(string(Tv2), ".", ",")) no-error .
      if string(v-mm:Tv2) = ".0000000000"
      and Tv2 <> 0
      then do :
        v-mm:Set_Tv2(string(Tv2)) no-error .
      end .
      if string(v-mm:Tv2) = ".0000000000"
      and Tv2 <> 0
      then do :
        assign v-mm:Tv2 = Tv2 .
      end .
      if substring(string(v-mm:Tv2), length(string(v-mm:Tv2)) - 2) = "999"
      then do :
        v-mm:Set_Tv2(replace(string(Tv2 + 0.0000000001), ".", ",")) no-error .
        if string(v-mm:Tv2) = ".0000000000"
        and Tv2 <> 0
        then do :
          v-mm:Set_Tv2(string(Tv2 + 0.0000000001)) no-error .
        end .
      end .
      
      v-mm:Set_Tr1(replace(string(Tr1), ".", ",")) no-error .
      if string(v-mm:Tr1) = ".0000000000"
      and Tr1 <> 0
      then do :
        v-mm:Set_Tr1(string(Tr1)) no-error .
      end .
      if string(v-mm:Tr1) = ".0000000000"
      and Tr1 <> 0
      then do :
        assign v-mm:Tr1 = Tr1 .
      end .
      if substring(string(v-mm:Tr1), length(string(v-mm:Tr1)) - 2) = "999"
      then do :
        v-mm:Set_Tr1(replace(string(Tr1 + 0.0000000001), ".", ",")) no-error .
        if string(v-mm:Tr1) = ".0000000000"
        and Tr1 <> 0
        then do :
          v-mm:Set_Tr1(string(Tr1 + 0.0000000001)) no-error .
        end .
      end .
      
      v-mm:Set_Tr2(replace(string(Tr2), ".", ",")) no-error .
      if string(v-mm:Tr2) = ".0000000000"
      and Tr2 <> 0
      then do :
        v-mm:Set_Tr2(string(Tr2)) no-error .
      end .
      if string(v-mm:Tr2) = ".0000000000"
      and Tr2 <> 0
      then do :
        assign v-mm:Tr2 = Tr2 .
      end .
      if substring(string(v-mm:Tr2), length(string(v-mm:Tr2)) - 2) = "999"
      then do :
        v-mm:Set_Tr2(replace(string(Tr2 + 0.0000000001), ".", ",")) no-error .
        if string(v-mm:Tr2) = ".0000000000"
        and Tr2 <> 0
        then do :
          v-mm:Set_Tr2(string(Tr2 + 0.0000000001)) no-error .
        end .
      end .
      
      v-mm:Set_R1(replace(string(R1), ".", ",")) no-error .
      if string(v-mm:R1) = ".0000000000"
      then do :
        v-mm:Set_R1(string(R1)) no-error .
      end .
      if string(v-mm:R1) = ".0000000000"
      then do :
        assign v-mm:R1 = R1 .
      end .
      
      v-mm:Set_R2(replace(string(R2), ".", ",")) no-error .
      if string(v-mm:R2) = ".0000000000"
      then do :
        v-mm:Set_R2(string(R2)) no-error .
      end .
      if string(v-mm:R2) = ".0000000000"
      then do :
        assign v-mm:R2 = R2 .
      end .
  
      output stream outstream to value ("pomi.log") append.
      put stream outstream unformatted
        "    " SKIP
        "    " SKIP
        cur-time-string()           FORMAT "x(16)"    SKIP
        'Процедура'                 v-proc                      FORMAT "x(128)"    SKIP
        'Версия dll: '              v-pokmi-dll-version                            SKIP
        'CODE_PL                      = ' buf_place.pl-code                        SKIP
        'M1                           = ' v-mm:M1                                  SKIP
        'M2                           = ' v-mm:M2                                  SKIP
        'H1                           = ' v-mm:H1                                  SKIP
        'H2                           = ' v-mm:H2                                  SKIP
        'H1_water                     = ' v-mm:H1_water                            SKIP
        'H2_water                     = ' v-mm:H2_water                            SKIP
        'CalibrationTable             = ' v-mm:CalibrationTable                    SKIP
        'CalibrationBelt              = ' v-mm:CalibrationBelt                     SKIP
        'Tv1                          = ' v-mm:Tv1                                 SKIP
        'Tv2                          = ' v-mm:Tv2                                 SKIP
        'Tr1                          = ' v-mm:Tr1                                 SKIP
        'Tr2                          = ' v-mm:Tr2                                 skip
        'R1                           = ' v-mm:R1                                  SKIP
        'R2                           = ' v-mm:R2                                  SKIP
        'ToolType1                    = ' v-mm:ToolType1                           SKIP
        'ToolType2                    = ' v-mm:ToolType2                           SKIP
        'DeltaOtn_K                   = ' v-mm:DeltaOtn_K                          SKIP
        'OperDirection                = ' v-mm:OperDirection                       SKIP
        'ToolAutomationLevel_H1       = ' v-mm:ToolAutomationLevel_H1              SKIP
        'ToolAutomationLevel_H2       = ' v-mm:ToolAutomationLevel_H2              SKIP
        'ToolAutomationLevel_H_Water1 = ' v-mm:ToolAutomationLevel_H_Water1        SKIP
        'ToolAutomationLevel_H_Water2 = ' v-mm:ToolAutomationLevel_H_Water2        SKIP
        'ToolAutomationLevel_R1       = ' v-mm:ToolAutomationLevel_R1              SKIP
        'ToolAutomationLevel_R2       = ' v-mm:ToolAutomationLevel_R2              SKIP
        'ToolAutomationLevel_Tv1      = ' v-mm:ToolAutomationLevel_Tv1             SKIP 
        'ToolAutomationLevel_Tv2      = ' v-mm:ToolAutomationLevel_Tv2             SKIP 
        'ToolAutomationLevel_Tr1      = ' v-mm:ToolAutomationLevel_Tr1             SKIP 
        'ToolAutomationLevel_Tr2      = ' v-mm:ToolAutomationLevel_Tr2             SKIP 
        'DeltaAbs_H_CalcType1         = ' v-mm:DeltaAbs_H_CalcType1                SKIP 
        'DeltaAbs_H_CalcType2         = ' v-mm:DeltaAbs_H_CalcType2                SKIP 
        'DeltaAbs_H_Water_CalcType1   = ' v-mm:DeltaAbs_H_Water_CalcType1          SKIP 
        'DeltaAbs_H_Water_CalcType2   = ' v-mm:DeltaAbs_H_Water_CalcType2          SKIP 
        'DeltaAbs_H1                  = ' v-mm:DeltaAbs_H1                         SKIP 
        'DeltaAbs_H2                  = ' v-mm:DeltaAbs_H2                         SKIP 
        'DeltaAbs_H_Water1            = ' v-mm:DeltaAbs_H_Water1                   SKIP 
        'DeltaAbs_H_Water2            = ' v-mm:DeltaAbs_H_Water2                   SKIP 
        'DeltaAbs_R1                  = ' v-mm:DeltaAbs_R1                         SKIP 
        'DeltaAbs_R2                  = ' v-mm:DeltaAbs_R2                         SKIP 
        'DeltaAbs_Tv1                 = ' v-mm:DeltaAbs_Tv1                        SKIP 
        'DeltaAbs_Tv2                 = ' v-mm:DeltaAbs_Tv2                        SKIP 
        'DeltaAbs_Tr1                 = ' v-mm:DeltaAbs_Tr1                        SKIP 
        'DeltaAbs_Tr2                 = ' v-mm:DeltaAbs_Tr2                        SKIP 
        'DeltaOtn_H1                  = ' v-mm:DeltaOtn_H1                         SKIP 
        'DeltaOtn_H2                  = ' v-mm:DeltaOtn_H2                         SKIP 
        'DeltaOtn_H_Water1            = ' v-mm:DeltaOtn_H_Water1                   SKIP 
        'DeltaOtn_H_Water2            = ' v-mm:DeltaOtn_H_Water2                   SKIP 
        'DeltaOtn_R1                  = ' v-mm:DeltaOtn_R1                         SKIP 
        'DeltaOtn_R2                  = ' v-mm:DeltaOtn_R2                         SKIP 
        'DeltaOtn_N                   = ' v-mm:DeltaOtn_N                          SKIP 
      .
      output stream outstream close.
      
      v-mm:Exec() .
      if v-mm:Result <> 0 then do :
        error-string = v-mm:ResultDetail .
        output stream outstream to value ("pomi.log")  append.
        put stream outstream error-string format "X(1024)" skip.
        error-string = replace(error-string, ";", (";" + {&new-line})) .
        message
        substitute('Ошибка работы библиотеки ПОкМИ. &1&2', {&new-line}, error-string)
        view-as alert-box error.
        release object v-mm no-error .
        v-mm = ?.
        output stream outstream close .
        undo _trpomi, return error .
      end.  
      
      output stream outstream to value ("pomi.log") append.
      put stream outstream unformatted
        'V_total1                   = ' v-mm:V_total1                          SKIP 
        'V_total2                   = ' v-mm:V_total2                          SKIP 
        'V_water1                   = ' v-mm:V_water1                          SKIP 
        'V_water2                   = ' v-mm:V_water2                          SKIP
        'Delta_V1                   = ' v-mm:Delta_V1                          SKIP 
        'Delta_V2                   = ' v-mm:Delta_V2                          SKIP 
        'M                          = ' v-mm:M                                 SKIP 
        'DeltaOtn_M                 = ' v-mm:DeltaOtn_M                        SKIP 
      .
      output stream outstream close.
      
      assign
        p-tank-weight-rvs   = p-tank-weight-rvs + v-mm:M
        p-tank-vol-pomi-rvs = p-tank-vol-pomi-rvs + (((v-mm:V_total2 - v-mm:V_water2) - (v-mm:V_total1 - v-mm:V_water1)) * 1000)
        v-avg-temp          = v-avg-temp + ((bf_bef_rvs-line.state-temperature + bf_aft_rvs-line.state-temperature) / 2)
      .
      
      release object v-mm no-error .
      v-mm = ?.
    
    end . /* do ii = 1 to num-entries(v-pl-code-list) */
    
    assign v-avg-temp = v-avg-temp / num-entries(v-pl-code-list) .
    
    infoSecObj:TankWeightRvs = p-tank-weight-rvs .
    infoSecObj:TankVolPomiRvs = p-tank-vol-pomi-rvs .
    infoSecObj:AvgTempRvs = v-avg-temp .
    
    def var dMP  as decimal no-undo.
    def var MF   as decimal no-undo.
    def var dMF  as decimal no-undo.
    def var MTTH as decimal no-undo.
    def var md   as decimal no-undo.
    def var dmd  as decimal no-undo.
    def var dF   as decimal no-undo.
    def var NPE  as decimal no-undo.
    def var ME   as decimal no-undo.
    def var dMEd as decimal no-undo.
    
    assign
      MTTH = infoSecObj:DocQnty * infoSecObj:DocDensity
      MF = p-tank-weight-rvs
      dF = 0.65
      NPE = infoSectionTotal:NormalWastage
      dmd = MF * dF * 0.01
      dMP = MF - MTTH
      dMEd = MTTH * NPE * 0.001.
      ME = MTTH - MF - dmd.
    .
    
    if MTTH > MF
    and abs(dMP) > dmd + dMed
    then do:
      ME = dMEd.
    end.
    if ME < 0 then ME = 0 .
    
    infoSecObj:NaturalLoss = ME.
    
  end . /* _trpomi */
  
end procedure .