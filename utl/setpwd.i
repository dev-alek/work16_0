&glob login sysadm
&glob paswordold sysadm
&glob paswordnew !sysadm_new1
&glob xpaswordcur "{&paswordold}":U
&glob paswordcur if pasold() eq 1 then "sysadm":U else if pasold() eq 2 then "{&paswordold}":U else "{&paswordnew}":U

&if "{1}" = "class" &then
method private integer pasold ():
&else
function pasold returns integer  ():
&endif
 define variable vReturn as integer no-undo.
 find first _user
           where _user._userid    = "{&login}"
           no-error
           .
   if available _user
   then do:
       if _user._password = encode("{&paswordnew}") 
       then
          vReturn = 3.
       else if _user._password = encode("{&paswordold}") 
       then
          vReturn =  2.
       else do:
          find first sys-ctrl no-lock no-error.
          if     available sys-ctrl
             and sys-ctrl.db-num    eq 0
          then
             vReturn = 1.
          release sys-ctrl.   
       end.
      
   end.
   release _user.
   return vReturn. 
end.  
