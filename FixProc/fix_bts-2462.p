/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита для BTS-2462. 
Восстановление удаленных марок с пустой датой изменения по маркам, привязаым к УПД
На вход задается внутренний номер УПД

Автор: Ростовцев А.М.
Дата создания: 09.04.2026
Author: 
Creation date: 

*/

{ utl/runpro.i }

define input parameter iDocId as character no-undo.

define buffer sys-ctrl          for ub.sys-ctrl.
define buffer utd               for ub.utd.
define buffer marking           for ub.marking.
define buffer c-marking         for ub.c-marking.
define buffer utd-lines         for ub.utd-lines.
define buffer utd-marking-lines for ub.utd-marking-lines.
define buffer utd-err           for ub.utd-err.

define variable vDocId   as integer no-undo.
define variable vDeleted as integer no-undo.
define variable vCreated as integer no-undo.
define variable vUpdated as integer no-undo.
define variable vDelAll  as integer no-undo.
define variable vCrtAll  as integer no-undo.
define variable vUpdAll  as integer no-undo.
define variable vFileLog as character no-undo.
define variable vRecKey  as character no-undo.
define stream prt.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Восстановление удаленных марок".

{ gbl/key-rec.i }

vDocId = integer(iDocId) no-error.
if error-status:error then
do:
  message "Не правильно передан номер УПД." skip
          "Необхдимо передать целочисленный внутренний номер УПД в ТН."
  view-as alert-box.
  return.
end.


find first sys-ctrl no-lock.

find first utd no-lock where
           utd.db-num = sys-ctrl.db-num
       and utd.doc-id = vDocId
no-error.
  
if avail utd then
do transaction:
    vFileLog = "УПД_" + string(vDocId) + ".log".
    output stream prt to value(vFileLog).
    MARK:
    for each utd-marking-lines no-lock where
             utd-marking-lines.db-num = sys-ctrl.db-num
         and utd-marking-lines.doc-id = vDocId
    break by utd-marking-lines.LineNum:
      find first marking no-lock where
                 marking.mark = utd-marking-lines.mark no-error.
      if not avail marking then
      do:
        vDeleted = vDeleted + 1.
        for last c-marking no-lock where
                 c-marking.mark = utd-marking-lines.mark
            use-index pi-2
        :
          create marking.
          buffer-copy c-marking to marking
            assign
              marking.sts         = utd-marking-lines.sts
              marking.last-change = datetime(c-marking.corr-date,c-marking.corr-time * 1000) 
          no-error.  
          if error-status:error then
          do:
            put stream prt unformatted 
              substitute("Ошибка при восстановлении марки &1: &2.~n",utd-marking-lines.mark,error-status:get-message(1))
            .
            next MARK.
          end.
          vCreated = vCreated + 1.
          put stream prt unformatted
            substitute("Создана марка &1.~n",utd-marking-lines.mark)
          .
        end.
        if not avail c-marking then
        do:
          put stream prt unformatted
            substitute("Для марки &1 не найдена запись в истории.~n",utd-marking-lines.mark)
          .
        end.
      end.
      else do: /* марка есть, но, если не все поля заполнены, возможно она создалась при продаже и надо восстановить */
        if marking.unit-ext = "" then
        do:
            for last c-marking no-lock where
                     c-marking.mark = utd-marking-lines.mark
                 and c-marking.unit-ext <> ""      
                use-index pi-2
            :
              find current marking exclusive-lock.
              assign
                marking.unit     = c-marking.unit when marking.unit = ""
                marking.unit-ext = c-marking.unit-ext when marking.unit-ext = ""
                marking.gds-ext-id = c-marking.gds-ext-id when marking.gds-ext-id = ""   
                marking.gds-code = c-marking.gds-code when marking.gds-code = 0 or marking.gds-code = ?
                marking.comment = c-marking.comment when marking.comment = "" 
                marking.box-qnty = c-marking.box-qnty when marking.box-qnty = 0
                marking.loc-key = c-marking.loc-key when marking.loc-key = "" 
                marking.obj-type = c-marking.obj-type when marking.obj-type = ""  
                marking.obj-code = c-marking.obj-code when marking.obj-code = 0 or marking.obj-code = ?
                marking.mark-parent = c-marking.mark-parent when marking.mark-parent = "" 
/*                marking.expDate = c-marking.expDate when marking.expDate = ""               */
/*                marking.expDateOther = c-marking.expDateOther when marking.expDateOther = ""*/
              no-error.
    /*          buffer-copy c-marking to marking                        */
    /*            except sts last-change loc-key online-result no-error.*/
              if error-status:error then
              do:
                put stream prt unformatted 
                  substitute("Ошибка при восстановлении марки &1: &2.",utd-marking-lines.mark,error-status:get-message(1)) skip
                .
                next MARK.
              end.
              vUpdated = vUpdated + 1.
              put stream prt unformatted
                substitute("Восстановлена марка &1.~n",utd-marking-lines.mark)
              .
            end.
            if not avail c-marking then
            do:
              put stream prt unformatted
                substitute("Для марки &1 не найдена запись в истории.",utd-marking-lines.mark) skip
              .
            end.
        end.
      end.    
      if last-of(utd-marking-lines.LineNum) then
      do:
        put stream prt unformatted
          substitute("По строке &1 создано &2 марок из &2 удаленных, восстановлено &3 марок.",utd-marking-lines.LineNum,vCreated,vDeleted,vUpdated) skip
        .
        if vDeleted = vCreated then 
        do:  /* удалим ошибку по строке */
          for first utd-lines no-lock where
                    utd-lines.db-num  = utd-marking-lines.db-num
                and utd-lines.doc-id  = utd-marking-lines.doc-id
                and utd-lines.LineNum = utd-marking-lines.LineNum
          : 
            run gen-key-rec (input "utd-lines", 
                             input  buffer utd-lines:handle, 
                             output vRecKey).
            for each utd-err exclusive-lock where  
                     utd-err.db-num = sys-ctrl.db-num
                 and utd-err.doc-id = vDocId
                 and utd-err.reckey = vRecKey
                 and utd-err.CodeErr begins "NotMark"
            :
              delete utd-err.
              put stream prt unformatted
                substitute("По строке &1 удалена ошибка NotMark.~n",utd-lines.LineNum)
              .
            end.
          end.             
        end.
         
        assign
          vDelAll = vDelAll + vDeleted
          vCrtAll = vCrtAll + vCreated
          vUpdAll = vUpdAll + vUpdated
          vDeleted = 0
          vCreated = 0
          vUpdated = 0
        .  
      end.
    end.  
    output stream prt close.
end.
else do:
  message substitute("Не найдена УПД с номером &1.",vDocId)
  view-as alert-box.
  return.
end.

MESSAGE 
  (if vDelAll <> vCrtAll then "Не все марки восстановлены." else "Успешно!") skip
  substitute("Всего по УПД создано &1 марок из &2 удаленных.",vCrtAll,vDelAll) skip
  substitute("Всего по УПД восстановлено &1 марок.",vUpdAll) skip
  "Файл лога:" search(vFileLog) "."
VIEW-AS ALERT-BOX.

