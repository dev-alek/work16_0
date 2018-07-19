/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Библиотека для работы с атрибутами для резервуаров

Автор: Шальнев Иван Сергеевич
Дата создания: 12/22/11
Author: Ivan Shalnev
Creation date: 12/22/11

*/

&global-define place-type        "place-type"                /*тип резервуара(вертикальный,горизонтальный)*/
&global-define place-SI          "place-SI"                    /*средство измерения*/
&global-define place-diameter    "place-diameter"        /*диаметр резервуара(мм)*/
&global-define dead-balance       "dead-balance"        /*мертвый остаток*/
&global-define place-ratio-error "place-ratio-error"  /*относительная погрешность составления калибровочной таблицы резервуара*/
&global-define place-dens-prov         "dens-prov"         /*плотность при поверке резервуара*/
&global-define place-virtual     "place-virtual"     /*виртуальный резервуар*/
&global-define place-twice-code  "place-twice-code" /*Код сдвоенного резервуара*/
&global-define place-sert-urov   "place-sert-urov" /*Сертифицированный уровнемер по массе*/
&global-define list-place-attr   'place-type,place-SI,place-diameter,dead-balance,place-ratio-error,dens-prov,place-virtual,place-twice-code,place-sert-urov':u /*список атрибутов резервуара*/


procedure placelib_write-attr:
define input  parameter p-code     like ub.place-attr.attr-code .
define input  parameter p-obj-code like ub.place-attr.obj-code .
define input  parameter p-obj-type like ub.place-attr.obj-type .
define input  parameter p-pl-code  like ub.place-attr.pl-code .
define input  parameter p-value    like ub.place-attr.attr-value .
define output parameter p-ok       as logical.

define buffer buf_place-attr for ub.place-attr .

  do on error undo, return error return-value :
     p-ok = false.
     find first buf_place-attr exclusive-lock where buf_place-attr.attr-code   = p-code
                                                and buf_place-attr.obj-code    = p-obj-code
                                                and buf_place-attr.obj-type    = p-obj-type
                                                and buf_place-attr.pl-code     = p-pl-code no-error.
     if not available buf_place-attr then do :
        create buf_place-attr.
        assign
          buf_place-attr.attr-code   = p-code
          buf_place-attr.attr-value  = p-value
          buf_place-attr.obj-code    = p-obj-code
          buf_place-attr.obj-type    = p-obj-type
          buf_place-attr.pl-code     = p-pl-code
        .
        p-ok = true.
     end.
     else do:
        buf_place-attr.attr-value  = p-value .
        p-ok = true.
     end.
  end.

end.

procedure placelib_get-attr:
define input  parameter  p-code     like ub.place-attr.attr-code .
define input  parameter  p-obj-code like ub.place-attr.obj-code .
define input  parameter  p-obj-type like ub.place-attr.obj-type .
define input  parameter  p-pl-code  like ub.place-attr.pl-code .
define output parameter  p-value    like ub.place-attr.attr-value .
define output parameter  p-ok       as logical.


define buffer buf_place-attr for ub.place-attr .

  do on error undo, return error return-value :
     p-ok = false.
     find first buf_place-attr no-lock where buf_place-attr.attr-code   = p-code
                                                and buf_place-attr.obj-code    = p-obj-code
                                                and buf_place-attr.obj-type    = p-obj-type
                                                and buf_place-attr.pl-code     = p-pl-code no-error.
     if available buf_place-attr then do :
       p-value = buf_place-attr.attr-value.
       p-ok = true.
     end.
     else do :
       p-ok = false.
     end.
  end.

end.


procedure placelib_del-attr:
define input parameter  p-code     like ub.place-attr.attr-code .
define input parameter  p-obj-code like ub.place-attr.obj-code .
define input parameter  p-obj-type like ub.place-attr.obj-type .
define input parameter  p-pl-code  like ub.place-attr.pl-code .
define input parameter  p-value    like ub.place-attr.attr-value .
define output parameter p-ok       as logical.

define buffer buf_place-attr for ub.place-attr .

  do on error undo, return error return-value :
     p-ok = false.
     find first buf_place-attr exclusive-lock where buf_place-attr.attr-code   = p-code
                                                and buf_place-attr.obj-code    = p-obj-code
                                                and buf_place-attr.obj-type    = p-obj-type
                                                and buf_place-attr.pl-code     = p-pl-code no-error.
     if available buf_place-attr then do :
        delete buf_place-attr.
        p-ok = true.
     end.
  end.

end.











