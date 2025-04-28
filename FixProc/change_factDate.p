block-level on error undo, throw.
/* def input parameter p-type as int. */
{utl/runpro.i}
{ cmp/str-glbl.i }
/*{ str/libofarh.i }*/
/*{ str/lib-farh.i }*/
/*{ cmp/library.i  }*/

/*define var parparentproc as widget-handle no-undo .*/
/*{ gbl/getcntxt.i def }*/
/*{ gbl/getcntxt.i get }*/
define variable  v-fact-order           as decimal no-undo . /* порядковый номер закрытия документа  */
define variable  v-shift-end-fact-order as decimal no-undo . /* номер конца смены                    */
define variable  v-day-end-fact-order   as decimal no-undo . /* номер конца дня                      */
define variable v-ii as decimal no-undo .

define buffer bf_fin-doc for ub.fin-doc .

  for each bf_fin-doc where bf_fin-doc.status_   = {&fact}      
                            by bf_fin-doc.host-code by bf_fin-doc.status_ by bf_fin-doc.fact-date by bf_fin-doc.fact-order on error undo, return error return-value :
if bf_fin-doc.fact-date > 03/20/2025 then do:
/*    if year(bf_fin-doc.fact-date) > 2025 then do:*/
        bf_fin-doc.fact-date = date(string(entry(1,string(bf_fin-doc.fact-date),"/")) + "/" + string(entry(2,string(bf_fin-doc.fact-date),"/")) + "/2025") . 
        v-ii = v-ii + 0.000000001 .
     //   string(bf_fin-doc.fact-date) = 2025 .
    
        if bf_fin-doc.shift-flag = 0 then do:
      run factord in this-procedure (
       input  bf_fin-doc.fact-date
      ,input  bf_fin-doc.fact-time
      ,input  bf_fin-doc.fact-num
      ,input  bf_fin-doc.shift-date
      ,input  bf_fin-doc.shift-num
      ,input  no
      ,output v-fact-order
      ,output v-shift-end-fact-order
      ,output v-day-end-fact-order
      ) .           
        end.
        else do:
   run factord in this-procedure (
       input  bf_fin-doc.fact-date
      ,input  bf_fin-doc.fact-time
      ,input  bf_fin-doc.fact-num
      ,input  bf_fin-doc.shift-date
      ,input  bf_fin-doc.shift-num
      ,input  yes
      ,output v-fact-order
      ,output v-shift-end-fact-order
      ,output v-day-end-fact-order
      ) .            
        end.              
                                     
          if v-fact-order <> 0 then bf_fin-doc.fact-order = v-fact-order .   
          if v-shift-end-fact-order <> 0 then bf_fin-doc.shift-fact-order = v-shift-end-fact-order .                                  
    end.
    end.
    message "Готово!"
    view-as alert-box.
    
    procedure factord :

  define input  parameter p-fact-date            as date    no-undo . /* фактическая дата закрытия документа  */
  define input  parameter p-fact-time            as integer no-undo . /* фактическое время закрытия документа */
  define input  parameter p-fact-num             as integer no-undo . /* фактический номер закрытия документа */
  define input  parameter p-shift-date           as date    no-undo . /* дата начала смены для документа      */
  define input  parameter p-shift-num            as integer no-undo . /* номер смены для документа            */
  define input  parameter p-shift-on             as logical no-undo . /* на объекте включены смены            */
  define output parameter p-fact-order           as decimal no-undo . /* порядковый номер закрытия документа  */
  define output parameter p-shift-end-fact-order as decimal no-undo . /* номер конца смены   используется для АРХИВА */
  define output parameter p-day-end-fact-order   as decimal no-undo . /* номер конца дня     используется для АРХИВА */

  define variable vss-description as character no-undo init "factord: Определение порядкового номера документа".

  if p-fact-date = ?
  then do:
    return error "Не указана фактическая дата" .
  end.

  define variable v-fact-date-num as integer no-undo .
  assign
    v-fact-date-num = integer(p-fact-date)
  .

  if p-fact-num = ?
  or p-fact-num = 0
  then do:
    return error "Не задан p-fact-num " + string(p-fact-num) .
  end.

  if p-fact-num < 0
  then do:
    return error "Отрицательный fact-num " + string(p-fact-num) .
  end.

  if p-fact-num >= 100000000
  then do:
    return error "Недопустимо большой fact-num " + string(p-fact-num) .
  end.

  if p-shift-on = true
  then do:
    /* смены включены */
    /* должны быть заданы дата и номер смены */
    if p-shift-date = ?
    then do:
      return error "Не задана дата смены" .
    end.

    if p-shift-num = ?
    or p-shift-num = 0
    then do:
      return error "Не задан номер смены" .
    end.
  end.
  else do:
    /* смены выключены */
    /* присваиваем значения по умолчанию */
    assign
      p-shift-date = p-fact-date
      p-shift-num  = {&max-shift-num}
    .
  end.

  define variable v-shift-offset as integer no-undo .
  if p-shift-date = p-fact-date
  then do:
    assign
      v-shift-offset = 1
    .
  end.
  if p-shift-date < p-fact-date
  then do:
    assign
      v-shift-offset = 0
    .
  end.
  if p-shift-date > p-fact-date
  then do:
    message
      
      "Неправильная дата закрытия смены" skip
      "Дата закрытия не смены не может быть раньше чем дата открытия смены" skip
      view-as alert-box error .
    undo, return error
      substitute("Дата закрытия не смены &1 не может быть раньше чем дата открытия смены &2"
        ,string(p-fact-date, '99/99/9999':U)
        ,string(p-shift-date, '99/99/9999':U)
        )
    .
  end.

  if p-shift-num < {&min-shift-num}
  or p-shift-num > {&max-shift-num}
  then do:
    message
      
      "Неправильный номер смены" skip
      "p-shift-num" p-shift-num skip
      view-as alert-box error .
    undo, return error return-value .
  end.

  assign
    p-fact-order           = v-fact-date-num
                           + v-shift-offset * 0.5
                           + p-shift-num    * 0.02 - 0.01
                           + p-fact-num     * {&arh-delta}
                           + v-ii
    p-shift-end-fact-order = v-fact-date-num
                           + v-shift-offset * 0.5
                           + p-shift-num    * 0.02
                           + v-ii
    p-day-end-fact-order   = v-fact-date-num
                           + 0.99
                           + v-ii
  .

  if p-fact-order           <= v-fact-date-num
  or p-shift-end-fact-order <= v-fact-date-num
  or p-fact-order           >= p-shift-end-fact-order - {&arh-delta} /* arh-delta зарезервировано для сменной сверки */
  or p-shift-end-fact-order >= p-day-end-fact-order
  then do:
    message
      "Внутренняя ошибка при генерации фактического номера" skip
      "p-fact-date"            p-fact-date            skip
      "p-fact-time"            p-fact-time            skip
      "p-fact-num"             p-fact-num             skip
      "p-shift-date"           p-shift-date           skip
      "p-shift-num"            p-shift-num            skip
      "p-shift-on"             p-shift-on             skip
      "p-shift-end-fact-order" p-shift-end-fact-order skip
      "p-day-end-fact-order"   p-day-end-fact-order   skip
      "v-fact-date-num"        v-fact-date-num        skip
      view-as alert-box error .
    undo, return error return-value .
  end.

end procedure. /* factord */
    
