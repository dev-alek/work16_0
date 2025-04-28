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

using ibs.th.skt.ControlledClients.*.
using ibs.th.skt.HeadHttp from propath.
block-level on error undo, throw.

class ibs.th.skt.Commands.IRequest abstract:  

define public property Content as longchar no-undo 
    get.
    set.

  define public property ContentBuff as memptr no-undo 
    get.
    set.

  define public property HndlSocket as handle no-undo 
    get.
    set.
    
  define public property HeadHTTP as HeadHTTP no-undo 
    get.
    set.
  define public property queryPar as character  no-undo 
  get:
     return if valid-object (HeadHTTP) then HeadHTTP:queryPar else "".
  end.  
 
  
end class.