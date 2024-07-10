procedure putc-61 :
/*  define parameter buffer buf_cash-desk for ub.cash-desk.                 */
/*  define input parameter par-cash-num like ub.cash-desk.cash-num no-undo .*/
/*  define input parameter p-pos-version like ub.cash-desk.version no-undo .*/
  define variable v-value              as character no-undo .
  define variable v-type               as character no-undo .
  define variable v-index              as integer   no-undo .
  define variable v-ii                 as integer   no-undo .
  define variable v-jj                 as integer   no-undo .
  define variable v-plu                as character no-undo .
  define variable v-dop                as character no-undo .
  define variable v-dop2               as character no-undo .
  define variable v-cp-attr-code       as character no-undo .
  define variable attr-value           as character no-undo .
  define variable attr-type            as character no-undo .
  define variable v-maria-rule-num     as integer   no-undo .
  define variable v-maria-discnt-value as character no-undo .
  define variable v-skip-fields        as integer   no-undo .
  define variable v-version-dec        as decimal   no-undo .
  define variable v-paymentetc         as character no-undo .
  define buffer BUF_DIS-RULE      for UB.DIS-RULE.
  define buffer buf_dis-cp-rule   for ub.dis-cp-rule.
  define buffer buf_cash-pay-attr for ub.cash-pay-attr.

  define variable v-mode      as character no-undo . /* create/update */
  define variable v-retfl     as logical   no-undo .
      
  define variable v-i-num     as integer   no-undo .
  define variable v-i-counter as integer   no-undo .
  define variable v-j-num     as integer   no-undo .
  define variable v-j-counter as integer   no-undo .
  define variable v-stub      as integer   no-undo .
  define variable vTypePay    as character no-undo.
  define variable vIp         as integer   no-undo.
  define VARIABLE name-cash as character no-undo.
define VARIABLE name-cash1 as character no-undo.
define VARIABLE name-cash2 as character no-undo.
define variable ufo-passwd as character no-undo.
define variable ufo-enc20  as character format "x(20)" no-undo.
define variable enc-passwd as character no-undo.
define variable v-psswd as character no-undo .
/* 23/V-2018 на время input throught ... появляется консольное окно;
             вместо этого делаем os-command no-console ... с выводом в файл */
define variable v-shadow-fname as character no-undo .
define buffer buf_clients for ub.clients .

  define variable v-attr-type as character no-undo .
  do
    on error undo, return error
    :
    if selective = 0 then 
    do:
    end.
    else 
    do:
      do ii = 0 to num-entries(recid-list,{&comma-char}):
        FIND FIRST ub.staff-attr No-LOCK WHERE
          recid(ub.staff-attr) = integer(entry(ii,recid-list,{&comma-char})) No-ERROR.
        IF avail ub.staff-attr then
        do:
    v-shadow-fname = substitute( "pass&1.dat" , string(random(1, 80000), "99999") ) .

      find first ub.person where ub.person.cashier = ub.staff-attr.staff-code no-error.

      run bgelib-tag-open in this-procedure ( input 2, input "Cashier", input substitute("ctrl='&1' tms='&2' code='&3'"
                                                                                          , (if action = "U":U
                                                                                             then "ADD":U
                                                                                             else "DEL":U)
                                                                                          , OS2-time
                                                                                          , if ub.person.cashier eq ? then "*" else string(ub.person.cashier))).
if available ub.person
then do:                       
            find FIRST buf_clients no-lock WHERE
                  buf_clients.obj-type = {&prs}
              AND buf_clients.obj-code = ub.person.psn-code no-error .                                                            
name-cash1 = if ub.person.name1 <> "" then (substring(ub.person.name1,1,1) + '.') else ''.
name-cash2 = if ub.person.name2 <> "" then (substring(ub.person.name2,1,1) + '.') else ''.
name-cash = buf_clients.obj-name + ' ' + name-cash1 + ' ' + name-cash2 .
end.
enc-passwd = "".
ufo-passwd = search('exe/ufo_passwd.exe':u).
if ufo-passwd > "" then do:
  os-command silent value(ufo-passwd) value(v-psswd) > value(v-shadow-fname) .
  input stream finp from value(v-shadow-fname) .
  repeat:
    import stream finp unformatted ufo-enc20 no-error.
    enc-passwd = enc-passwd + ufo-enc20.
  end.
  input stream finp close.
  os-delete value(v-shadow-fname).
end.

      run bgelib-tag-put in this-procedure ( input 3, input "CashierName"         , input name-cash, input 1 ).
      run bgelib-tag-put in this-procedure ( input 3, input "CashierParol"        , input v-psswd, input 1 ).
      run bgelib-tag-put in this-procedure ( input 3, input "CashierLock"         , input "1", input 1 ).
      run bgelib-tag-put in this-procedure ( input 3, input "CashierINN"          , input if available person then string(person.inn) else "", input 1 ).
      run bgelib-tag-put in this-procedure ( input 3, input "CashierShadow"       , input enc-passwd, input 1 ).
      run bgelib-tag-put in this-procedure ( input 3, input "CashierQRCode"       , input ub.staff-attr.attr-value, input 1 ).
      run bgelib-tag-close in this-procedure ( input 2, input "Cashier").
    END.
        end.
      END.
    end.

end procedure. /* putc-61 */