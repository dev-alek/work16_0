/*

$Revision: $
$Author: $
$Date: $
$Workfile: $
$Archive: $

Сводный отчёт по поставкам НП

Автор: Рукавишников Вадим
Дата создания: 24/05/21
Author: Rukavishnikov Vadim
Creation date: 24/05/21

*/

using ibs.th.str.*.

define input parameter iCntxtHostCodeObj as integer   no-undo.
define input parameter iGdsCodeList      as character no-undo.
define input parameter iSuppsList        as character no-undo.
define input parameter iTranTimeMax      as integer   no-undo.
define input parameter iDelta-tank-ac    as logical   no-undo.
define input parameter iDelta-tank-fact  as logical   no-undo.
define input parameter i-Itog            as logical   no-undo.

define variable vss-revision    as character     no-undo init "$ $":U .
define variable vss-author      as character     no-undo init "$ $":U .
define variable vss-date        as character     no-undo init "$ $":U .
define variable vss-workfile    as character     no-undo init "$ $":U .
define variable vss-archive     as character     no-undo init "$ $":U .
define variable vss-description as character     no-undo init "Сводный отчёт по поставкам НП".
define variable parparentproc   as widget-handle no-undo.
define variable mParamStr       as character     no-undo extent 10.
define variable mProdBcStrList  as character     no-undo.
define variable mSuppStrList    as character     no-undo.
define variable mPrim           as character     no-undo extent 10.

{cmp/str-glbl.i}
{cmp/vssrevis.i}
{cmp/r-page1.i}
{cmp/trg-def.i}
{str/lib-trn.i}
{gbl/gbclcode.i}
{str/trdcalib.i}
{ref/gds-attr.i}
{gbl/prn-lib.i "new shared"}
{str/is-gas.i}
{str/is-sug.i}
{str/placelib.i}
{gbl/usrfulnf.i}

define temp-table tt-rep no-undo
  field col1  as character  /* АЗК/АЗС */
  field obj-type as character
  field obj-code as integer
  field col2  as character  /* Дата и номер смены */
  field shift-date as date
  field shift-num as integer
  field col3  as character  /* Внутренний номер документа приема */
  field col4  as character  /* Номер документа поставщика */
  field col5  as character  /* Дата начала приема НП  */
  field col6  as character  /* Время приемки  */
  field min-pour as integer
  field col7  as character  /* Поставщик  */
  field col8  as character  /* Перевозчик  */
  field col9  as character  /* Нефтебаза  */
  field col10 as character  /* АЦ */
  field col11 as character  /* Тип АЦ */
  field col12 as character  /* Приёмщик */
  field col13 as character  /* № секции */
  field col14 as character  /* Марка НП */
  field gds-code as integer
  field col15 as character  /* № резервуара  */
  field col16 as character  /* Способ разблокировки API-адаптера */
  field col17 as character  /* Номер ключа/код доступа */
  /* Параметры топлива по ТТН */
  field col18 as decimal    /* Объем, л */
  field col18str as character
  field col19 as decimal    /* Масса, кг */
  field col19str as character
  field col20 as decimal    /* Плотн., г/см3 */
  field col20str as character
  field col21 as decimal    /* Темп., °С */
  field col21str as character
  /* Параметры топлива по измерениям в АЦ  */
  field col22 as decimal    /* Объем, л */
  field col22str as character
  field col23 as decimal    /* Масса, кг */
  field col23str as character
  field col24 as decimal    /* Масса ЕУ, кг */
  field col24str as character
  field col25 as decimal    /* Плотн., г/см3 */
  field col25str as character
  field col26 as decimal    /* Темп., °С */
  field col26str as character
  /* Параметры топлива по измерениям в резервуаре до слива */
  field col27 as decimal    /* Объем, л */
  field col28 as decimal    /* Масса, кг */
  field col29 as decimal    /* Плотн., г/см3 */
  field col30 as decimal    /* Темп., °С */
  /* Параметры топлива по измерениям в резервуаре после слива */
  field col31 as decimal    /* Объем, л */
  field col32 as decimal    /* Масса, кг */
  field col33 as decimal    /* Плотн., г/см3 */
  field col34 as decimal    /* Темп., °С */
  /* Принято к учету */
  field col35 as decimal    /* Объем, л */
  field col36 as decimal    /* Масса, кг */
  /* Отклонение АЦ к ТТН */
  field col37 as decimal decimals 1    /* Масса, кг (1.22 - 1.18) */
  field col38 as decimal decimals 2    /* % (1.36/1.18*100) */
  /* Отклонение резервуара к АЦ */
  field col39 as decimal decimals 1    /* Масса, кг (1.31- 1.27 - 1.22) */
  field col40 as decimal decimals 2    /* % (1.38/1.22*100) */
  /* Отклонение между резервуаром и  принятым к учету топливом */
  field col41 as decimal decimals 1    /* Масса, кг (1.31 - 1.27 - 1.35) */
  field col42 as decimal decimals 2    /* % (1.40/1.35*100) */
  
  field col43 as decimal decimals 1    /* Сверхнормативные расхождения между резервуаром и АЦ, кг  */
  field col44 as decimal decimals 1    /* Сверхнормативные расхождения между резервуаром и принятым к учету топливом, кг */
  
  field delta-mass-qnty-ac as decimal
  field delta-mass-qnty-before as decimal
  field delta-mass-qnty-after as decimal
  
  field no-itog         as logical
  
  index pi as primary
    obj-code
    shift-date shift-num
    gds-code
    col3
    col15
.

define temp-table tt-itog no-undo
  field col1  as character  /* АЗК/АЗС */
  field obj-type as character
  field obj-code as integer
  /* Параметры топлива по ТТН */
  field col18 as decimal    /* Объем, л */
  field col19 as decimal    /* Масса, кг */
  /* Параметры топлива по измерениям в АЦ  */
  field col22 as decimal    /* Объем, л */
  field col23 as decimal    /* Масса, кг */
  field col24 as decimal    /* Масса ЕУ, кг */
  /* Параметры топлива по измерениям в резервуаре до слива */
  field col27 as decimal    /* Объем, л */
  field col28 as decimal    /* Масса, кг */
  /* Параметры топлива по измерениям в резервуаре после слива */
  field col31 as decimal    /* Объем, л */
  field col32 as decimal    /* Масса, кг */
  /* Принято к учету */
  field col35 as decimal    /* Объем, л */
  field col36 as decimal    /* Масса, кг */
  /* Отклонение АЦ к ТТН */
  field col37 as decimal    /* Масса, кг (1.21 - 1.17) */
  field col38 as decimal    /* % (1.37/1.17*100) */
  field col38red as logical
  /* Отклонение резервуара к АЦ */
  field col39 as decimal    /* Масса, кг (1.30- 1.26 - 1.21) */
  field col40 as decimal    /* % (1.41/1.21*100) */
  field col40red as logical
  /* Отклонение между резервуаром и  принятым к учету топливом */
  field col41 as decimal    /* Масса, кг (1.30 - 1.26 - 1.34) */
  field col42 as decimal    /* % (1.43/1.34*100) */
  field col42red as logical
  
  field col43 as decimal    /* Сверхнормативные расхождения между резервуаром и АЦ, кг  */
  field col44 as decimal    /* Сверхнормативные расхождения между резервуаром и принятым к учету топливом, кг */
  index pi as primary
    obj-code
.

define temp-table tt-all-itog no-undo
  field col1  as character  /* АЗК/АЗС */
  field obj-type as character
  field obj-code as integer
  /* Параметры топлива по ТТН */
  field col18 as decimal    /* Объем, л */
  field col19 as decimal    /* Масса, кг */
  /* Параметры топлива по измерениям в АЦ  */
  field col22 as decimal    /* Объем, л */
  field col23 as decimal    /* Масса, кг */
  field col24 as decimal    /* Масса ЕУ, кг */
  /* Параметры топлива по измерениям в резервуаре до слива */
  field col27 as decimal    /* Объем, л */
  field col28 as decimal    /* Масса, кг */
  /* Параметры топлива по измерениям в резервуаре после слива */
  field col31 as decimal    /* Объем, л */
  field col32 as decimal    /* Масса, кг */
  /* Принято к учету */
  field col35 as decimal    /* Объем, л */
  field col36 as decimal    /* Масса, кг */
  /* Отклонение АЦ к ТТН */
  field col37 as decimal    /* Масса, кг (1.21 - 1.17) */
  field col38 as decimal    /* % (1.37/1.17*100) */
  field col38red as logical
  /* Отклонение резервуара к АЦ */
  field col39 as decimal    /* Масса, кг (1.30- 1.26 - 1.21) */
  field col40 as decimal    /* % (1.41/1.21*100) */
  field col40red as logical
  /* Отклонение между резервуаром и  принятым к учету топливом */
  field col41 as decimal    /* Масса, кг (1.30 - 1.26 - 1.34) */
  field col42 as decimal    /* % (1.43/1.34*100) */
  field col42red as logical
  
  field col43 as decimal    /* Сверхнормативные расхождения между резервуаром и АЦ, кг  */
  field col44 as decimal    /* Сверхнормативные расхождения между резервуаром и принятым к учету топливом, кг */
  index pi as primary
    obj-code
.

define stream sOutStr-html.

function f_disp_time returns character
   (input iTime as integer):
   define variable vHour    as integer   no-undo.
   define variable vMinute  as integer   no-undo.
   define variable vSec     as integer   no-undo.
   define variable vTimeStr as character no-undo.
   
   if iTime < 0 then return "".
   
   vHour = truncate(iTime / 3600, 0).
   vMinute = truncate((iTime - vHour * 3600) / 60, 0).
   vSec = iTime - vHour * 3600 - vMinute * 60.
   vTimeStr = trim(string(vHour, ">>>99")) + ":" +
              string(vMinute, "99")  + ":" +
              string(vSec,    "99").
   return vTimeStr.
end function.

function fDate2Str returns character
   (input idate as date,
    input iformat as char):
   define variable vdatestr as character no-undo.
   if idate = ? then
      vdatestr = "".
   else
      vdatestr = trim(string(idate, iformat)).

   return vdatestr.
end function.

function fDec2Str returns character
   (input idec as decimal,
    input iformat as char):
   define variable vdecstr as character no-undo.
   if idec = ? then
      vdecstr = "".
   else
      vdecstr = trim(string(idec, iformat)).

   return vdecstr.
end function.

function fInt2Str returns character
   (input iInt as integer,
    input iformat as char):
   define variable vIntStr as character no-undo.
   if iInt = ? then
      vIntStr = "".
   else
      vIntStr = trim(string(iInt, iformat)).

   return vIntStr.
end function.

function fStrNvl returns character
   (input iStr     as character,
    input iDefault as character):
   return if iStr > "" then iStr else iDefault.
end function.

/* MAIN */
run BeforeCalc .

run initTT .

run calc-itog .

run PrintTT .

procedure BeforeCalc:
   define variable vI       as integer   no-undo.
   define variable vJ       as integer   no-undo.
   define variable vStr     as character no-undo.
   define variable vChkCode as character no-undo.   
   
   if x-tog-shift then do:
     vI = vI + 1.
     mParamStr[vI] = "По сменам: c " + string(X-shift-start) + " по " + string(X-shift-end).
   end.
   
   vI = vI + 1.
   if X-date-start = X-date-end then
     mParamStr[vI] = "За дату : " + string(X-date-start, "99.99.9999").
   else
     mParamStr[vI] = "За период c " + string(X-date-start, "99.99.9999") + " по " + string(X-date-end, "99.99.9999").
   
   vI = vI + 1.
   mParamStr[vI] = "Выбор объекта: ".
   for each obj-list:
     mParamStr[vI] = mParamStr[vI] + obj-list.obj-name + "," .
   end.
   mParamStr[vI] = trim(mParamStr[vI], ",").
   
   vI = vI + 1.
   if iGdsCodeList = "*" then do:
     mParamStr[vI] = "Вся номенклатура".
     mProdBcStrList = "*".
   end.
   else do:
     mParamStr[vI] = "Номенклатура: ".
     vStr = "".

     for each goods where
               can-do(iGdsCodeList, string(goods.gds-code))
     no-lock:
       vStr = vStr + "," + string(goods.gds-code) + "(" + goods.gds-name + ")".
       for each prod-bc where
                prod-bc.b-code = goods.gds-code
       no-lock:
         mProdBcStrList = mProdBcStrList + "," + prod-bc.b-str.
       end.
     end.
     vStr = trim(vStr, ",").
     mProdBcStrList = trim(mProdBcStrList, ",").
     mParamStr[vI] = mParamStr[vI] + vStr.
   end.
   
   vI = vI + 1.
   if iSuppsList = "*" then do:
     mParamStr[vI] = "Все поставщики".
     mSuppStrList = "*".
   end.
   else do:
     mParamStr[vI] = "Поставщики: ".
     vStr = "".

     for each clients where can-do(iSuppsList, string(clients.obj-code))
                        and clients.obj-type = "орг"
     no-lock:
       vStr = vStr + ", Орг" + string(clients.obj-code) + " " + clients.obj-name + "".
     end.
     vStr = trim(vStr, ", ").
     mParamStr[vI] = mParamStr[vI] + vStr.
   end.
   
   if iTranTimeMax > 0
   then do:
     vI = vI + 1.
     mParamStr[vI] = "Только со временем слива секции НП более " + string(iTranTimeMax) + " минут".
   end.
   
   if iDelta-tank-ac
   and iDelta-tank-fact
   then do :
     vI = vI + 1.
     mParamStr[vI] = "Только со сверхнормативным расхождением между резервуаром и АЦ, либо между резервуаром и принятым НП".
   end.
   else
   if iDelta-tank-ac
   then do :
     vI = vI + 1.
     mParamStr[vI] = "Только со сверхнормативным расхождением между резервуаром и АЦ".
   end.
   else
   if iDelta-tank-fact
   then do :
     vI = vI + 1.
     mParamStr[vI] = "Только со сверхнормативным расхождением между резервуаром и принятым НП".
   end.
   
   vI = vI + 1.
   if i-Itog
   then do :
     mParamStr[vI] = "Только итоги".
   end .
   else do :
     mParamStr[vI] = "В т.ч. итоги".
   end .
   
   vI = vI + 1.
   
   
   mPrim[1] = "Объем в ИТОГО: отображается в виде справочной информации." .
   mPrim[2] = "<u>Расчет отклонения АЦ к ТТН</u> " + fill("&nbsp;" , 11) + " <u>Расчет отклонения резервуара к АЦ</u>" .
   mPrim[3] = "Масса = (1.23-1.19)      " + fill("&nbsp;" , 28) + "Масса = (1.32-1.28-1.23)" .
   mPrim[4] = "% = (1.37/1.19*100)      " + fill("&nbsp;" , 28) + "% = (1.39/1.23*100)" .
   mPrim[5] = "<u>Расчет отклонения между резервуаром и принятым к учету топливом</u>" .
   mPrim[6] = "Масса = (1.32-1.28-1.36)" .
   mPrim[7] = "% = (1.41/1.36*100)" .
   
end procedure.

procedure initTT :
  define buffer buf_trn-doc       for ub.trn-doc .
  
  for each obj-list :
    if x-TOG-Shift
    then do :
      for each buf_trn-doc no-lock where buf_trn-doc.obj-type     = obj-list.obj-type
                                     and buf_trn-doc.obj-code     = obj-list.obj-code
                                     and buf_trn-doc.ext-doc-type = {&TDEDT_Pri_Vnesh}
                                     and buf_trn-doc.status_      = {&fact}
                                     and can-do(iSuppsList, string(buf_trn-doc.cli-code))
                                     and (buf_trn-doc.shift-date > X-date-Start or (buf_trn-doc.shift-date = X-date-Start and buf_trn-doc.shift-num >= x-Shift-Start))
                                     and (buf_trn-doc.shift-date < X-date-End or (buf_trn-doc.shift-date = X-date-End and buf_trn-doc.shift-num <= x-Shift-End))
      :
        run processTrn(input buf_trn-doc.doc-code) .
      end .
    end .
    else do :
      for each buf_trn-doc no-lock where buf_trn-doc.obj-type     = obj-list.obj-type
                                     and buf_trn-doc.obj-code     = obj-list.obj-code
                                     and buf_trn-doc.ext-doc-type = {&TDEDT_Pri_Vnesh}
                                     and buf_trn-doc.status_      = {&fact}
                                     and can-do(iSuppsList, string(buf_trn-doc.cli-code))
                                     and buf_trn-doc.fact-date >= X-date-Start
                                     and buf_trn-doc.fact-date <= X-date-End
      :
        run processTrn(input buf_trn-doc.doc-code) .
      end .
    end .
  end .
  
end procedure .

procedure processTrn :
  define input parameter p-doc-code as character no-undo .
  
  define buffer buf_tt-rep for tt-rep .
  
  define buffer buf_trn-doc       for ub.trn-doc .
  define buffer buf_goods         for ub.goods .
  define buffer buf_doc-line      for ub.doc-line .
  define buffer buf_rvs-doc       for ub.rvs-doc .
  define buffer buf_rvs-line      for ub.rvs-line .
  define buffer buf_rvs-line-attr for ub.rvs-line-attr .
  define buffer buf_clients       for ub.clients .
  define buffer buf_place         for ub.place .
  define buffer buf_doc-pl        for ub.doc-pl .
  
  define variable v-ok                  as logical   no-undo.
  define variable is-petrolium          as logical   no-undo.
  define variable is-pieces             as logical   no-undo.
  define variable v-InfoSectionsTotal   as class     InfoSectionsTotal no-undo .
  define variable iNum                  as integer   no-undo .
  define variable varvalue              as character no-undo .
  define variable vartype               as character no-undo .
  define variable is-ptrl-trn           as logical   no-undo .
  define variable is-sug-trn            as logical   no-undo .
  define variable is-com-tanks          as logical   no-undo .
  define variable v-num-com-tanks       as integer   no-undo .
  define variable v-is-sug-gds          as logical   no-undo .
  define variable v-nids                as character no-undo .
  define variable v-cli-name            as character no-undo .
  define variable v-auto-cli-name       as character no-undo .
  define variable v-nb-cli-name         as character no-undo .
  define variable v-user-name           as character no-undo .
  define variable v-car-num             as character no-undo .
  define variable v-place-num           as character no-undo .
  define variable v-hour-pour           as integer   no-undo .
  define variable v-min-pour            as integer   no-undo .
  define variable v-hour-start          as integer   no-undo .
  define variable v-min-start           as integer   no-undo .
  define variable v-hour-end            as integer   no-undo .
  define variable v-min-end             as integer   no-undo .
  define variable v-date-start          as date      no-undo .
  define variable v-date-end            as date      no-undo .
  define variable v-time-start          as integer   no-undo .
  define variable v-time-end            as integer   no-undo .
  define variable v-SectionName         as character no-undo .
  define variable v-delta-ac            as decimal   no-undo .
  define variable v-delta-fact          as decimal   no-undo .
  define variable v-delta-mass-qnty-ac  as decimal   no-undo .
/*  define variable v-pl-sum-col22        as decimal   no-undo .*/
/*  define variable v-pl-sum-col23        as decimal   no-undo .*/
/*  define variable v-pl-sum-col36        as decimal   no-undo .*/
  
  is-ptrl-trn = no .
  is-sug-trn = no .
  varvalue = "" .
  { str/tdat-val.i
    p-doc-code
    {&trdcattr-is-fuel}
    varvalue
    vartype
    no-error
  }
  if varvalue = "yes"
  then do:
    is-ptrl-trn = yes .
  end.
  if not is-ptrl-trn
  then do :
    varvalue = "" .
    { str/tdat-val.i
      p-doc-code
      {&trdcattr-is-lgas}
      varvalue
      vartype
      no-error
    }
    if varvalue = "yes"
    then do:
      is-sug-trn = yes .
      is-ptrl-trn = yes .
    end.
  end .
  if not is-ptrl-trn
  then do :
    varvalue = "" .
    { str/tdat-val.i
      p-doc-code
      {&trdcattr-is-lgas-corr}
      varvalue
      vartype
      no-error
    }
    if varvalue = "yes"
    then do:
      is-sug-trn = yes .
      is-ptrl-trn = yes .
    end.
  end .
  
  if not is-ptrl-trn
  then do :
    return .
  end .
  
  find first buf_trn-doc no-lock where buf_trn-doc.doc-code = p-doc-code .
  
  { str/tdat-val.i
    p-doc-code
    {&trdcattr-nids}
    v-nids
    vartype
    no-error
  }
  
  for first buf_clients no-lock where buf_clients.obj-type = buf_trn-doc.cli-type
                                  and buf_clients.obj-code = buf_trn-doc.cli-code
  :
    v-cli-name = buf_clients.obj-name .
  end .
  
  v-user-name = usrfulnf(buf_trn-doc.creid) .
  
  varvalue = "" .
  { str/tdat-val.i
    p-doc-code
    {&trdcattr-autoent}
    varvalue
    vartype
    no-error
  }
  if varvalue > ""
  and num-entries(varvalue, ";") >= 2
  then do :
    for first buf_clients no-lock where buf_clients.obj-type = entry (1, varvalue, ";")
                                    and buf_clients.obj-code = integer (entry (2, varvalue, ";"))
    :
      v-auto-cli-name = buf_clients.obj-name .
    end .
  end .
  
  varvalue = "" .
  { str/tdat-val.i
    p-doc-code
    {&trdcattr-ptbobj}
    varvalue
    vartype
    no-error
  }
  if varvalue > ""
  and num-entries(varvalue, ";") >= 2
  then do :
    for first buf_clients no-lock where buf_clients.obj-type = entry (1, varvalue, ";")
                                    and buf_clients.obj-code = integer (entry (2, varvalue, ";"))
    :
      v-nb-cli-name = buf_clients.obj-name .
    end .
  end .
  
  { str/tdat-val.i
    p-doc-code
    {&trdcattr-car-num}
    v-car-num
    vartype
    no-error
  }
  
  if is-sug-trn
  then do :
    varvalue = "" .
    { str/tdat-val.i
      p-doc-code
      {&trdcattr-time-start}
      varvalue
      vartype
      no-error
    }
    if varvalue > ""
    then do :
      assign
        v-hour-start = integer (entry (1, varvalue, ":"))
        v-min-start  = integer (entry (2, varvalue, ":"))
      no-error .
    end .
    
    varvalue = "" .
    { str/tdat-val.i
      p-doc-code
      {&trdcattr-time-end}
      varvalue
      vartype
      no-error
    }
    if varvalue > ""
    then do :
      assign
        v-hour-end = integer (entry (1, varvalue, ":"))
        v-min-end  = integer (entry (2, varvalue, ":"))
      no-error .
    end .
    
    varvalue = "" .
    { str/tdat-val.i
      p-doc-code
      {&trdcattr-date-start}
      varvalue
      vartype
      no-error
    }
    if varvalue > ""
    then do :
      v-date-start = date(varvalue) no-error .
    end .
    
    varvalue = "" .
    { str/tdat-val.i
      p-doc-code
      {&trdcattr-date-end}
      varvalue
      vartype
      no-error
    }
    if varvalue > ""
    then do :
      v-date-end = date(varvalue) no-error .
    end .
    
    v-hour-pour = v-hour-end - v-hour-start .
    v-min-pour = v-min-end - v-min-start .
    if v-min-pour < 0
    then do :
      v-hour-pour = v-hour-pour - 1 .
      v-min-pour = v-min-pour + 60 .
    end .
    v-hour-pour = v-hour-pour + (24 * (v-date-end - v-date-start)) .
    
  end .
  
  doc-line_ :
  for each buf_doc-line no-lock where buf_doc-line.doc-code = p-doc-code,
     first buf_goods no-lock where buf_goods.artic      = buf_doc-line.artic
                               and buf_goods.prod-type  = buf_doc-line.prod-type
                               and buf_goods.prod-code  = buf_doc-line.prod-code
                               and can-do(iGdsCodeList, string(buf_goods.gds-code))
  :
    { str/is-petrl.i
    buf_doc-line.artic
    buf_doc-line.prod-type
    buf_doc-line.prod-code
    is-petrolium
    is-pieces
    no-error
    }
    if not is-petrolium
    then do :
      next doc-line_ .
    end .
    
    if is-gas(buf_goods.gds-code)
    then do :
      next doc-line_ .
    end .
    
    v-is-sug-gds = no .
    is-com-tanks = no .
    if is-sug(buf_goods.gds-code)
    then do :
      v-is-sug-gds = yes .
    end .
    
    v-InfoSectionsTotal = new InfoSectionsTotal(p-doc-code, buf_goods.gds-code, "").
    
    do iNum = 1 to v-InfoSectionsTotal:SectionNum :
      
      v-SectionName = if v-is-sug-gds then "1" else v-InfoSectionsTotal:GetInfoSectionProp(iNum):SectionName .
      
      if v-is-sug-gds
      then do :
        for first buf_doc-pl no-lock where buf_doc-pl.obj-type = buf_doc-line.obj-type
                                       and buf_doc-pl.obj-code = buf_doc-line.obj-code
                                       and buf_doc-pl.out-code = buf_doc-line.doc-code
                                       and buf_doc-pl.gds-code = buf_goods.gds-code,
            first buf_place no-lock where buf_place.pl-code = buf_doc-pl.pl-code
        :
          run placelib_get-attr  ( input {&place-twice-code}
            ,input buf_place.obj-code
            ,input buf_place.obj-type
            ,input buf_place.pl-code
            ,output varvalue
            ,output v-ok      ) no-error.
          if varvalue <> "" then  v-place-num  = buf_place.loc1 + "," + varvalue .
          else v-place-num  = buf_place.loc1 .
          
          run placelib_get-attr  ( input {&place-com-tanks}
            ,input buf_place.obj-code
            ,input buf_place.obj-type
            ,input buf_place.pl-code
            ,output varvalue
            ,output v-ok      ) no-error.
          if v-ok
          and varvalue > ""
          then do :
            is-com-tanks = yes .
            v-num-com-tanks = 1 + num-entries(varvalue) .
            v-place-num = v-place-num + "," + varvalue .
          end .
        end .                           
      end .
      else do :
        v-place-num = v-InfoSectionsTotal:GetInfoSectionProp(iNum):ListTank .
        
        v-date-start  = v-InfoSectionsTotal:GetInfoSectionProp(iNum):DateStart .
        v-date-end    = v-InfoSectionsTotal:GetInfoSectionProp(iNum):DateEnd .
        
        v-hour-start  = integer( truncate( v-InfoSectionsTotal:GetInfoSectionProp(iNum):TimeStart / 3600 , 0 ) ) .
        v-min-start  = integer( ( v-InfoSectionsTotal:GetInfoSectionProp(iNum):TimeStart - v-hour-start * 3600 ) / 60 ).
        
        v-hour-end   = integer( truncate( v-InfoSectionsTotal:GetInfoSectionProp(iNum):TimeEnd / 3600 , 0 ) ).
        v-min-end    = integer( ( v-InfoSectionsTotal:GetInfoSectionProp(iNum):TimeEnd - v-hour-end * 3600 ) / 60).
        
        v-hour-pour = v-hour-end - v-hour-start .
        v-min-pour = v-min-end - v-min-start .
        if v-min-pour < 0
        then do :
          v-hour-pour = v-hour-pour - 1 .
          v-min-pour = v-min-pour + 60 .
        end .
        v-hour-pour = v-hour-pour + (24 * (v-date-end - v-date-start)) .
        
      end .
      
      find first tt-rep where tt-rep.obj-type   = obj-list.obj-type
                          and tt-rep.obj-code   = obj-list.obj-code
                          and tt-rep.gds-code   = buf_goods.gds-code 
                          and tt-rep.col3       = buf_trn-doc.doc-code
                          and tt-rep.col15      = v-place-num
                          no-error .
      if not available tt-rep
      then do : 
        create tt-rep .
        assign
          tt-rep.obj-type   = obj-list.obj-type
          tt-rep.obj-code   = obj-list.obj-code
          tt-rep.gds-code   = buf_goods.gds-code
          tt-rep.shift-date = buf_trn-doc.shift-date
          tt-rep.shift-num  = buf_trn-doc.shift-num
          tt-rep.min-pour   = (v-hour-pour * 60) + v-min-pour
          tt-rep.col1       = obj-list.obj-name
          tt-rep.col2       = string(tt-rep.shift-num) + " от " + string(tt-rep.shift-date)
          tt-rep.col3       = buf_trn-doc.doc-code
          tt-rep.col4       = v-nids
          tt-rep.col5       = string(buf_trn-doc.doc-date)
          tt-rep.col6       = string(v-hour-pour, "99") + ":" + string(v-min-pour, "99") + ":00"
          tt-rep.col7       = v-cli-name
          tt-rep.col8       = v-auto-cli-name
          tt-rep.col9       = v-nb-cli-name
          tt-rep.col10      = v-car-num
          tt-rep.col11      = "Без СЭП"
          tt-rep.col12      = v-user-name
          tt-rep.col13      = v-SectionName
          tt-rep.col14      = buf_goods.gds-name
          tt-rep.col15      = v-place-num 
          tt-rep.col16      = ""
          tt-rep.col17      = ""
        .
        
        if v-is-sug-gds
        then do :
          assign
            tt-rep.col18  = buf_doc-line.doc-qnty
            tt-rep.col19  = buf_doc-line.cli-qnty
            tt-rep.col20  = buf_doc-line.doc-density
            tt-rep.col21  = buf_doc-line.temperature
          .
          assign
            tt-rep.col22  = ?
            tt-rep.col23  = ?
            tt-rep.col24  = ?
            tt-rep.col25  = ?
            tt-rep.col26  = ?
          .
        end .
        else do :
          assign
            tt-rep.col18  = if v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocVolume > 0 then v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocVolume else v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocQnty
            tt-rep.col19  = v-InfoSectionsTotal:GetInfoSectionProp(iNum):CliQnty
            tt-rep.col20  = v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocDensity
            tt-rep.col21  = v-InfoSectionsTotal:GetInfoSectionProp(iNum):TTNTemp
          .
          assign
            tt-rep.col22  = v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankVol
            tt-rep.col23  = v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankWeight
            tt-rep.col24  = v-InfoSectionsTotal:GetInfoSectionProp(iNum):NaturalLoss
            tt-rep.col25  = if v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankDensityPomi > 0 then v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankDensityPomi else v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankDensity
            tt-rep.col26  = v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankTemp
          .
        end .
        
        assign
          tt-rep.col18str =  fDec2Str(tt-rep.col18, "->>>>>>>>>>>9"  )
          tt-rep.col19str =  fDec2Str(tt-rep.col19, "->>>>>>>>>>>9.9")
          tt-rep.col20str =  fDec2Str(tt-rep.col20, "->>>>>>>>9.9999")
          tt-rep.col21str =  fDec2Str(tt-rep.col21, "->>>>>>>>>>>9.9")
                             
          tt-rep.col22str =  fDec2Str(tt-rep.col22, "->>>>>>>>>>>9"  )
          tt-rep.col23str =  fDec2Str(tt-rep.col23, "->>>>>>>>>>>9.9")
          tt-rep.col24str =  fDec2Str(tt-rep.col24, "->>>>>>>>>>9.99")
          tt-rep.col25str =  fDec2Str(tt-rep.col25, "->>>>>>>>9.9999")
          tt-rep.col26str =  fDec2Str(tt-rep.col26, "->>>>>>>>>>>9.9")
        .
        
        assign
          tt-rep.delta-mass-qnty-before = 0.65
          tt-rep.delta-mass-qnty-after = 0.65
          tt-rep.delta-mass-qnty-ac = 0.65
        .
        
        v-delta-mass-qnty-ac = v-InfoSectionsTotal:GetInfoSectionProp(iNum):AccPomi .
        if v-delta-mass-qnty-ac = 0 
        or v-delta-mass-qnty-ac = ?
        then do :
          v-delta-mass-qnty-ac = v-InfoSectionsTotal:PercAcc .
        end .
        if v-delta-mass-qnty-ac = 0 
        or v-delta-mass-qnty-ac = ?
        then do :
          v-delta-mass-qnty-ac = 0.65 .
        end .
        
        if v-delta-mass-qnty-ac > 0.65 then v-delta-mass-qnty-ac = 0.65 .
        
        assign
          tt-rep.delta-mass-qnty-ac = v-delta-mass-qnty-ac
        .
        
        find first buf_place no-lock where buf_place.obj-type = buf_doc-line.obj-type
                                       and buf_place.obj-code = buf_doc-line.obj-code
                                       and buf_place.loc1     = tt-rep.col15
                                       no-error .
        if available buf_place
        then do :
          for first buf_rvs-doc no-lock where buf_rvs-doc.rvs-type = {&rvs-before-doc}
                                          and buf_rvs-doc.out-code = buf_doc-line.doc-code,
              first buf_rvs-line no-lock where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
                                           and buf_rvs-line.gds-code = buf_goods.gds-code
                                           and buf_rvs-line.pl-code  = buf_place.pl-code
          :
            assign
              tt-rep.col27  = buf_rvs-line.state-measure-qnty
              tt-rep.col28  = buf_rvs-line.state-measure-cli-qnty
              tt-rep.col29  = buf_rvs-line.state-density
              tt-rep.col30  = buf_rvs-line.state-temperature
            .
            for first buf_rvs-line-attr no-lock where buf_rvs-line-attr.obj-type = buf_rvs-line.obj-type
                                                  and buf_rvs-line-attr.obj-code = buf_rvs-line.obj-code
                                                  and buf_rvs-line-attr.rvs-code = buf_rvs-line.rvs-code
                                                  and buf_rvs-line-attr.pl-code  = buf_rvs-line.pl-code
                                                  and buf_rvs-line-attr.gds-code = buf_rvs-line.gds-code
                                                  and buf_rvs-line-attr.attr-code = "temp-izm-vol"
            :
              tt-rep.col30 = decimal(buf_rvs-line-attr.attr-value) .
            end .
            for first buf_rvs-line-attr no-lock where buf_rvs-line-attr.obj-type = buf_rvs-line.obj-type
                                                  and buf_rvs-line-attr.obj-code = buf_rvs-line.obj-code
                                                  and buf_rvs-line-attr.rvs-code = buf_rvs-line.rvs-code
                                                  and buf_rvs-line-attr.pl-code  = buf_rvs-line.pl-code
                                                  and buf_rvs-line-attr.gds-code = buf_rvs-line.gds-code
                                                  and buf_rvs-line-attr.attr-code = "delta-mass-qnty"
            :
              tt-rep.delta-mass-qnty-before = decimal(buf_rvs-line-attr.attr-value) .
            end .
          end .
          for first buf_rvs-doc no-lock where buf_rvs-doc.rvs-type = {&rvs-after-doc}
                                          and buf_rvs-doc.out-code = buf_doc-line.doc-code,
              first buf_rvs-line no-lock where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
                                           and buf_rvs-line.gds-code = buf_goods.gds-code
                                           and buf_rvs-line.pl-code  = buf_place.pl-code
          :
            assign
              tt-rep.col31  = buf_rvs-line.state-measure-qnty
              tt-rep.col32  = buf_rvs-line.state-measure-cli-qnty
              tt-rep.col33  = buf_rvs-line.state-density
              tt-rep.col34  = buf_rvs-line.state-temperature
            .
            for first buf_rvs-line-attr no-lock where buf_rvs-line-attr.obj-type = buf_rvs-line.obj-type
                                                  and buf_rvs-line-attr.obj-code = buf_rvs-line.obj-code
                                                  and buf_rvs-line-attr.rvs-code = buf_rvs-line.rvs-code
                                                  and buf_rvs-line-attr.pl-code  = buf_rvs-line.pl-code
                                                  and buf_rvs-line-attr.gds-code = buf_rvs-line.gds-code
                                                  and buf_rvs-line-attr.attr-code = "temp-izm-vol"
            :
              tt-rep.col34 = decimal(buf_rvs-line-attr.attr-value) .
            end .
            for first buf_rvs-line-attr no-lock where buf_rvs-line-attr.obj-type = buf_rvs-line.obj-type
                                                  and buf_rvs-line-attr.obj-code = buf_rvs-line.obj-code
                                                  and buf_rvs-line-attr.rvs-code = buf_rvs-line.rvs-code
                                                  and buf_rvs-line-attr.pl-code  = buf_rvs-line.pl-code
                                                  and buf_rvs-line-attr.gds-code = buf_rvs-line.gds-code
                                                  and buf_rvs-line-attr.attr-code = "delta-mass-qnty"
            :
              tt-rep.delta-mass-qnty-after = decimal(buf_rvs-line-attr.attr-value) .
            end .
          end .
        end .
        
        if is-com-tanks
        and not available buf_place
        then do :
          for first buf_rvs-doc no-lock where buf_rvs-doc.rvs-type = {&rvs-before-doc}
                                          and buf_rvs-doc.out-code = buf_doc-line.doc-code,
               each buf_rvs-line no-lock where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
                                           and buf_rvs-line.gds-code = buf_goods.gds-code
          :
            assign
              tt-rep.col27  = tt-rep.col27 + buf_rvs-line.state-measure-qnty
              tt-rep.col28  = tt-rep.col28 + buf_rvs-line.state-measure-cli-qnty
              tt-rep.col30  = tt-rep.col30 + buf_rvs-line.state-temperature
            .
          end .
          assign
            tt-rep.col29 = tt-rep.col28 / tt-rep.col27
            tt-rep.col30 = tt-rep.col30 / v-num-com-tanks
          .
          for first buf_rvs-doc no-lock where buf_rvs-doc.rvs-type = {&rvs-after-doc}
                                          and buf_rvs-doc.out-code = buf_doc-line.doc-code,
               each buf_rvs-line no-lock where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
                                           and buf_rvs-line.gds-code = buf_goods.gds-code
          :
            assign
              tt-rep.col31  = tt-rep.col31 + buf_rvs-line.state-measure-qnty
              tt-rep.col32  = tt-rep.col32 + buf_rvs-line.state-measure-cli-qnty
              tt-rep.col34  = tt-rep.col34 + buf_rvs-line.state-temperature
            .
          end .
          assign
            tt-rep.col33 = tt-rep.col32 / tt-rep.col31
            tt-rep.col34 = tt-rep.col34 / v-num-com-tanks
          .
        end .
        
        assign
          tt-rep.col35  = v-InfoSectionsTotal:GetInfoSectionProp(iNum):FactQnty
          tt-rep.col36  = v-InfoSectionsTotal:GetInfoSectionProp(iNum):FactKgQnty
        .
        
        assign
          tt-rep.col37  = tt-rep.col23 - tt-rep.col19
          tt-rep.col38  = tt-rep.col37 / tt-rep.col19 * 100
        .
        
        assign
          tt-rep.col39  = tt-rep.col32 - tt-rep.col28 - tt-rep.col23
          tt-rep.col40  = tt-rep.col39 / tt-rep.col23 * 100
        .
        
        assign
          tt-rep.col41  = tt-rep.col32 - tt-rep.col28 - tt-rep.col36
          tt-rep.col42  = tt-rep.col41 / tt-rep.col36 * 100
        .
        
        v-delta-ac = sqrt(exp((tt-rep.col32 * tt-rep.delta-mass-qnty-after), 2) + exp((tt-rep.col28 * tt-rep.delta-mass-qnty-before), 2) + exp((tt-rep.col23 * tt-rep.delta-mass-qnty-ac), 2)) / 100 .
        v-delta-fact = sqrt(exp((tt-rep.col32 * tt-rep.delta-mass-qnty-after), 2) + exp((tt-rep.col28 * tt-rep.delta-mass-qnty-before), 2)) / 100 .
        
        if v-delta-ac > abs(tt-rep.col39)
        then do :
          tt-rep.col43 = 0 .
        end .
        else do :
          tt-rep.col43 = abs(tt-rep.col39) - v-delta-ac .
        end .
        
        if v-is-sug-gds
        then do :
          tt-rep.col43 = 0 .
        end .
        
        if v-delta-fact > abs(tt-rep.col41)
        then do :
          tt-rep.col44 = 0 .
        end .
        else do :
          tt-rep.col44 = abs(tt-rep.col41) - v-delta-fact .
        end .
      end . /* if not available tt-rep */
      else do :
        assign
          tt-rep.col13 = tt-rep.col13 + "," + v-SectionName
        .
        
        v-delta-mass-qnty-ac = v-InfoSectionsTotal:GetInfoSectionProp(iNum):AccPomi .
        if v-delta-mass-qnty-ac = 0 
        or v-delta-mass-qnty-ac = ?
        then do :
          v-delta-mass-qnty-ac = v-InfoSectionsTotal:PercAcc .
        end .
        if v-delta-mass-qnty-ac = 0 
        or v-delta-mass-qnty-ac = ?
        then do :
          v-delta-mass-qnty-ac = 0.65 .
        end .
        
        if v-delta-mass-qnty-ac > 0.65 then v-delta-mass-qnty-ac = 0.65 .
        
        assign
          tt-rep.delta-mass-qnty-ac = tt-rep.delta-mass-qnty-ac + v-delta-mass-qnty-ac
        .
        
        assign
          tt-rep.col18  = tt-rep.col18 + if v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocVolume > 0 then v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocVolume else v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocQnty
          tt-rep.col19  = tt-rep.col19 + v-InfoSectionsTotal:GetInfoSectionProp(iNum):CliQnty
          tt-rep.col20  = tt-rep.col20 + v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocDensity
          tt-rep.col21  = tt-rep.col21 + v-InfoSectionsTotal:GetInfoSectionProp(iNum):TTNTemp
        .
        assign
          tt-rep.col22  = tt-rep.col22 + v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankVol
          tt-rep.col23  = tt-rep.col23 + v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankWeight
          tt-rep.col24  = tt-rep.col24 + v-InfoSectionsTotal:GetInfoSectionProp(iNum):NaturalLoss
          tt-rep.col25  = tt-rep.col25 + (if v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankDensityPomi > 0 then v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankDensityPomi else v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankDensity)
          tt-rep.col26  = tt-rep.col26 + v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankTemp
        .
        
        assign
          tt-rep.col18str = tt-rep.col18str + "<br>" + {&new-line} + fDec2Str((if v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocVolume > 0 then v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocVolume else v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocQnty), "->>>>>>>>>>>9"  )
          tt-rep.col19str = tt-rep.col19str + "<br>" + {&new-line} + fDec2Str(v-InfoSectionsTotal:GetInfoSectionProp(iNum):CliQnty, "->>>>>>>>>>>9.9")
          tt-rep.col20str = tt-rep.col20str + "<br>" + {&new-line} + fDec2Str(v-InfoSectionsTotal:GetInfoSectionProp(iNum):DocDensity, "->>>>>>>>9.9999")
          tt-rep.col21str = tt-rep.col21str + "<br>" + {&new-line} + fDec2Str(v-InfoSectionsTotal:GetInfoSectionProp(iNum):TTNTemp, "->>>>>>>>>>>9.9")
                                             
          tt-rep.col22str = tt-rep.col22str + "<br>" + {&new-line} + fDec2Str(v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankVol, "->>>>>>>>>>>9"  )
          tt-rep.col23str = tt-rep.col23str + "<br>" + {&new-line} + fDec2Str(v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankWeight, "->>>>>>>>>>>9.9")
          tt-rep.col24str = tt-rep.col24str + "<br>" + {&new-line} + fDec2Str(v-InfoSectionsTotal:GetInfoSectionProp(iNum):NaturalLoss, "->>>>>>>>>>9.99")
          tt-rep.col25str = tt-rep.col25str + "<br>" + {&new-line} + fDec2Str((if v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankDensityPomi > 0 then v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankDensityPomi else v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankDensity), "->>>>>>>>9.9999")
          tt-rep.col26str = tt-rep.col26str + "<br>" + {&new-line} + fDec2Str(v-InfoSectionsTotal:GetInfoSectionProp(iNum):TankTemp, "->>>>>>>>>>>9.9")
        .
        
        assign
          tt-rep.col35  = tt-rep.col35 + v-InfoSectionsTotal:GetInfoSectionProp(iNum):FactQnty
          tt-rep.col36  = tt-rep.col36 + v-InfoSectionsTotal:GetInfoSectionProp(iNum):FactKgQnty
        .
        
        assign
          tt-rep.col37  = tt-rep.col23 - tt-rep.col19
          tt-rep.col38  = tt-rep.col37 / tt-rep.col19 * 100
        .
        
        assign
          tt-rep.col39  = tt-rep.col32 - tt-rep.col28 - tt-rep.col23
          tt-rep.col40  = tt-rep.col39 / tt-rep.col23 * 100
        .
        
        assign
          tt-rep.col41  = tt-rep.col32 - tt-rep.col28 - tt-rep.col36
          tt-rep.col42  = tt-rep.col41 / tt-rep.col36 * 100
        .
        
      end .
      
    end .
    
    delete object v-InfoSectionsTotal no-error .
    
    for each tt-rep where tt-rep.obj-type   = obj-list.obj-type
                      and tt-rep.obj-code   = obj-list.obj-code
                      and tt-rep.gds-code   = buf_goods.gds-code 
                      and tt-rep.col3       = buf_trn-doc.doc-code
                      and num-entries(tt-rep.col13) > 1
    :
      assign
        tt-rep.col20  = tt-rep.col20 / num-entries(tt-rep.col13)
        tt-rep.col21  = tt-rep.col21 / num-entries(tt-rep.col13)
        
        tt-rep.col25  = tt-rep.col25 / num-entries(tt-rep.col13)
        tt-rep.col26  = tt-rep.col26 / num-entries(tt-rep.col13)
      .
      
      assign
        tt-rep.delta-mass-qnty-ac = tt-rep.delta-mass-qnty-ac / num-entries(tt-rep.col13)
      .
      
      v-delta-ac = sqrt(exp((tt-rep.col32 * tt-rep.delta-mass-qnty-after), 2) + exp((tt-rep.col28 * tt-rep.delta-mass-qnty-before), 2) + exp((tt-rep.col23 * tt-rep.delta-mass-qnty-ac), 2)) / 100 .
      v-delta-fact = sqrt(exp((tt-rep.col32 * tt-rep.delta-mass-qnty-after), 2) + exp((tt-rep.col28 * tt-rep.delta-mass-qnty-before), 2)) / 100 .
      
      if v-delta-ac > abs(tt-rep.col39)
      then do :
        tt-rep.col43 = 0 .
      end .
      else do :
        tt-rep.col43 = abs(tt-rep.col39) - v-delta-ac .
      end .
      
      if v-is-sug-gds
      then do :
        tt-rep.col43 = 0 .
      end .
      
      if v-delta-fact > abs(tt-rep.col41)
      then do :
        tt-rep.col44 = 0 .
      end .
      else do :
        tt-rep.col44 = abs(tt-rep.col41) - v-delta-fact .
      end .
    end .
    
  end .
        
end procedure .

procedure calc-itog :
  
  for each tt-rep :
    tt-rep.no-itog = no .
    if iDelta-tank-ac
    and iDelta-tank-fact
    then do :
      if tt-rep.col43 = 0
      and tt-rep.col44 = 0
      then tt-rep.no-itog = yes .
    end .
    else
    if iDelta-tank-ac
    then do :
      if tt-rep.col43 = 0 then tt-rep.no-itog = yes .
    end .
    else
    if iDelta-tank-fact
    then do :
      if tt-rep.col44 = 0 then tt-rep.no-itog = yes .
    end .
    
    if iTranTimeMax > 0
    then do :
      if tt-rep.min-pour <= iTranTimeMax then tt-rep.no-itog = yes .
    end .
  end .
  
  for each tt-rep where not tt-rep.no-itog :
    find first tt-itog where tt-itog.obj-type = tt-rep.obj-type
                         and tt-itog.obj-code = tt-rep.obj-code
                         no-error .
    if not available tt-itog
    then do :
      create tt-itog .
      assign
        tt-itog.obj-type = tt-rep.obj-type
        tt-itog.obj-code = tt-rep.obj-code
        tt-itog.col1     = tt-rep.col1
        tt-itog.col38red = no
        tt-itog.col40red = no
        tt-itog.col42red = no
      .
    end .
    assign
      tt-itog.col18 = tt-itog.col18 + tt-rep.col18
      tt-itog.col19 = tt-itog.col19 + tt-rep.col19
      tt-itog.col22 = tt-itog.col22 + (if tt-rep.col22 = ? then 0 else tt-rep.col22)
      tt-itog.col23 = tt-itog.col23 + (if tt-rep.col23 = ? then 0 else tt-rep.col23)
      tt-itog.col24 = tt-itog.col24 + (if tt-rep.col24 = ? then 0 else tt-rep.col24)
      tt-itog.col27 = tt-itog.col27 + (if tt-rep.col27 = ? then 0 else tt-rep.col27)
      tt-itog.col28 = tt-itog.col28 + (if tt-rep.col28 = ? then 0 else tt-rep.col28)
      tt-itog.col31 = tt-itog.col31 + (if tt-rep.col31 = ? then 0 else tt-rep.col31)
      tt-itog.col32 = tt-itog.col32 + (if tt-rep.col32 = ? then 0 else tt-rep.col32)
      tt-itog.col35 = tt-itog.col35 + tt-rep.col35
      tt-itog.col36 = tt-itog.col36 + tt-rep.col36
      tt-itog.col37 = tt-itog.col37 + (if tt-rep.col37 = ? then 0 else tt-rep.col37)
      tt-itog.col38 = tt-itog.col37 / tt-itog.col19 * 100
      tt-itog.col39 = tt-itog.col39 + (if tt-rep.col39 = ? then 0 else tt-rep.col39)
      tt-itog.col40 = tt-itog.col39 / tt-itog.col23 * 100
      tt-itog.col41 = tt-itog.col41 + (if tt-rep.col41 = ? then 0 else tt-rep.col41)
      tt-itog.col42 = tt-itog.col41 / tt-itog.col36 * 100
      tt-itog.col43 = tt-itog.col43 + (if tt-rep.col43 = ? then 0 else tt-rep.col43)
      tt-itog.col44 = tt-itog.col44 + (if tt-rep.col44 = ? then 0 else tt-rep.col44)
    .
        
    find first tt-all-itog no-error .
    if not available tt-all-itog
    then do :
      create tt-all-itog .
      assign
        tt-all-itog.col38red = no
        tt-all-itog.col40red = no
        tt-all-itog.col42red = no
      .
    end .
    assign
      tt-all-itog.col18 = tt-all-itog.col18 + tt-rep.col18
      tt-all-itog.col19 = tt-all-itog.col19 + tt-rep.col19
      tt-all-itog.col22 = tt-all-itog.col22 + (if tt-rep.col22 = ? then 0 else tt-rep.col22)
      tt-all-itog.col23 = tt-all-itog.col23 + (if tt-rep.col23 = ? then 0 else tt-rep.col23)
      tt-all-itog.col24 = tt-all-itog.col24 + (if tt-rep.col24 = ? then 0 else tt-rep.col24)
      tt-all-itog.col27 = tt-all-itog.col27 + (if tt-rep.col27 = ? then 0 else tt-rep.col27)
      tt-all-itog.col28 = tt-all-itog.col28 + (if tt-rep.col28 = ? then 0 else tt-rep.col28)
      tt-all-itog.col31 = tt-all-itog.col31 + (if tt-rep.col31 = ? then 0 else tt-rep.col31)
      tt-all-itog.col32 = tt-all-itog.col32 + (if tt-rep.col32 = ? then 0 else tt-rep.col32)
      tt-all-itog.col35 = tt-all-itog.col35 + tt-rep.col35
      tt-all-itog.col36 = tt-all-itog.col36 + tt-rep.col36
      tt-all-itog.col37 = tt-all-itog.col37 + (if tt-rep.col37 = ? then 0 else tt-rep.col37)
      tt-all-itog.col38 = tt-all-itog.col37 / tt-all-itog.col19 * 100
      tt-all-itog.col39 = tt-all-itog.col39 + (if tt-rep.col39 = ? then 0 else tt-rep.col39)
      tt-all-itog.col40 = tt-all-itog.col39 / tt-all-itog.col23 * 100
      tt-all-itog.col41 = tt-all-itog.col41 + (if tt-rep.col41 = ? then 0 else tt-rep.col41)
      tt-all-itog.col42 = tt-all-itog.col41 / tt-all-itog.col36 * 100
      tt-all-itog.col43 = tt-all-itog.col43 + (if tt-rep.col43 = ? then 0 else tt-rep.col43)
      tt-all-itog.col44 = tt-all-itog.col44 + (if tt-rep.col44 = ? then 0 else tt-rep.col44)
    .
    
    if abs(tt-rep.col38) > tt-rep.delta-mass-qnty-ac
    then do :
      assign
        tt-itog.col38red = yes
        tt-all-itog.col38red = yes
      .
    end .
    if abs(tt-rep.col40) > 0.65
    then do :
      assign
        tt-itog.col40red = yes
        tt-all-itog.col40red = yes
      .
    end .
    if abs(tt-rep.col42) > 0.65
    then do :
      assign
        tt-itog.col42red = yes
        tt-all-itog.col42red = yes
      .
    end .
    
  end .
  
end procedure .

procedure PrintTT:
   define variable vReportId     as character no-undo.
   define variable vFileNameRep  as character no-undo.
   define variable vStr          as character no-undo.
   define variable vI            as integer   no-undo.

   do on error undo, return error return-value:
      run get-report-num(output vReportId).
      vFileNameRep = session:temp-directory + string(vReportId) + ".html".

      output stream sOutStr-html to value(vFileNameRep) convert target 'UTF-8'.
      put stream sOutStr-html unformatted
 { rep/htmlhead.i }
      .

      put stream sOutStr-html unformatted
           '<body>' skip
           '<TABLE name="1" outline_below="true" fit_to_page="true" orientation="landscape" CELLSPACING="0" BORDER="0">' skip
           '<thead>' skip
           '<TR class="set_columns">' skip
               '<TD style="width: 100px;"></TD>' skip            /*  1    */
               '<TD style="width:  60px;"></TD>' skip            /*  2    */
               '<TD style="width:  80px;"></TD>' skip            /*  3    */
               '<TD style="width:  80px;"></TD>' skip            /*  4    */
               '<TD style="width:  70px;"></TD>' skip            /*  5    */
               '<TD style="width:  70px;"></TD>' skip            /*  6    */
               '<TD style="width:  70px;"></TD>' skip            /*  7    */
               '<TD style="width:  70px;"></TD>' skip            /*  8    */
               '<TD style="width:  70px;"></TD>' skip            /*  9    */
               '<TD style="width:  70px;"></TD>' skip            /*  10   */
               '<TD style="width:  70px;"></TD>' skip            /*  11   */
               '<TD style="width:  70px;"></TD>' skip            /*  12   */
               '<TD style="width:  50px;"></TD>' skip            /*  13   */
               '<TD style="width:  70px;"></TD>' skip            /*  14   */
               '<TD style="width:  50px;"></TD>' skip            /*  15   */
               '<TD style="width:  70px;"></TD>' skip            /*  16   */
               '<TD style="width:  70px;"></TD>' skip            /*  17   */
               '<TD style="width:  79px;"></TD>' skip            /*  18   */
               '<TD style="width:  82px;"></TD>' skip            /*  19   */
               '<TD style="width:  97px;"></TD>' skip            /*  20   */
               '<TD style="width:  60px;"></TD>' skip            /*  21   */
               '<TD style="width:  70px;"></TD>' skip            /*  22   */
               '<TD style="width:  70px;"></TD>' skip            /*  23   */
               '<TD style="width:  70px;"></TD>' skip            /*  24   */
               '<TD style="width:  70px;"></TD>' skip            /*  25   */
               '<TD style="width:  60px;"></TD>' skip            /*  26   */
               '<TD style="width:  70px;"></TD>' skip            /*  27   */
               '<TD style="width:  70px;"></TD>' skip            /*  28   */
               '<TD style="width:  70px;"></TD>' skip            /*  29   */
               '<TD style="width:  70px;"></TD>' skip            /*  30   */
               '<TD style="width:  70px;"></TD>' skip            /*  31   */
               '<TD style="width:  70px;"></TD>' skip            /*  32   */
               '<TD style="width:  70px;"></TD>' skip            /*  33   */
               '<TD style="width:  70px;"></TD>' skip            /*  34   */
               '<TD style="width:  70px;"></TD>' skip            /*  35   */
               '<TD style="width:  70px;"></TD>' skip            /*  36   */
               '<TD style="width:  70px;"></TD>' skip            /*  37   */
               '<TD style="width:  90px;"></TD>' skip            /*  38   */
               '<TD style="width:  70px;"></TD>' skip            /*  39   */
               '<TD style="width:  90px;"></TD>' skip            /*  40   */
               '<TD style="width:  70px;"></TD>' skip            /*  41   */
               '<TD style="width:  90px;"></TD>' skip            /*  42   */
               '<TD style="width:  70px;"></TD>' skip            /*  43   */
               '<TD style="width:  90px;"></TD>' skip            /*  44   */
           '</TR>' skip
           '<TR>' skip
               '<TD colspan="14" STYLE="font-size: 14px;">' + 'Сводный отчёт по поставкам топлива' + '</TD>'skip
               '<TD colspan="10" STYLE="font-size: 14px; font-weight:bold; ">' + 'Примечание к отчету:' + '</TD>'skip
           '</TR>' skip
           .

      do vI = 1 to extent(mParamStr):
         if mParamStr[vI] = ""
         and mPrim[vI] = "" 
         then leave .
         put stream sOutStr-html unformatted
              '<TR>' skip
                  '<TD colspan="14" STYLE="font-size: 14px;">' + mParamStr[vI] + '</TD>' skip
                  '<TD colspan="10" STYLE="font-size: 14px; font-style: italic; ">' + mPrim[vI] + '</TD>' skip
              '</TR>' skip
            .
      end.
      
      put stream sOutStr-html unformatted
           '<TR>' skip
               '<TD colspan="14" STYLE="font-size: 14px;">Дата печати: ' + string(today, "99.99.9999") + ' ' + string(time, "HH:MM") + '</TD>' skip
           '</TR>' skip
           '</thead>' skip
         .

      put stream sOutStr-html unformatted
        '<tbody>'
        '<TR >'skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">АЗК/АЗС</TH>'                                                   skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Дата и номер смены</TH>'                                        skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Внутренний номер документа приема</TH>'                         skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Номер документа поставщика</TH>'                                skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Дата начала приема НП</TH>'                                     skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Время приемки</TH>'                                             skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Поставщик</TH>'                                                 skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Перевозчик</TH>'                                                skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Нефтебаза</TH>'                                                 skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">АЦ</TH>'                                                        skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Тип АЦ</TH>' 
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Приёмщик</TH>'                                                   skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">№ секции</TH>'                                                  skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Марка НП</TH>'                                                  skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">№ резервуара</TH>'                                              skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Способ разблокировки API-адаптера</TH>'                         skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Номер ключа/код доступа</TH>'                                   skip
        '<TH text_wrap="true" rowspan="4" colspan="4" style="text-align: center; font-weight:bold; ">Параметры топлива по ТТН</TH>'                                  skip
        '<TH text_wrap="true" rowspan="4" colspan="5" style="text-align: center; font-weight:bold; ">Параметры топлива по измерениям в АЦ</TH>'                      skip
        '<TH text_wrap="true" rowspan="4" colspan="4" style="text-align: center; font-weight:bold; ">Параметры топлива по измерениям в резервуаре до слива</TH>'     skip
        '<TH text_wrap="true" rowspan="4" colspan="4" style="text-align: center; font-weight:bold; ">Параметры топлива по измерениям в резервуаре после слива</TH>'  skip
        '<TH text_wrap="true" rowspan="4" colspan="2" style="text-align: center; font-weight:bold; ">Принято к учету</TH>'                                           skip
        '<TH text_wrap="true" rowspan="4" colspan="2" style="text-align: center; font-weight:bold; ">Отклонение АЦ к ТТН</TH>'                                       skip
        '<TH text_wrap="true" rowspan="4" colspan="2" style="text-align: center; font-weight:bold; ">Отклонение резервуара к АЦ</TH>'                                skip
        '<TH text_wrap="true" rowspan="4" colspan="2" style="text-align: center; font-weight:bold; ">Отклонение между резервуаром и  принятым к учету топливом</TH>' skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Сверхнормативные расхождения между резервуаром и АЦ, кг</TH>'   skip
        '<TH text_wrap="true" rowspan="5" style="text-align: center; font-weight:bold; ">Сверхнормативные расхождения между резервуаром и принятым к учету топливом, кг</TH>' skip
        '</TR>'skip
        
        '<TR >'skip
        '</TR>'skip
        
        '<TR >'skip
        '</TR>'skip
        
        '<TR >'skip
        '</TR>'skip
        
        '<TR >'skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Объем, л</TH>'                        skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Масса, кг</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Плотн., г/см3</TH>'                   skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Темп., °С</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Объем, л</TH>'                        skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Масса, кг</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Масса ЕУ, кг</TH>'                    skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Плотн., г/см3</TH>'                   skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Темп., °С</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Объем, л</TH>'                        skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Масса, кг</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Плотн., г/см3</TH>'                   skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Темп., °С</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Объем, л</TH>'                        skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Масса, кг</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Плотн., г/см3</TH>'                   skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Темп., °С</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Объем, л</TH>'                        skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Масса, кг</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Масса, кг</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">%</TH>'                               skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Масса, кг</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">%</TH>'                               skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">Масса, кг</TH>'                       skip
        '<TH text_wrap="true" style="text-align: center; font-weight:bold; ">%</TH>'                               skip
        '</TR>'skip
        
        '<TR >'skip
        '<TH style="text-align: center; font-weight:bold; ">1.1</TH>'   skip
        '<TH style="text-align: center; font-weight:bold; ">1.2</TH>'   skip
        '<TH style="text-align: center; font-weight:bold; ">1.3</TH>'   skip
        '<TH style="text-align: center; font-weight:bold; ">1.4</TH>'   skip
        '<TH style="text-align: center; font-weight:bold; ">1.5</TH>'   skip
        '<TH style="text-align: center; font-weight:bold; ">1.6</TH>'   skip
        '<TH style="text-align: center; font-weight:bold; ">1.7</TH>'   skip
        '<TH style="text-align: center; font-weight:bold; ">1.8</TH>'   skip
        '<TH style="text-align: center; font-weight:bold; ">1.9</TH>'   skip
        '<TH style="text-align: center; font-weight:bold; ">1.10</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.11</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.12</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.13</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.14</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.15</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.16</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.17</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.18</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.19</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.20</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.21</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.22</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.23</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.24</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.25</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.26</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.27</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.28</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.29</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.30</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.31</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.32</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.33</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.34</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.35</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.36</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.37</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.38</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.39</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.40</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.41</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.42</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.43</TH>'  skip
        '<TH style="text-align: center; font-weight:bold; ">1.44</TH>'  skip
        '</TR>'skip
      .

      for each tt-rep where not tt-rep.no-itog
      break
        by tt-rep.obj-code
        by tt-rep.shift-date
        by tt-rep.shift-num
        by tt-rep.col3
        by tt-rep.gds-code
        by tt-rep.col13
      :
        if not i-Itog
        then do :
          
          put stream sOutStr-html unformatted
            '<TR >'skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col1, "") '</TH>'   skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col2, "") '</TH>'   skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col3, "") '</TH>'   skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col4, "") '</TH>'   skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col5, "") '</TH>'   skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col6, "") '</TH>'   skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col7, "") '</TH>'   skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col8, "") '</TH>'   skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col9, "") '</TH>'   skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col10, "") '</TH>'  skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col11, "") '</TH>'  skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col12, "") '</TH>'  skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col13, "") '</TH>'  skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col14, "") '</TH>'  skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col15, "") '</TH>'  skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col16, "") '</TH>'  skip
            '<TH style="text-align: center; font-weight:normal; ">' fStrNvl(tt-rep.col17, "") '</TH>'  skip
            '<TH num="#,##0.00" style="text-align: center; font-weight:normal; ">' + tt-rep.col18str + '</TH>'  skip
            '<TH num="#,##0.00" style="text-align: center; font-weight:normal; ">' + tt-rep.col19str + '</TH>'  skip
            '<TH num="#,##0.00" style="text-align: center; font-weight:normal; ">' + tt-rep.col20str + '</TH>'  skip
            '<TH num="#,##0.00" style="text-align: center; font-weight:normal; ">' + tt-rep.col21str + '</TH>'  skip
            '<TH num="#,##0.00" style="text-align: center; font-weight:normal; ">' + tt-rep.col22str + '</TH>'  skip
            '<TH num="#,##0.00" style="text-align: center; font-weight:normal; ">' + tt-rep.col23str + '</TH>'  skip
            '<TH num="#,##0.00" style="text-align: center; font-weight:normal; ">' + tt-rep.col24str + '</TH>'  skip
            '<TH num="#,##0.00" style="text-align: center; font-weight:normal; ">' + tt-rep.col25str + '</TH>'  skip
            '<TH num="#,##0.00" style="text-align: center; font-weight:normal; ">' + tt-rep.col26str + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col27, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col27, "->>>>>>>>>>>9"  ) + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col28, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col28, "->>>>>>>>>>>9.9") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col29, "->>>>>>>>9.9999") + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col29, "->>>>>>>>9.9999") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col30, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col30, "->>>>>>>>>>>9.9") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col31, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col31, "->>>>>>>>>>>9"  ) + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col32, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col32, "->>>>>>>>>>>9.9") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col33, "->>>>>>>>9.9999") + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col33, "->>>>>>>>9.9999") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col34, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col34, "->>>>>>>>>>>9.9") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col35, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col35, "->>>>>>>>>>>9"  ) + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col36, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col36, "->>>>>>>>>>>9.9") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col37, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:normal; color: ' + (if abs(tt-rep.col38) > tt-rep.delta-mass-qnty-ac then "red" else "black") + '; ">' + fDec2Str(tt-rep.col37, "->>>>>>>>>>>9.9") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col38, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:normal; color: ' + (if abs(tt-rep.col38) > tt-rep.delta-mass-qnty-ac then "red" else "black") + '; ">' + fDec2Str(tt-rep.col38, "->>>>>>>>>>9.99") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col39, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:normal; color: ' + (if abs(tt-rep.col40) > 0.65 then "red" else "black") + '; ">' + fDec2Str(tt-rep.col39, "->>>>>>>>>>>9.9") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col40, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:normal; color: ' + (if abs(tt-rep.col40) > 0.65 then "red" else "black") + '; ">' + fDec2Str(tt-rep.col40, "->>>>>>>>>>9.99") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col41, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:normal; color: ' + (if abs(tt-rep.col42) > 0.65  then "red" else "black") + '; ">' + fDec2Str(tt-rep.col41, "->>>>>>>>>>>9.9") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col42, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:normal; color: ' + (if abs(tt-rep.col42) > 0.65 then "red" else "black") + '; ">' + fDec2Str(tt-rep.col42, "->>>>>>>>>>9.99") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col43, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col43, "->>>>>>>>>>>9.9") + '</TH>'  skip
            '<TH num="#,##0.00" val="' + fDec2Str(tt-rep.col44, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:normal; ">' + fDec2Str(tt-rep.col44, "->>>>>>>>>>>9.9") + '</TH>'  skip
            '</TR>'skip
          .
        end .
             
        if last-of(tt-rep.obj-code) then do:
          for first tt-itog where tt-itog.obj-type = tt-rep.obj-type
                              and tt-itog.obj-code = tt-rep.obj-code
          :
            put stream sOutStr-html unformatted
              '<TR >'skip
              '<TH style="text-align: center; font-weight:bold; ">Итого по:</TH>'  skip
              '<TH style="text-align: center; font-weight:bold; ">' fStrNvl(tt-itog.col1, "") '</TH>'   skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col18, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col18, "->>>>>>>>>>>9"  ) + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col19, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col19, "->>>>>>>>>>>9.9") + '</TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col22, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col22, "->>>>>>>>>>>9"  ) + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col23, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col23, "->>>>>>>>>>>9.9") + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col24, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col24, "->>>>>>>>>>9.99") + '</TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col27, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col27, "->>>>>>>>>>>9"  ) + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col28, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col28, "->>>>>>>>>>>9.9") + '</TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col31, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col31, "->>>>>>>>>>>9"  ) + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col32, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col32, "->>>>>>>>>>>9.9") + '</TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col35, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col35, "->>>>>>>>>>>9"  ) + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col36, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col36, "->>>>>>>>>>>9.9") + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col37, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-itog.col38red then "red" else "black") + '; ">' + fDec2Str(tt-itog.col37, "->>>>>>>>>>>9.9") + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col38, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-itog.col38red then "red" else "black") + '; ">' + fDec2Str(tt-itog.col38, "->>>>>>>>>>9.99") + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col39, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-itog.col40red then "red" else "black") + '; ">' + fDec2Str(tt-itog.col39, "->>>>>>>>>>>9.9") + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col40, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-itog.col40red then "red" else "black") + '; ">' + fDec2Str(tt-itog.col40, "->>>>>>>>>>9.99") + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col41, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-itog.col42red then "red" else "black") + '; ">' + fDec2Str(tt-itog.col41, "->>>>>>>>>>>9.9") + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col42, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-itog.col42red then "red" else "black") + '; ">' + fDec2Str(tt-itog.col42, "->>>>>>>>>>9.99") + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col43, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col43, "->>>>>>>>>>>9.9") + '</TH>'  skip
              '<TH num="#,##0.00" val="' + fDec2Str(tt-itog.col44, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-itog.col44, "->>>>>>>>>>>9.9") + '</TH>'  skip
              '</TR>'skip
            .
          end .
        end .
      end .
      
      for first tt-all-itog:
        put stream sOutStr-html unformatted
          '<TR >'skip
          '<TH style="text-align: center; font-weight:bold; ">Итого по:</TH>'  skip
          '<TH style="text-align: center; font-weight:bold; ">Всем выбранным объектам</TH>'   skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col18, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col18, "->>>>>>>>>>>9"  ) + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col19, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col19, "->>>>>>>>>>>9.9") + '</TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col22, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col22, "->>>>>>>>>>>9"  ) + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col23, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col23, "->>>>>>>>>>>9.9") + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col24, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col24, "->>>>>>>>>>9.99") + '</TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col27, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col27, "->>>>>>>>>>>9"  ) + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col28, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col28, "->>>>>>>>>>>9.9") + '</TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col31, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col31, "->>>>>>>>>>>9"  ) + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col32, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col32, "->>>>>>>>>>>9.9") + '</TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH style="text-align: center; font-weight:bold; "></TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col35, "->>>>>>>>>>>9"  ) + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col35, "->>>>>>>>>>>9"  ) + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col36, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col36, "->>>>>>>>>>>9.9") + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col37, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-all-itog.col38red then "red" else "black") + '; ">' + fDec2Str(tt-all-itog.col37, "->>>>>>>>>>>9.9") + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col38, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-all-itog.col38red then "red" else "black") + '; ">' + fDec2Str(tt-all-itog.col38, "->>>>>>>>>>9.99") + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col39, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-all-itog.col40red then "red" else "black") + '; ">' + fDec2Str(tt-all-itog.col39, "->>>>>>>>>>>9.9") + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col40, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-all-itog.col40red then "red" else "black") + '; ">' + fDec2Str(tt-all-itog.col40, "->>>>>>>>>>9.99") + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col41, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-all-itog.col42red then "red" else "black") + '; ">' + fDec2Str(tt-all-itog.col41, "->>>>>>>>>>>9.9") + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col42, "->>>>>>>>>>9.99") + '" style="text-align: center; font-weight:bold; color: ' + (if tt-all-itog.col42red then "red" else "black") + '; ">' + fDec2Str(tt-all-itog.col42, "->>>>>>>>>>9.99") + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col43, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col43, "->>>>>>>>>>>9.9") + '</TH>'  skip
          '<TH num="#,##0.00" val="' + fDec2Str(tt-all-itog.col44, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight:bold; ">' + fDec2Str(tt-all-itog.col44, "->>>>>>>>>>>9.9") + '</TH>'  skip
          '</TR>'skip
        .
      end.
      
         
      put stream sOutStr-html unformatted
         '</tbody>' skip
         '</table>' skip
         '</body>' skip
         '</html>' skip
         .
         
      output stream sOutStr-html close.

      run prn-lib-reportviewer in this-procedure (
          input parparentproc
          ,input vFileNameRep
          ,input ""
          ) no-error.
      if error-status:error then
      do:
          message return-value view-as alert-box.
          return .
      end.
            
   end.

end procedure.

PROCEDURE get-report-num :

  define output parameter p-report-num as integer no-undo .

  do
    on error undo, return error return-value
    :
    run gbl/getrpnum.p (output p-report-num).
  end.

END PROCEDURE.
