&scoped-define vssseq {&sequence}
def var vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
{cmp\str-glbl.i {1}}
define variable mMRCCode as logical no-undo.
&if "{1}" = "class"
&then
method private character repSpecSimbforDm
&else
function repSpecSimbforDm return char 
&endif
(iDM as char ):
    define variable vReplist_old as character no-undo init "),(,&gt;,&lt;,&amp;,&apos;,&quot;".
    define variable vReplist_new as character no-undo init  ",,>,<,&,~',~"".
    define variable vi as integer no-undo.
    
    do vi = 1 to num-entries(vReplist_old):
        iDM = replace(iDM,entry(vi,vReplist_old),entry(vi,vReplist_new)).
    end.
    return iDM.
        
end.

&if "{1}" = "class"
&then
method private character getGtinByDM
&else
function getGtinByDM return char 
&endif
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
      else if   vtxt begins "01"
             or vtxt begins "02"   
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
   return vgtin.    
end.

&if "{1}" = "class"
&then
method private integer getGdsCodeByGtin
&else
function getGdsCodeByGtin return int 
&endif
(iGtin as char):
   
   define buffer prod-bc for prod-bc.
   
   find first prod-bc where prod-bc.b-str eq iGtin no-lock no-error.
   find first bar-code where bar-code.b-code eq prod-bc.b-code no-lock no-error.
   return if avail prod-bc then bar-code.gds-code else ?.
end.

&if "{1}" = "class"
&then
method private integer getGdsCodeByDM
&else
function getGdsCodeByDM return int 
&endif
(iDm as char):
   define variable vGtin as char no-undo.
   define buffer prod-bc for prod-bc.
   vGtin  = getGtinByDM (IDM ).
   return getGdsCodeByGtin (vGtin).
    
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

&if "{1}" = "class"
&then
method private character  GetNextElement
&else
function GetNextElement return character  
&endif
  (output oteg          as character 
  ,output otegval       as character
  ,input-output pstr    as character 
  /*,input        iLength as character*/ ):
     define variable vlistElem as character no-undo    init "00,01,02,21,17,11,13,(01),(02),(21),(17),(11),(13)". /* ,(8005),8005".*/
     define variable vlistallleng as character no-undo init "00,00,00,00,00,00,00,0000,0000,0000,0000,0000,0000".  /* ,000000,0000". */
     define variable vlistleng1   as character no-undo init "27,14,14,07,06,06,06,0014,0014,0007,0006,0006,0006". /* ,000006,0006". */
     define variable vlistleng2   as character no-undo init "27,14,14,13,06,06,06,0014,0014,0007,0006,0006,0006". /* ,000006,0006".*/
     define variable vTeg as character no-undo.
     define variable vLength as integer no-undo.
     define variable vi as integer no-undo.
     define variable vj as integer no-undo.
     if mMRCCode
     then
        assign
           vlistElem     = vlistElem    + ",(8005),8005"
           vlistallleng  = vlistallleng + ",000000,0000"
           vlistleng1    = vlistleng1   + ",000006,0006"
           vlistleng2    = vlistleng2   + ",000006,0006"
        .
     
     if length(pstr) eq 4
     then
        return "".
        block-elem:
    do vi = 1 to num-entries(vlistElem):
       vTeg = entry(vi,vlistElem).
       if pstr begins vTeg
       then do:
          
          vLength = int(entry(vi,vlistallleng)) no-error.
          if vLength eq 0
             and not error-status:error
          then 
             vLength = int(entry(vi,vlistleng1)).
          else do:
             block-mas:
             do vj = 1 to num-entries(entry(vi,vlistallleng),"|"):
                vLength = int(entry(vj,entry(vi,vlistallleng),"|")).
                if vLength eq length(pstr)
                then do:
                   vLength = vj.
                   leave block-mas.
                end.
                else
                   vLength = ?.
             end.
             vLength = int(entry(vi,if vLength ne ? then vlistleng1 else vlistleng2)).
          end.
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

&if "{1}" = "class"
&then
method private character  GetCodeIdent
&else
function GetCodeIdent return character  
&endif
(iDm as char):
   define variable Velement   as character no-undo init "first".
   define variable oCodeIdent as character no-undo.
   define variable vteg as character no-undo.
   define variable vtegval as character no-undo.
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
      oCodeIdent = substring(iDm,1,21).
   else  if     length(iDm) eq 25
            and not iDm begins "01"
            and not iDm begins "02"
   then
      oCodeIdent = substring(iDm,1,21).
   else do while Velement ne "" and idm ne "":
      Velement = GetNextElement(output vteg, output vtegval, input-output idm).
      oCodeIdent = oCodeIdent + Velement.
   end.
   return oCodeIdent.

end.

&if "{1}" = "class"
&then
method private character  GetTegCod
&else
function GetTegCod return character  
&endif
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

&if "{1}" = "class"
&then
method private character  addBracketForCode
&else
function addBracketForCode return character  
&endif
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



&if "{1}" = "class"
&then
method private integer getlevelByCodId
&else
function getlevelByCodId return int 
&endif
(iDm as char):
   define variable vLength as int no-undo.
   define variable vLevel  as int no-undo.
   define variable vCode as character no-undo.

   vcode = replace(replace(idm,"(",""),")","").
   vLength = length(vcode).
   if    vLength eq 18
      or vLength eq 20
   then 
      Vlevel = 4.
   else if vLength eq 21
   then 
      Vlevel = 1.
   else if vLength eq 25 /* табак */
   then do:
      if  iDm begins "01"
      then
         Vlevel = 3.
      else
         Vlevel = 1.
   end.
   else if     vLength >= 26
           and vLength <= 46
   then do:
      if    substring(iDm,17,2) eq "11" /*табак*/
         or substring(iDm,17,2) eq "13"
         or (    substring(iDm,17,2) eq "21"
             and vLength >= 33
             and substring(iDm,26,4) ne "8005")
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
&if "{1}" = "class"
&then
method private character  getLevelMotpBycodid
&else
function getLevelMotpBycodid return character  
&endif
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

&if "{1}" = "class"
&then
method private character  getLevelMotpByDM
&else
function getLevelMotpByDM return character  
&endif
(iDm as char):
   return getLevelMotpByCodId(GetCodeIdent(iDm)).
end.

&if "{1}" = "class"
&then
method private character  getLevelUTDByCodId
&else
function getLevelUTDByCodId return character  
&endif
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

&if "{1}" = "class"
&then
method private character  getLevelUTDByDM
&else
function getLevelUTDByDM return character  
&endif
(iDm as char):
   return getLevelUTDByCodId(GetCodeIdent(iDm)).
end.

&if "{1}" = "class"
&then
method private integer   getQntyUTDByCodId
&else
function getQntyUTDByCodId return integer   
&endif
(iDm as char):
   define variable vLevel as integer no-undo.
   define variable vList as character no-undo init "1,5,10,500".
   vLevel = getlevelByCodId(iDm).
   if    vLevel eq ?
      or vLevel < 1
      or vLevel > 4
   then
      return ?.
   else
      return int(entry(vlevel,vList)).
end.
&if "{1}" = "class"
&then
method private integer   getQntyUTDByDM
&else
function getQntyUTDByDM return integer   
&endif
(iDm as char):
   return getQntyUTDByCodId(GetCodeIdent(iDm)).
end.
&if "{1}" = "class"
&then
method private decimal    getMRC4
&else
function getMRC4 return decimal    
&endif
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
&if "{1}" = "class"
&then
method private decimal    getMRCByDM
&else
function getMRCByDM return decimal    
&endif
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


   