disable triggers for load of ub.parts .

{ utl/runpro.i }

define input parameter p-obj-code as character no-undo .
define input parameter p-gds-code as character no-undo .

define buffer minus_parts for ub.parts .
define buffer bf_parts for ub.parts .

define variable v-minus-qnty as decimal no-undo .
define variable v-minus-fact-qnty as decimal no-undo .
define variable v-minus-cli-qnty as decimal no-undo .
define variable v-minus-real-qnty as decimal no-undo .

find first goods no-lock where goods.gds-code = integer(p-gds-code) no-error .
if not available goods
then do :
  message "Не найден товар с кодом " p-gds-code view-as alert-box .
  return .
end .

find first minus_parts no-lock where minus_parts.out-code = "free-zone"
                                 and minus_parts.obj-type = "маг"
                                 and minus_parts.obj-code = integer(p-obj-code)
                                 and minus_parts.artic = goods.artic
                                 and minus_parts.prod-type = goods.prod-type
                                 and minus_parts.prod-code = goods.prod-code
                                 and minus_parts.qnty < 0
                                 no-error .
if not available minus_parts
then do :
  message "Не найдено отрицательных партий свободной зоны для компенсации!" view-as alert-box .
  return .
end .                                 

for each minus_parts exclusive-lock where minus_parts.out-code = "free-zone"
                                      and minus_parts.obj-type = "маг"
                                      and minus_parts.obj-code = integer(p-obj-code)
                                      and minus_parts.artic = goods.artic
                                      and minus_parts.prod-type = goods.prod-type
                                      and minus_parts.prod-code = goods.prod-code
                                      and minus_parts.qnty < 0
                                      :
  find first bf_parts exclusive-lock where bf_parts.out-code = minus_parts.out-code
                                       and bf_parts.obj-type = minus_parts.obj-type
                                       and bf_parts.obj-code = minus_parts.obj-code
                                       and bf_parts.artic = minus_parts.artic
                                       and bf_parts.prod-type = minus_parts.prod-type
                                       and bf_parts.prod-code = minus_parts.prod-code
                                       and bf_parts.pl-code = minus_parts.pl-code
                                       and bf_parts.qnty >= abs(minus_parts.qnty)
                                       no-error .
  if not available bf_parts
  then do :
    for each bf_parts exclusive-lock where bf_parts.out-code = minus_parts.out-code
                                       and bf_parts.obj-type = minus_parts.obj-type
                                       and bf_parts.obj-code = minus_parts.obj-code
                                       and bf_parts.artic = minus_parts.artic
                                       and bf_parts.prod-type = minus_parts.prod-type
                                       and bf_parts.prod-code = minus_parts.prod-code
                                       and bf_parts.pl-code = minus_parts.pl-code
                                       and bf_parts.qnty > 0
                                       :
      assign  
        v-minus-qnty = min(abs(minus_parts.qnty), bf_parts.qnty)
        v-minus-fact-qnty = min(abs(minus_parts.fact-qnty), bf_parts.fact-qnty)
        v-minus-cli-qnty = min(abs(minus_parts.cli-qnty), bf_parts.cli-qnty)
        v-minus-real-qnty = min(abs(minus_parts.real-qnty), bf_parts.real-qnty)
      .
      assign
        bf_parts.qnty = bf_parts.qnty - v-minus-qnty
        bf_parts.fact-qnty = bf_parts.fact-qnty - v-minus-fact-qnty
        bf_parts.cli-qnty = bf_parts.cli-qnty - v-minus-cli-qnty
        bf_parts.real-qnty = bf_parts.real-qnty - v-minus-real-qnty
      .
      assign
        minus_parts.qnty = minus_parts.qnty + v-minus-qnty
        minus_parts.fact-qnty = minus_parts.fact-qnty + v-minus-fact-qnty
        minus_parts.cli-qnty = minus_parts.cli-qnty + v-minus-cli-qnty
        minus_parts.real-qnty = minus_parts.real-qnty + v-minus-real-qnty
      .            
      if bf_parts.qnty = 0
      then do :
        delete bf_parts .
      end .      
      if minus_parts.qnty = 0
      then do :
        release bf_parts no-error .
        delete minus_parts no-error .
      end .                
    end .
  end .   
  else do :
    assign
      bf_parts.qnty = bf_parts.qnty + minus_parts.qnty
      bf_parts.fact-qnty = bf_parts.fact-qnty + minus_parts.fact-qnty
      bf_parts.cli-qnty = bf_parts.cli-qnty + minus_parts.cli-qnty
      bf_parts.real-qnty = bf_parts.real-qnty + minus_parts.real-qnty
    . 
    if bf_parts.qnty = 0
    then do :
      delete bf_parts .
    end .
    else do :
      release bf_parts .
    end .
    delete minus_parts no-error .     
  end .                           
end .

message "Готово!" view-as alert-box .
