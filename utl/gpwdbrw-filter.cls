/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Фильтр для формы браузера gpwdbrw

Автор: Сергей Палагин
Дата создания: 21/10/18
Author: Sergey Palagin
Creation date: 21/10/18

*/

block-level on error undo, throw.

class utl.gpwdbrw-filter:
   
   { utl/flt-operator.i }
   
   define public property User as utl.flt-condition no-undo 
   get.
   set. 

   define public property HostName as utl.flt-condition no-undo 
   get.
   set. 
   
   define public property DateGen as utl.flt-condition no-undo 
   get.
   set.
    
   define public property TimeGen as utl.flt-condition no-undo 
   get.
   set. 
   
   define public property ObjectNum as utl.flt-condition no-undo 
   get.
   set. 
   
   define public property CashNum as utl.flt-condition no-undo 
   get.
   set. 

   define public property Fio as utl.flt-condition no-undo 
   get.
   set.
    
   define public property DateProl as utl.flt-condition no-undo 
   get.
   set.
   
   /* связывающий условия модификатор - AND/OR */
   define public property Modifier as char init "and" no-undo 
   get.
   set.

   method public character GetModifierName():
      
      define variable result as character no-undo.
      
      case this-object:Modifier:
         when "and" then result = "И".
         when "or" then result = "ИЛИ".
      end case.
  
      return result.

   end method.

   method public static utl.gpwdbrw-filter GetObject():
      
      def var vFilter as class utl.gpwdbrw-filter no-undo.
      def var vCond   as class utl.flt-condition  no-undo.
      
      vFilter = new utl.gpwdbrw-filter().
/* ---------------------------- */
      
      assign
         vCond = new utl.flt-condition()
         vCond:BufferName = "b-tech-prol-pwd"
         vCond:Field_ = "f-user"
         vCond:FieldName = "Идентификатор пользователя:"
         vCond:FieldType = "char"
      .
      
      vCond:AddOp({&flt-eq}).
      vCond:AddOp({&flt-ne}).
      vCond:AddOp({&flt-list}).
      
      vFilter:user = vCond.
/* ---------------------------- */
      assign
         vCond = new utl.flt-condition()
         vCond:BufferName = "b-tech-prol-pwd"
         vCond:Field_ = "f-hostname"
         vCond:FieldName = "Имя хоста:"
         vCond:FieldType = "char"
      .
      
      vCond:AddOp({&flt-eq}).
      vCond:AddOp({&flt-ne}).
      vCond:AddOp({&flt-contrains}).
      vCond:AddOp({&flt-list}).
      
      vFilter:HostName = vCond.
/* ---------------------------- */
      assign
         vCond = new utl.flt-condition()
         vCond:BufferName = "b-tech-prol-pwd"
         vCond:Field_ = "f-time"
         vCond:FieldName = "Дата генерации пароля:"
         vCond:FieldType = "date"
      .
      
      vCond:AddOp({&flt-eq}).
      vCond:AddOp({&flt-ne}).
      vCond:AddOp({&flt-gt}).
      vCond:AddOp({&flt-ge}).
      vCond:AddOp({&flt-lt}).
      vCond:AddOp({&flt-le}).
      vCond:AddOp({&flt-between}).
      vCond:AddOp({&flt-list}).
      
      vFilter:DateGen = vCond.

/* ---------------------------- */
      assign
         vCond = new utl.flt-condition()
         vCond:BufferName = "b-tech-prol-pwd"
         vCond:Field_ = "f-time"
         vCond:FieldName = "Время генерации пароля:"
         vCond:FieldType = "time"
      .
      
      vCond:AddOp({&flt-eq}).
      vCond:AddOp({&flt-ne}).
      vCond:AddOp({&flt-list}).
      
      vFilter:TimeGen = vCond.

/* ---------------------------- */
      assign
         vCond = new utl.flt-condition()
         vCond:BufferName = "b-clients"
         vCond:Field_ = "obj-code"
         vCond:FieldName = "Объект:"
         vCond:FieldType = "int"
      .
      
      vCond:AddOp({&flt-eq}).
      vCond:AddOp({&flt-ne}).
      vCond:AddOp({&flt-list}).
      
      vFilter:ObjectNum = vCond.
/* ---------------------------- */
      assign
         vCond = new utl.flt-condition()
         vCond:BufferName = "b-cash-desk"
         vCond:Field_ = "cash-num"
         vCond:FieldName = "Касса:"
         vCond:FieldType = "int"
      .
      
      vCond:AddOp({&flt-eq}).
      vCond:AddOp({&flt-ne}).
      vCond:AddOp({&flt-list}).
      
      vFilter:CashNum = vCond.

/* ---------------------------- */
      assign
         vCond = new utl.flt-condition()
         vCond:BufferName = "b-tech-prol-pwd"
         vCond:Field_ = "f-fio"
         vCond:FieldName = "ФИО заказчика пароля:"
         vCond:FieldType = "char"
      .
      
      vCond:AddOp({&flt-eq}).
      vCond:AddOp({&flt-ne}).
      vCond:AddOp({&flt-contrains}).
      vCond:AddOp({&flt-begins}).
      vCond:AddOp({&flt-list}).
      
      vFilter:Fio = vCond.
      
/* ---------------------------- */
      assign
         vCond = new utl.flt-condition()
         vCond:BufferName = "b-tech-prol-pwd"
         vCond:Field_ = "f-date"
         vCond:FieldName = "Дата проведения техпролива:"
         vCond:FieldType = "date"
      .
      
      vCond:AddOp({&flt-eq}).
      vCond:AddOp({&flt-ne}).
      vCond:AddOp({&flt-gt}).
      vCond:AddOp({&flt-ge}).
      vCond:AddOp({&flt-lt}).
      vCond:AddOp({&flt-le}).
      vCond:AddOp({&flt-between}).
      vCond:AddOp({&flt-list}).
      
      vFilter:DateProl = vCond.
      
      return vFilter.

   end method.


   method public character GetWhere():
      
      def var vWhere as char no-undo.
      def var vCond  as char no-undo.
      
      vCond = this-object:HostName:GetWhere().
      
      if vCond <> "" then
      do:
         vWhere = substitute("&1 &2 (&3)",vWhere,Modifier,vCond).
      end.

      vCond = this-object:Fio:GetWhere().
      
      if vCond <> "" then
      do:
         vWhere = substitute("&1 &2 (&3)",vWhere,Modifier,vCond).
      end.

      vCond = this-object:User:GetWhere().
      
      if vCond <> "" then
      do:
         vWhere = substitute("&1 &2 (&3)",vWhere,Modifier,vCond).
      end.
      
      assign
         vWhere = trim(vWhere," ")
         vWhere = trim(vWhere,Modifier)
      .
      
      return vWhere.

   end method.
   
   method public log IsEnabled():
      
      return this-object:CashNum:Enabled or
             this-object:DateGen:Enabled or
             this-object:DateProl:Enabled or
             this-object:Fio:Enabled or
             this-object:HostName:Enabled or
             this-object:ObjectNum:Enabled or
             this-object:TimeGen:Enabled or
             this-object:User:Enabled.
             
   end method.
   
   method public char GetQueryString():
      
      def var vWhere       as char no-undo.
      def var vCond        as char no-undo.
      def var vQueryString as char no-undo.
      
      vQueryString = "for each b-tech-prol-pwd no-lock ".
      
      vCond = this-object:HostName:GetWhere().
      
      if vCond <> "" then
         vWhere = substitute("&1 &2 (&3)",vWhere,Modifier,vCond).
      
      vCond = this-object:Fio:GetWhere().
      
      if vCond <> "" then
         vWhere = substitute("&1 &2 (&3)",vWhere,Modifier,vCond).

      vCond = this-object:User:GetWhere().
      
      if vCond <> "" then
         vWhere = substitute("&1 &2 (&3)",vWhere,Modifier,vCond).

      vCond = this-object:DateProl:GetWhere().
      
      if vCond <> "" then
         vWhere = substitute("&1 &2 (&3)",vWhere,Modifier,vCond).
      
      assign
         vWhere = trim(vWhere," ")
         vWhere = trim(vWhere,Modifier)
      .

      if vWhere <> "" then
         vQueryString = substitute("&1 where &2", vQueryString, vWhere).
      
      assign
         vQueryString = substitute("&1, first b-clients no-lock where ", vQueryString)
         vQueryString = substitute("&1        b-clients.obj-type = entry(1,b-tech-prol-pwd.shop-surr) ", vQueryString)
         vQueryString = substitute("&1    and b-clients.obj-code = int(entry(2,b-tech-prol-pwd.shop-surr)) ", vQueryString)
      .
      
      assign   
         vQueryString = substitute("&1, first b-cash-desk no-lock where ", vQueryString)
         vQueryString = substitute("&1        b-cash-desk.db-num   = int64(entry(1,b-tech-prol-pwd.cash-desk-surr)) ", vQueryString)
         vQueryString = substitute("&1    and b-cash-desk.obj-code = int64(entry(2,b-tech-prol-pwd.cash-desk-surr)) ", vQueryString)
         vQueryString = substitute("&1    and b-cash-desk.pos-type = entry(3,b-tech-prol-pwd.cash-desk-surr) ",        vQueryString)
         vQueryString = substitute("&1    and b-cash-desk.cash-num = int64(entry(4,b-tech-prol-pwd.cash-desk-surr)) ", vQueryString)
      .
      
      assign 
         vQueryString = substitute("&1, first ttTemp ", vQueryString)
      .
      
      assign
         vCond = this-object:ObjectNum:GetWhere()
         vWhere = ""
      .
      
      if vCond <> "" then
         vWhere = substitute("&1 &2 &3 ",vWhere,Modifier,vCond).
      
      vCond = this-object:CashNum:GetWhere().
      
      if vCond <> "" then
         vWhere = substitute("&1 &2 &3 ",vWhere,Modifier,vCond).
      
      assign
         vWhere = trim(vWhere)
         vWhere = trim(vWhere,Modifier)
         vWhere = trim(vWhere,Modifier)
      .
      
      if vWhere <> "" then
         vQueryString = substitute("&1 where &2 ", vQueryString,vWhere).
      
      return vQueryString.

   end method.

end class.