/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$



Автор: Морозов Александр Сергеевич
Дата создания: 01/30/15
Author: Alexandr Morozov
Creation date: 01/30/15

*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

define input parameter objType as character no-undo.
define input parameter objCode as integer no-undo.
define input parameter barCode as integer no-undo.
define output parameter varprice-sale as decimal no-undo.
define output parameter varcur-vat-pc as decimal no-undo.

define variable vardoc-num    as character no-undo.
define variable varroad-tax   as decimal   no-undo.
define variable varexcise     as decimal   no-undo.
define variable varcur-slt-pc as decimal   no-undo.

{ cmp/library.i  }

{ gbl/bcprcex.i
    objType
    objCode
    barCode
    0
    0
    vardoc-num
    varprice-sale
    varroad-tax
    varexcise
    varcur-vat-pc
    varcur-slt-pc
}