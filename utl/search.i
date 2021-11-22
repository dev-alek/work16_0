&if defined(search_def) eq 0
&then
&glob search_def yes
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

&if "{1}" = "class"
&then
method private character  SearchPFile 
&else
function SearchPFile returns character 
&endif 
 (input inFile as char):
     define variable oFile       as character no-undo.
     define variable vFileSearch as character no-undo.
     define variable vNumEntry   as integer no-undo.
     vNumEntry = num-entries(inFile,".").
     vFileSearch = inFile.
     if    entry(vNumEntry,inFile,".") eq "p"
        or entry(vNumEntry,inFile,".") eq "w"
     then do:
        entry(vNumEntry,vFileSearch, ".") = "r". 
        oFile = search(vFileSearch ).
        if oFile eq ?
        then
           oFile = search(inFile).
     end.
     else
        oFile = search(vFileSearch).
     return oFile.
     
  end.
&endif