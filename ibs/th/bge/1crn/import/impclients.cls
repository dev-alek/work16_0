/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных clients (контрагенты) из 1С

Автор: Молотков Сергей
Дата создания: 02/10/17
Author: Molotkov Sergey
Creation date: 02/10/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

class ibs.th.bge.1crn.import.impclients implements ibs.th.bge.1crn.import.iimpsubject: 
  
  { cmp/str-glbl.i class }
  
  
  define property Msg as character no-undo
    get. 
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
    define variable v-mode      as character no-undo. /* create/update */
    define variable v-rid       as recid no-undo.
    define variable v-firm-code as integer no-undo . /* like ub.firm.firm-code */
    define variable v-grp-code  as integer no-undo . /* like ub.clients.grp-code */
    define variable v-is-pboul  as logical no-undo . /* like ub.firm.is-pboul */
    define variable v-addr1     as character no-undo . /* первые 80 символов для address1 */
    define variable v-addr2     as character no-undo . /* оставшиеся символы для address2 */
    define variable v-addr3     as character no-undo . /* первые 80 символов для address1 */
    define variable v-addr4     as character no-undo . /* оставшиеся символы для address2 */
    define variable v-retfl     as logical no-undo .
    define buffer buf_firm for ub.firm .

    define variable objImp as class clients no-undo.
    
    objImp = cast (subjectObj, clients).

    if objImp:del-f > 0 then do:
      Msg = "not supported in TH".
      v-retfl = false .
      return false. /* уходит в finally, где перевозвращает v-retfl вместо false */
    end.
    
    assign
      Msg = ""
      v-firm-code = integer(objImp:code_)
      v-grp-code  = 3 /* "Поставщики"  - здесь импорт только юр.лиц;
                         перечень кодов групп клиентов предопределён и согласован с техносервом */
      v-is-pboul  = length(objImp:inn) > 10 
      v-addr1     = substring(objImp:leg-adr, 1, 80)
      v-addr2     = substring(objImp:leg-adr, 81)
      v-addr3     = substring(objImp:post-adr, 1, 80)
      v-addr4     = substring(objImp:post-adr, 81)
    .
    find first buf_firm no-lock where buf_firm.firm-code = v-firm-code no-error .
    if available buf_firm then assign
      v-mode = {&update}
      v-rid  = recid(buf_firm)
    .
    else assign
      v-mode = {&add-import}
      v-rid  = ?
    .

    run ref/firm1.p (
       input ?             /* parparentproc handle, not used */
      ,input-output v-rid  /* p-rid as recid, only for output */
      ,input v-mode        /* p-mode as character */
      ,input "discards"    /* p-callpoint: if "discards" then clients.trg-param & firm.trg-param = {&trg-param-no-callnews} */
      ,input yes           /* p-silent: yes с выводом в return-value */
      ,input - v-firm-code /* p-firm-code. Какая-то новая фишка: минусовой код позволяет диапазоны с code-range.stts='f' */
      ,input objImp:del-l  /* p-stts like ub.clients.stts (int): 0 - запись видна, >0 - запись не видна в справочнике, как бы удалена */
      ,input objImp:name_  /* p-obj-name like ub.clients.obj-name */
      ,input 0             /* p-lim-kr like ub.clients.lim-kr (dec-2) */
      ,input ""            /* p-PS like ub.clients.PS */
      ,input v-grp-code    /* p-grp-code */
      ,input v-addr1       /* p-addres1 like ub.firm.addres1 */
      ,input v-addr2       /* p-addres2 like ub.firm.addres2 */
      ,input objImp:city   /* p-city like ub.firm.city */
      ,input objImp:agnt   /* p-contact-psn like ub.firm.contact-psn */
      ,input ""            /* p-director like ub.firm.director */
      ,input objImp:e-mail /* p-e-mail like ub.firm.e-mail */
      ,input objImp:full-name /* p-engl-name like ub.firm.engl-name */ 
      ,input ""            /* p-fax like ub.firm.fax */
      ,INPUT ""            /* p-given-by like ub.firm.given-by */
      ,input objImp:ind    /* p-ind like ub.firm.ind */
      ,input objImp:inn    /* p-inn like ub.firm.inn */
      ,INPUT yes           /* p-no-check-inn: yes пропускает проверку ИНН */
      ,INPUT v-is-pboul    /* p-is-pboul like ub.firm.is-pboul */
      ,input objImp:kpp    /* p-kpp like ub.firm.kpp */
      ,input ""            /* p-okonh like ub.firm.okonh */
      ,input objImp:okpo   /* p-okpo like ub.firm.okpo */
      ,INPUT ""            /* p-passp-num like ub.firm.passp-num */
      ,INPUT ""            /* p-passp-ser like ub.firm.passp-ser */
      ,input ""            /* p-phone like ub.firm.phone */
      ,input ""            /* p-phone1-note like ub.firm.phone1-note */
      ,input v-addr3       /* p-post-addr1 like ub.firm.post-addr1 */
      ,input v-addr4       /* p-post-addr2 like ub.firm.post-addr2 */
      ,input ""            /* p-post-city like ub.firm.post-city */
      ,input 0             /* p-post-ind like ub.firm.post-ind */
      ,input 0             /* p-reg-code like ub.clients.reg-code */
      ,input ""            /* p-telex like ub.firm.telex */
      ,input 0             /* p-tobj-code like ub.firm.tobj-code */
      ,input false         /* p-turnover-buyer like ub.clients.turnover-buyer */
      ,input false         /* p-turnover-buyer-gds like ub.clients.turnover-buyer-gds */
    ) .
    v-retfl = true .

    catch exAppErrors as class Progress.Lang.AppError :
      Msg = exAppErrors:ReturnValue .
      if Msg = "" then Msg = exAppErrors:GetMessage(1) .
      v-retfl = false.
      undo, throw exAppErrors .
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      Msg = exProErrors:GetMessage(1) . 
      v-retfl = false.
      undo, throw exProErrors .
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      Msg = "Unexpected error occurred..." .
      v-retfl = false.
      undo, throw exAnyErrors .
    end catch .
    finally :
      return v-retfl.
    end finally .
  end method. /* end_of Excute */

end class.