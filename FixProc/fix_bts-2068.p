/*

Утилита для BTS-2068. Востановление сменной сверки.

*/


{ utl/runpro.i }
define input parameter parparentproc    as widget-handle no-undo .
define input parameter iDocCode         as character     no-undo .


on write of ub.rvs-doc override 
    do: 
    end.


define buffer rvs-doc               for ub.rvs-doc .
define buffer c-rvs-doc             for ub.c-rvs-doc .
define buffer cc-rvs-doc            for ub.c-rvs-doc .
define buffer rvs-line              for ub.rvs-line .
define buffer rvs-line-pump         for ub.rvs-line-pump .
define buffer rvs-line-attr         for ub.rvs-line-attr .
define buffer control-rvs-line-attr for ub.rvs-line-attr .

define variable docName        as character no-undo .
define variable docCodeControl as character no-undo .

{ cmp/str-glbl.i }
{ gbl/getcntxt.i def }

find first cc-rvs-doc no-lock where
    cc-rvs-doc.rvs-code  = iDocCode and
    cc-rvs-doc.fact-order <> 0 
    no-error.

if not avail cc-rvs-doc then 
do:
    message 
        "Документ с номером" iDocCode "не найден!"
        view-as alert-box.
    return.  
end.

disable triggers for load of rvs-doc.

for first c-rvs-doc no-lock where c-rvs-doc.rvs-code = iDocCode and
    c-rvs-doc.fact-order <> 0:
    create rvs-doc .
    rvs-doc.rvs-code = c-rvs-doc.rvs-code .
    buffer-copy c-rvs-doc except rvs-code to rvs-doc.
    docName = entry(2,rvs-doc.PS,"№") .
    docCodeControl = entry(1,docName,".") .
    docCodeControl = trim(docCodeControl,"") .
end.
for each c-rvs-line no-lock where c-rvs-line.rvs-code = iDocCode:
    find first rvs-line where rvs-line.rvs-code = c-rvs-line.rvs-code and 
        rvs-line.gds-code = c-rvs-line.gds-code and
        rvs-line.pl-code = c-rvs-line.pl-code no-error .
    if not available (rvs-line) then 
    do:
        create rvs-line .
        rvs-line.rvs-code = c-rvs-line.rvs-code .
        rvs-line.gds-code = c-rvs-line.gds-code .
        rvs-line.pl-code = c-rvs-line.pl-code .
    end.

    buffer-copy c-rvs-line except rvs-code gds-code to rvs-line .

end.
for each c-rvs-line-pump no-lock where c-rvs-line-pump.rvs-code = iDocCode:
    find first rvs-line-pump where rvs-line-pump.rvs-code = c-rvs-line-pump.rvs-code and 
        rvs-line-pump.gds-code = c-rvs-line-pump.gds-code and rvs-line-pump.pl-code = c-rvs-line-pump.pl-code and
        rvs-line-pump.pump-code = c-rvs-line-pump.pump-code and rvs-line-pump.nozzle-code = c-rvs-line-pump.nozzle-code no-error .
    if not available (rvs-line-pump) then 
    do:
        create rvs-line-pump .
        assign
            rvs-line-pump.rvs-code    = c-rvs-line-pump.rvs-code  
            rvs-line-pump.gds-code    = c-rvs-line-pump.gds-code 
            rvs-line-pump.pl-code     = c-rvs-line-pump.pl-code 
            rvs-line-pump.pump-code   = c-rvs-line-pump.pump-code 
            rvs-line-pump.nozzle-code = c-rvs-line-pump.nozzle-code
            .
    end.
    buffer-copy c-rvs-line-pump except rvs-code gds-code pl-code pump-code nozzle-code to rvs-line-pump  .

end.
/*Атрибуты нужно брать из сверки, по которой была сделана сменная сверка*/
for each control-rvs-line-attr no-lock where control-rvs-line-attr.rvs-code = docCodeControl:
    create rvs-line-attr .
    rvs-line-attr.rvs-code = iDocCode .
    buffer-copy control-rvs-line-attr except rvs-code to rvs-line-attr .
end.
    message 
        "Успешно!" 
        view-as alert-box .

