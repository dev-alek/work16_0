 
/*------------------------------------------------------------------------
   File        : LogWrite
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Admin
   Created     : Mon Apr 20 22:05:32 MSK 2015
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.


class ibs.th.skt.Adapters.LogWrite: 

  define public property LogStr as character no-undo
    get ():
      def var str as char no-undo.
      run ibs/th/skt/Adapters/GetLogStrProc.p (output str).
      return str.
    end  .
    set (str as char):
      run ibs/th/skt/Adapters/SetLogStrProc.p (input str).
    end.
    
    method public void WriteFileToLog(ifile as char) :
      run ibs/th/skt/Adapters/WriteFileToLog.p (ifile).
    end.

end class.