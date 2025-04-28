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



