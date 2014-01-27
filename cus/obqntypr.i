/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура расчета количества за период

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

Creation date: 06/02/03 3:58

*/
&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

procedure ob-line  :
define input  parameter x-store-code     like ub.clients.obj-code     no-undo.
define input  parameter x-store-type     like ub.clients.obj-type     no-undo.
define input  parameter x-artic          like ub.ot-line.artic        no-undo.
define input  parameter x-prod-code      like ub.ot-line.prod-code    no-undo.
define input  parameter x-prod-type      like ub.ot-line.prod-type    no-undo.
define input  parameter x-fact-order-1   like ub.ot-line.fact-order   no-undo.
define input  parameter x-fact-order-2   like ub.ot-line.fact-order   no-undo.
define input  parameter x-sum-type       like ub.ot-line.sum-type     no-undo.
define input  parameter x-cat-id         like ub.ot-line.cat-id       no-undo.
define input  parameter x-ext-doc-type   like ub.ot-line.ext-doc-type no-undo.
define input  parameter xtog-obj         as   logical no-undo.
define output parameter p-prih  as decimal no-undo .
define output parameter p-rash  as decimal no-undo .
define output parameter p-kassa as decimal no-undo .

define buffer p-doc-line for ub.doc-line.
define variable p-doc-type as character no-undo .
define variable str-doc-type as character no-undo .
str-doc-type =
{&tdedt_pri_vnesh}      + "," +
{&tdedt_pri_prvo  }     + "," +
{&tdedt_spi_vnesh}      + "," +
{&tdedt_spi_prvo}       + "," +
{&tdedt_ras_prvo}       + "," +
{&tdedt_ras_perem}      + "," +
{&tdedt_vozvrat_perem}  + "," +
{&tdedt_ras_vnesh}      + "," +
{&tdedt_vozvrat_vnesh}  + "," +
{&tdedt_ras_vnesh_kass} + "," +
{&tdedt_vozvrat_vnesh_kass} .

assign
  p-prih  = 0
  p-rash  = 0
  p-kassa = 0
.
define variable i as integer no-undo .
define variable v-nn as integer   no-undo .
v-nn = num-entries( str-doc-type ) .
  repeat i = 1 to v-nn :
    p-doc-type = entry( i, str-doc-type) .
       for each p-doc-line where
                p-doc-line.obj-type    = x-store-type
            and p-doc-line.obj-code    = x-store-code
            and p-doc-line.artic       = x-artic
            and p-doc-line.prod-type   = x-prod-type
            and p-doc-line.prod-code   = x-prod-code
            and p-doc-line.ext-doc-type = p-doc-type
            and p-doc-line.status_     = {&fact}
            and p-doc-line.fact-order >= x-fact-order-1
            and p-doc-line.fact-order <= x-fact-order-2 no-lock :
        case p-doc-line.ext-doc-type:
        /*разбивка по типам документов */
        /* приход */
             when   {&tdedt_pri_vnesh}  or
             when   {&tdedt_pri_prvo  }     then
               do:
               assign p-prih   = p-prih  +  p-doc-line.fact-qnty.
               end.

        /* расход */
              when  {&tdedt_spi_vnesh}      then if  p-t-sp      then assign p-rash = p-rash   +  p-doc-line.fact-qnty.
              when  {&tdedt_spi_prvo}       then if  p-t-sppv    then assign p-rash = p-rash   +  p-doc-line.fact-qnty.
              when  {&tdedt_ras_prvo}       then if  p-t-sppv-2  then assign p-rash = p-rash   +  p-doc-line.fact-qnty.
              when  {&tdedt_ras_perem}      then if  p-t-sppv-3  then assign p-rash = p-rash   +  p-doc-line.fact-qnty.
              when  {&tdedt_vozvrat_perem}  then if  p-t-sppv-4  then assign p-rash = p-rash   -  p-doc-line.fact-qnty.
              when  {&tdedt_ras_vnesh}      then if  p-t-rv      then assign p-rash = p-rash   +  p-doc-line.fact-qnty.
              when  {&tdedt_vozvrat_vnesh}  then if  p-t-rvz     then assign p-rash = p-rash   -  p-doc-line.fact-qnty.
       /* касса */
              when  {&tdedt_ras_vnesh_kass}     then if p-t-rvc  then assign p-kassa  = p-kassa  +  p-doc-line.fact-qnty.
              when  {&tdedt_vozvrat_vnesh_kass} then if p-t-rvzc then assign p-kassa  = p-kassa  -  p-doc-line.fact-qnty.
          end case.
    end.
  end.
assign
  p-rash  = p-rash
  p-kassa = p-kassa
.

end procedure.
/* $Workfile$ e n d */