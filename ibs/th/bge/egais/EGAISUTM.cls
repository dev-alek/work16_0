 
/*------------------------------------------------------------------------
   File        : EGAISUTM
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Fri Nov 13 16:37:34 MSK 2015
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.bge.egais.*.


class ibs.th.bge.egais.EGAISUTM inherits EGAISImpl:
 
{cmp/str-glbl.i class}
{ gbl/thbj-def.i }

  define protected variable TimeOut as character no-undo.

  define property ConPar as character no-undo
  get.
  protected set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
		
  constructor public EGAISUTM (inOjType as char, inObjCode as int):
    
    define variable v-value-character   as character no-undo .
    define variable v-value-decimal     as decimal   no-undo .
    define variable v-value-integer     as integer   no-undo .
    define variable v-value-logical     as logical   no-undo .
    define variable v-value-type        as character no-undo .
    define variable v-value-date        as date      no-undo .
    
    /*get-key-value section 'EGAIS' key 'ConParameter' value ConPar.
    if ConPar = ? then do:
      assign
      Msg = substitute("Ошибка ini - файла:&1Секция &2&1Ключ &3&1"
                        , {&new-line}
                        , 'EGAIS'
                        , 'ConParameter')
      StatusErr = true.
    end.*/        
    get-key-value section 'EGAIS' key 'TimeOut' value TimeOut.
    if TimeOut = ? then do:
      assign
        TimeOut = "5".
    end.
    run adm/shattri.p (
         input "get":U
        ,input inOjType
        ,input inObjCode
        ,input {&attr-egais-host}
        ,input {&attr-egais-host_egais-utm}
        ,output v-value-character
        ,output v-value-date
        ,output v-value-decimal
        ,output v-value-integer
        ,output v-value-logical
        ,output v-value-type
        ,input-output table thbjattr_thbj-attr
        ) no-error .
    ConPar = trim (v-value-character, '/').
    ConPar = trim (ConPar, '\').


  end constructor.


  method protected character GetURLUTM (arg as char):

  end.
  
  method protected character GetSubjectOfRequestUTM ():

  end.
  
  method final protected logical WriteDbStatus ( inSubject as int,  inParameters as char, inReplyId as char, inSts as log ):
    
    define buffer buf_ext-sys for ub.ext-system.
    
    find first buf_ext-sys no-lock where buf_ext-sys.delivery-method = 10 no-error.

    if available (buf_ext-sys) then 
    do:
      find first ub.esys-all-attr 
              where ub.esys-all-attr.key7 = inReplyId no-error.
      if not available ub.esys-all-attr 
        then do:
          create ub.esys-all-attr.
          ub.esys-all-attr.key4       = string (now).
        end.
      assign
        ub.esys-all-attr.table-name = "esys-pck-sent"
        ub.esys-all-attr.attr-code  = "egais"
        ub.esys-all-attr.attr-value = inParameters
        ub.esys-all-attr.key1       = buf_ext-sys.esys-id
        ub.esys-all-attr.key2       = inSubject
        ub.esys-all-attr.key3       = string (inSts)
        ub.esys-all-attr.key5       = DbNum  
        ub.esys-all-attr.key7       = inReplyId
        ub.esys-all-attr.key8       = User_Id
      no-error.
      if error-status:error
      then do:
        return false.
      end.
    end.
    else
      return false.
    
    return true.
    
  end method.

  method final protected logical CheckCurrentRequest ( inSubject as int,  inParameters as char, output outReplyId as char ):
    
    find first ub.esys-all-attr 
                where ub.esys-all-attr.table-name = "esys-pck-sent" 
                and ub.esys-all-attr.attr-code = "egais"
                and ub.esys-all-attr.key2       = inSubject
                and ub.esys-all-attr.attr-value = inParameters
                and ub.esys-all-attr.key3 = string (false)
                no-error.
    if available (ub.esys-all-attr )
    then do:
      outReplyId = ub.esys-all-attr.key7.
      return true.
    end.
    
    return false.
    
  end method.
  
  method protected handle ParseResponse (inFileName as char):

  end. 

  method protected void ParseResponse (inContent as char, inTableType as int):

  end.  

end class.