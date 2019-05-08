
find first _user
           where _user._userid    = userid ("ub")
           no-error
           .
_User._Password = encode(session:parameter).