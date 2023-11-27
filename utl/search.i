&if defined(search_def) eq 0
&then
&glob search_def yes
{ cmp/str-glbl.i }

{ def/funcmet.i objExists character }
(input  ifolder as character,
 input  iType   as character  ):
    define variable vFileType as character no-undo init "D,F".
    define variable vi        as integer no-undo.
    define variable vtype as character no-undo.
    if iType ne ?
    then
       vFileType = iType.
    do vi = 1 to num-entries(vFileType):
       file-information:file-name = "./" + ifolder.
       vtype = file-information:file-type.
       if index(vtype , entry(vi,vFileType )) > 0 then return file-information:full-pathname .
       file-information:file-name = ifolder.
       vtype = file-information:file-type.
       if index( vtype, entry(vi,vFileType )) > 0 then return file-information:full-pathname .
    end.
    return ? .

end.

{ def/funcmet.i SearchFile character }
(input  ifile as character):
   return objExists(ifile,?).
end.

{ def/funcmet.i SearchPFile character }
(input inFile as char):
     define variable oFile       as character no-undo.
     define variable vFileSearch as character no-undo.
     define variable vNumEntry   as integer no-undo.
     vNumEntry = num-entries(inFile,".").
     vFileSearch = inFile.
     if    vNumEntry > 0
        and (   entry(vNumEntry,inFile,".") eq "p"
             or entry(vNumEntry,inFile,".") eq "w")
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