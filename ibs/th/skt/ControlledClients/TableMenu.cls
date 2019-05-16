/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$



Автор: Морозов Александр Сергеевич
Дата создания: 01/30/15
Author: Alexandr Morozov
Creation date: 01/30/15

*/

&scop CRLF chr(13) + chr(10)
&scop HdEnd chr(13) + chr(10) + chr(13) + chr(10)


using Progress.Lang.*.
using ibs.th.skt.Adapters.*.

class ibs.th.skt.ControlledClients.TableMenu: 

  /*содержит записанную csv*/
  define public property CSVStr as longchar no-undo
    get.
    private set.

    
  define public property SomeStr as char no-undo
    get.
    set.

  define private variable response   as character no-undo.
  define private variable v-parsed   as character no-undo.
  define private variable v-sea-code as integer   no-undo.
  define private variable v-obj-code as integer   no-undo.
  define private variable v-grp-rus  as character no-undo.
  define private variable v-grp-eng  as character no-undo.
  define variable logWrite      as class   LogWrite no-undo.
  define variable mbuffer-out   as memptr  no-undo.
  define variable v-cont-length as integer no-undo.

  constructor public TableMenu (  ):
    
    logWrite = new LogWrite().
    
  end constructor.


  method public void WriteCSVGrp ():
    
    for each ub.season no-lock:
      if ub.season.stts <> 0 then next.

      v-grp-rus = entry(1, ub.season.sea-name, '/').
      v-grp-eng = ''.
      assign
        v-grp-eng = entry(2, ub.season.sea-name, '/') no-error.
        
      response = response + string(ub.season.sea-code) + ',' + v-grp-rus + ',' + v-grp-eng + '|'.
    end.
    SomeStr = response.
  
  end method.


  method public void WriteCSVGds (cont as longchar):

    v-parsed = trim(substring(cont, (index(cont, 'grp=') + 4), (index(cont, '/') - (index(cont, 'grp=') + 4))), '"').
    v-obj-code = integer(entry(1, v-parsed, ';')).
    v-sea-code = integer(entry(2, v-parsed, ';')).

    for each ub.gds-season where ub.gds-season.sea-code = v-sea-code no-lock:
      find first ub.goods where ub.goods.gds-code = ub.gds-season.gds-code no-lock no-error.
      if ub.goods.stts <> 0 then next.
      find first ub.gds-obj where ub.gds-obj.obj-code = v-obj-code
        and ub.gds-obj.obj-type = 'маг'
        and ub.gds-obj.gds-code = ub.goods.gds-code no-lock no-error.
      if not available(ub.gds-obj) then 
      do:
        logWrite:LogStr = 'Ошибка: Товар ' + ub.goods.gds-name + ' Код: ' + string(ub.goods.gds-code) + 
          '. Убедитесь, что на товар назначена цена.'.
        next.
      end.
      find first ub.bar-code where ub.bar-code.gds-code = ub.goods.gds-code
        and ub.bar-code.unit-cli = ub.goods.unit-base 
        and ub.bar-code.in-code = ''
        and ub.bar-code.part-code = '' no-lock no-error.
      if not available(ub.bar-code) then next.
      response = response + string(ub.bar-code.b-code) + ',' +
        replace(replace(replace(replace(ub.goods.label-name, "&", "&amp;"), '"', "&quot;") , "'", "&apos;"), ',', '.') + ',' +
        replace(replace(replace(replace(if ub.goods.engl-name = ? then "" else ub.goods.engl-name, "&", "&amp;"), '"', "&quot;") , "'", "&apos;"), ',', '.') + ',' +
        trim(string(ub.gds-obj.price-sale, "->>>>>>>>>>>9.99")) + '|'.
    end.
    SomeStr = response.

  end method.
  
end class.