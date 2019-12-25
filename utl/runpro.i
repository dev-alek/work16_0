define input  parameter iKey     as integer no-undo.
define output parameter oChekSum as character no-undo.
if userid("ub") eq ""
then do:
   oChekSum = {utl/chekproc.i iKey }.
   return.
end. 