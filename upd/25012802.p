block-level on error undo, throw.
{ cmp/trg-def.i  }
define input  parameter parparentproc as handle no-undo.
define input  parameter iparam        as character no-undo.
define output parameter oOk           as logical no-undo.

define buffer buf_thbj-attr for thbj-attr.

if g#db-num eq 0
then do:
   for each db no-lock:
      for each thbj-attr where thbj-attr.upper-prop-code eq {&attr-gisMT}
                           and thbj-attr.obj-type        eq {&db}
                           and thbj-attr.obj-code        eq db.db-num
                           and thbj-attr.prop-code       ne ""
                           and thbj-attr.prop-code       ne {&attr-gisMT_OflineAdress}
                           and thbj-attr.prop-code       ne {&attr-gisMT_OflineLogin}
                           and thbj-attr.prop-code       ne {&attr-gisMT_OflinePswd}
                           and thbj-attr.prop-code       ne {&attr-gisMT_adressPort} 
                           and thbj-attr.prop-code       ne {&attr-gisMT_dopParam}
                           and thbj-attr.prop-code       ne {&attr-gisMT_gisAdress}
                           and thbj-attr.prop-code       ne {&attr-gisMT_proxyLogin}
                           and thbj-attr.prop-code       ne {&attr-gisMT_proxyPswd}
                           and thbj-attr.prop-code       ne {&attr-gisMT_regKey}
                           and thbj-attr.prop-code       ne {&attr-gisMT_waitTime}
                           and thbj-attr.prop-code       ne {&attr-gisMT_cdnTurnOn}
                           and thbj-attr.prop-code       ne {&attr-gisMT_cdnAdress}
      no-lock:
         oOk = false.
         return.  
      end.
   end.
end.
oOk = true.