/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по всем сухим чекам продажи и возврата с топливом

Автор: 
Дата создания: 
Author: 
Creation date: 

Автор1: 
Дата создания: 

*/

define input parameter parparentproc as widget-handle no-undo .
/*define input parameter custom-par    as character     no-undo .*/
define variable custom-par as character no-undo .
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Отчет по всем сухим чекам продажи и возврата с топливом":U .

{ cmp/str-glbl.i     }
{ cmp/library.i     }
{ cmp/r-page1.i  new }
{ cmp/vssrevis.i     }
{ str/lib-trn.i }   






define buffer buf_goods   for ub.goods.
define variable is-petrol as logical no-undo .
define variable is-pieces as logical no-undo .
define temp-table tt-goods no-undo like ub.goods.

/* for each buf_goods no-lock:
{ str/is-petrl.i buf_goods.artic buf_goods.prod-type buf_goods.prod-code is-petrol is-pieces no-error }
    if is-petrol THEN do:    */
            /*  message  is-petrol buf_goods.prod-type buf_goods.prod-code buf_goods.artic view-as alert-box. */
             /* buffer-copy buf_goods to tt-goods. */
             
		    /*  ASSIGN
                   gds-list.prod-type = goods.prod-type
                   gds-list.prod-code = goods.prod-code
                   gds-list.artic     = goods.artic
		   .   */
   /*  end.
end. */








&scop ttl " Отчет по всем сухим чекам продажи и возврата с топливом "
custom-par = "all,{&Arc-OT-yes},{&Arc-Supp-yes},{&Arc-stk-yes},{&Excel-yes}" + {&comma-char} + "TOG-Shift-2 = yes" + {&comma-char} + custom-par.
run rep/d-report.w (
                input parparentproc ,
                input 'rep/r-schk.p',
                {&ttl},
                input 4,
                "{&g-choice}", /* выбор товара */
/*                "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one}",  выбор товара */
                /* input "{&o-firm},{&o-currency},{&o-choice}",   выбор объекта */
                input "*",  /* выбор объекта все */
                input "",
                input "",
                input custom-par,
                input yes).


/* $Workfile$   E n d */