/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

открытие потока и сопутствующие операции для различных видов касс -

Автор: Бахтадзе Наталья Викторовна
Дата создания: 06/23/03
Author: Bakhtadze Natalya
Creation date: 06/23/03


Для различных subject

*/

/*  вставляется в цикл по кассам */

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
define variable hSAXWriter as handle no-undo.
define variable Mreq as longchar no-undo.
run xml-cd-filename in this-procedure (
      input out
    , output v-xml-file-name
    , output v-xml-file-name-path
    , output v-log-file-name
    , output v-locked
).
if v-xml-encoding <> "windows-1251" then
    fix-codepage(Mreq) = v-xml-encoding.

create sax-writer hSAXWriter.
hSAXWriter:set-output-destination("longchar", Mreq) no-error.
hSAXWriter:formatted = true.
hSAXWriter:encoding = v-xml-encoding.
               
hSAXWriter:start-document() no-error.
define variable OS-time as character  no-undo.
OS-time =  string( ( today - date( "01/01/1996" ) ) * 24 * 3600 + time, ">>>>>>>>9" ).
hSAXWriter:start-element(V-root-teg) no-error.
hSAXWriter:insert-attribute("type",   "REQUEST")       no-error.
hSAXWriter:insert-attribute("id",     v-xml-file-name) no-error.
hSAXWriter:insert-attribute("from",   substitute ("{&bef-shop}&1", for-cash-desk.cash-num))      no-error.
hSAXWriter:insert-attribute("to",     substitute ("{&bef-shop}&1_касса", for-cash-desk.cash-num,for-cash-desk.cash-num)) no-error.
hSAXWriter:insert-attribute("tstamp", string(OS-time))     no-error.
                 
/* $Workfile$ e n d */