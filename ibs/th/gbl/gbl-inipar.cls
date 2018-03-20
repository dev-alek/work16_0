/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Статический класс со значениями параметров из ini-файла

Автор: Молотков Сергей
Дата создания: 14/02/18
Author: Molotkov Sergey
Creation date: 14/02/18

*/

using Progress.Lang.*.

block-level on error undo, throw.

class ibs.th.gbl.gbl-inipar: 

  define static property conPar as character no-undo
    get.
    private set.
  define static property conParKeyName as character no-undo
    initial "секция REP-SETS ключ ConPar в .ini файле"
    get.
    private set.
    
  define static property conParFlt as character no-undo
    get.
    private set.
  define static property conParFltKeyName as character no-undo
    initial "секция REP-SETS ключ ConParFlt в .ini файле"
    get.
    private set.
    
  define static property logDir as character no-undo
    get.
    private set.
  define static property logDirKeyName as character no-undo
    initial "секция REP-SETS ключ logDir в .ini файле"
    get.
    private set.
    
  define static property comstr as character no-undo
    get.
    private set.
  define static property comstrKeyName as character no-undo
    initial "секция revision ключ comstr в .ini файле"
    get.
    private set.

  define static property dirflrvs as character no-undo
    get.
    private set.
  define static property dirflrvsKeyName as character no-undo
    initial "секция revision ключ dirflrvs в .ini файле"
    get.
    private set.

  define static property dirflpmp as character no-undo
    get.
    private set.
  define static property dirflpmpKeyName as character no-undo
    initial "секция revision ключ dirflpmp в .ini файле"
    get.
    private set.
   
    
  constructor static gbl-inipar():
    ibs.th.gbl.gbl-inipar:InitPar ( ) .
  end constructor.

  method public static void InitPar ( ) :
    get-key-value section "rep-sets" key "ConPar"    value conPar .
    get-key-value section "rep-sets" key "ConParFlt" value conParFlt .
    get-key-value section "rep-sets" key "logDir"    value logDir .
    get-key-value section "revision" key "comstr"    value comstr .
    get-key-value section "revision" key "dirflrvs"  value dirflrvs .
    get-key-value section "revision" key "dirflpmp"  value dirflpmp .
    if logDir = ?
    then do :
      logDir = ".\" .
    end .
    else do :
      logDir = right-trim(logDir, "\") .
      logDir = right-trim(logDir, "/") .
      logDir = logDir + "\" .
    end. 
  end method. // end_of InitPar
  
end class.