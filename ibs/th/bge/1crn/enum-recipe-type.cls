/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

коды типов рецептов согласно протоколу взаимодействия с 1С

Автор: Молотков Сергей
Дата создания: 13/11/17
Author: Molotkov Sergey
Creation date: 13/11/17

*/

enum ibs.th.bge.1crn.enum-recipe-type:
  define enum
    enmanufacturing =  1 /* производство */
    engathering     =  2 /* комплектация */
    enalternative   =  3 /* альтернатива */
  .
end enum .
