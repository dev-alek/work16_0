/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Декларация об объемах розничной продажи алкогольной продукции, кроме пива

Автор: Кирюхин Сергей
Дата создания: 03/09/12
Author: SKiryxin
Creation date: 03/09/12

*/

/* ***************************  Definitions  ************************** */

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Декларация об объемах розничной продажи алкогольной продукции".

{ cmp/vssrevis.i      }
{ cmp/str-glbl.i      }
{ cmp/r-page1.i new   }
{ cmp/showinf.i  }
{ gbl/getcntxt.i def }

run rep/d-report.w
    ( input parParentProc ,                                                     /* 0 */
      input 'rep/e-alcdc.w',                                                    /* 1 RUN */
      input "Приложение 11 - Декларация алкоголь",                              /* 2 Title */
      input 2,                                                                  /* 3 dates */    
      input "{&g-all}":U,                                                       /* 4 goods */
      input "{&o-firm},{&o-choice}":U,                                          /* 5 objects */
      input "",                                                                 /* 6 Price */
      input "",                                                                 /* 7 currency */
      input "all",                                                              /* 8 object type */
      input no                                                                  /* 9 одна закладка */
    ) no-error.