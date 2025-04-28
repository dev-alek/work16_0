 
 /*------------------------------------------------------------------------
    File        : usertable
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : svvtm
    Created     : Tue Nov 19 21:04:13 MSK 2024
    Notes       : 
  ----------------------------------------------------------------------*/
USING Progress.Lang.*.
using ibs.th.ref.sobj.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ibs.th.ref.sobj.usertable :
    
 { cmp/str-glbl.i class}
 { gbl/getcntxt.i def }
 { cmp/library.i class }
 { cmp/obj-list.i class } /* obj-list s*/
 {rep/tt-user.i} 

/* define temp-table tt-objects  no-undo 
field name_ as character
field table_ as character
field flg    as logical  LABEL "*" format ""
.
define temp-table tt-user-account no-undo
field user-id_  as character LABEL "ID"  
field user_name as character LABEL "Имя пользователя"  
field db-num    as integer   LABEL "БД "  
field flg       as logical   LABEL "*" format ""
index pi db-num user-id_
.
*/ 

define variable v-user-table-name as character no-undo .
define variable v-user-table      as character no-undo .
define variable v-table           as character no-undo .
/*define variable x-Date-Start as date  no-undo. */ 
/* define variable x-Date-End   as date  no-undo. */
DEFINE        VARIABLE mform  AS CLASS ibs.th.ref.sobj.userhist no-undo.

               
define property query_user-table as handle no-undo 
  public get.
  public set.
  
define property query_user-account as handle no-undo 
  public get.
  public set.                  
  
constructor public usertable (iform as class ibs.th.ref.sobj.userhist ):

super().
mform = iform.
  create query query_user-table.                    
               query_user-table:set-buffers(buffer tt-objects:HANDLE). 
               query_user-table:query-prepare("FOR EACH tt-objects").
               query_user-table:query-open.

  create query query_user-account.                    
               query_user-account:set-buffers(buffer tt-user-account:HANDLE). 
               query_user-account:query-prepare("FOR EACH tt-user-account").
               query_user-account:query-open.
               
for each user-obj  ,
      each ub.user-account no-lock where ub.user-account.user-id = user-obj.user-id: 
      create tt-user-account .
      assign
      tt-user-account.db-num    = user-obj.db-num /* obj-code*/ 
      tt-user-account.user-id_  = ub.user-account.user-id
      tt-user-account.user_name = "ID: " + ub.user-account.user-id 
                              + " ФИО: " + user-account.last-name 
                              + " "      + user-account.first-name 
                              + " "      + user-account.second-name
                              .
end. 

for each c-user-log no-lock 
/*     where c-user-log.corr-date >= mform:ParamObj:x-Date-Start and c-user-log.corr-date <= mform:ParamObj:x-Date-End */
    by c-user-log.head-table :
    v-table = c-user-log.head-table .
    if v-table begins "c-" /* and v-table <> {&table_c-usr-hist} and v-table <> {&table_c-plc-hist}  */
     then  do:
         v-user-table = replace(v-table,"c-","").
     end.
     else v-user-table = v-table .    
     find first tt-objects where tt-objects.table_ = v-user-table no-error .
     if not AVAILABLE (tt-objects) then 
        do:
           { gbl/tblnmusr.i
            v-user-table
            v-user-table-name
          } 
        create tt-objects .
            assign
            tt-objects.table_ = v-user-table 
            tt-objects.name_  = v-user-table-name
            .    
     end.
 
end.
                    
               
end constructor.

METHOD public void init_tt(): 

/* qqq = new ibs.th.ref.sobj.sParamForm( ) . */

/*message mform:ParamObj:x-Date-Start  mform:ParamObj:x-Date-End "---"  
mform:ParamObj:x-SelectObject '---' mform:ParamObj:x-text-Obj mform:ParamObj:get-obj-List-text() qqq:all-object
view-as alert-box.*/ 

/* EMPTY TEMP-TABLE tt-user-account. */
/*  message obj-list.obj-id  ' ' obj-list.obj-name ' ' obj-list.db-num  view-as alert-box. */


mform:ParamObj:get-obj-list(output table obj-list).

for each user-obj  ,
      each ub.user-account no-lock where ub.user-account.user-id = user-obj.user-id:
         create tt-user-account .
         assign
         tt-user-account.db-num    = user-obj.db-num /* obj-code*/ 
         tt-user-account.user-id_  = ub.user-account.user-id
         tt-user-account.user_name = "ID: " + ub.user-account.user-id 
                              + " ФИО: " + user-account.last-name 
                              + " "      + user-account.first-name 
                              + " "      + user-account.second-name
                               .
end.

 for each tt-user-account:
    find first obj-list where tt-user-account.db-num = obj-list.db-num no-error.
      if not AVAILABLE obj-list then 
         do:
            delete tt-user-account .
         end.
END. 

create query query_user-account.                    
               query_user-account:set-buffers(buffer tt-user-account:HANDLE). 
               query_user-account:query-prepare("FOR EACH tt-user-account").
               query_user-account:query-open.

EMPTY TEMP-TABLE tt-objects.

 for each c-user-log no-lock 
    where c-user-log.corr-date >= mform:ParamObj:x-Date-Start and c-user-log.corr-date <= mform:ParamObj:x-Date-End 
    by c-user-log.head-table :
    v-table = c-user-log.head-table .
    if v-table begins "c-" /* and v-table <> {&table_c-usr-hist} and v-table <> {&table_c-plc-hist}  */
     then  do:
         v-user-table = replace(v-table,"c-","").
     end.
     else v-user-table = v-table .    
     find first tt-objects where tt-objects.table_ = v-user-table no-error .
     if not AVAILABLE (tt-objects) then 
        do:
           { gbl/tblnmusr.i
            v-user-table
            v-user-table-name
          } 
        create tt-objects .
            assign
            tt-objects.table_ = v-user-table 
            tt-objects.name_  = v-user-table-name
            .    
     end.
 
end. 
            
END.
    
METHOD public void mark_user():
    tt-user-account.flg = not tt-user-account.flg .
END.

METHOD public void mark_table():
    tt-objects.flg = not tt-objects.flg .
END.

METHOD public void my_report():
    /*message 'rep/r-hist-sysadm.p' view-as alert-box. */
    
    find first tt-user-account where tt-user-account.flg = yes no-error. /* если нет помеченных записей, то все, 
                                                                            если есть помеченные, то отправляем только их*/
    if AVAILABLE tt-user-account then do: 
      for each tt-user-account  :
          if   tt-user-account.flg = no then delete tt-user-account .
       end.
    end.
       
    find first tt-objects where tt-objects.flg = yes no-error.
    
    if AVAILABLE tt-objects then do: 
      for each tt-objects  :
          if   tt-objects.flg = no then delete tt-objects .
       end.
    end.
    
     run rep/r-hist-sysadm.p 
         (input mform:ParamObj:my-handle,  
          input mform:ParamObj:x-Date-Start,
          input mform:ParamObj:x-Date-End,
          input table tt-user-account BY-REFERENCE,
          input table tt-objects      BY-REFERENCE ) . 
END.

END CLASS.