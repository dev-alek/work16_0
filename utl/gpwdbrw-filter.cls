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
         vCond:BufferName = "b-tech-prol-pwd"
         vCond:Field_ = "shop-surr"
         vCond:FieldName = "Объект:"
         vCond:FieldType = "char"
      .
      
      vCond:AddOp({&flt-eq}).
      vCond:AddOp({&flt-ne}).
      vCond:AddOp({&flt-list}).
      
      vFilter:ObjectNum = vCond.
/* ---------------------------- */
      assign
         vCond = new utl.flt-condition()
         vCond:BufferName = "b-tech-prol-pwd"
         vCond:Field_ = "cash-desk-surr"
         vCond:FieldName = "Касса:"
         vCond:FieldType = "char"
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

end class.