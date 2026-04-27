/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита для BTS-2391. 
Исправление расхождения количества по признакам и общего количества по партиям:
1. Артикул 04631140056244. Исправляет расхождение кол-ва по док-ту и факт. кол-во в док-те расхода через кассу 160201-101м.
2. Артикул 130248. Исправляет фактическое кол-во в партии по док-ту расхода 128096-101м. 

Автор: Ростовцев А.М.
Дата создания: 31.03.2026
Author: 
Creation date: 

*/

{ utl/runpro.i }

on write of doc-line override do: end.
on write of gds-dtl  override do: end.
on write of parts    override do: end.

define buffer trn-doc  for ub.trn-doc.
define buffer doc-line for ub.doc-line.
define buffer gds-dtl  for ub.gds-dtl.
define buffer parts    for ub.parts.

do transaction:

    for first trn-doc no-lock where 
              trn-doc.doc-code = "160201-101м" 
       ,first doc-line where 
              doc-line.doc-code = trn-doc.doc-code
          and doc-line.artic = "04631140056244"
       ,first gds-dtl where 
              gds-dtl.doc-code = trn-doc.doc-code
          and gds-dtl.artic = "04631140056244"
       :
      doc-line.fact-qnty = 1.
      gds-dtl.fact-qnty = 1.
    end.
    
    for first parts where 
              parts.out-code  = "128096-101м"
          and parts.artic     = "130248"
    : 
      parts.fact-qnty = 5.
    end.
end.    

MESSAGE "Успешно!!!"
VIEW-AS ALERT-BOX.


