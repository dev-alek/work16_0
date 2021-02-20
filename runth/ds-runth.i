define temp-table tt-ver no-undo serialize-name "Version"
    field version           as character 
    field last_ver          as character 
    index pi is primary unique
        version
.

define temp-table tt-Params no-undo serialize-name "ReplaseParam"
    field version_run            as character serialize-hidden 
    field version_id             as integer
    field Value_Old              as character
    field Value_new              as character
    index pi is primary unique
        version_run version_id
    index Value_Old Value_Old
.

define temp-table tt-fileReplase no-undo serialize-name "FileReplase"
    field FileName_Old           as character
    field FileName_New           as character 
    field FileId                 as integer
    field FileCycle              as logical 
    index pi is primary unique
        FileId
.

define temp-table tt-fileList no-undo serialize-name "FileList"
    field FileName           as character 
    field FileId             as character
    field RunFile            as logical 
    index pi is primary unique
        FileId
.

define temp-table tt-HotKey no-undo serialize-name "HotKey"
    field HotId               as integer  
    field HotAttr             as character
    field HotVal              as character 
    
    index pi is primary unique
        HotAttr
.

define temp-table tt-HotValList no-undo serialize-name "HotValList"
    field HotKeyId                   as integer serialize-hidden
    field HotValList              as character 
    
    index pi is primary unique
        HotKeyId HotValList
.

define dataset ds-replace xml-node-name "root" for tt-ver, tt-Params, tt-fileList, tt-fileReplase
data-relation  relver  for tt-ver, tt-Params relation-fields (version,version_run) nested.
define dataset ds-HotParam xml-node-name "root" for  tt-HotKey, tt-HotValList
data-relation  relhot  for tt-HotKey, tt-HotValList relation-fields (HotId,HotKeyId) nested.