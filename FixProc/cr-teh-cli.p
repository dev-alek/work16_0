{ cmp/str-glbl.i }
{ utl/runpro.i }
{ ref/cgrplbfn.i }

on write of ub.clients override do: end.
on write of ub.firm override do: end.

define variable v-name as character no-undo.

run cli-grplib-get-full-name in this-procedure (input 5, output v-name) .

do transaction:
   find first clients where
              clients.obj-type = {&cmp}
          and clients.obj-code = 800000001
   no-lock no-error.
   if not avail clients then do:
      create clients.
      assign
        clients.obj-type = {&cmp}
        clients.obj-code = 800000001 /* для контрагента РЕАЛИЗАЦИЯ согласован код 800 000 001 */
        clients.obj-name = "Реализация розничная"
        clients.stts     = 0
        clients.grp-code = 5 
        clients.grp-name = v-name
      .
   end.
   find first firm where
              firm.firm-code = 800000001
   no-lock no-error.
   if not avail firm then do:
      create firm.
      assign
        firm.firm-code = 800000001
        firm.ind       = 0 /* firm.ind на тестовом сервере 0 в формате "6-знаков" */
      .
   end.
   
   find first clients where
              clients.obj-type = {&cmp}
          and clients.obj-code = 800000002
   no-lock no-error.
   if not avail clients then do:
      create clients.
      assign
        clients.obj-type = {&cmp}
        clients.obj-code = 800000002
        clients.obj-name = "Технологический пролив"
        clients.stts     = 0
        clients.grp-code = 5
        clients.grp-name = v-name
      .
   end.
   find first firm where
              firm.firm-code = 800000002
   no-lock no-error.
   if not avail firm then do:
      create firm.
      assign
        firm.firm-code = 800000002
        firm.ind       = 0
      .
   end.
   
   find first clients where
              clients.obj-type = {&cmp}
          and clients.obj-code = 800000003
   no-lock no-error.
   if not avail clients then do:
      create clients.
      assign
        clients.obj-type = {&cmp}
        clients.obj-code = 800000003
        clients.obj-name = "Отбор проб"
        clients.stts     = 0
        clients.grp-code = 5
        clients.grp-name = v-name
      .
   end.
   find first firm where
              firm.firm-code = 800000003
   no-lock no-error.
   if not avail firm then do:
      create firm.
      assign
        firm.firm-code = 800000003
        firm.ind       = 0
      .
   end.
   
   find first clients where
              clients.obj-type = {&cmp}
          and clients.obj-code = 800000004
   no-lock no-error.
   if not avail clients then do:
      create clients.
      assign
        clients.obj-type = {&cmp}
        clients.obj-code = 800000004
        clients.obj-name = "Программа лояльности"
        clients.stts     = 0
        clients.grp-code = 5
        clients.grp-name = v-name
      .
   end.
   find first firm where
              firm.firm-code = 800000004
   no-lock no-error.
   if not avail firm then do:
      create firm.
      assign
        firm.firm-code = 800000004
        firm.ind       = 0
      .
   end.
   
   find first clients where
              clients.obj-type = {&cmp}
          and clients.obj-code = 800000005
   no-lock no-error.
   if not avail clients then do:
      create clients.
      assign
        clients.obj-type = {&cmp}
        clients.obj-code = 800000005
        clients.obj-name = "Ввод первоначальных остатков"
        clients.stts     = 0
        clients.grp-code = 5
        clients.grp-name = v-name
      .
   end.
   find first firm where
              firm.firm-code = 800000005
   no-lock no-error.
   if not avail firm then do:
      create firm.
      assign
        firm.firm-code = 800000005
        firm.ind       = 0
      .
   end.
   
   find first clients where
              clients.obj-type = {&cmp}
          and clients.obj-code = 800000006
   no-lock no-error.
   if not avail clients then do:
      create clients.
      assign
        clients.obj-type = {&cmp}
        clients.obj-code = 800000006
        clients.obj-name = 'Банк "ВБРР" АО'
        clients.stts     = 0
        clients.grp-code = 5
        clients.grp-name = v-name
      .
   end.
   find first firm where
              firm.firm-code = 800000006
   no-lock no-error.
   if not avail firm then do:
      create firm.
      assign
        firm.firm-code = 800000006
        firm.ind       = 0
      .
   end.
   
   find first clients where
              clients.obj-type = {&cmp}
          and clients.obj-code = 800000007
   no-lock no-error.
   if not avail clients then do:
      create clients.
      assign
        clients.obj-type = {&cmp}
        clients.obj-code = 800000007
        clients.obj-name = "Банк ВБРР (агентская выручка)"
        clients.stts     = 0
        clients.grp-code = 5
        clients.grp-name = v-name
      .
   end.
   find first firm where
              firm.firm-code = 800000007
   no-lock no-error.
   if not avail firm then do:
      create firm.
      assign
        firm.firm-code = 800000007
        firm.ind       = 0
      .
   end.
   
   find first clients where
              clients.obj-type = {&cmp}
          and clients.obj-code = 800000008
   no-lock no-error.
   if not avail clients then do:
      create clients.
      assign
        clients.obj-type = {&cmp}
        clients.obj-code = 800000008
        clients.obj-name = "Перемещение денежных средств"
        clients.stts     = 0
        clients.grp-code = 5
        clients.grp-name = v-name
      .
   end.
   find first firm where
              firm.firm-code = 800000008
   no-lock no-error.
   if not avail firm then do:
      create firm.
      assign
        firm.firm-code = 800000008
        firm.ind       = 0
      .
   end.
   
   find first clients where
              clients.obj-type = {&cmp}
          and clients.obj-code = 800000009
   no-lock no-error.
   if not avail clients then do:
      create clients.
      assign
        clients.obj-type = {&cmp}
        clients.obj-code = 800000009
        clients.obj-name = "Выдача наличных денежных средств"
        clients.stts     = 0
        clients.grp-code = 5
        clients.grp-name = v-name
      .
   end.
   find first firm where
              firm.firm-code = 800000009
   no-lock no-error.
   if not avail firm then do:
      create firm.
      assign
        firm.firm-code = 800000009
        firm.ind       = 0
      .
   end.
end.