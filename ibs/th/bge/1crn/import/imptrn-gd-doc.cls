/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных country из 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
using ibs.th.bge.1crn.import.*.
using ibs.th.skt.Adapters.AdapterOra-i516-1c from propath.
using ibs.th.skt.Adapters.AdapterOra-i506-1c from propath.

block-level on error undo, throw.

class ibs.th.bge.1crn.import.imptrn-gd-doc implements ibs.th.bge.1crn.import.iimpsubject: 
  
  { cmp/str-glbl.i class }
  
  {ibs/th/skt/ControlledClients/TSDTT-1c.i}
  
  define buffer buf_clients for ub.clients.
  
  define property Msg as character no-undo
    get. 
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
		
    define variable v-doc-rec as recid     no-undo.
    define variable result    as logical   no-undo.
    define variable glog      as logical   no-undo.
    define variable mode      as character no-undo.
    define variable ii        as integer   no-undo.
    define variable jj        as integer   no-undo.
    define variable objTrnDoc  as class     trn-gd-doc-in   no-undo.
    define variable objGd      as class     trn-gd          no-undo.
    define variable objPrt     as class     trn-prt         no-undo.
    define variable objMark    as class     trn-mark        no-undo.
    define variable adapObj    as class     AdapterOra-i516-1c no-undo.
    define variable objGds     as class     subjects        no-undo.
    define variable objPrts    as class     subjects        no-undo.
    define variable objMarks   as class     subjects        no-undo.
    
    objTrnDoc = cast (subjectObj, trn-gd-doc-in).
    
    adapObj = new AdapterOra-i516-1c ().
    
    find first ub.sys-ctrl.
    find first buf_clients where buf_clients.db-num = ub.sys-ctrl.db-num.
    empty temp-table TempTrnDoc.
    empty temp-table TempDocLine.
    empty temp-table TempDocMark.
    
    create TempTrnDoc.
    assign
      TempTrnDoc.obj-type = buf_clients.obj-type
      TempTrnDoc.obj-code = buf_clients.obj-code
      TempTrnDoc.doc-date = objTrnDoc:doc-date
      TempTrnDoc.doc-id = objTrnDoc:doc-id
      TempTrnDoc.dog-code = objTrnDoc:dog-code
      TempTrnDoc.source-doc = objTrnDoc:source-doc
    .

    case trim (objTrnDoc:doc-type, '0'):
      when '1' then do:
        assign
          TempTrnDoc.ext-doc-code = objTrnDoc:doc-code
          TempTrnDoc.cli-type = "орг"
          TempTrnDoc.cli-code = integer (objTrnDoc:contr-code)
        .
      end.
      when '4' then do:
        assign
          TempTrnDoc.ext-doc-type = {&TDEDT_Pri_Perem} 
          TempTrnDoc.ext-doc-code = replace (objTrnDoc:doc-code, "-", "=") 
          TempTrnDoc.cli-type = "маг"
          TempTrnDoc.cli-code = integer (objTrnDoc:fuel-st-code)
          TempTrnDoc.out-code = objTrnDoc:doc-code
        .
      end.
      when '8' then do:
        assign
          TempTrnDoc.ext-doc-type = {&TDEDT_Vozvrat_Perem} 
          TempTrnDoc.ext-doc-code = replace (objTrnDoc:doc-code, "-", "*") 
          TempTrnDoc.cli-type = "маг"
          TempTrnDoc.cli-code = integer (objTrnDoc:fuel-st-code)
          TempTrnDoc.out-code = objTrnDoc:doc-code
        .
      end.
      when '2' then do:
        TempTrnDoc.ext-doc-type = {&TDEDT_Ras_Vnesh} .
      end.
      otherwise do:
        Msg = "Не поддерживаемый тип документа на загрузку: " + objTrnDoc:doc-type.
        return false.
      end.
    end case.
    
    objGds = objTrnDoc:GDS.
    objPrts = objTrnDoc:prts.
    
    do ii = 1 to objGds:Get(ii):
      objGd = cast (objGds:SubjectObjCurr, trn-gd).
      objMarks = objGd:marks.
    
      if valid-object (objPrts)
      then do jj = 1 to objPrts:Get(jj):
        objPrt =  cast (objPrts:SubjectObjCurr, trn-prt).
        if objPrt:gd-line-num = objGd:line-num
        then do:
          create TempDocLine.
          assign
            TempDocLine.gds-code = objGd:gd-code
            TempDocLine.fact-qnty = objPrt:qnty
            TempDocLine.doc-qnty = objPrt:qnty
            TempDocLine.vsd-uuid = objPrt:vad-guid
            TempDocLine.part-id = objPrt:prt-id
            TempDocLine.price-rubl = objGd:sum / objGd:qnty-fact
            TempDocLine.vat-pc = (objGd:sum-nds / (objGd:sum - objGd:sum-nds)) * 100. 
        end.
      end.
      else do :
        objPrts = objGd:prts no-error .
        if valid-object (objPrts)
        then do jj = 1 to objPrts:Get(jj):
          objPrt =  cast (objPrts:SubjectObjCurr, trn-prt).
          create TempDocPart .
          assign
            TempDocPart.gds-code = objGd:gd-code
            TempDocPart.doc-qnty = objPrt:qnty-ttn
            TempDocPart.fact-qnty = objPrt:qnty-fact
            TempDocPart.price-rubl = objPrt:sum / objPrt:qnty-fact
            TempDocPart.vat-pc = (objPrt:sum-nds / (objPrt:sum - objPrt:sum-nds)) * 100
            TempDocPart.part-id = objPrt:prt-id
            TempDocPart.in-doc-id = objPrt:in-doc-id
            TempDocPart.edoc-id = objPrt:edoc-id
            TempDocPart.vsd-uuid = objPrt:vad-guid
          .
        end .
      end .
      if available (TempDocLine)
      then do:
        release TempDocLine.
        next.
      end.
      else do:
        create TempDocLine.
        assign
          TempDocLine.gds-code = objGd:gd-code
          TempDocLine.fact-qnty = objGd:qnty-fact
          TempDocLine.doc-qnty = objGd:qnty-ttn
          TempDocLine.price-rubl = objGd:sum / objGd:qnty-fact
          TempDocLine.vat-pc = (objGd:sum-nds / (objGd:sum - objGd:sum-nds)) * 100
          TempDocLine.koef = objGd:koef
          TempDocLine.unit-code = objGd:unit-code
        .
        release TempDocLine.
      end.
      
      if valid-object (objMarks)
      then do jj = 1 to objMarks:Get(jj):
        objMark = cast (objMarks:SubjectObjCurr, trn-mark).
        create TempDocMark.
        assign
          TempDocMark.mark = replace (replace (objMark:mark-code, "(", "" ), ")", "")
          TempDocMark.prt-id = objMark:prt-id
          TempDocMark.in-doc-id = objMark:in-doc-id
          TempDocMark.gtin = objMark:gtin
          TempDocMark.gtin_qnt = objMark:gtin_qnt
          TempDocMark.upd_id = objMark:upd_id
          TempDocMark.gds-code = objGd:gd-code
        .
      end.
      
    end.
    
    adapObj:SetTempTable(table TempTrnDoc, table TempDocLine, table TempDocPart, table TempDocMark, "").
    adapObj:WriteDB(output glog).
    
    
    if error-status:error then
    do:
      Msg = return-value.
      result = false.
    end.
    else do:
      result = true.
    end.
		
    return result.

  end method.
	

end class.
