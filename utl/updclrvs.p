/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита запуска редактирования закрытых сверок

Автор: Гридчина Полина Дмитриевна
Дата создания: 14/29/07
Author: Polia Gridchina
Creation date: 14/29/07



*/


 def input parameter parproc as handle.
 def input parameter par-doc-code as char.



define variable vss-revision    as character no-undo initial "$Revision$":U.
define variable vss-author      as character no-undo initial "$Author$":U.
define variable vss-date        as character no-undo initial "$Date$":U.
define variable vss-workfile    as character no-undo initial "$Workfile$":U.
define variable vss-archive     as character no-undo initial "$Archive$":U.
define variable vss-description as character no-undo initial "Утилита запуска редактирования закрытых сверок":U.


  def var rvs-rec as recid.
  find first rvs-doc where rvs-code = par-doc-code exclusive-lock.
  if rvs-doc.status_ <> "факт" then do :
      message "Данная сверка не закрыта на факт!" view-as alert-box .
      return .
  end.    
  rvs-rec = recid(rvs-doc).
  run utl/rvs-doc_upd.w
    ( input        parproc
     ,input        'ИЗМЕНЕНИЕ'
     ,input        rvs-doc.rvs-type
     ,input        no
     ,input-output rvs-rec
    ) no-error.
    
      run str/callnews.p
         (input 'rvs-doc':U
         ,input (buffer ub.rvs-doc:handle)
         ) no-error .
      if error-status :error then do:
        message "Невозможно маршрутизировать rvs-doc для отправки в новости" view-as alert-box.
      end.
   release rvs-doc.

message 'Если Вы корректировли сменную сверку, то не забудьте, пожалуйста, перепечатать сменный отчет!' view-as alert-box warning. 