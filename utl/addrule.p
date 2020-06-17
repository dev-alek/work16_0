define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo init "Досоздание параметров". 
define var parparentproc as handle no-undo.
{cmp\str-glbl.i}
{ cmp/library.i }
{gbl/key-rec.i}
{rul/calldscr.i}
define temp-table tt0-rp-by-call no-undo like ub.rp-by-call.
define temp-table tt0-rule-by-call no-undo like ub.rule-by-call.
define temp-table tt0-rule-call-param no-undo like ub.rule-call-param.
define temp-table tt2-rule-call-param no-undo like ub.rule-call-param.
{adm/thbj-rum.i}

define variable v-order-id as integer no-undo.
define variable v-once-more as integer no-undo.
define variable v-uniq-key-rec as character no-undo.
define variable v-found-can-calc as logical no-undo.
define buffer ruledict2 for ruledict.
define buffer ruledict-param2 for ruledict-param.
v-uniq-key-rec = substitute("thbj-attr&1&10&1rum&1edoc",{&delim-key}) .
run thbj-rum_FILL-table in THIS-PROCEDURE ({&edoc},
                                                {&update},
                                                no,
                                                v-uniq-key-rec) no-error.
find first rule-profile no-lock where
          rule-profile.profile_id = 93.
find last rp-by-call no-lock where
          rp-by-call.call_id = v-uniq-key-rec
      and rp-by-call.profile_id = rule-profile.profile_id no-error.
if available rp-by-call then do:
  v-once-more = rp-by-call.once-more.
end.


for each rule-by-profile no-lock where
        rule-by-profile.profile_id = rule-profile.profile_id
by rule-by-profile.profile_id
by rule-by-profile.codex_id
by rule-by-profile.ruleset_id
by rule-by-profile.rp_order_id
on error undo, return error :
   if rule-profile.profile-type <> {&cmb} 
   then do:
      find first rule no-lock where
                rule.RULE_id = rule-by-profile.RULE_id no-error.
      if not available rule 
      then do:
         undo, return error
            substitute("Не найдено правило &1, которое должно быть подключено по алгоритму &2&3" +
                   "кодекс правил &4, свод правил &5"
                   , rule-by-profile.RULE_id
                   , rule-by-profile.profile_id
                   , {&NEW-LINE}
                   , rule-by-profile.codex_id
                   , rule-by-profile.ruleset_id).
      end.
      find last rule-by-call where
            rule-by-call.codex_id =  rule-by-profile.codex_id
        and rule-by-call.ruleset_id = rule-by-profile.ruleset_id
      use-index imain no-error.
      if available rule-by-call then do:
         v-order-id = rule-by-call.order_id + 1.
      end.
      else do:
         v-order-id = 0.
      end.
      define variable v-call#-id as integer no-undo.
      run rul/g-callid.p ( input "edoc",
                           entry(1, v-uniq-key-rec, {&delim-par} ),
                           output v-call#-id).
      
      find first rule-by-call where rule-by-call.call#_id eq v-call#-id
                                and rule-by-call.codex_id eq  rule-by-profile.codex_id
                                and rule-by-call.ruleset_id eq rule-by-profile.ruleset_id
      no-lock no-error.
      if not available rule-by-call
      then do:
     
         create tt0-rule-by-call.
         buffer-copy rule-by-profile to tt0-rule-by-call. 
         assign
            tt0-rule-by-call.call#_id = v-call#-id
            tt0-rule-by-call.order_id = v-order-id
            tt0-rule-by-call.algo-des = substitute("Профайл &1. &2", rule-profile.profile_id, rule.NAME)
            tt0-rule-by-call.is_dynamic = rule-by-profile.IS_dynamic
            tt0-rule-by-call.can-calc =  yes /*(if not tt0-rule-by-call.is_dynamic
                                      or (tt0-rule-by-call.codex_id = 22
                                          and
                                          tt0-rule-by-call.ruleset_id = 1)
                                        then yes
                                        else no)*/
            tt0-rule-by-call.call_id = entry(1, v-uniq-key-rec, {&delim-par} )
  
            tt0-rule-by-call.once-more = v-once-more 
         .
      end.
      else do:
         for each tt0-rule-by-call where tt0-rule-by-call.codex_id eq  rule-by-profile.codex_id
                                      and tt0-rule-by-call.ruleset_id eq rule-by-profile.ruleset_id
         :
            tt0-rule-by-call.can-calc =  yes.
         end.
      end.
      
     /* v-found-can-calc = v-found-can-calc or rule-by-call.can-calc . */
  
      find first ruledict no-lock where
               ruledict.entry-type = {&rdict-etype-rule}
         and   ruledict.uniq-key-rec = rule.uniq-key-rec.
      define variable v-rule-profile-uniq-key-rec as character no-undo.
      run gen-key-rec in this-procedure (
                                        input  {&table_rule-profile}
                                       ,input buffer rule-profile:handle
                                       ,output v-rule-profile-uniq-key-rec).
      find first ruledict2 no-lock where
                 ruledict2.entry-type = {&rdict-etype-rule-profile}
           and  ruledict2.uniq-key-rec = v-rule-profile-uniq-key-rec.
      for each ruledict-param no-lock where
               ruledict-param.entry-id = ruledict.entry-id
      on error undo, return error:
         find first rp-rule-param no-lock where
                    rp-rule-param.profile_id = rule-profile.profile_id
                and rp-rule-param.rule-param-name = ruledict-param.param-name
                and rp-rule-param.codex_id = rule-by-profile.codex_id
                and rp-rule-param.ruleset_id = rule-by-profile.ruleset_id
                and rp-rule-param.rule_id = rule-by-profile.rule_id
                and rp-rule-param.rp_order_id = rule-by-profile.rp_order_id.
         find first ruledict-param2 no-lock where
                    ruledict-param2.entry-id = ruledict2.entry-id
                and ruledict-param2.param-name = rp-rule-param.rp-param-name.
         find first rule-call-param where
                  rule-call-param.call#_id = rule-by-call.call#_id
            and   rule-call-param.codex_id = rule-by-call.codex_id
            and rule-call-param.ruleset_id = rule-by-call.ruleset_id
            and rule-call-param.call_id  = rule-by-call.call_id
            and rule-call-param.order_id = rule-by-call.order_id
      
            and rule-call-param.param-name = ruledict-param.param-name
            and rule-call-param.p-index = 0
         no-lock no-error.
         if not available rule-call-param
         then do:
            if available rule-by-call
            then do:
               create tt0-rule-call-param.
               assign
                  tt0-rule-call-param.call#_id = rule-by-call.call#_id
                  tt0-rule-call-param.codex_id = rule-by-call.codex_id
                  tt0-rule-call-param.ruleset_id = rule-by-call.ruleset_id
                  tt0-rule-call-param.call_id  = rule-by-call.call_id
                  tt0-rule-call-param.order_id = rule-by-call.order_id
                  tt0-rule-call-param.rule_id = rule.rule_id
                  tt0-rule-call-param.param-name = ruledict-param.param-name
                  tt0-rule-call-param.p-index = 0
                  tt0-rule-call-param.param-des = ruledict-param.documentation
                  tt0-rule-call-param.param-num = ruledict-param.param-num
                  tt0-rule-call-param.param-label = ruledict-param.param-label
                  tt0-rule-call-param.param-mode = ruledict-param.param-mode
                  tt0-rule-call-param.param-data-type = ruledict-param.param-data-type
                  tt0-rule-call-param.param-2-data-type = ruledict-param.param-2-data-type
                  tt0-rule-call-param.param-3-data-type = ruledict-param.param-3-data-type
                  tt0-rule-call-param.param-value-character = ruledict-param2.init-value-character
                  tt0-rule-call-param.param-value-date = ruledict-param2.init-value-date
                  tt0-rule-call-param.param-value-decimal = ruledict-param2.init-value-decimal
                  tt0-rule-call-param.param-value-integer = ruledict-param2.init-value-integer
                  tt0-rule-call-param.param-value-logical = ruledict-param2.init-value-logical
                  tt0-rule-call-param.profile_id          = rule-by-call.profile_id
                  tt0-rule-call-param.once-more           = rule-by-call.once-more
               .
               if ruledict-param.param-2-data-type = "r-b" then do:
                  define variable v-curr-r-b as character no-undo.
                  { gbl/curr-r-b.i v-curr-r-b }
                  tt0-rule-call-param.param-value-character = (if v-curr-r-b = {&r-b-rubl}
                                                          then {&r-b-rubl}
                                                          else {&r-b-base}).
               end.
            end.
            else do:
               create tt0-rule-call-param.
               assign
                  tt0-rule-call-param.call#_id = tt0-rule-by-call.call#_id
                  tt0-rule-call-param.codex_id = tt0-rule-by-call.codex_id
                  tt0-rule-call-param.ruleset_id = tt0-rule-by-call.ruleset_id
                  tt0-rule-call-param.call_id  = tt0-rule-by-call.call_id
                  tt0-rule-call-param.order_id = tt0-rule-by-call.order_id
                  tt0-rule-call-param.rule_id = rule.rule_id
                  tt0-rule-call-param.param-name = ruledict-param.param-name
                  tt0-rule-call-param.p-index = 0
                  tt0-rule-call-param.param-des = ruledict-param.documentation
                  tt0-rule-call-param.param-num = ruledict-param.param-num
                  tt0-rule-call-param.param-label = ruledict-param.param-label
                  tt0-rule-call-param.param-mode = ruledict-param.param-mode
                  tt0-rule-call-param.param-data-type = ruledict-param.param-data-type
                  tt0-rule-call-param.param-2-data-type = ruledict-param.param-2-data-type
                  tt0-rule-call-param.param-3-data-type = ruledict-param.param-3-data-type
                  tt0-rule-call-param.param-value-character = ruledict-param2.init-value-character
                  tt0-rule-call-param.param-value-date = ruledict-param2.init-value-date
                  tt0-rule-call-param.param-value-decimal = ruledict-param2.init-value-decimal
                  tt0-rule-call-param.param-value-integer = ruledict-param2.init-value-integer
                  tt0-rule-call-param.param-value-logical = ruledict-param2.init-value-logical
                  tt0-rule-call-param.profile_id          = tt0-rule-by-call.profile_id
                  tt0-rule-call-param.once-more           = tt0-rule-by-call.once-more
               .
               if ruledict-param.param-2-data-type = "r-b" then do:
                
                  { gbl/curr-r-b.i v-curr-r-b }
                  tt0-rule-call-param.param-value-character = (if v-curr-r-b = {&r-b-rubl}
                                                          then {&r-b-rubl}
                                                          else {&r-b-base}).
               end.
            end.
         end.
      end.
      
           
   end. /*if buf2_rule-profile.profile-type <> {&cmb} then do*/
   
end. /*FOR EACH buf_rule-by-profile NO-LOCK WHERE*/
   
define buffer buf3_rule-call-param for rule-call-param.
   define buffer buf2_rule-call-param for tt0-rule-call-param.
   define buffer buf_rule-call-param for rule-call-param.
   define buffer buf_rp-rule-param for rp-rule-param.
   define variable v-ind as integer no-undo.
        
   for each buf3_rule-call-param where
                buf3_rule-call-param.profile_id = rule-profile.profile_id

         /* and buf3_rule-call-param.param-num = rule-call-param.param-num */
   no-lock:
      if      (lookup("LIST", buf3_rule-call-param.param-3-data-type) > 0
         or
              lookup("SORTED-LIST", buf3_rule-call-param.param-3-data-type) > 0
         )
         and buf3_rule-call-param.p-index > 0 
      then do:
         v-ind = buf3_rule-call-param.p-index.

         for each buf_rp-rule-param where
               buf_rp-rule-param.rp-param-name = buf3_rule-call-param.param-name
         and buf_rp-rule-param.profile_id = buf3_rule-call-param.profile_id
               on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
               on stop   undo, return error substitute( "&1. stop", vss-workfile )
               on endkey undo, return error substitute( "&1. endkey", vss-workfile )
         :
            find first buf_rule-call-param where
                       buf_rule-call-param.call_id = v-uniq-key-rec
                     and buf_rule-call-param.profile_id = buf_rp-rule-param.profile_id
                     and buf_rule-call-param.codex_id = buf_rp-rule-param.codex_id
                     and buf_rule-call-param.ruleset_id = buf_rp-rule-param.ruleset_id
                     and buf_rule-call-param.rule_id = buf_rp-rule-param.rule_id
                     and buf_rule-call-param.param-name = buf_rp-rule-param.rule-param-name
                     and buf_rule-call-param.once-more = buf3_rule-call-param.once-more 
                     and buf_rule-call-param.p-index = v-ind no-error.
            if not avail buf_rule-call-param
            then do:
               find first buf_rule-call-param where
                        buf_rule-call-param.call_id = v-uniq-key-rec
                     and buf_rule-call-param.profile_id = buf_rp-rule-param.profile_id
                     and buf_rule-call-param.codex_id = buf_rp-rule-param.codex_id
                     and buf_rule-call-param.ruleset_id = buf_rp-rule-param.ruleset_id
                     and buf_rule-call-param.rule_id = buf_rp-rule-param.rule_id
                     and buf_rule-call-param.param-name = buf_rp-rule-param.rule-param-name
                     and buf_rule-call-param.once-more = buf3_rule-call-param.once-more
                     and buf_rule-call-param.p-index = 0.
               find first buf2_rule-call-param where
                       buf2_rule-call-param.call_id = v-uniq-key-rec
                     and buf2_rule-call-param.profile_id = buf_rp-rule-param.profile_id
                     and buf2_rule-call-param.codex_id = buf_rp-rule-param.codex_id
                     and buf2_rule-call-param.ruleset_id = buf_rp-rule-param.ruleset_id
                     and buf2_rule-call-param.rule_id = buf_rp-rule-param.rule_id
                     and buf2_rule-call-param.param-name = buf_rp-rule-param.rule-param-name
                     and buf2_rule-call-param.once-more = buf3_rule-call-param.once-more 
                     and buf2_rule-call-param.p-index = v-ind no-error.
               if not avail buf2_rule-call-param
               then do:
                  create buf2_rule-call-param.
                  buffer-copy buf_rule-call-param
                  except p-index
                  to buf2_rule-call-param
                  assign
                     buf2_rule-call-param.p-index = v-ind
                  .
   
                  run set-value in THIS-PROCEDURE (
                                       input buf2_rule-call-param.profile_id
                                      ,input buf2_rule-call-param.once-more
                                      ,input buf_rp-rule-param.rp-param-name
                                      ,input buf2_rule-call-param.call_id
                                      ,input buf2_rule-call-param.codex_id
                                      ,input buf2_rule-call-param.ruleset_id
                                      ,input buf2_rule-call-param.order_id
                                      ,input buf2_rule-call-param.param-name
                                      ,input buf2_rule-call-param.p-index
                                      ,input buf3_rule-call-param.param-value-character
                                      ,input buf3_rule-call-param.param-value-date
                                      ,input buf3_rule-call-param.param-value-decimal
                                      ,input buf3_rule-call-param.param-value-integer
                                      ,input buf3_rule-call-param.param-value-logical).
                                       
          
               end.
            end.
         end.
      end.
   end.   
          
procedure set-value :
define input parameter p-profile-id as integer no-undo.
define input parameter p-once-more as integer no-undo.
define input parameter p-rp-param-name as character no-undo.
define input parameter p-call-id as character no-undo.
define input parameter p-codex-id as integer no-undo.
define input parameter p-ruleset-id as integer no-undo.
define input parameter p-order-id as integer no-undo.
define input parameter p-param-name as character no-undo.
define input parameter p-index as integer no-undo.
define input parameter p-value-character as character no-undo.
define input parameter p-value-date as date no-undo.
define input parameter p-value-decimal as decimal no-undo.
define input parameter p-value-integer as integer no-undo.
define input parameter p-value-logical as logical no-undo.
define buffer buf_tt-rule-call-param for tt0-rule-call-param.
define buffer buf_rp-rule-param for ub.rp-rule-param.
/*CASE p-list-mode:
  WHEN {&TABLE_rp-rule-param} THEN DO:*/
      for each  buf_rp-rule-param no-lock where
          buf_rp-rule-param.profile_id = p-profile-id
          and buf_rp-rule-param.rp-param-name = p-rp-param-name
      ,each buf_tt-rule-call-param where
             buf_tt-rule-call-param.profile_id = p-profile-id
          and buf_tt-rule-call-param.once-more = p-once-more
          and buf_tt-rule-call-param.call_id = p-CALL-id
          and buf_tt-rule-call-param.codex_id = buf_rp-rule-param.codex_id
          and buf_tt-rule-call-param.ruleset_id = buf_rp-rule-param.ruleset_id
          and buf_tt-rule-call-param.rule_id = buf_rp-rule-param.rule_id
          and buf_tt-rule-call-param.param-name = buf_rp-rule-param.rule-param-name
          and buf_tt-rule-call-param.p-index = p-index
        on error undo, return error :

          assign
          buf_tt-rule-call-param.param-value-character = p-value-character
          buf_tt-rule-call-param.param-value-date      = p-value-date
          buf_tt-rule-call-param.param-value-decimal   = p-value-decimal
          buf_tt-rule-call-param.param-value-integer   = p-value-integer
          buf_tt-rule-call-param.param-value-logical   = p-value-logical
          .

      end.
  /* END.
  WHEN {&TABLE_rule-call-param} THEN DO:
    FIND FIRST buf_tt-rule-call-param WHERE
        buf_tt-rule-call-param.call_id = p-call-id
    AND buf_tt-rule-call-param.codex_id = p-codex-id
    AND buf_tt-rule-call-param.ruleset_id = p-ruleset-id
    AND buf_tt-rule-call-param.order_id = p-order-id
    AND buf_tt-rule-call-param.param-name = p-param-name
    AND buf_tt-rule-call-param.p-index = p-index.
    assign
    buf_tt-rule-call-param.param-value-character = p-value-character
    buf_tt-rule-call-param.param-value-date      = p-value-date
    buf_tt-rule-call-param.param-value-decimal   = p-value-decimal
    buf_tt-rule-call-param.param-value-integer   = p-value-integer
    buf_tt-rule-call-param.param-value-logical   = p-value-logical
    .

  END.
END CASE. */
end procedure.

 run rul/thbjrum1.p (
                 input {&update}
                ,input {&edoc}
                ,input v-uniq-key-rec
                ,input 0
                ,input "":U
                ,input 0
                ,input yes
                ,input TABLE tt0-rp-by-call
                ,input TABLE tt0-rule-by-call
                ,input TABLE tt0-rule-call-param) no-error . 
                /*run rul/ruprcall.p ( input {&edoc}
                        ,input v-uniq-key-rec
                        ,input (/* {&table_rp-by-call} + {&comma-char} + {&table_rule-by-call} + {&comma-char} + */ {&table_rule-call-param}) /*p-data-completeness*/
                        ,input ? /*p-cmd-proc-handle*/  /*cmd-bush вызоывем внутри*/
                        ,input 0
                        ,INPUT TABLE tt0-rp-by-call
                        ,INPUT TABLE tt0-rule-by-call
                        ,INPUT TABLE tt0-rule-call-param) no-error . */
if error-status:error then do:

if return-value <> '':U then do:
  message
  error-status:get-message(1)
  return-value
  view-as alert-box .
end.
end.
          