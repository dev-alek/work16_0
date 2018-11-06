/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

коды типов чеков согласно протоколу взаимодействия с 1С

Автор: Молотков Сергей
Дата создания: 10/11/17
Author: Molotkov Sergey
Creation date: 10/11/17

*/

enum ibs.th.bge.1crn.enum-chk-type:
  define enum
    ensale     =  1 /* продажа */
    encashment =  2 /* инкассация */
    enfund     =  3 /* кассовый фонд */
    enreturn   =  6 /* возврат */
    enannu     =  8 /* &rcpt-annu  = Аннуляция */
    enzrep     = 12 /* &rcpt-z-rep = Z отчет (12) */
  .
  define enum           
    entranscancell  = 14 /* &rcpt-trans-cancell  = сброс топливной транзакции */
    enoverflow      = 15 /* &rcpt-overflow       = переливы */
    entranstransfer = 16 /* &rcpt-trans-transfer = перевод транзакции */
    entechrefuell   = 17 /* &rcpt-tech-refuell   = тех. пролив. */
  .
end enum .
