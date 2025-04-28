

FUNCTION getNunHoses RETURNS integer /*Получение кол-ва рукавов*/
  (p-doc-code as character) :
  define variable vGateValve as character no-undo.  
  define variable vOk        as logical   no-undo.  
  define variable vNumHoses  as integer   no-undo init 0.  
    
  define buffer buf_doc-pl        for ub.doc-pl.
  define buffer buf_place         for ub.place.
  define buffer buf_doc-line      for ub.doc-line.
  define buffer buf_goods         for ub.goods.
  define buffer buf_doc-line-attr for ub.doc-line-attr.
  
  find first buf_doc-pl where
    buf_doc-pl.out-code = p-doc-code
    no-lock no-error.
  if avail buf_doc-pl then
    find first buf_place where
      buf_place.obj-type = buf_doc-pl.obj-type
      and buf_place.obj-code = buf_doc-pl.obj-code
      and buf_place.pl-code  = buf_doc-pl.pl-code
      no-lock no-error.
  if avail buf_place then 
  do:
    run placelib_get-attr  ( 
      input {&place-gate-valve}
      ,input buf_place.obj-code
      ,input buf_place.obj-type
      ,input buf_place.pl-code
      ,output vGateValve
      ,output vOk      
      ) no-error.
    if not vOk or not logical(vGateValve) then
      vNumHoses = 1. 
    else 
    do:
      for first buf_doc-line where  
        buf_doc-line.doc-code = p-doc-code 
        no-lock,
        first buf_goods where 
        buf_goods.artic     =  buf_doc-line.artic
        and buf_goods.prod-code =  buf_doc-line.prod-code
        and buf_goods.prod-type =  buf_doc-line.prod-type 
        no-lock,
        first buf_doc-line-attr where
        buf_doc-line-attr.doc-code  = p-doc-code   
        and buf_doc-line-attr.gds-code  = buf_goods.gds-code
        and buf_doc-line-attr.attr-code = "connect-hoses"
        no-lock:
        vNumHoses = if buf_doc-line-attr.attr-value = "yes" then 1 else 0.
      end.         
    end.
  end. 

  RETURN vNumHoses.

END FUNCTION.

function tempRas RETURNS decimal /*температура*/
  (doc-code as character,
  is-rvs as logical,
  gds-code as integer,
  pl-code as integer):
     
  define variable v-temp as decimal no-undo .
  
  define buffer buf_rvs-line for ub.rvs-line .
  define buffer buf_rvs-doc  for ub.rvs-doc .
  
  for each buf_rvs-doc no-lock where buf_rvs-doc.out-code = doc-code and
    buf_rvs-doc.rvs-type = {&rvs-after-doc} :
    for each buf_rvs-line no-lock where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code and
      buf_rvs-line.gds-code = gds-code and
      buf_rvs-line.pl-code = pl-code :
      v-temp = if is-rvs then buf_rvs-line.state-temperature else buf_rvs-line.temperature .
    end.
    return v-temp .
  end.
  return 0 .
end function. 

function masRas RETURNS decimal /*массовая доля пропана*/
  (doc-code as character,
  gds-code as integer,
  pl-code as integer):
     
  define variable v-masDol as decimal no-undo .
  
  define buffer buf_doc-line-attr for ub.doc-line-attr .
    
  for first buf_doc-line-attr exclusive-lock where buf_doc-line-attr.doc-code = doc-code
    and buf_doc-line-attr.gds-code = gds-code
    and buf_doc-line-attr.attr-code = "propan-perc":
    v-masDol = decimal (buf_doc-line-attr.attr-value) .                                    
  end.
  return v-masDol .                                           

end function. 

function autoAttr RETURNS character /**/
  (doc-code as character,
  attr-code as character):
  
  define buffer buf_doc-attr       for ub.doc-attr .
  define buffer buf_auto-tank-attr for ub.auto-tank-attr .
  
  find first buf_doc-attr no-lock where buf_doc-attr.attr-code = {&trdcattr-car-num}
    and buf_doc-attr.doc-code = doc-code no-error .
  if available (buf_doc-attr) then 
  do:
    find first buf_auto-tank-attr no-lock where 
      buf_auto-tank-attr.attr-code = attr-code and
      buf_auto-tank-attr.auto-num = buf_doc-attr.attr-value no-error .
    if available (buf_auto-tank-attr) then return buf_auto-tank-attr.attr-value .
  end.
  return "" .
end function. 

function volumeGF RETURNS decimal /*Объем слитой ЖФ СУГ*/
  (doc-code as character,
  gds-code as integer,
  pl-code as integer):
    
  define buffer buf_rvs-line for ub.rvs-line .
  define buffer buf_rvs-doc  for ub.rvs-doc .
  for each buf_rvs-doc no-lock where buf_rvs-doc.out-code = doc-code and
    buf_rvs-doc.rvs-type = {&rvs-after-doc}:
    find first buf_rvs-line no-lock where buf_rvs-line.rvs-code = doc-code 
      and buf_rvs-line.gds-code = gds-code 
      and buf_rvs-line.pl-code = pl-code no-error .
    if available (buf_rvs-line) then return buf_rvs-line.state-measure-tc-qnty .
  end.
  return 0 .
end function. 

procedure tp-rtr:
  /* ТП при продувке резинотканевых рукавов для удаления воздуха
  Таблица 6 Нормы тех. потерь СУГ при продувке рукавов
  Температура (С)		Массовая доля пропана (%)	Коэффициент
  от -40 до -20 (вкл)	от 0 до 50 (вкл)		0,040
  от -40 до -20 (вкл)	от 50 до 60 (вкл)		0,050
  от -40 до -20 (вкл)	Более 60			    0,060
  от -20 до 0 (вкл)	от 0 до 50 (вкл)		0,070
  от -20 до 0 (вкл)	от 50 до 60 (вкл)		0,080
  от -20 до 0 (вкл)	Более 60			    0,110
  от 0 до 20 (вкл)	от 0 до 50 (вкл)		0,130
  от 0 до 20 (вкл)	от 50 до 60 (вкл)		0,150
  от 0 до 20 (вкл)	Более 60			    0,200
  более 20         	от 0 до 50 (вкл)		0,210
  более 20	        от 50 до 60 (вкл)		0,240
  более 20	        Более 60			    0,310  */
  DEFINE INPUT  PARAMETER sug-temp  AS INTEGER NO-UNDO .
  DEFINE INPUT  PARAMETER mass-prop AS INTEGER NO-UNDO .
  DEFINE OUTPUT PARAMETER ktp       AS DECIMAL NO-UNDO .
  DO:
    if     sug-temp >  -40 and sug-temp <= -20
      and mass-prop >   0 and mass-prop <= 50
      then ktp = 0.040 .
    if     sug-temp >  -40 and sug-temp <= -20  
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 0.050  .
    if     sug-temp >  -40 and sug-temp <= -20  
      and mass-prop >  60
      then ktp = 0.060  .
    if      sug-temp  > -20 and sug-temp  <=  0  
      and mass-prop >   0 and mass-prop <= 50
      then ktp = 0.070  .
    if      sug-temp  > -20 and sug-temp  <=  0  
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 0.080 .
    if      sug-temp > -20 and sug-temp <=  0  
      and mass-prop > 60
      then ktp = 0.110 . 
    if      sug-temp >    0 and sug-temp <=  20  
      and mass-prop >   0 and mass-prop <= 50
      then ktp = 0.130    .
    if      sug-temp >    0 and sug-temp <=  20  
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 0.150        .       
    if      sug-temp >   0  and sug-temp <= 20  
      and mass-prop > 60
      then ktp = 0.2 .       
    if      sug-temp >   20 
      and mass-prop >   0 and mass-prop <= 50
      then ktp = 0.210  .
    if      sug-temp >   20 
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 0.240   .       
    if  sug-temp >      20  
      and mass-prop > 60
      then ktp = 0.310  .       
  END.                                             
END PROCEDURE. 

procedure tp-arm:
  /* ТП при продувке СУГ участка арматуры между запорными устройствами 
  резинотканевых рукавов и АЦ для удаления воздуха
  Таблица 7 Нормы тех. потерь СУГ при продувке рукавов
  Температура (С)	        Массовая доля пропана (%)	Коэффициент
  от -40 до -20 (вкл)	от 0 до 50 (вкл)		0,040
  от -40 до -20 (вкл)	от 50 до 60 (вкл)		0,040
  от -40 до -20 (вкл)	Более 60			    0,050
  от -20 до 0 (вкл)	от 0 до 50 (вкл)		0,070
  от -20 до 0 (вкл)	от 50 до 60 (вкл)		0,070
  от -20 до 0 (вкл)	Более 60			    0,100
  от 0 до 20 (вкл)	от 0 до 50 (вкл)		0,120
  от 0 до 20 (вкл)	от 50 до 60 (вкл)		0,190
  от 0 до 20 (вкл)	Более 60			    0,220
  более 20		от 0 до 50 (вкл)		    0,210
  более 20		от 50 до 60 (вкл)		    0,240
  более 20		Более 60			        0,280 */
  DEFINE INPUT  PARAMETER  sug-temp  AS INTEGER NO-UNDO .
  DEFINE INPUT  PARAMETER  mass-prop AS INTEGER NO-UNDO .
  DEFINE OUTPUT PARAMETER  ktp       AS DECIMAL NO-UNDO .
  DO:
    if     sug-temp  >  -40 and sug-temp <= -20  
      and mass-prop >   0 and mass-prop <= 50
      then ktp = 0.040   .
    if     sug-temp >  -40 and sug-temp <= -20  
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 0.040   .
    if     sug-temp >  -40 and sug-temp <= -20  
      and mass-prop >  60
      then ktp = 0.050       .
    if      sug-temp  > -20 and sug-temp  <=  0  
      and mass-prop >   0 and mass-prop <= 50
      then ktp = 0.070       .
    if      sug-temp  > -20 and sug-temp  <=  0  
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 0.070  .
    if      sug-temp > -20 and sug-temp <=  0  
      and mass-prop > 60
      then ktp = 0.100  . 
    if      sug-temp  >   0 and sug-temp <=  20  
      and mass-prop >   0 and mass-prop <= 50
      then ktp = 0.120    .
    if      sug-temp >    0 and sug-temp <=  20  
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 0.190    .       
    if      sug-temp >    0  and sug-temp <=  20  
      and mass-prop >  60
      then ktp = 0.220   .       
    if      sug-temp >   20 and mass-prop >   0
      and mass-prop <= 50 
      then ktp = 0.210   .
    if      sug-temp >   20 
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 0.240   .       
    if      sug-temp >   20 and mass-prop >  60
      then ktp = 0.280   .              
  END.                                             
END PROCEDURE. 

procedure tp-emp:    
  /* ТП при опорожнении резинотканевых рукавов по окончании налива (слива) АЦ
  Таблица 8 Нормы тех. потерь СУГ при опорожнении рукавов
  Температура (С)	    Массовая доля пропана (%)	Длина рукава (м)    Коэффициент
  от -40 до -20 (вкл)	от 0 до 50 (вкл)	от 0 до 7 (вкл)		7,081
  от -40 до -20 (вкл)	от 0 до 50 (вкл)	более 7			    9,441
  от -40 до -20 (вкл)	от 50 до 60 (вкл)	от 0 до 7 (вкл)		7,087
  от -40 до -20 (вкл)	от 50 до 60 (вкл)	более 7			    9,449
  от -40 до -20 (вкл)	более 60		от 0 до 7 (вкл)		    7,099
  от -40 до -20 (вкл)	более 60		более 7			        9,466
  от -20 до 0 (вкл)	от 0 до 50 (вкл)	от 0 до 7 (вкл)		6,793
  от -20 до 0 (вкл)	от 0 до 50 (вкл)	более 7		    	9,057
  от -20 до 0 (вкл)	от 50 до 60 (вкл)	от 0 до 7 (вкл)		6,801
  от -20 до 0 (вкл)	от 50 до 60 (вкл)	более 7			9,068
  от -20 до 0 (вкл)	более 60		от 0 до 7 (вкл)		6,822
  от -20 до 0 (вкл)	более 60		более 7		    	9,096
  от 0 до 20 (вкл)	от 0 до 50 (вкл)	от 0 до 7 (вкл)		6,550
  от 0 до 20 (вкл)	от 0 до 50 (вкл)	более 7			    8,734
  от 0 до 20 (вкл)	от 50 до 60 (вкл)	от 0 до 7 (вкл)		6,566
  от 0 до 20 (вкл)	от 50 до 60 (вкл)	более 7		8,755
  от 0 до 20 (вкл)	более 60		от 0 до 7 (вкл)	6,605
  от 0 до 20 (вкл)	более 60		более 7			8,807
  более 20		от 0 до 50 (вкл)	от 0 до 7 (вкл)	6,294
  более 20		от 0 до 50 (вкл)	более 7			8,393
  более 20		от 50 до 60 (вкл)	от 0 до 7 (вкл)	6,317
  более 20		от 50 до 60 (вкл)	более 7			8,423
  более 20		более 60		от 0 до 7 (вкл)		6,377
  более 20		более 60		более 7			    8,502 */
  DEFINE INPUT  PARAMETER  sug-temp  AS INTEGER NO-UNDO .
  DEFINE INPUT  PARAMETER  mass-prop AS INTEGER NO-UNDO .
  DEFINE INPUT  PARAMETER  length    AS INTEGER NO-UNDO .
  DEFINE OUTPUT PARAMETER  ktp       AS DECIMAL NO-UNDO .
  DO:
    if     sug-temp  > -40 AND sug-temp  <= -20
      and mass-prop >   0 and mass-prop <=  50
      and length    >   0 and length    <=   7
      then ktp = 7.081    .
    if     sug-temp  >  -40 AND sug-temp  <= -20
      and mass-prop >    0 and mass-prop <=  50
      and length    >    7
      then ktp = 9.441   .        
    if     sug-temp  >  -40 AND sug-temp  <= -20
      and mass-prop >   50 and mass-prop <=  60
      and length    >    0 and length    <=   7
      then ktp = 7.087   .       
    if     sug-temp  >  -40 AND sug-temp  <= -20
      and mass-prop >   50 and mass-prop <=  60
      and length    >    7
      then ktp = 9.449  .       
    if     sug-temp  >  -40 AND sug-temp  <= -20
      and mass-prop >   60 
      and length    >    0 and length    <=   7
      then ktp = 7.099          .
    if     sug-temp  >  -40 AND sug-temp  <= -20
      and mass-prop >   60
      and length    >    7
      then ktp = 9.466    .
    if     sug-temp  >  -20 AND sug-temp  <=   0
      and mass-prop >    0 and mass-prop <=  50
      and length    >    0 and length    <=   7
      then ktp = 6.793   .
    if     sug-temp  >  -20 AND sug-temp  <=   0
      and mass-prop >    0 and mass-prop <=  50
      and length    >    7
      then ktp = 9.057  .
    if     sug-temp  >  -20 AND sug-temp  <=   0
      and mass-prop >   50 and mass-prop <=  60
      and length    >    0 and length    <=   7
      then ktp = 6.801   .              
    if     sug-temp  >  -20 AND sug-temp  <=   0
      and mass-prop >   50 and mass-prop <=  60
      and length    >    7 
      then ktp = 9.068  .               
    if     sug-temp  >  -20 AND sug-temp  <=   0
      and mass-prop >   60 
      and length    >    0 and length    <=   7
      then ktp = 6.822   .                
    if     sug-temp  >  -20 AND sug-temp  <=   0
      and mass-prop >   60
      and length    >    7
      then ktp = 9.095    .                  
    if     sug-temp  >    0 AND sug-temp  <=  20
      and mass-prop >    0 and mass-prop <=  50
      and length    >    0 and length    <=   7
      then ktp = 6.550    .
    if     sug-temp  >    0 AND sug-temp  <=  20
      and mass-prop >    0 and mass-prop <=  50
      and length    >    7
      then ktp = 8.734   .    
    if     sug-temp  >   0 AND sug-temp  <=  20
      and mass-prop >   50 and mass-prop <=  60
      and length    >    0 and length    <=   7
      then ktp = 6.566 .   
    if     sug-temp  >    0 AND sug-temp  <=  20
      and mass-prop >   50 and mass-prop <=  60
      and length    >    7
      then ktp = 8.755  .      
    if    sug-temp  >     0 AND sug-temp  <=  20
      and mass-prop >   60 
      and length    >    0 and length    <=   7
      then ktp = 6.605 .         
    if    sug-temp   >    0 AND sug-temp  <=  20
      and mass-prop >   60
      and length    >    7
      then ktp = 8.807  .            
    if    sug-temp   >   20 
      and mass-prop >    0 and mass-prop <=  50
      and length    >    0 and length    <=   7
      then ktp = 6.294  .                   
    if    sug-temp   >   20 
      and mass-prop >   50 and mass-prop <=  60
      and length    >    0 and length    <=   7
      then ktp = 6.317  .               
    if    sug-temp   >   20 
      and mass-prop >   50 and mass-prop <=  60
      and length    >    7
      then ktp = 8.423   .          
    if    sug-temp   >   20 
      and mass-prop >   60
      and length    >    0 and length    <=   7
      then ktp = 6.377    .              
    if    sug-temp   >   20 
      and mass-prop <=  60
      and length    >    0 and length    >    7
      then ktp = 8.502   .                     
  END.                                             
END PROCEDURE. 

procedure tp-ret:
  /* ТП при возврате АЦ 
  Таблица 9 Нормы тех. потерь СУГ при опорожнении рукавов
  Температура (С)		Коэффициент
  от -40 до -20 (вкл)	3,630
  от -20 до 0 (вкл)	3,350
  от 0 до 20 (вкл)	3,110
  более 20		    2,910  */
  DEFINE INPUT  PARAMETER  sug-temp  AS INTEGER NO-UNDO .
  DEFINE OUTPUT PARAMETER  ktp       AS DECIMAL NO-UNDO .
  DO:
    if sug-temp > -40 and sug-temp <= -20 then ktp = 3.630 .                        
    if sug-temp > -20 and sug-temp <=   0 then ktp = 3.350 .                        
    if sug-temp >   0 and sug-temp <=  20 then ktp = 3.110 .                               
    if sug-temp >  20                     then ktp = 2.910 .                                      
  END.                                             
END PROCEDURE. 

procedure tp-chklv:
  /* ТП при проверке уровня наполнения с помощью контрольного вентиля АЦ
  Таблица 10 Нормы тех.потерь СУГ при проверке уровня наполнения АЦ
  Температура (С)	     Массовая доля пропана (%)	Коэффициент
  от -40 до -20 (вкл)	от 0 до 50 (вкл)	2,300
  от -40 до -20 (вкл)	от 50 до 60 (вкл)	2,570
  от -40 до -20 (вкл)	Более 60		    3,140
  от -20 до 0 (вкл)	от 0 до 50 (вкл)	3,690
  от -20 до 0 (вкл)	от 50 до 60 (вкл)	4,070
  от -20 до 0 (вкл)	Более 60		    4,980
  от 0 до 20 (вкл)	от 0 до 50 (вкл)	6,090
  от 0 до 20 (вкл)	от 50 до 60 (вкл)	6,770
  от 0 до 20 (вкл)	Более 60		    8,400
  более 20		от 0 до 50 (вкл)	    9,150
  более 20		от 50 до 60 (вкл)	    10,100
  более 20		Более 60	        	12,530 */
  DEFINE INPUT  PARAMETER  sug-temp  AS INTEGER NO-UNDO .
  DEFINE INPUT  PARAMETER  mass-prop AS INTEGER NO-UNDO .
  DEFINE OUTPUT PARAMETER  ktp       AS DECIMAL NO-UNDO .
  DO:
    if     sug-temp >  -40 and sug-temp <= -20  
      and mass-prop >   0 and mass-prop <= 50
      then ktp = 2.300   .
    if  sug-temp >  -40 and sug-temp <= -20  
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 2.570   .
    if  sug-temp >  -40 and sug-temp <= -20  
      and mass-prop >  60 
      then ktp = 3.140   .
    if  sug-temp >  -20 and sug-temp <=   0  
      and mass-prop >   0 and mass-prop <= 50
      then ktp = 3.690         .
    if  sug-temp >  -20 and sug-temp <=   0  
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 4.070   .
    if  sug-temp >  -20 and sug-temp <=   0  
      and mass-prop >  60
      then ktp = 4.980   .
    if  sug-temp >   0 and sug-temp <=  20  
      and mass-prop >  0 and mass-prop <= 50
      then ktp = 6.090    .
    if  sug-temp >    0 and sug-temp <=  20  
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 6.770   .
    if  sug-temp >    0 and sug-temp <=  20  
      and mass-prop >  60
      then ktp = 8.400   .
    if  sug-temp >   20 
      and mass-prop >   0 and mass-prop <= 50
      then ktp = 9.150 .
    if  sug-temp >   20 
      and mass-prop >  50 and mass-prop <= 60
      then ktp = 10.100  .
    if  sug-temp  > 20 
      and mass-prop > 60
      then ktp = 12.530  .       
  END.                                             
END PROCEDURE.

procedure doc-line-write:
  define input parameter doc-code as character no-undo .
  define input parameter attr-code as character no-undo .
  define input parameter gds-code as integer no-undo .
  define input parameter attr-value as character no-undo .
  find first ub.doc-line-attr exclusive-lock where ub.doc-line-attr.attr-code = attr-code
    and ub.doc-line-attr.doc-code = doc-code
    and ub.doc-line-attr.gds-code = gds-code no-error .
  if not available (ub.doc-line-attr) then 
  do:
    create ub.doc-line-attr .
    assign
      ub.doc-line-attr.attr-code = attr-code
      ub.doc-line-attr.doc-code  = doc-code
      ub.doc-line-attr.gds-code  = gds-code
      .
  end.
  ub.doc-line-attr.attr-value = attr-value .
end procedure .  

procedure doc-line-value:
  define input parameter doc-code as character no-undo .
  define input parameter attr-code as character no-undo .
  define input parameter gds-code as integer no-undo .
  define output parameter attr-value as character no-undo .
  find first ub.doc-line-attr exclusive-lock where ub.doc-line-attr.attr-code = attr-code
    and ub.doc-line-attr.doc-code = doc-code
    and ub.doc-line-attr.gds-code = gds-code no-error .
  if available (ub.doc-line-attr) then 
  do:
    attr-value = ub.doc-line-attr.attr-value .
  end.

end procedure .  

procedure spr-sug:
  define input parameter doc-code as character no-undo .
  define input parameter reason-code as integer no-undo .
  define buffer buf_doc-pl   for ub.doc-pl .
  define buffer buf_doc-line for ub.doc-line .
  define buffer buf_doc-attr for ub.doc-attr .
  define variable numHoses    as integer   no-undo .
  define variable vBlowdown   as decimal   no-undo .
  define variable vFittings   as decimal   no-undo .
  define variable vEmptying   as decimal   no-undo .
  define variable vRefund     as decimal   no-undo .
  define variable vCtrlvalve  as decimal   no-undo .
  define variable vTemp       as decimal   no-undo .
  define variable vMasDol     as decimal   no-undo .
  define variable vVolue      as decimal   no-undo .
  define variable is-rvd      as logical   no-undo .
  define variable lengthRukav as decimal   no-undo .
  define variable ktp         as decimal   no-undo .
  define variable valve       as logical   no-undo .
  define variable clear-ac    as logical   no-undo .
  define variable GNS         as character no-undo .
  
  numHoses = getNunHoses(doc-code) . 
  lengthRukav = decimal (autoAttr(doc-code,"con-sleeve")) .
  valve = if autoAttr(doc-code, "valve") = "" then false else logical(autoAttr(doc-code, "valve")) .

  find first buf_doc-attr no-lock where buf_doc-attr.attr-code = {&trdcattr-clear-ac} and
    buf_doc-attr.doc-code = doc-code no-error .
  if available (buf_doc-attr) then clear-ac = logical (buf_doc-attr.attr-value) .

  find first buf_doc-attr no-lock where buf_doc-attr.attr-code = {&trdcattr-ptbobj} and
    buf_doc-attr.doc-code = doc-code no-error .
  if available (buf_doc-attr) then GNS = buf_doc-attr.attr-value .

  for each buf_doc-line no-lock where buf_doc-line.doc-code = doc-code:
    find first ub.goods no-lock where ub.goods.artic = buf_doc-line.artic and
      ub.goods.prod-code = buf_doc-line.prod-code and
      ub.goods.prod-type = buf_doc-line.prod-type no-error .
    for first buf_doc-pl no-lock where buf_doc-pl.out-code = buf_doc-line.doc-code and
      buf_doc-pl.gds-code = ub.goods.gds-code:
      find first ub.place-attr where ub.place-attr.attr-code = "place-rvd-tmp"
        and ub.place-attr.pl-code = buf_doc-pl.pl-code
        and ub.place-attr.obj-code = buf_doc-line.obj-code
        and ub.place-attr.obj-type = buf_doc-line.obj-type no-error .
      if available (ub.place-attr) then is-rvd = logical (ub.place-attr.attr-value) .
      else is-rvd = false .

      vTemp = tempRas(doc-code, is-rvd, ub.goods.gds-code, buf_doc-pl.pl-code) .
      vMasDol = masRas(doc-code, ub.goods.gds-code, buf_doc-pl.pl-code) .
      vVolue = volumeGF(doc-code, ub.goods.gds-code, buf_doc-pl.pl-code) .
      
      run tp-rtr(vTemp, vMasDol, output ktp) .
      vBlowdown = ktp * numHoses . /*Значение технологических потерь при продувке резинотканевых рукавов для удаления воздуха*/
      run tp-arm(vTemp, vMasDol, output ktp) .
      vFittings = ktp * numHoses . /*Значение технологических потерь при продувке участка арматуры между запорными устройствами резинотканевых рукавов и АЦ для удаления воздуха*/
      run tp-emp(vTemp, vMasDol, lengthRukav, output ktp) .
      vEmptying = ktp * numHoses . /*Значение технологических потерь при опорожнении резинотканевых рукавов по окончании налива (слива) АЦ*/
      run tp-ret(vTemp, output ktp) .
      if GNS > ""  and clear-ac then vRefund = ktp * vVolue .
      else vRefund = 0 .
      run tp-chklv(vTemp, vMasDol, output ktp) .
      if reason-code = 99 and valve then vCtrlvalve = ktp .
      else vCtrlvalve = 0 .
      
      run doc-line-write(doc-code, "blowdown", ub.goods.gds-code, string (vBlowdown)) .
      run doc-line-write(doc-code, "fittings", ub.goods.gds-code, string (vFittings)) .
      run doc-line-write(doc-code, "emptying", ub.goods.gds-code, string (vEmptying)) .
      run doc-line-write(doc-code, "refund", ub.goods.gds-code, string (vRefund)) .
      run doc-line-write(doc-code, "ctrlvalve", ub.goods.gds-code, string (vCtrlvalve)) .

    end.
  end.


/*    vBlowdown = blowdown(numHoses, vTemp, vMasDol) . */
end procedure .


