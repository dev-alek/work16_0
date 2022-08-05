{&CommentStartNoClass}
method public character  GetDocumforid
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function GetDocumforid returns character
{utl\comment.i} */
(input  iorg as character ,
 input  idoc-id as character ,
 output oDocument      as component-handle
  ):
   define variable vOrganization  as component-handle no-undo.
   define variable vDocument      as component-handle no-undo.
   define buffer utd           for ub.utd.
   
   if     
          iorg  ne ?
      and iorg  ne ""
      and idoc-id ne ?
      and idoc-id ne ""
   then do:
      vOrganization = mDiadocConnection:GetOrganizationById(iorg) no-error.
      if vOrganization ne ?
      then do:
         oDocument = vOrganization:GetDocumentById(idoc-id,false) no-error.
         if oDocument eq ?
         then
            PutErr(substitute("Error Нет доступа к документу &2 по организации &1. ", iorg,idoc-id)).
      end.
      else do:
         PutErr(substitute("Error Нет доступа к организации &1 по документу &2. ", iorg,idoc-id)).
         return "Нет доступа к организации " + iorg.
      end.
   end.
   else
      return "Нет доступа к организации не ЭДО".
   
   release object vOrganization no-error.
   return "". 
end.

{&CommentStartNoClass}
method public character  GetDocum
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function GetDocum returns character
{utl\comment.i} */
(input  idb-num as integer,
 input  idoc-id as integer,
 output oDocument      as component-handle
  ):
   define variable vOrganization  as component-handle no-undo.
   define variable vDocument      as component-handle no-undo.
   define buffer utd           for ub.utd.
   find first utd where utd.db-num eq idb-num
                    and utd.doc-id eq idoc-id
   no-lock no-error.
   if     available utd
      and utd.OrganizationExt ne ?
      and utd.OrganizationExt ne ""
      and utd.DocumentExt ne ?
      and utd.DocumentExt ne ""
   then do:
      vOrganization = mDiadocConnection:GetOrganizationById(utd.OrganizationExt) no-error.
      if vOrganization ne ?
      then do:
         oDocument = vOrganization:GetDocumentById(utd.DocumentExt,false) no-error.
         if oDocument eq ?
         then
            PutErr(substitute("Error Нет доступа к документу &2 по организации &1. ", utd.OrganizationExt,utd.DocumentExt)).

         release object vOrganization no-error.
      end.
      else do:
         PutErr(substitute("Error Нет доступа к организации &1 по документу &2. ", utd.OrganizationExt,utd.DocumentNumber)).
         return "Нет доступа к организации " + utd.OrganizationExt.
      end.
   end.
   else
      return "Нет доступа к организации не ЭДО".
   
   
   return "". 
end.

{&CommentStartNoClass}
method public logical GetFirstUTDinPack
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function GetFirstUTDinPack returns logical 
{utl\comment.i} */
(input idb-num as integer, 
 input idoc-id as integer,
 output odb-num as integer,
 output odoc-id as integer ):
   define buffer buf_utd for utd.
   define buffer     utd for utd.
   find first utd where utd.db-num eq idb-num
                    and utd.doc-id eq idoc-id
   no-lock no-error.
   if available utd
   then do:
      if utd.PackageId eq ""
      then do:
         assign
            odb-num = utd.db-num
            odoc-id = utd.doc-id
         .
         return yes.
      end.
      else do:
         find first buf_utd where Buf_utd.PackageId eq utd.PackageId
                              and Buf_utd.EDocType  eq objSrv:Env:Utd:EDocType:UTD:KeyIntDB
                              
         no-lock.
         assign
            odb-num = buf_utd.db-num
            odoc-id = buf_utd.doc-id
         .
         
         return if available buf_utd then (recid(utd) eq recid(buf_utd)) else no.
      end.  
   end.
   return ?.
end.

{&CommentStartNoClass}
method public logical addMarkforUtd
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function addMarkforUtd returns logical 
{utl\comment.i} */
(iDb-num  as integer ,
 iDoc-id  as integer ,
 ilinenum as integer ,
 iMark as character  ,
 isite   as character,
 iUtdType as character    ):
    define buffer     marking            for ub.marking.
    define buffer     marking-attr       for ub.marking-attr.
    define buffer utd-marking-lines      for ub.utd-marking-lines.
    define buffer utd-marking-lines-attr for ub.utd-marking-lines-attr.
    define variable vMRC  as decimal no-undo.
    define variable vQnty as decimal no-undo.
   if imark ne "-"
   then do:
      imark = repTegforDm(imark).
      vQnty = getQntyUTDByCodId(imark) .
      find first utd-marking-lines where utd-marking-lines.mark       = imark
                                     and utd-marking-lines.db-num     = idb-num     
                                     and utd-marking-lines.doc-id     = idoc-id 
                                     and utd-marking-lines.Linenum    = iLinenum        
      exclusive-lock no-error.
      if not available utd-marking-lines
      then do:
         create utd-marking-lines.
         assign
            utd-marking-lines.mark      = imark
            utd-marking-lines.db-num    = idb-num     
            utd-marking-lines.doc-id    = idoc-id 
            utd-marking-lines.Linenum   = iLinenum
            utd-marking-lines.site      = isite
            utd-marking-lines.doc-level = 1
            utd-marking-lines.gds-code  = ?        
         .
         create utd-marking-lines-attr.
         assign
            utd-marking-lines-attr.mark      = imark
            utd-marking-lines-attr.db-num    = idb-num     
            utd-marking-lines-attr.doc-id    = idoc-id 
            utd-marking-lines-attr.Linenum   = iLinenum
            utd-marking-lines-attr.attr-code = "box-qnty"
            utd-marking-lines-attr.attr-value = string(vQnty)
         .
         release utd-marking-lines-attr.
         release utd-marking-lines. 
      end.
      else do:
         if    (    isite eq "-"
            and utd-marking-lines.site eq "+")
         or (    isite eq "+"
            and utd-marking-lines.site eq "-")
         then 
            delete utd-marking-lines.
         else if isOAD (imark)
         then do:
            define variable vnewMark as character no-undo.
            vnewMark = "02" + GetTegCod(imark,"02") + "37" + string(int(GetTegCod(imark,"37")) * 2).
            utd-marking-lines.mark = vnewmark.
            find first ub.utd-marking-lines-attr where 
            utd-marking-lines-attr.mark      = imark
            and utd-marking-lines-attr.db-num    = idb-num     
            and utd-marking-lines-attr.doc-id    = idoc-id 
            and utd-marking-lines-attr.Linenum   = iLinenum
            and utd-marking-lines-attr.attr-code = "box-qnty"
            exclusive-lock no-error.
            if available utd-marking-lines-attr
            then do:
               utd-marking-lines-attr.mark = utd-marking-lines.mark.
               utd-marking-lines-attr.attr-value = string(integer (ub.utd-marking-lines-attr.attr-value) * 2).
            end.
         end.
         release utd-marking-lines.
      end.
      if isMark (imark)
      then do:                               
         find first marking where marking.mark eq iMark exclusive-lock no-error.
         if not available marking
         then do:
            create marking.
            marking.mark = iMark.
            marking.gds-code = ?.
            marking.unit     = getLevelUTDByCodId(marking.mark) .
         end.
         marking.unit-ext   = getLevelMotpByCodId(marking.mark) .
         marking.box-qnty   = vQnty. 
         marking.unit       = getLevelUTDByCodId(marking.mark) .
/*         marking.unit-ext = utd-lines.UnitCode .*/
         if       marking.sts = objSrv:Env:marking:Sts:Mark:MarkError:KeyIntDB
            or (     iUtdType eq "UniversalTransferDocument"
                  and marking.sts = objSrv:Env:marking:Sts:Mark:NotAvailable:KeyIntDB)
         then
            marking.sts = ?.                  
         vMRC =  getMRCByDM (iMark).
         if     vMRC ne 0 
            and vMRC ne ?
         then do:
            find first marking-attr where marking-attr.mark      =  iMark
                                      and marking-attr.attr-code = "MRC"
            no-lock no-error.
            if not available marking-attr
            then do:
               create marking-attr.
               assign
                  marking-attr.mark =  iMark
                  marking-attr.attr-code = "MRC"
                  marking-attr.attr-value = string(vMRC)
               .
            end.
            release marking-attr no-error.
         end.
      end.
      
   end.
end.

