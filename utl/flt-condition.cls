
block-level on error undo, throw.
 
{ utl/flt-operator.i }

class utl.flt-condition:
   
   /* Имя поля в БД */  
   define public property Field_ as char no-undo 
   get.
   set.
    
   /* Тип - char, date... */
   define public property FieldType as char no-undo 
   get.
   set.
   
   /* Имя буфера, по которому фильтруется элемент */ 
   define public property BufferName as char no-undo 
   get.
   set. 
   
   /* Имя условия для отображения в формах пользователю */
   define public property FieldName as char no-undo 
   get.
   set. 
   
   /* Значение поля */
   define public property Value as char no-undo 
   get.
   set. 
   
   /* Операция - равно, не равно, содержит, список и пр.*/
   define public property Operation as char no-undo 
   get.
   set. 
   
   /* Список поддерживаемых условием операций */
   define public property SupportOp as char no-undo 
   get.
   private set. 
   
   define public property Enabled as logical no-undo 
   get.
   set.

   /* Получает строку с where выражением для данного условия */
   method public char GetWhere():
      
      def var vRes as char no-undo.
      
      if this-object:Enabled then
      do:
         case this-object:Operation:
            when {&flt-eq}        then vRes = flt-eq(). 
            when {&flt-ne}        then vRes = flt-ne().
            when {&flt-lt}        then vRes = flt-lt().
            when {&flt-le}        then vRes = flt-le().  
            when {&flt-gt}        then vRes = flt-gt().
            when {&flt-ge}        then vRes = flt-ge().
            when {&flt-begins}    then vRes = flt-begins().
            when {&flt-between}   then vRes = flt-between().
            when {&flt-list}      then vRes = flt-list().
            when {&flt-contrains} then vRes = flt-contrains(). 
         end case.
      end.
         
      return vRes.

   end method.

   method public char AddOp(iOp as char):
      
      this-object:SupportOp = this-object:SupportOp + "," + iOp.       

   end method.

   method public char GetValue( ):
      
      def var vRes   as char no-undo.
         
      main:
      do on error undo, throw:
         
         if this-object:FieldType begins "int" then
         do: 
            vRes = this-object:value.
            leave main.
         end.

         if this-object:FieldType begins "char" then
         do: 
            vRes = quoter(this-object:value).
            leave main.
         end.
         
         if this-object:FieldType = "date" then
         do: 
            vRes = quoter(date(this-object:value)).
            leave main.
         end.
         
      end.
       
      return vRes.

   end method.

   
   method private char flt-eq():
      
      def var vRes as char no-undo.
         vRes = substitute("&1.&2 = &3", 
                             this-object:BufferName,
                             this-object:Field_,
                             GetValue()).
      return vRes.

   end method.
      
   method private char flt-ne():
      
      def var vRes as char no-undo.
         vRes = substitute("&1.&2 <> &3", 
                             this-object:BufferName,
                             this-object:Field_,
                             GetValue()).
      return vRes.

   end method.

   method private char flt-lt():
      
      def var vRes as char no-undo.
         vRes = substitute("&1.&2 < &3", 
                             this-object:BufferName,
                             this-object:Field_,
                             GetValue()).
      return vRes.

   end method.
   
   method private char flt-le():
      
      def var vRes as char no-undo.
      
         vRes = substitute("&1.&2 <= &3", 
                             this-object:BufferName,
                             this-object:Field_,
                             GetValue()).
      return vRes.

   end method.

   
   method private char flt-gt():
      
      def var vRes   as char no-undo.
      
         vRes = substitute("&1.&2 > &3", 
                             this-object:BufferName,
                             this-object:Field_,
                             GetValue()).
      return vRes.

   end method.
   
   method private char flt-ge():
      
      def var vRes as char no-undo.
      
         vRes = substitute("&1.&2 >= &3", 
                             this-object:BufferName,
                             this-object:Field_,
                             GetValue()).
      return vRes.

   end method.

   method private char flt-begins():
      
      def var vRes as char no-undo.
      
         vRes = substitute("&1.&2 begins &3", 
                             this-object:BufferName,
                             this-object:Field_,
                             GetValue()).
      return vRes.

   end method.
   
   method private char flt-between():
      
      def var vRes as char no-undo.
      def var vDate1 as date no-undo.
      def var vDate2 as date no-undo.
      
      if this-object:FieldType = "date" and
         num-entries(this-object:Value,"-") = 2 then
      do:
         assign
            vDate1 = date(entry(1,this-object:Value,"-"))
            vDate2 = date(entry(2,this-object:Value,"-"))
         .
         
         vRes = substitute("(&1.&2 >= &3) and (&1.&2 <= &4)", 
                             this-object:BufferName,
                             this-object:Field_,
                             quoter(vDate1),
                             quoter(vDate2)).
      end.
      
      return vRes.

   end method.

   method private char flt-list():
      
      def var vRes as char no-undo.
      
      if this-object:FieldType begins "char" then
      do: 
         vRes = substitute("can-do(&3,&1.&2)", 
                            this-object:BufferName,
                            this-object:Field_,
                            GetValue()).
      end.
      
      return vRes.

   end method.

   method private char flt-contrains():
      
      def var vRes as char no-undo.
      
      if this-object:FieldType begins "char" then
      do: 
         vRes = substitute("&1.&2 matches ('*&3*')", 
                            this-object:BufferName,
                            this-object:Field_,
                            this-object:value).
      end.
      
      return vRes.

   end method.
   
   
end class.