define variable v-enc-file as character no-undo.
define variable v-ver-file as character no-undo.

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "удаление всех записей BatchProcess с типом {&btpr-type-autoupg}".

{cmp\str-glbl.i }
{ gbl/xmldom.i   }
assign
    v-enc-file = substitute( "&1\vertag.enc":U, "c:\work16_0\cmp" )
  .
  run gbl/_tmpfile.p ( input "cp":U  , input ".ver":U, output v-ver-file ).
  run xmldom-clear in this-procedure .
  run xmldom-add in this-procedure ( input "TradeHouse":U, input "version":U          , input "16.0"           ).
  run xmldom-add in this-procedure ( input "TradeHouse":U, input "locale":U           , input "rus"            ).
  run xmldom-add in this-procedure ( input "TradeHouse":U, input "SVNRev":U           , input "-1"          ).
  run xmldom-add in this-procedure ( input "TradeHouse":U, input "compilerVersion":U  , input "3.0"  ).
  run xmldom-add in this-procedure ( input "TradeHouse":U, input "date":U             , input date("09/05/2023")              ).
  run xmldom-add in this-procedure ( input "TradeHouse":U, input "time":U             , input time              ).
  run xmldom-add in this-procedure ( input "TradeHouse":U, input "comment":U          , input "2023_03_29 Rel 13 Patch 06.1 ПМ"           ).
  run xmldom-add in this-procedure ( input "TradeHouse":U, input "Release":U          , input 13          ).
  run xmldom-add in this-procedure ( input "TradeHouse":U, input "Patch":U            , input 6             ).
  run xmldom-add in this-procedure ( input "TradeHouse":U, input "branch":U           , input 1             ).
  run xmldom-save in this-procedure ( input v-ver-file ).

  
  run utl/filecrypnodb.p ( input v-ver-file
                     , input "sysadm"
                     , input yes
                     , input v-enc-file
                     ) no-error.
  if error-status :error
  then do:
    message
      skip(1)
      skip "Ошибка шифрования файла параметров версии."
      skip return-value
      skip trim( error-status :get-message( 1 ) )
            trim( error-status :get-message( 2 ) )
            trim( error-status :get-message( 3 ) )
    view-as alert-box error.
    undo, return error.
  end.
  

