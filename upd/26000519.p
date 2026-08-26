block-level on error undo, throw.
{ cmp/trg-def.i  }
define input  parameter parparentproc as handle no-undo.
define input  parameter iparam        as character no-undo.
define output parameter oOk           as logical no-undo.

define temp-table x_thbj-attr no-undo like ub.thbj-attr.

function ThbjattrCr return logical
    (input p-prop-code as character,
     input p-prop-val as character,
     input p-prop-type as character):
     
    define variable vOk as logical no-undo.    
    define buffer thbj-attr for ub.thbj-attr.         
    vOk = true.
    do trans:          
        for each x_thbj-attr:
            find first thbj-attr where thbj-attr.upper-prop-code eq {&attr-gisMT}
                                 and thbj-attr.obj-type        eq x_thbj-attr.obj-type
                                 and thbj-attr.obj-code        eq x_thbj-attr.obj-code
                                 and thbj-attr.prop-code       eq p-prop-code                          
            exclusive-lock no-wait no-error.
            if not available thbj-attr and
               not locked thbj-attr 
            then do:
               create thbj-attr.
               assign
                  thbj-attr.obj-type = x_thbj-attr.obj-type
                  thbj-attr.obj-code  = x_thbj-attr.obj-code
                  thbj-attr.upper-prop-code = {&attr-gisMT}
                  thbj-attr.prop-code = p-prop-code 
                  thbj-attr.prop-value-type = p-prop-type
                  . 
               case p-prop-type:
                   when "character"
                      then thbj-attr.property-value-character = p-prop-val.
                   when "decimal"
                      then  thbj-attr.property-value-decimal = decimal(p-prop-val).
                   when "logical"     
                      then  thbj-attr.property-value-logical = logical(p-prop-val).
               end.   
            end.
           /* else if locked thbj-attr then vOk = false.*/
        end.
    end.
    return vOk.
end.

PROCEDURE ObjCodeList:
   define buffer buf_thbj-attr for ub.thbj-attr.
   for each buf_thbj-attr no-lock where                           
            buf_thbj-attr.upper-prop-code = {&attr-gisMT}
        and buf_thbj-attr.prop-code       = '' :
      if buf_thbj-attr.obj-type = {&db} or 
         (buf_thbj-attr.obj-type = "" and x_thbj-attr.obj-code = 0)
      then do:         
          find first x_thbj-attr where
              x_thbj-attr.obj-type = buf_thbj-attr.obj-type and
              x_thbj-attr.obj-code = buf_thbj-attr.obj-code no-error .
    
          if not available x_thbj-attr then do:
            create  x_thbj-attr.
            buffer-copy buf_thbj-attr to X_thbj-attr.        
          end.    
      end.
   end.          
END PROCEDURE. 

if g#db-num <> 0 then do:
   /* запускаем выгрузку параметров на кассу */
   run str/diallog.w (
        input parparentproc
      , input this-procedure
      , input "str/sendgismt.p":U
      , input ( {&db} + {&delim-par} + string(g#db-num) + {&delim-par} + 'U':U + {&delim-par} + 'gismt':U + {&delim-par} + 'Передача настроек для проверки КМ':U)
      , input ? /*p-auto-go*/
      , input "":U
      , input substitute("Отсылка настроек для проверки КМ")
  ) no-error.
   oOk = yes.
   return.
end.   
/* собираем список локальных секций */
run ObjCodeList.

/* Ищем в секции параметр и создаем, если его нет */
oOk = ThbjattrCr({&attr-gisMT_MACC_Timeout},"0","decimal").
if oOk then 
oOk = ThbjattrCr ({&attr-gisMT_Resp_TH_required},"yes","logical").
if oOk then 
oOk = ThbjattrCr({&attr-gisMT_TH_IP},"","character").
if oOk then 
oOk = ThbjattrCr({&attr-gisMT_TH_Port},"1500","character").
if oOk then 
oOk = ThbjattrCr({&attr-gisMT_LmCHzPort},"5995","character").
if oOk then 
oOk = ThbjattrCr({&attr-gisMT_AddTimeoutPIoT},"1","character").


  
