 
 /*------------------------------------------------------------------------
    File        : ICommandProc
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Thu Sep 21 18:10:21 MSK 2023
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

using ibs.th.skt.Commands.*.

class ibs.th.skt.Commands.ICommandProc inherits ICommand  abstract: 
   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   define public property hpApi as handle no-undo 
   get.
   private set.
   
   { cmp/str-glbl.i class }
   { gbl/runrepid.i }
   
   method public int64 runProc (icmd as character):
     define variable bat-file as character no-undo.
     define variable v-pid as int64 no-undo.
     run gbl/_tmpfile.p (
                        input ""
                      , input "bat"
                      , output bat-file) .
     output to value(bat-file) convert target "ibm866".
     put  unformatted icmd skip.
     output close.
     run gbl/run-gpid.p (input bat-file
                        ,input '':U
                        ,output v-pid).
     if not session:debug-alert
     then do:
         os-delete value(bat-file) no-error.
     end.
                                 
     return v-pid.

     
  end.
  
     
   constructor public ICommandProc (  ):
      super ().
      run gbl\getwindows.p(output hpApi).
   end constructor.

   destructor public ICommandProc ( ):

   end destructor.

end class.