TRIGGER PROCEDURE FOR DELETE OF Code.
{cmp\str-glbl.i}
define buffer buf_code for code.
define var vparent as char no-undo.
vparent = (if code.parent = "" then "" else ( code.parent  +  {&delim-par}) )  + code.code.
for each buf_code where buf_code.parent begins vparent
exclusive-lock:
   delete buf_code.
end.

