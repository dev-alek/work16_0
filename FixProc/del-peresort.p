block-level on error undo, throw.

{ utl/runpro.i }

/*define input parameter gdsCode as integer no-undo .*/
define input parameter doc-code as character no-undo .
define variable qnty as decimal no-undo .
define buffer bf_parts for ub.parts .
do transaction:
    disable triggers for load of ub.doc-line .
    for each doc-line exclusive-lock where doc-line.doc-code =  doc-code:

        for FIRST parts exclusive-lock WHERE parts.out-code      = doc-line.doc-code AND  
            parts.artic     = doc-line.artic     AND                               
            parts.prod-type = doc-line.prod-type AND                               
            parts.prod-code = doc-line.prod-code  :
            find first goods no-lock where goods.artic = parts.artic and goods.prod-type = parts.prod-type and goods.prod-code = parts.prod-code no-error .
            find first parts-root no-lock where parts-root.doc-code = parts.out-code and (parts-root.gds-code = goods.gds-code or 
                parts-root.orig-gds-code = goods.gds-code)    no-error .
            if not available(parts-root) then 
            do:
                
                /* ¬ случае остальных накладных проверим, что не осталось зависших партий по данной линии */
                if can-find (first ub.parts no-lock
                    where ub.parts.out-code  = ub.doc-line.doc-code
                    and ub.parts.obj-type  = ub.doc-line.obj-type
                    and ub.parts.obj-code  = ub.doc-line.obj-code
                    and ub.parts.artic     = ub.doc-line.artic
                    and ub.parts.prod-type = ub.doc-line.prod-type
                    and ub.parts.prod-code = ub.doc-line.prod-code
                    )
                    then 
                do:
                    qnty = ub.parts.fact-qnty . 
                    find first bf_parts exclusive-lock where bf_parts.artic = ub.parts.artic and
                    bf_parts.prod-code = ub.parts.prod-code and
                    bf_parts.prod-type = ub.parts.prod-type and
                    bf_parts.out-code = "free-zone" and
                    bf_parts.fact-qnty = ub.parts.fact-qnty no-error .
                    if available (bf_parts) then delete bf_parts .
                    delete ub.parts .
                    
                end.

                /* удал€ем все признаки по строке */
                for each ub.gds-dtl exclusive-lock
                    where ub.gds-dtl.doc-code  = ub.doc-line.doc-code
                    and ub.gds-dtl.artic     = ub.doc-line.artic
                    and ub.gds-dtl.prod-type = ub.doc-line.prod-type
                    and ub.gds-dtl.prod-code = ub.doc-line.prod-code
                    :
                    delete ub.gds-dtl .
                end.

                /* удал€ем информацию о резервировании партий по строке */
                for each ub.doc-prts exclusive-lock
                    where ub.doc-prts.out-code = doc-code
                    and ub.doc-prts.gds-code = ub.goods.gds-code
                    :
                    delete ub.doc-prts .
                end.

                /* удал€ем строки, хран€щие информацию по инвентаризации */
                for each ub.inv-line exclusive-lock
                    where ub.inv-line.doc-code  = ub.doc-line.doc-code
                    and ub.inv-line.artic     = ub.doc-line.artic
                    and ub.inv-line.prod-type = ub.doc-line.prod-type
                    and ub.inv-line.prod-code = ub.doc-line.prod-code
                    :
                    delete ub.inv-line.
                end.

                /* удал€ем информацию о резервировании товара по складским местам */
                for each ub.doc-pl exclusive-lock
                    where ub.doc-pl.out-code = ub.doc-line.doc-code
                    and ub.doc-pl.gds-code = ub.goods.gds-code
                    :
                    delete ub.doc-pl.
                end.

                for each ub.doc-pl-pump exclusive-lock
                    where ub.doc-pl-pump.out-code  = ub.doc-line.doc-code
                    and ub.doc-pl-pump.gds-code  = ub.goods.gds-code
                    :
                    delete ub.doc-pl-pump.
                end.

                /* удал€ем атрибуты строки документа */
                for each ub.doc-line-attr exclusive-lock
                    where ub.doc-line-attr.doc-code = ub.doc-line.doc-code
                    and ub.doc-line-attr.gds-code = ub.goods.gds-code
                    :
                    delete ub.doc-line-attr .
                end.

                /* ”дал€ем суммы по строке */
                for each ub.doc-line-sum exclusive-lock
                    where ub.doc-line-sum.doc-code = ub.doc-line.doc-code and
                    ub.doc-line-sum.gds-code = ub.goods.gds-code
                    :
                    delete ub.doc-line-sum .
                end.

                /* ”дал€ем оставшиес€ св€зки между парти€ми */
                for each ub.parts-root exclusive-lock
                    where ub.parts-root.doc-code  = ub.doc-line.doc-code
                    and ub.parts-root.gds-code  = ub.goods.gds-code
                    :
                    delete ub.parts-root.
                end.

                /* удал€ем информацию по произведенным товарам */
                for each ub.doc-fbr-gds exclusive-lock
                    where ub.doc-fbr-gds.out-code = ub.doc-line.doc-code
                    and ub.doc-fbr-gds.gds-code = ub.goods.gds-code
                    :
                    delete ub.doc-fbr-gds.
                end.

                for each ub.stk-line exclusive-lock where ub.stk-line.artic = ub.doc-line.artic and
                    ub.stk-line.prod-code = ub.doc-line.prod-code and
                    ub.stk-line.prod-type = ub.doc-line.prod-type and
                    ub.stk-line.obj-code = ub.doc-line.obj-code and
                    ub.stk-line.obj-type = ub.doc-line.obj-type and
                    ub.stk-line.fact-order >= ub.doc-line.fact-order :
                    delete ub.stk-line .
                end.
                for each     ub.gds-obj exclusive-lock where
                    ub.gds-obj.artic = ub.doc-line.artic and
                    ub.gds-obj.prod-type = ub.doc-line.prod-type and
                    ub.gds-obj.prod-code = ub.doc-line.prod-code
                    :
                    ub.gds-obj.fact-qnty = ub.gds-obj.fact-qnty - qnty .
                    ub.gds-obj.free-qnty = ub.gds-obj.free-qnty - qnty .
                    ub.gds-obj.fact-cli-qnty = ub.gds-obj.fact-qnty .
                end.
                for each ub.prt-obj exclusive-lock where ub.prt-obj.artic = ub.doc-line.artic and
                    ub.prt-obj.prod-code = ub.doc-line.prod-code and
                    ub.prt-obj.prod-type = ub.doc-line.prod-type and
                    ub.prt-obj.obj-code = ub.doc-line.obj-code and
                    ub.prt-obj.obj-type = ub.doc-line.obj-type :
                    ub.prt-obj.fact-qnty = ub.prt-obj.fact-qnty - qnty .
                    ub.prt-obj.free-qnty = ub.prt-obj.free-qnty - qnty .
                end.
                delete doc-line .
            end. /* main-block */
        end.
    end.  
    message "√отово!"
        view-as alert-box.   
end. 



   


   
