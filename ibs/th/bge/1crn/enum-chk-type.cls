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
    enzrep     = 12 /* Z отчет (12) */
  .
  define enum           
    entranscancell  = 14 /* сброс топливной транзакции */
    enoverflow      = 15 /* переливы */
    entranstransfer = 16 /* перевод транзакции */
    entechrefuell   = 17 /* тех. пролив. */
  .
end enum .
