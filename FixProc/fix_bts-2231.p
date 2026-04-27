block-level on error undo, throw.

{ utl/runpro.i }

define input parameter p-doc-num as character no-undo .
define input parameter p-gds-list as character no-undo .

define buffer price-doc  for ub.price-doc .
define buffer price-list for ub.price-list .
define buffer parts      for ub.parts .
define buffer prev_parts for ub.parts .
define buffer bf_parts   for ub.parts .

define variable v-doc-num  as character no-undo .
define variable v-gds-code as integer   no-undo .
define variable v-qnty     as decimal   no-undo .

define variable ii         as integer   no-undo .

v-doc-num = p-doc-num .

find first price-doc no-lock where price-doc.doc-num = v-doc-num no-error .
if not available price-doc
    then 
do :
    message "Переоценка не найдена!" view-as alert-box .
    return .
end .

tr_ :
do trans :

    do ii = 1 to num-entries(p-gds-list) :
        v-gds-code = integer(entry(ii, p-gds-list)) .

        find first price-list exclusive-lock where price-list.doc-num = price-doc.doc-num
            and price-list.b-code = v-gds-code
            no-error .
        if not available price-list
            then 
        do :
            message substitute("Товар &1 в переоценке не найден!", v-gds-code) view-as alert-box .
            undo tr_, return .
        end .
        v-qnty = price-list.doc-qnty .
        find first goods no-lock where goods.gds-code = v-gds-code no-error .
        for each parts exclusive-lock where parts.out-code = price-doc.doc-num and
            parts.artic = goods.artic and parts.prod-code = goods.prod-code and
            parts.prod-type = goods.prod-type:
            if v-qnty >= parts.fact-qnty then 
            do:    
                v-qnty = v-qnty - parts.fact-qnty .
            end.
            else 
            do:
                if v-qnty = 0 then 
                do:
                    delete parts .
                end.
                else 
                do:
                    assign
                        parts.fact-qnty = v-qnty 
                        parts.qnty      = v-qnty
                        .
                    v-qnty = 0 .
                end.
            end.
        end.
    end .
end .

message "Готово!" view-as alert-box .

