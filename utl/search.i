&if "{1}" = "class"
&then
method public character  SearchFile
&else
function objExists returns character 

(input  ifolder as character,
 input  iType   as character  ) forward.

function SearchFile returns character 
&endif 
(input  ifile as character):
   return objExists(ifile,?).
end.


&if "{1}" = "class"
&then
method public character  objExists 
&else
function objExists returns character 
&endif 
(input  ifolder as character,
 input  iType   as character  ):
    define variable vFileType as character no-undo init "D,F".
    define variable vi        as integer no-undo.
    if iType ne ?
    then
       vFileType = iType.
    do vi = 1 to num-entries(vFileType):
       file-information:file-name = "./" + ifolder.
       if index( file-information:file-type, entry(vi,vFileType )) > 0 then return file-information:full-pathname .
       file-information:file-name = ifolder.
       if index( file-information:file-type, entry(vi,vFileType )) > 0 then return file-information:full-pathname .
    end.
    return ? .

end.