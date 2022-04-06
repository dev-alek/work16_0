&scoped-define vssseq {&sequence}
def var vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
{cmp\str-glbl.i {1}}
{gbl\xmlchar.i}
define variable mMRCCode as logical no-undo.
define variable mTypeMark as character  no-undo.


{&CommentStartNoClass}
method private character repTegforDm
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function repTegforDm return char 
{utl\comment.i} */
(iDM as char ):
    define variable vTeglist as character no-undo init "01,02,11,13,17,21,8005".
    define variable vteg as character no-undo.
    define variable oDM as character no-undo. 
    define variable vi as integer no-undo.
    oDM = iDm.
    do vi = 1 to num-entries(vTeglist):
       vTeg = entry(vi,vTeglist).
       oDM = replace(oDM,"(" + vTeg + ")",vTeg).
    end.
    return oDM.
end.
{&CommentStartNoClass}
method private character repSpecSimbforDm
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function repSpecSimbforDm return char 
{utl\comment.i} */ 
(iDM as char ):
    
    define variable oDM as character no-undo.
  {&CommentStartClass}
  run
  {utl\comment.i} */  
    xmlchar-decode(iDM, output oDM).
    
  return repTegforDm (oDM).
end.

{&CommentStartNoClass}
method private character repSpecSimbforXlm
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function repSpecSimbforXlm return char 
{utl\comment.i} */ 
(iDM as char ):
  
    define variable vReplist_new as character no-undo init "&amp;,&gt;,&lt;,&apos;,&quot;".
    define variable vReplist_old as character no-undo init "&,>,<,~',~"".
    define variable vi as integer no-undo.
    
    iDM = replace(iDM,chr(29),"").
    return iDM.
        
end.

{&CommentStartNoClass}
method private character getGtinByDM
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getGtinByDM return char 
{utl\comment.i} */ 
(IDM as char):
   define variable VTXT as char no-undo.
   define variable vGtin as char no-undo.
   vTXt = IdM.
   vGtin = IDM.
   if    length(vtxt) > 14
   then do:
      if   vtxt begins "(01)"
             or vtxt begins "(02)"   
      then
         vGtin = substring(vtxt,5,14).
      else if   (vtxt begins "01"
             or vtxt begins "02" )
             and substring(iDm,17,2) eq "21"
             and length(vtxt) >= 25  
      then
         vGtin = substring(vtxt,3,14).
      else if     length(vtxt) eq 14 + 7 + 4 + 4
          or length(vtxt) eq 14 + 7 + 4
          or length(vtxt) eq 14 + 7 
      then 
         vGtin = substring(vtxt,1,14).
      
       
       
      /*if     length(vGtin) > 14
         and length(vGtin) ne 18
         and length(vGtin) ne 20
      then 
         vGtin = ?.*/
   end.
     
  
   if length(vGtin) eq 14
   then do:
      define variable bar_code as character no-undo.
      bar_code = substr (vGtin, 1, length (vGtin) - 1).
      run str/chk-sum.p
       (input-output bar_code ) no-error .
      if vGtin ne  bar_code
      then
         vGtin = "".
   end.
   else 
      vGtin = "". 
   return vgtin.    
end.

{&CommentStartNoClass}
method private integer getGdsCodeByGtin
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getGdsCodeByGtin return int 
{utl\comment.i} */ 
(iGtin as char):
   
   define buffer prod-bc  for prod-bc.
   define buffer bar-code for bar-code.
   
   find first prod-bc where prod-bc.b-str eq iGtin no-lock no-error.
   find first bar-code where bar-code.b-code eq prod-bc.b-code no-lock no-error.
   return if avail bar-code then bar-code.gds-code else ?.
end.

{&CommentStartNoClass}
method private decimal getQntyCodeByGtin
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getQntyCodeByGtin return decimal  
{utl\comment.i} */ 
(iGtin as char):
   
   define buffer prod-bc for prod-bc.
   define buffer bar-code for bar-code.
   
   find first prod-bc where prod-bc.b-str eq iGtin no-lock no-error.
   find first bar-code where bar-code.b-code eq prod-bc.b-code no-lock no-error.
   return if avail bar-code then bar-code.cli-base-rate else ?.
end.

{&CommentStartNoClass}
method private integer getGdsCodeByDM
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getGdsCodeByDM return int 
{utl\comment.i} */ 
(iDm as char):
   define variable vGtin as char no-undo.
   define buffer prod-bc for prod-bc.
   vGtin  = getGtinByDM (IDM ).
   return getGdsCodeByGtin (vGtin).
    
end.

{&CommentStartNoClass}
method private logical ChekTypeMarkByGds
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function ChekTypeMarkByGds return logical 
{utl\comment.i} */
(iGds-code as integer ):
   define buffer goods-attr for goods-attr.
   find first goods-attr where goods-attr.gds-code   = iGds-code 
                           and goods-attr.attr-code  = {&attr-mark-type}
   no-lock no-error.
   if available goods-attr
   then do:
      mTypeMark = goods-attr.attr-value.                        
      return goods-attr.attr-value = "tabak" .
   end.
   else 
      return no.
end.

{&CommentStartNoClass}
method private logical ChekTypeMarkByDm
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function ChekTypeMarkByDm return logical 
{utl\comment.i} */
(iDM as char ):
   return ChekTypeMarkByGds(getGdsCodeByDM(idm)).
end.
/*
КИ
+ 14 + 7 + 4               = 25 табачная (14 + 7 + 4) КИ
+ 2 + 14 + 2 + 13          = 31 Обувные товары,Шины,Духи,одежды,Велосипеды,Кресла-коляски,молочные ("01" + 14 + "21" +13)
+ 2 + 14 + 2 + 20          = 38 Фотокамеры
+ 2 + 14 + 2 + 13 + 2 + 6  = 39 молочные ( "01" + 14 + "21" + 13 + "17" + 6  )
+ 2 + 14 + 2 + 13 + 4 + 10 = 45 молочные

КИН
- 2 + 14 + 2 + 13          = 31 Духи,одежды ("01" + 14 + "21" +13)

КИГУ
- 2 + 14 + 2 + 13          = 31 молочные ("01" + 14 + "21" +13)
- 2 + 14 + 2 + 13 + 2 + 6  = 39 молочные ( "01" + 14 + "21" + 13 + "17" + 6  )
+ 2 + 14 + 2 + 13 + 4 + 8  = 43 молочные
+ 2 + 14 + 2 + 7 + 4 + 6   = 35 табачная
+ 2 + 14 + 2 + 7           = 25 табачная ("01" + 14 + "21" + 7)

КИТУ
+ 18 Обувные товары,Шины,Духи,одежды,Велосипеды,Кресла-коляски,Фотокамеры,молочные
+ 2 + 14 + 2 + 6 + 2 (до +20) = 26 - 46 табачная ("01"("02") + 14 + "11"("13") + 6 + 21 (до +20)
+ 20 табачная
*/

{&CommentStartNoClass}
method private character  GetNextElement
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function GetNextElement return character  
{utl\comment.i} */ 
  (output oteg          as character 
  ,output otegval       as character
  ,input-output pstr    as character 
  /*,input        iLength as character*/ ):
     define variable vlistElem as character no-undo    init "00,01,02,21,17,11,13,(01),(02),(21),(17),(11),(13)". /* ,(8005),8005".*/
     define variable vlistleng   as character no-undo init "27,14,14,13,06,06,06,0014,0014,0013,0006,0006,0006". /* ,000006,0006".*/
     define variable vTeg as character no-undo.
     define variable vLength as integer no-undo.
     define variable vi as integer no-undo.
     define variable vj as integer no-undo.
     if mtypemark eq "milk"
     then do:
        entry (4,vlistleng) = "06".
     end.
     else if mtypemark eq "tabak"
     then do:
        entry (4,vlistleng) = "07".
     end.
       
     if mMRCCode
     then
        assign
           vlistElem     = vlistElem    + ",(8005),8005"
           vlistleng     = vlistleng    + ",000006,0006"
        .
     
     if length(pstr) eq 4
     then
        return "".
        block-elem:
    do vi = 1 to num-entries(vlistElem):
       vTeg = entry(vi,vlistElem).
       if pstr begins vTeg
       then do:
          vLength = int(entry(vi,vlistleng)).
          oteg = entry(vi,vlistElem).
          otegval = substring (pstr,length(oteg) + 1, vLength).
          vTeg = oteg + otegval.
          oteg = replace(replace(oteg,")",""),"(","").
          
          pstr = substring (pstr,length(vTeg)+ 1).
          leave block-elem.
       end.
       else
          vTeg = "".
    end.
    return vteg.
end.

{&CommentStartNoClass}
method private character  GetCodeIdent
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function GetCodeIdent return character  
{utl\comment.i} */ 
(iDm as char):
   define variable Velement   as character no-undo init "first".
   define variable oCodeIdent as character no-undo.
   define variable vteg as character no-undo.
   define variable vtegval as character no-undo.
   ChekTypeMarkByDm(idm).
   if iDm begins {&tech-mark-prefix}
   then
      oCodeIdent = iDm.
   else if length(iDm) < 21
   then
      oCodeIdent = ?.
   else if     length(iDm) eq 29
      and not iDm begins "01"
      and not iDm begins "02"
   then
      
      oCodeIdent = substring(iDm,1,if mMRCCode then 25 else 21 ).
   else  if     (   length(iDm) eq 25
                 or length(iDm) eq 29
                 or length(iDm) eq 21)
            and ((not iDm begins "01"
            and not iDm begins "02")
            or   substring(iDm,17,2) ne "21")
   then
      oCodeIdent = substring(iDm,1,21).
   else if getGtinByDM (iDm) eq ""
   then 
      oCodeIdent = substring(iDm,1,21).
   else do while Velement ne "" and idm ne "":
      Velement = GetNextElement(output vteg, output vtegval, input-output idm).
      oCodeIdent = oCodeIdent + Velement.
   end.
   return oCodeIdent.

end.

{&CommentStartNoClass}
method private character  GetTegCod
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function GetTegCod return character  
{utl\comment.i} */ 
(icodeIdent as char, iTeg as char):
   define variable Velement   as character no-undo init "first".
   define variable oTeg as character no-undo.
   define variable vteg as character no-undo.
   define variable vtegval as character no-undo.
   
   if     ((length(icodeIdent) eq 21
      and not icodeIdent begins "01"
      and not icodeIdent begins "02")
      or
          ( length(icodeIdent) eq 25
            and not icodeIdent begins "01"
            and not icodeIdent begins "02"))
       
   then do:
      if iTeg eq "01" or iTeg eq "02"
      then
         oTeg = substring(icodeIdent,1,21).
      else  if  iTeg eq "21" 
      then  
         oTeg = substring(icodeIdent,15,7).
   end.
   else do: 
      ChekTypeMarkByDm(icodeIdent).
      block-teg: 
         do while Velement ne "" and icodeIdent ne "":
         Velement = GetNextElement(output vteg, output vtegval, input-output icodeIdent).
         if Velement begins iTeg
         then do:
            oTeg = vtegval.
            leave block-teg.
         end.
      end.
   end.
   return oTeg.

end.

{&CommentStartNoClass}
method private character  addBracketForCode
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function addBracketForCode return character  
{utl\comment.i} */ 
(icodeIdent as char):
   define variable Velement   as character no-undo init "first".
   define variable oTeg as character no-undo.
   define variable vteg as character no-undo.
   define variable vtegval as character no-undo.
   
   if     length(icodeIdent) le 24
   then do:
      oTeg = icodeIdent.
   end.
   else do:
      ChekTypeMarkByDm(icodeIdent).
      mMRCCode = yes. 
      block-teg:
      do while Velement ne "" and icodeIdent ne "":
         Velement = GetNextElement(output vteg, output vtegval, input-output icodeIdent).
         if vteg ne ""
         then
            oTeg = oTeg + "(" + vteg + ")" + vtegval .
         
      end.
      mMRCCode = no.
   end.
   return oTeg.

end.



{&CommentStartNoClass}
method private integer getlevelByCodId
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getlevelByCodId return int 
{utl\comment.i} */ 
(iCode as char):
   define variable vLength as int no-undo.
   define variable vLevel  as int no-undo.
   if not ChekTypeMarkByDM (icode) then return ?.
   vLength = length(iCode).
   if    vLength eq 18
      or vLength eq 20
   then 
      Vlevel = 4.
   else if vLength eq 21
   then 
      Vlevel = 1.
   else if vLength eq 25 /* табак */
   then do:
      if  iCode begins "01"
      then
         Vlevel = 3.
      else
         Vlevel = 1.
   end.
   else if     vLength >= 26
           and vLength <= 46
   then do:
      if    substring(iCode,17,2) eq "11" /*табак*/
         or substring(iCode,17,2) eq "13"
         or (    substring(iCode,17,2) eq "21"
             and vLength >= 33
             and substring(iCode,26,4) ne "8005")
      then
         Vlevel = 4.
      else if    vLength eq 31
              or vLength eq 38
              or vLength eq 39
              or vLength eq 45    
      then
         Vlevel = 1.
      else if    vLength eq 35
              or vLength eq 43 
      then
         Vlevel = 3.
      else
         Vlevel = ?.
   end.   
   else 
      Vlevel = ?.
   return Vlevel. 
end.

/*
КИ
+ 14 + 7 + 4               = 25 табачная (14 + 7 + 4) КИ
+ 2 + 14 + 2 + 13          = 31 Обувные товары,Шины,Духи,одежды,Велосипеды,Кресла-коляски,молочные ("01" + 14 + "21" +13)
+ 2 + 14 + 2 + 20          = 38 Фотокамеры
+ 2 + 14 + 2 + 13 + 2 + 6  = 39 молочные ( "01" + 14 + "21" + 13 + "17" + 6  )
+ 2 + 14 + 2 + 13 + 4 + 10 = 45 молочные

КИН
- 2 + 14 + 2 + 13          = 31 Духи,одежды ("01" + 14 + "21" +13)

КИГУ
- 2 + 14 + 2 + 13          = 31 молочные ("01" + 14 + "21" +13)
- 2 + 14 + 2 + 13 + 2 + 6  = 39 молочные ( "01" + 14 + "21" + 13 + "17" + 6  )
+ 2 + 14 + 2 + 13 + 4 + 8  = 43 молочные
+ 2 + 14 + 2 + 7 + 4 + 6   = 35 табачная
+ 2 + 14 + 2 + 7           = 25 табачная ("01" + 14 + "21" + 7)

КИТУ
+ 18 Обувные товары,Шины,Духи,одежды,Велосипеды,Кресла-коляски,Фотокамеры,молочные
+ 2 + 14 + 2 + 6 + 2 (до +20) = 26 - 46 табачная ("01"("02") + 14 + "11"("13") + 6 + 21 (до +20)
+ 20 табачная
*/
{&CommentStartNoClass}
method private character  getLevelMotpBycodid
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getLevelMotpBycodid return character  
{utl\comment.i} */ 
(iDm as char):
   define variable vLevel as integer no-undo.
   define variable vList as character no-undo init "Unit,kin,Level1,Level2,Level3,Level4,Level5".
   vLevel = getlevelByCodId(iDm).
   if    vLevel eq ?
      or vLevel < 1
      or vLevel > 6
   then
      return ?.
   else
      return entry(vlevel,vList).
end.

{&CommentStartNoClass}
method private character  getLevelMotpByDM
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getLevelMotpByDM return character  
{utl\comment.i} */ 
(iDm as char):
   return getLevelMotpByCodId(GetCodeIdent(iDm)).
end.

{&CommentStartNoClass}
method private character  getLevelUTDByCodId
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getLevelUTDByCodId return character  
{utl\comment.i} */ 
(iDm as char):
   define variable vLevel as integer no-undo.
   define variable vList as character no-undo init "КИ,КИН,КИГУ,КИТУ".
   vLevel = getlevelByCodId(iDm).
   if    vLevel eq ?
      or vLevel < 1
      or vLevel > 4
   then
      return ?.
   else
      return entry(vlevel,vList).
end.

{&CommentStartNoClass}
method private character  getLevelUTDByDM
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getLevelUTDByDM return character  
{utl\comment.i} */ 
(iDm as char):
   return getLevelUTDByCodId(GetCodeIdent(iDm)).
end.

{&CommentStartNoClass}
method private decimal getQntyUTDByCodId
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getQntyUTDByCodId return decimal    
{utl\comment.i} */ 
(iDm as char):
   define variable vLevel as integer no-undo.
   define variable vList as character no-undo init "1,5,10,500".
   if ChekTypeMarkByDM (iDM)
   then do:
   vLevel = getlevelByCodId(iDm).
   if    vLevel eq ?
      or vLevel < 1
      or vLevel > 4
   then
      return ?.
   else
      return int(entry(vlevel,vList)).
end.
   else
      return getQntyCodeByGtin(getGtinByDm(idm)).
end.

{&CommentStartNoClass}
method private decimal getQntyUTDByDM
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getQntyUTDByDM return decimal    
{utl\comment.i} */ 
(iDm as char):
   return getQntyUTDByCodId(GetCodeIdent(iDm)).
end.

{&CommentStartNoClass}
method private decimal    getMRC4
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getMRC4 return decimal    
{utl\comment.i} */ 
(iMRC as char):
   define variable oMrc     as decimal no-undo init ?.
   define variable vAlphabet as character no-undo init "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\~"%&\'*+-./_,:;=<>?".
   define variable vi       as integer no-undo.
   define variable vfound   as integer no-undo.
   define variable vposStart   as integer no-undo.
   
  /* if keycode(substring(iMRC,1,1)) eq keycode("A") /* онадеимся что пачка не стои больше 5120.00 руб */
   then*/ do:
   OMRc = 0.
   do vi = 1 to 4:
      define variable vsimb as character no-undo.
      vsimb = substring(iMRC,vi,1).
      vposStart = if keycode("Z") < keycode(vsimb) then 27 else 1.
      vfound = index(vAlphabet,vsimb,vposStart) - 1.
      if vfound > 0
      then
         OMRc = OMRc + exp (80,(4 - vi) ) * vfound  .
      end.
      OMRc = OMRc / 100.
   end.
   return OMRc.
end.

{&CommentStartNoClass}
method private decimal    getMRCByDM
{utl\comment.i} "Изврат для eclipse" */ {&CommentStartClass}
function getMRCByDM return decimal    
{utl\comment.i} */ 
(iDm as char):
   define variable vMRC     as character no-undo.
   define variable oMrc     as decimal no-undo init ?.
   define variable Velement as character no-undo.
   define variable vteg as character no-undo.
   define variable vtegval as character no-undo.
   
   if    length(idm) eq 14 + 7 + 4 + 4
      or length(idm) eq 14 + 7 + 4 
   then do:
      vMRC = substring(idm,22,4).
      omrc = getMRC4(vMRC).
      
   end.
   else do:
       block-mrc:
       do while Velement ne "" and idm ne "":
          Velement = GetNextElement(output vteg, output vtegval, input-output idm).
          if Velement begins "8005"
          then do:
             vMRC = substring(idm,5,6).
             leave block-mrc.
          end.
          else if Velement begins "(8005)"
          then do:
             vMRC = substring(idm,7,6).
             leave block-mrc.
          end.
       end.
       if vMRC ne ""
       then
          OMRc = dec(vmrc) / 100 no-error.
   end.
   return OMRc.
end.
