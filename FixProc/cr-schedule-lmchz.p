/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Создание расписания автоматических заданий для ЛМ ЧЗ

Автор: Белова Марина Михайловна
Дата создания: 30/09/24
Author: Marina Belova
Creation date: 30/09/24

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle as handle no-undo .
define input parameter p-log-handle as handle no-undo .
define input parameter p-param-run as char no-undo.
 /* (string(buf_ext-file.db-num) + {&delim-par} +
         string(buf_ext-file.from-db-num) + {&delim-par} +
         string(buf_Ext-file.file-num)*/                                                                                       
                                             
/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Создание автоматического задания".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }  

define variable vPar1 as character no-undo.
define variable vPar2 as character no-undo.
if num-entries(p-param-run,{&delim-par}) <> 3 then return.
assign
   vPar1 =  entry(1,p-param-run,{&delim-par})
   vPar2 = entry(2,p-param-run,{&delim-par})
   .   
RUN CopySchedule in this-procedure (vPar1, vPar2) no-error.

procedure CopySchedule:
    define input param iDbNum     as character no-undo.
    define input param iDbNumFrom as character no-undo.
    
    define buffer buf_schedule for ub.schedule .
    define buffer buf_schedule-attr for ub.schedule-attr.
    define buffer copy_schedule for ub.schedule .
    define buffer copy_schedule-attr for ub.schedule-attr.
    define buffer buf_db       for ub.db .
    define buffer buf_sys-ctrl for ub.sys-ctrl .
    
    def var vProcName    as char no-undo.
    def var vTaskNum     as int  no-undo.
    def var vTaskNumFrom as int  no-undo.
    def var vDbNum       as int  no-undo.
    def var vDbNumFrom   as int  no-undo.

    assign
        vDbNum = int(iDbNum)
        vDbNumFrom = int(iDbNumFrom)
        no-error.
    if vDbNum = ? or  vDbNumFrom = ? then 
    do:
        run write-to-log in p-log-handle (
             substitute("Некорректно задан номер БД &1: &2"
                         , iDbNum
                         , iDbNumFrom )).
       return.
    end.
    if vDbNum = vDbNumFrom then 
    do:
        run write-to-log in p-log-handle (
              substitute("Задан одинаковый номер БД &1: &2"
                         , iDbNum
                         , iDbNumFrom )).
        return.
    end.
        
    Run GetBufSch (vDbNum, output vTaskNum).
       
    /* ищем произвольное задание на исходной базе (на ТСД) */    
    Run GetBufSch (vDbNumFrom, output vTaskNumFrom).
        
    /* создаем задание для этой базы */
    if vTaskNumFrom <> 0  
    then do
    on error undo, return error return-value:
        for first  buf_schedule no-lock
             where buf_schedule.cre-db-num = vDbNumFrom
               and buf_schedule.task-type  = {&btpr-type-autofree}
               and buf_schedule.task-num = vTaskNumFrom :
                   
            /* уже есть задание для этой базы */                        
            if vTaskNum <> 0 then             
            do:
               find first copy_schedule exclusive-lock
                     where copy_schedule.cre-db-num = vDbNum
                       and copy_schedule.task-type  = {&btpr-type-autofree}
                       and copy_schedule.task-num = vTaskNum
                       no-error.                        
               if not avail copy_schedule then do:        
                   run write-to-log in p-log-handle (
                          substitute("Для БД &1 задание rep-lmchz: &2 не удалось обновить - заблокировано другим пользователем."
                                     , vDbNum
                                     , vTaskNum )). 
                   return.                  
               end.   
               for each buf_schedule-attr exclusive-lock     
                  where buf_schedule-attr.cre-db-num = copy_schedule.cre-db-num
                    and buf_schedule-attr.task-type  = copy_schedule.task-type
                    and buf_schedule-attr.task-num   = copy_schedule.task-num:
                    delete buf_schedule-attr.
               end.                     
                       
            end.                        
            else do:
                create copy_schedule.                
                assign
                  copy_schedule.cre-db-num = vDbNum 
                  copy_schedule.db-num-char = string(vDbNum)
                  .
                copy_schedule.task-num = next-value( s-task-num, {&db-name_schema} ).  
            end.  
            
            buffer-copy buf_schedule except cre-db-num db-num-char task-num to copy_schedule.        
        
            for each buf_schedule-attr no-lock     
               where buf_schedule-attr.cre-db-num = buf_schedule.cre-db-num
                 and buf_schedule-attr.task-type  = buf_schedule.task-type
                 and buf_schedule-attr.task-num   = buf_schedule.task-num :
                                          
                create copy_schedule-attr.
                assign
                   copy_schedule-attr.cre-db-num = vDbNum
                   copy_schedule-attr.task-num = copy_schedule.task-num .
                buffer-copy buf_schedule-attr except cre-db-num task-num to copy_schedule-attr.
            end.
            if vTaskNum <> 0 
            then
                run write-to-log in p-log-handle (
                     substitute("Для БД &1 обновлено задание rep-lmchz: &2",
                                 vDbNum,
                                 copy_schedule.task-num)).
            else 
                run write-to-log in p-log-handle (
                     substitute("Для БД &1 создано задание rep-lmchz: &2",
                                 vDbNum,
                                 copy_schedule.task-num)).
        end.    
    end.
    else do:
        run write-to-log in p-log-handle (
              substitute("Для БД &1 нет произвольного задания rep-lmchz"
                         , vDbNumFrom )). 
       return .        
    end.
            
end procedure.
    
 procedure GetBufSch:
     define input param iNumDb as int no-undo.
     define output param oTaskNum as int no-undo.
     
     define buffer  buf_schedule for ub.schedule .
     define buffer  buf_schedule-attr for ub.schedule-attr.
           
    block_sch:
    for each buf_schedule no-lock
      where buf_schedule.cre-db-num = iNumDb
        and buf_schedule.task-type  = {&btpr-type-autofree}        
    , first buf_schedule-attr no-lock     /* Ищем атрибут */
      where buf_schedule-attr.cre-db-num = buf_schedule.cre-db-num
        and buf_schedule-attr.task-type  = buf_schedule.task-type
        and buf_schedule-attr.task-num   = buf_schedule.task-num
        and buf_schedule-attr.attr-code  = "schd-free-id" + {&delim-par} + "rep-lmchz"
        :                    
         leave block_sch .        
    end.    
    if avail buf_schedule
       then oTaskNum = buf_schedule.task-num.
       else oTaskNum = 0.
       
end procedure.
