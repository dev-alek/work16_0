&scoped-define vssseq {&sequence}
def var vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
&if defined (def-utd-attr) eq 0
&then
   &glob def-utd-attr yes
    
&if "{1}" = "class"
&then
method public char getattrUtdEx
&else
function getattrUtdex returns char 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 iattrcode as character,
 iExValue  as character  ):
   define buffer utd-attr for utd-attr.
   find first utd-attr where utd-attr.db-num eq idb-num
                         and utd-attr.doc-id eq idoc-id
                         and utd-attr.attr-code eq iattrcode
   no-lock no-error.
   return if not available utd-attr  then iExValue    else  utd-attr.attr-value.     
end.

&if "{1}" = "class"
&then
method public char getattrUtd
&else
function getattrUtd returns char 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 iattrcode as character ):
  return getattrUtdex(idb-num,idoc-id,iattrcode,?).
end.
&if "{1}" = "class"
&then
method public void setattrUtd
&else
function setattrUtd returns logical 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 iattrcode as character, 
 iattrval  as character ):
   define buffer utd-attr for utd-attr.
   find first utd-attr where utd-attr.db-num eq idb-num
                         and utd-attr.doc-id eq idoc-id
                         and utd-attr.attr-code eq iattrcode
   no-lock no-error.
   if not available utd-attr
   then do:
      create utd-attr.
      assign
         utd-attr.db-num    = idb-num
         utd-attr.doc-id    = idoc-id
         utd-attr.attr-code = iattrcode
         utd-attr.attr-value = iattrval
      . 
   end.
   else do:
      if utd-attr.attr-value ne iattrval
      then do:
         find current utd-attr exclusive-lock no-error.
         if available utd-attr
         then
            utd-attr.attr-value = iattrval.
      end.
   end.
   release utd-attr.   
end.


&if "{1}" = "class"
&then
method public char GetAttrUtdlinesEx
&else
function GetAttrUtdlinesEx returns char 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 ilinenum  as integer, 
 iattrcode as character,
 iExValue  as character  ):
   define buffer utd-lines-attr for utd-lines-attr.
   find first utd-lines-attr where utd-lines-attr.db-num    eq idb-num
                               and utd-lines-attr.doc-id    eq idoc-id
                               and utd-lines-attr.lineNum   eq ilineNum
                               and utd-lines-attr.attr-code eq iattrcode
   no-lock no-error.
   return if not available utd-lines-attr  then iExValue    else  utd-lines-attr.attr-value.     
end.

&if "{1}" = "class"
&then
method public char GetAttrUtdlines
&else
function GetAttrUtdlines returns char 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 ilinenum  as integer, 
 iattrcode as character ):
   return GetAttrUtdlinesex (idb-num,idoc-id,ilinenum,iattrcode,?).
end.

&if "{1}" = "class"
&then
method public void setattrUtdlines
&else
function setattrUtdlines returns logical 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 ilinenum  as integer, 
 iattrcode as character, 
 iattrval  as character ):
   define buffer utd-lines-attr for utd-lines-attr.
   find first utd-lines-attr where utd-lines-attr.db-num    eq idb-num
                               and utd-lines-attr.doc-id    eq idoc-id
                               and utd-lines-attr.lineNum   eq ilineNum
                               and utd-lines-attr.attr-code eq iattrcode
   no-lock no-error.
   if not available utd-lines-attr
   then do:
      create utd-lines-attr.
      assign
         utd-lines-attr.db-num    = idb-num
         utd-lines-attr.doc-id    = idoc-id
         utd-lines-attr.lineNum   = ilineNum
         utd-lines-attr.attr-code = iattrcode
         utd-lines-attr.attr-value = iattrval
      . 
   end.
   else do:
      if utd-lines-attr.attr-value ne iattrval
      then do:
         find current utd-lines-attr exclusive-lock no-error.
         if available utd-lines-attr
         then
            utd-lines-attr.attr-value = iattrval.
      end.
   end.
   release utd-lines-attr.      
end.
&endif