/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт сообщения с накладаной в 1С ERPRN trn-gd-doc

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
using ibs.th.str.*.
using ibs.th.str.mercury.*.
using ibs.th.gbl.storage.*.

block-level on error undo, throw.

class ibs.th.bge.1crn.subjects.trn-gd-doc implements iexpsubject:

  { cmp/str-glbl.i class }
  { str/lib-trn.i  class }
  { cmp/library.i  class }
  
  &scop create-record find first buf_doc-attr where buf_doc-attr.doc-code = DocCode and buf_doc-attr.attr-code = ~{&~{&attr-code~}~} no-error. ~
  if available (buf_doc-attr) then write-data-element (buf_doc-attr.attr-code, buf_doc-attr.attr-value).
    
  &scop create-record-date find first buf_doc-attr where buf_doc-attr.doc-code = DocCode and buf_doc-attr.attr-code = ~{&~{&attr-code~}~} no-error. ~
  if available (buf_doc-attr) then write-data-element (buf_doc-attr.attr-code, iso-date (date (buf_doc-attr.attr-value))). 

  &scop create-record-cust find first buf_doc-attr where buf_doc-attr.doc-code = DocCode and buf_doc-attr.attr-code = ~{&~{&attr-code~}~} no-error. ~
  if available (buf_doc-attr) then write-data-element ('~{&tag-code~}', (buf_doc-attr.attr-value)).
  
  &scop create-record-cust-obj-code find first buf_doc-attr where buf_doc-attr.doc-code = DocCode and buf_doc-attr.attr-code = ~{&~{&attr-code~}~} no-error. ~
  if available (buf_doc-attr) then write-data-element ('~{&tag-code~}', (if buf_doc-attr.attr-value = ""  or buf_doc-attr.attr-value = ? then "" else ((if num-entries (buf_doc-attr.attr-value, ";") = 2 then (entry (2, buf_doc-attr.attr-value, ";" )) else substring (buf_doc-attr.attr-value, 4, length ( buf_doc-attr.attr-value)))))).

  &scop create-record-cust-time find first buf_doc-attr where buf_doc-attr.doc-code = DocCode and buf_doc-attr.attr-code = ~{&~{&attr-code~}~} no-error. ~
  if available (buf_doc-attr) then write-data-element ('~{&tag-code~}', (string-mth (integer (buf_doc-attr.attr-value), "HH:MM"))) no-error.

  &scop create-record-cust-date find first buf_doc-attr where buf_doc-attr.doc-code = DocCode and buf_doc-attr.attr-code = ~{&~{&attr-code~}~} no-error. ~
  if available (buf_doc-attr) then write-data-element ('~{&tag-code~}', iso-date (date (buf_doc-attr.attr-value))).  

  define temp-table buf_trn-doc like ub.trn-doc.
  
  define buffer buf_doc-line for ub.doc-line.
  define buffer buf_parts for ub.parts.
  define buffer buf_gds-dtl for ub.gds-dtl.
  define buffer buf_doc-pl for ub.doc-pl.
  define buffer buf_gds for ub.goods.
  define buffer buf_doc-attr for ub.doc-attr.
  
  define property Msg as character no-undo
    get:
      return trim (Msg, {&new-line}).
    end.
    private set (inArg as char):
      Msg = Msg + {&new-line} + inArg.
    end.

  define property InitSecTag as character no-undo
    get.
    private set.

  define property DocCode as character no-undo
    get.
    set.

  define property BufTableHndlNew as handle no-undo
    get.
    set.

  define property BufTableHndlOld as handle no-undo
    get.
    set.
  
  define variable sw               as handle    no-undo.
  define variable v-doc-type-ERPRN as character no-undo.
  define variable v-is-petrol-trn  as logical   no-undo.
  define variable v-is-pieces      as logical   no-undo.
  define variable isDel            as logical   no-undo.
  define variable v-bufhnd         as handle    no-undo.
  define variable v-user-name      as character no-undo.


  method public void CrContentToSW (insw as handle):

    sw = insw.
    
    
    create buf_trn-doc.
    
    v-bufhnd = buffer buf_trn-doc:handle.
    
    if valid-handle (BufTableHndlNew)
    then do:
      v-bufhnd:buffer-copy (BufTableHndlNew) no-error.
      if error-status:error
      then do:
        Msg = "Ошибка выгрузки trn-gd-code, неверный буфер BufTableHndlNew".
        undo, return error Msg.
      end.
      isDel = false.
    end.
    else do:
      if not valid-handle (BufTableHndlOld)
      then do:
        Msg = "Ошибка выгрузки trn-gd-code, неопеределен ни старый ни новый буфер".
        undo, return error Msg.
      end.
      v-bufhnd:buffer-copy (BufTableHndlOld) no-error.
      if error-status:error
      then do:
        Msg = "Ошибка выгрузки trn-gd-code, неверный буфер BufTableHndlOld".
        undo, return error Msg.
      end.
      isDel = true.
    end.
    
    DocCode = buf_trn-doc.doc-code.
    
    for each buf_doc-line no-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code:
      { str/is-petrl.i
          buf_doc-line.artic
          buf_doc-line.prod-type
          buf_doc-line.prod-code
          v-is-petrol-trn
          v-is-pieces
      }
      if v-is-petrol-trn 
        then leave.
    end.
    
    if valid-handle (BufTableHndlOld) and BufTableHndlOld:buffer-field("ext-doc-type"):buffer-value = {&TDEDT_Pri_Perem}
      then buf_trn-doc.ext-doc-type = BufTableHndlOld:buffer-field("ext-doc-type"):buffer-value.
    
    { gbl/usrfulnm.i
      buf_trn-doc.creid
      v-user-name }
    
    if buf_trn-doc.reason-code = 23 and buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Vnesh} /*особый случай для расхода внешнего, если код основание 23 то это идет в 1С как возврат поставщику*/
    then do:
      v-doc-type-ERPRN = "2".
      if v-is-petrol-trn
        then StartDocTrnFuel().
        else StartDocTrn().
      SpiVnesh().
      if v-is-petrol-trn
        then EndDocTrnFuel().
        else EndDocTrn().
    end.
    else
      case buf_trn-doc.ext-doc-type:
        when {&TDEDT_Pri_Vnesh} then do:
          v-doc-type-ERPRN = "1".
          if v-is-petrol-trn
            then StartDocTrnFuel().
            else StartDocTrn().
          PriVnesh().
          if v-is-petrol-trn
            then EndDocTrnFuel().
            else EndDocTrn().
        end. 
        when {&TDEDT_Ras_Vnesh_VP} then do:
          v-doc-type-ERPRN = "2".
          if v-is-petrol-trn
            then StartDocTrnFuel().
            else StartDocTrn().
          SpiVnesh().
          if v-is-petrol-trn
            then EndDocTrnFuel().
            else EndDocTrn().
        end.
        when {&TDEDT_Ras_Perem} then do:
          v-doc-type-ERPRN = "3".
          if v-is-petrol-trn
            then StartDocTrnFuel().
            else StartDocTrn().
          RasPerem().
          if v-is-petrol-trn
            then EndDocTrnFuel().
            else do:
              writeprts ().
              EndDocTrn().
            end.
        end.
        when {&TDEDT_Pri_Perem} then do:
          v-doc-type-ERPRN = "4".
          if v-is-petrol-trn
            then StartDocTrnFuel().
            else StartDocTrn().
          PriPerem().
          if v-is-petrol-trn
            then EndDocTrnFuel().
            else EndDocTrn().
        end.
        when {&TDEDT_Spi_Vnesh} then do:
          v-doc-type-ERPRN = "5".
          if v-is-petrol-trn
            then StartDocTrnFuel().
            else StartDocTrn().
          SpiVnesh().
          if v-is-petrol-trn
            then EndDocTrnFuel().
            else EndDocTrn().
        end.
        when {&TDEDT_Ras_Vnesh} then do:
          v-doc-type-ERPRN = "7".
          if v-is-petrol-trn
            then StartDocTrnFuel().
            else StartDocTrn().
          SpiVnesh().
          if v-is-petrol-trn
            then EndDocTrnFuel().
            else EndDocTrn().
        end.
        when {&TDEDT_Vozvrat_Perem} or when {&TDEDT_Vozvrat_Vnesh} then do:
          v-doc-type-ERPRN = "8".
          StartDocTrn().
          PriPerem().
          EndDocTrn().
        end.
        otherwise do:
          return.
        end.
      end.
    
  end.


  method private void PriVnesh ():

    
    TrdcAattrPri().
    
    if v-is-petrol-trn
      then PriVneshLineFuel().
      else PriVneshLine().

    
  end.
  
  method private void PriPerem ():

    if v-doc-type-ERPRN = "4"
      then write-data-element ("fuel-st-code", string-mth (buf_trn-doc.cli-code)).

    if v-doc-type-ERPRN = "8"
      then write-data-element ("fuel-st-code", string-mth (buf_trn-doc.cli-code)).

    find first buf_doc-attr where buf_doc-attr.doc-code = DocCode and buf_doc-attr.attr-code = {&trdcattr-nids} no-error. ~
    if available (buf_doc-attr) 
    then do:
      write-data-element ('doc-id', buf_doc-attr.attr-value) no-error.
    end.  
    
    if v-is-petrol-trn
      then PriVneshLineFuel().
      else do: 
        PriVneshLine().
      end.

  end.
  
  method private void SpiVnesh ():

    if v-doc-type-ERPRN = "3"
      then write-data-element ("fuel-st-code", string-mth (buf_trn-doc.cli-code)).
    TrdcAattrRas().
        
    if v-is-petrol-trn
      then RasFuel().
      else Ras().
    
  end.
  
  method private void RasPerem ():
    
    if v-doc-type-ERPRN = "3"
      then write-data-element ("fuel-st-code", string-mth (buf_trn-doc.cli-code)).


    if v-is-petrol-trn
      then RasFuel().
      else Ras().
    
  end.

  method private void PriVneshLine ():
    
    sw:start-element ("gds").
    for each buf_doc-line no-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code:
      
      find first buf_gds no-lock where
            buf_gds.artic = buf_doc-line.artic 
        and buf_gds.prod-code = buf_doc-line.prod-code
        and buf_gds.prod-type = buf_doc-line.prod-type.
      
      sw:start-element ("gd").
        write-data-element ("line-num", string-mth (buf_doc-line.line-num)).
        write-data-element ("gd-code", string-mth (buf_gds.gds-code)).
        write-data-element ("unit-code", string (buf_doc-line.unit-cli)).
        write-data-element ("koef", string (buf_doc-line.cli-base-rate)).
        write-data-element ("qnty-ttn", string-mth (buf_doc-line.cli-qnty)).
        write-data-element ("qnty-fact", string-mth (buf_doc-line.fact-qnty / buf_doc-line.cli-base-rate)).
        
        if v-doc-type-ERPRN = "8"
        then do:
          find first buf_gds-dtl where buf_gds-dtl.doc-code = buf_trn-doc.doc-code
            and buf_gds-dtl.artic = buf_gds-dtl.artic 
            and buf_gds-dtl.prod-code = buf_gds-dtl.prod-code
            and buf_gds-dtl.prod-type = buf_gds-dtl.prod-type.
          write-data-element ("sum", string-mth (round (buf_gds-dtl.price-rubl * buf_gds-dtl.fact-qnty, 2))).
          write-data-element ("sum-nds", string-mth ( round ((buf_gds-dtl.price-rubl * buf_gds-dtl.fact-qnty * buf_doc-line.VAT-pc) / (100 + buf_doc-line.VAT-pc) , 2))).
          write-data-element ("nds-code", string-mth ( round (buf_doc-line.VAT-pc , 0))).
        end.
        else do:
          write-data-element ("sum", string-mth (round (buf_doc-line.price-cli * buf_doc-line.cli-qnty, 2))).
          write-data-element ("sum-nds", string-mth (round ((buf_doc-line.price-cli * buf_doc-line.cli-qnty * buf_doc-line.VAT-pc) / (100 + buf_doc-line.VAT-pc) , 2))).
          write-data-element ("nds-code", string-mth ( round (buf_doc-line.VAT-pc , 0))).
        end.
        
      sw:end-element ("gd").
      
    end.

    sw:end-element ("gds").
    
    writeprts ().
    
  end.

  method private void PriVneshLineFuel ():

    define variable infoSecsObj     as class InfoSectionsTotal no-undo.
    define variable infoSecObj      as class InfoSection       no-undo.
    define variable infoSecObjFirst as class InfoSection       no-undo.
    define variable ii as integer no-undo.
    define variable is-exist-sec as logical no-undo.
    
    
    infoSecsObj = new InfoSectionsTotal(). 

    &scop attr-code trdcattr-ptbobj
    &scop tag-code nb
    {&create-record-cust-obj-code}
    &scop attr-code trdcattr-ptb-item-pour
    &scop tag-code ptb-item-pour
    {&create-record-cust}
    &scop attr-code trdcattr-autoent
    &scop tag-code przk
    {&create-record-cust-obj-code}
    &scop attr-code trdcattr-car-num
    &scop tag-code tanker
    {&create-record-cust}
    &scop attr-code trdcattr-fio-driver
    &scop tag-code driver
    {&create-record-cust}
    &scop attr-code trdcattr-time-income
    &scop tag-code time-income
    {&create-record-cust}
    &scop attr-code trdcattr-inspection-cert
    &scop tag-code inspection-cert
    {&create-record-cust}
    &scop attr-code trdcattr-date-cert
    &scop tag-code date-cert
    {&create-record-cust-date}
    &scop attr-code trdcattr-condition
    &scop tag-code condition
    {&create-record-cust}
    
    find first buf_doc-attr where buf_doc-attr.doc-code = DocCode and buf_doc-attr.attr-code = {&trdcattr-seals-condition} no-error. ~
    if available (buf_doc-attr) 
    then do:
      write-data-element ('seales', entry (1, buf_doc-attr.attr-value, {&delim-par})) no-error.
      write-data-element ('seales-condition', entry (2, buf_doc-attr.attr-value, {&delim-par})) no-error.
    end.
    
    &scop attr-code trdcattr-date-pour
    &scop tag-code date-pour
    {&create-record-cust-date}
    &scop attr-code trdcattr-time-pour
    &scop tag-code time-pour
    {&create-record-cust}
    &scop attr-code trdcattr-doc-not
    &scop tag-code doc-not
    {&create-record-cust}
    &scop attr-code trdcattr-spisok-not-doc
    &scop tag-code spisok-not-doc
    {&create-record-cust}
    
    sw:start-element ("gds").
    for each buf_doc-line no-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code:
      
      find first buf_gds where
            buf_gds.artic = buf_doc-line.artic 
        and buf_gds.prod-code = buf_doc-line.prod-code
        and buf_gds.prod-type = buf_doc-line.prod-type.
      
      infoSecsObj:Initialization(buf_doc-line.doc-code, buf_gds.gds-code).
      infoSecsObj:GetDBAllAttr ().
      infoSecsObj:CalculateTotal().
      
      sw:start-element ("gd").
        write-data-element ("line-num", string-mth (buf_doc-line.line-num)).
        write-data-element ("gd-code", string-mth (buf_gds.gds-code)).
        write-data-element ("cap-ttn", string-mth (buf_doc-line.doc-qnty)).
        write-data-element ("wght-ttn", string-mth (buf_doc-line.cli-qnty)).
        write-data-element ("dnsty-ttn", string-mth (buf_doc-line.doc-density)).
        
        write-data-element ("cap-fact", string-mth (buf_doc-line.fact-qnty)).
        if not infoSecsObj:FactKgQntyTotal = 0
        then do:
          is-exist-sec = true.
          write-data-element ("wght-fact", string-mth (round (infoSecsObj:FactKgQntyTotal, 3))).
        end.
        else do:
          write-data-element ("wght-fact", string-mth (round (buf_doc-line.fact-density * buf_doc-line.fact-qnty, 3))).
        end.
        write-data-element ("dnsty-fact", string-mth (buf_doc-line.fact-density)).
        write-data-element ("sum", string-mth (round (buf_doc-line.price-cli * buf_doc-line.cli-qnty, 2))).
      
      sw:end-element ("gd").
    end.
    sw:end-element ("gds").

    if not buf_trn-doc.cli-code = 800000002 and is-exist-sec
    then do:
      
      sw:start-element ("scs").
      for each buf_doc-line no-lock where not v-doc-type-ERPRN = '4' and buf_doc-line.doc-code = buf_trn-doc.doc-code:
      
        find first buf_gds where
              buf_gds.artic = buf_doc-line.artic 
          and buf_gds.prod-code = buf_doc-line.prod-code
          and buf_gds.prod-type = buf_doc-line.prod-type.
          
        infoSecsObj:Initialization(buf_doc-line.doc-code, buf_gds.gds-code).
        infoSecsObj:GetDBAllAttr ().
        infoSecObjFirst = infoSecsObj:GetInfoSectionProp(1).
        do ii = 1 to infoSecsObj:SectionNum:
          infoSecObj = infoSecsObj:GetInfoSectionProp(ii).
          if infoSecObj:FactQnty = 0  or infoSecObj:FactQnty = ?
            then next.
          sw:start-element ("sc").
            write-data-element ("sc-num", string (infoSecObj:SectionName)).
            write-data-element ("gd-line-num", string-mth (buf_doc-line.line-num)).
            write-data-element ("cap-doc", string-mth (infoSecObj:DocQnty)).
            write-data-element ("dnsty-doc", string-mth (infoSecObj:DocDensity)).
            write-data-element ("wght-doc", string-mth (infoSecObj:CliQnty)).
            write-data-element ("cap-psprt", string-mth (infoSecObj:CarVol)).
            write-data-element ("sz-nck", string (infoSecObj:Diameter)).
            write-data-element ("lvl", string-mth (infoSecObj:ABTarir)).
            write-data-element ("cap-nck", string-mth (infoSecObj:Mouth)).
            write-data-element ("cap", string-mth (infoSecObj:TankVol)).
            write-data-element ("dnsty-f", string-mth (infoSecObj:TankDensity)).
            write-data-element ("cap-wtr", string-mth (infoSecObj:TankWater)).
            write-data-element ("t-cap", string-mth (infoSecObj:TankTemp)).
            write-data-element ("t-dnsty", string-mth (infoSecObj:DensTemp)).
            write-data-element ("ms-code", string-mth (infoSecObj:PlaceSi)).
            write-data-element ("pv-date", string (iso-date (infoSecObj:DatePovPlotn))).
            write-data-element ("dnsty-pr", string-mth (infoSecObj:TankDensityPomi)).
            write-data-element ("cap-pr", string-mth (infoSecObj:TankVolPomi)).
            write-data-element ("wght-pr", string-mth (infoSecObj:TankWeight)).
            write-data-element ("wght-eu", string-mth (infoSecObj:NaturalLoss)).
            write-data-element ("wght-vpr", string-mth (infoSecObj:AccAbsFact)).
            write-data-element ("ned", string-mth (infoSecObj:Deficit)).
            write-data-element ("izl", string-mth (infoSecObj:Excess)).
            write-data-element ("dnsty-uch", string-mth (infoSecObj:FactDensity)).
            write-data-element ("cap-uch", string-mth (infoSecObj:FactQnty)).
            write-data-element ("wght-uch", string-mth (infoSecObj:FactKgQnty)).
            write-data-element ("sl-date-s", string (iso-date (infoSecObjFirst:DateStart))).
            write-data-element ("sl-time-s", string (infoSecObjFirst:TimeStart, "HH:MM")).
            write-data-element ("sl-date-e", string (iso-date (infoSecObjFirst:DateEnd))).
            write-data-element ("sl-time-e", string (infoSecObjFirst:TimeEnd, "HH:MM")).
            write-data-element ("cmm", string (if infoSecObj:IsKP then "1" else "0")).
            write-data-element ("er-ms", string-mth (infoSecObj:AccPomi)).
            /*нормативный документ завода изготовителя*/
            write-data-element ("norm-doc", string (infoSecObj:NormDoc)).
            /*паспорт качества*/
            write-data-element ("passport-num", string (infoSecObj:NumPassport)).
            /*сертификат соответствия*/
            write-data-element ("certif-fuel", string (infoSecObj:CertifFuel)).
            /*срок действия сертификата*/
            write-data-element ("validity-certif", string (infoSecObj:ValidityCertif)).
            /*номер пробы*/
            write-data-element ("tests", if string (infoSecObj:Tests) = "" then "0" else string (infoSecObj:Tests)).
            /*номер печати пробы*/
            write-data-element ("num-print-prob", string (infoSecObj:NumPrintProb)).
            /*количество проб*/
            write-data-element ("prob-kol", string-mth (infoSecObj:KolProb)).
            /*дата отбора пробы*/
            write-data-element ("prob-date", iso-date (infoSecObj:DateProb)).
            /*время отбора пробы часы/минут HourProb MinProb*/
            write-data-element ("prob-time", string (infoSecObj:HourProb, "99") + ":" + string (infoSecObj:MinProb, "99")).
            write-data-element ("acc-ship", string-mth (infoSecObj:AccShip)).
            write-data-element ("tp-norm", string (infoSecObj:TPNorm)).
            write-data-element ("tp-tank-norm", string-mth (infoSecObj:TPNormPL)).
            write-data-element ("tp-nsn-norm", string-mth (infoSecObj:TPNormAuto)).
          sw:end-element ("sc").
        end.
      end.
      sw:end-element ("scs").
    end.
    
    sw:start-element ("tanks").
    for each buf_doc-line no-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code:
      find first buf_gds where
            buf_gds.artic = buf_doc-line.artic 
        and buf_gds.prod-code = buf_doc-line.prod-code
        and buf_gds.prod-type = buf_doc-line.prod-type.
      for each buf_doc-pl where buf_doc-pl.obj-type = buf_doc-line.obj-type and buf_doc-pl.obj-code = buf_doc-line.obj-code
        and buf_doc-pl.out-code = buf_doc-line.doc-code and buf_doc-pl.gds-code = buf_gds.gds-code
        :
        sw:start-element ("tank").
          write-data-element ("gd-line", string-mth (buf_doc-line.line-num)).
          write-data-element ("tank", string-mth (buf_doc-pl.pl-code)).
          write-data-element ("cap-doc", string-mth (buf_doc-pl.doc-qnty)).
          write-data-element ("dnsty-doc", string-mth (buf_doc-line.doc-density)).
          write-data-element ("wght-doc", string-mth (buf_doc-pl.cli-doc-qnty)).
          write-data-element ("dnsty", string-mth ( buf_doc-pl.cli-fact-qnty / buf_doc-pl.fact-qnty)).
          write-data-element ("cap", string-mth (buf_doc-pl.fact-qnty)).
          write-data-element ("wght", string-mth (buf_doc-pl.cli-fact-qnty)).
        sw:end-element ("tank").
      end.
    end.
    sw:end-element ("tanks").    
    
  end.

  method private void Ras ():
    
    sw:start-element ("gds").
    for each buf_gds-dtl no-lock where buf_gds-dtl.doc-code = buf_trn-doc.doc-code:
      find first buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code
        and buf_doc-line.artic = buf_gds-dtl.artic 
        and buf_doc-line.prod-code = buf_gds-dtl.prod-code
        and buf_doc-line.prod-type = buf_gds-dtl.prod-type.
      find first buf_gds where
            buf_gds.artic = buf_doc-line.artic 
        and buf_gds.prod-code = buf_doc-line.prod-code
        and buf_gds.prod-type = buf_doc-line.prod-type.
      sw:start-element ("gd").
        write-data-element ("line-num", string-mth (buf_doc-line.line-num)).
        write-data-element ("gd-code", string-mth (buf_gds.gds-code)).
        write-data-element ("unit-code", string (buf_gds.unit-base)).
        write-data-element ("koef", string (1)).
        write-data-element ("qnty-ttn", string-mth (buf_gds-dtl.doc-qnty)).
        write-data-element ("qnty-fact", string-mth (buf_gds-dtl.fact-qnty)).
        write-data-element ("sum", string-mth (round (buf_gds-dtl.price-rubl * buf_gds-dtl.fact-qnty, 2))).
        write-data-element ("sum-nds", string-mth ( round ((buf_gds-dtl.price-rubl * buf_gds-dtl.fact-qnty * buf_doc-line.VAT-pc) / (100 + buf_doc-line.VAT-pc) , 2))).
        write-data-element ("nds-code", string-mth ( round (buf_doc-line.VAT-pc , 0))).
      sw:end-element ("gd").
    end.
    sw:end-element ("gds").
    
  end.
  
  method private void RasFuel ():

    sw:start-element ("gds").
    for each buf_gds-dtl no-lock where buf_gds-dtl.doc-code = buf_trn-doc.doc-code:
      find first buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code
        and buf_doc-line.artic = buf_gds-dtl.artic 
        and buf_doc-line.prod-code = buf_gds-dtl.prod-code
        and buf_doc-line.prod-type = buf_gds-dtl.prod-type.
      find first buf_gds where
            buf_gds.artic = buf_doc-line.artic 
        and buf_gds.prod-code = buf_doc-line.prod-code
        and buf_gds.prod-type = buf_doc-line.prod-type.
      
      sw:start-element ("gd").
        write-data-element ("line-num", string-mth (buf_doc-line.line-num)).
        write-data-element ("gd-code", string-mth (buf_gds.gds-code)).
        write-data-element ("cap-ttn", string-mth (buf_gds-dtl.doc-qnty)).
        write-data-element ("wght-ttn", string-mth (buf_doc-line.cli-qnty)).
        write-data-element ("dnsty-ttn", string-mth (buf_doc-line.doc-density)).
        write-data-element ("cap-fact", string-mth (buf_gds-dtl.fact-qnty)).
        write-data-element ("wght-fact", string-mth (round (buf_doc-line.fact-density * buf_gds-dtl.fact-qnty, 3))).
        write-data-element ("dnsty-fact", string-mth (buf_doc-line.fact-density)).
        write-data-element ("sum", string-mth (round (buf_gds-dtl.price-rubl * buf_gds-dtl.fact-qnty, 2))).
        
        if v-doc-type-ERPRN = "3" or v-doc-type-ERPRN = "5" or v-doc-type-ERPRN = "7" 
          then write-data-element ("t", string-mth (round (buf_doc-line.temperature, 2))).
      
      sw:end-element ("gd").
    end.
    sw:end-element ("gds").
    
    sw:start-element ("tanks").
    for each buf_doc-line no-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code:
      find first buf_gds where
            buf_gds.artic = buf_doc-line.artic 
        and buf_gds.prod-code = buf_doc-line.prod-code
        and buf_gds.prod-type = buf_doc-line.prod-type.
      for each buf_doc-pl where buf_doc-pl.obj-type = buf_doc-line.obj-type and buf_doc-pl.obj-code = buf_doc-line.obj-code
        and buf_doc-pl.out-code = buf_doc-line.doc-code and buf_doc-pl.gds-code = buf_gds.gds-code
        :
        sw:start-element ("tank").
          write-data-element ("gd-line", string-mth (buf_doc-line.line-num)).
          write-data-element ("tank", string-mth (buf_doc-pl.pl-code)).
          write-data-element ("cap-doc", string-mth (buf_doc-pl.doc-qnty)).
          write-data-element ("dnsty-doc", string-mth (buf_doc-line.doc-density)).
          write-data-element ("wght-doc", string-mth (buf_doc-pl.cli-doc-qnty)).
          write-data-element ("dnsty", string-mth ( buf_doc-pl.cli-fact-qnty / buf_doc-pl.fact-qnty)).
          write-data-element ("cap", string-mth (buf_doc-pl.fact-qnty)).
          write-data-element ("wght", string-mth (buf_doc-pl.cli-fact-qnty)).
        sw:end-element ("tank").
      end.
    end.
    sw:end-element ("tanks"). 
    
  end.

  method private void StartDocTrn ():
      InitSecTag =  "trn-gd-docs".
      sw:start-element ("trn-gd-doc") .
        write-data-element ("doc-code", buf_trn-doc.doc-code).
        write-data-element ("doc-num", buf_trn-doc.doc-code).
        write-data-element ("del-f", string (isDel, "1/0") ).
        write-data-element ("doc-date", if buf_trn-doc.doc-date = ? then "" else iso-date (datetime (buf_trn-doc.doc-date, buf_trn-doc.real-time-create * 1000))).
        write-data-element ("fact-date", if buf_trn-doc.fact-date = ? then "" else iso-date (datetime (buf_trn-doc.fact-date, buf_trn-doc.fact-time * 1000))).
        write-data-element ("doc-type", v-doc-type-ERPRN).
        write-data-element ("doc-rsn-code", (if buf_trn-doc.reason-code = ? then "0" else string-mth (buf_trn-doc.reason-code))).
        write-data-element ("shift-date", if buf_trn-doc.shift-date = ? then "" else iso-date (date (buf_trn-doc.shift-date))).
        write-data-element ("shift-num", if buf_trn-doc.shift-num = ? then "0" else string-mth (buf_trn-doc.shift-num)).
        write-data-element ("contr-code", string-mth (buf_trn-doc.cli-code)).
        write-data-element ("dog-code", string-mth (buf_trn-doc.contract-code)).
        write-data-element ("operator", v-user-name ).
        write-data-element ("psn-wrkr", string-mth (buf_trn-doc.wrkr)).
        write-data-element ("psn-agnt", string-mth (buf_trn-doc.agnt)).
        write-data-element ("psn-boss", string-mth (buf_trn-doc.boss)).
  end.

  method private void EndDocTrn ():
    
    sw:end-element ("trn-gd-doc") .
/*    sw:end-element ("trn-gd-docs") .*/
    
  end.

  method private void StartDocTrnFuel ():
      InitSecTag =  "trn-fuel-docs".
      sw:start-element ("trn-fuel-doc") .
        write-data-element ("doc-code", buf_trn-doc.doc-code).
        write-data-element ("doc-num", buf_trn-doc.doc-code).
        write-data-element ("del-f", string (isDel, "1/0") ).
        write-data-element ("doc-date", if buf_trn-doc.doc-date = ? then "" else iso-date (datetime (buf_trn-doc.doc-date, buf_trn-doc.real-time-create * 1000))).
        write-data-element ("fact-date", if buf_trn-doc.fact-date = ? then "" else iso-date (datetime (buf_trn-doc.fact-date, buf_trn-doc.fact-time * 1000))).
        write-data-element ("doc-type", v-doc-type-ERPRN).
        write-data-element ("doc-rsn-code", string-mth (buf_trn-doc.reason-code)).
        write-data-element ("shift-date", if buf_trn-doc.shift-date = ? then "" else iso-date (date (buf_trn-doc.shift-date))).
        write-data-element ("shift-num", if buf_trn-doc.shift-num = ? then "0" else string-mth (buf_trn-doc.shift-num)).
        write-data-element ("contr-code", string-mth (buf_trn-doc.cli-code)).
        write-data-element ("dog-code", string-mth (buf_trn-doc.contract-code)).
        write-data-element ("operator", v-user-name ).
        write-data-element ("psn-wrkr", string-mth (buf_trn-doc.wrkr)).
        write-data-element ("psn-agnt", string-mth (buf_trn-doc.agnt)).
        write-data-element ("psn-boss", string-mth (buf_trn-doc.boss)).
  end.

  method private void EndDocTrnFuel ():
    
    sw:end-element ("trn-fuel-doc") .
    
  end.

  method private void write-data-element (inTag as char, inValue as char):
    
    if inValue = ?
    then do:
      Msg = substitute ('Предупреждение отладки: тег &1 иммет не определнное значение. Работа будет продолжена...', inTag).
    end.

    if inTag = ?
    then do:
      Msg = substitute ('Предупреждение отладки: Имя тега не может быть пустым...').
      return.
    end.

    if inTag = "acc-ship"
    then do:
      if string (inValue) begins "."
        then inValue = "0" + inValue.
    end.

    inTag = lc (InTag).

    if inValue = ?
      then 
/*      sw:write-empty-element (inTag)*/
      .
      else sw:write-data-element (inTag, inValue).
  
  end.

  method private character string-mth (inValue as integer):
    
    def var v-str as character no-undo.
    
    if inValue = ?
      then v-str = "0".
      else v-str = string (inValue). 
    
    return v-str.
    
  end.

  method private character string-mth (inValue as decimal):
    
    def var v-str as character no-undo.
    
    if inValue = ?
      then v-str = "0".
    
    if string (inValue) begins "."
      then v-str = "0" + string (inValue).
      else v-str = string (inValue).
    return v-str.
    
  end.

  method private void TrdcAattrPri ():
    
    &scop attr-code trdcattr-dids
    {&create-record-date}
    &scop attr-code trdcattr-nsf
    {&create-record}
    &scop attr-code trdcattr-dsf
    {&create-record-date}
/*    &scop attr-code trdcattr-expense_own*/
/*    {&create-record}                    */
    &scop attr-code trdcattr-ndog
    {&create-record}
    &scop attr-code trdcattr-ddog
    {&create-record-date}
    &scop attr-code trdcattr-nids
    {&create-record}
    &scop attr-code trdcattr-ndov
    {&create-record}
    &scop attr-code trdcattr-ddov
    {&create-record-date}
    &scop attr-code trdcattr-print-num
    {&create-record}
    &scop attr-code trdcattr-idCountryContr
    {&create-record}
    &scop attr-code trdcattr-car-time
    {&create-record}
    &scop attr-code trdcattr-t_pass-fname
    {&create-record}
    &scop attr-code trdcattr-t_pass-position
    {&create-record}
    &scop attr-code trdcattr-t_accept-fname
    {&create-record}
    &scop attr-code trdcattr-t_accept-position
    {&create-record}
    &scop attr-code trdcattr-ndovwho
    {&create-record}
    &scop attr-code trdcattr-nosn
    {&create-record}
    &scop tag-code shipper
    &scop attr-code trdcattr-shipper
    {&create-record-cust-obj-code}
    
    
  end.

  method private void TrdcAattrRas ():
    
/*    &scop attr-code trdcattr-qntyplace*/
/*    {&create-record}                  */
/*    &scop attr-code trdcattr-place-storage*/
/*    {&create-record}                      */
/*    &scop attr-code trdcattr-dispath*/
/*    {&create-record}                */
/*    &scop attr-code trdcattr-packer */
/*    {&create-record}                */
/*    &scop attr-code trdcattr-nfindoc*/
/*    {&create-record}                */
/*    &scop attr-code trdcattr-dfindoc*/
/*    {&create-record-date}           */
    &scop attr-code trdcattr-ddov
    {&create-record-date}
    &scop attr-code trdcattr-ndov
    {&create-record}
    &scop attr-code trdcattr-nids
    {&create-record}
/*    &scop attr-code trdcattr-ndog*/
/*    {&create-record}             */
/*    &scop attr-code trdcattr-ddog*/
/*    {&create-record}             */
    &scop attr-code trdcattr-recipient
    {&create-record}
    &scop attr-code trdcattr-auto
    {&create-record}
    &scop attr-code trdcattr-driver
    {&create-record}
    &scop attr-code trdcattr-print-num
    {&create-record}
    &scop attr-code trdcattr-idCountryContr
    {&create-record}
    &scop attr-code trdcattr-nsf
    {&create-record}
    &scop attr-code trdcattr-dsf
    {&create-record-date}
    &scop attr-code trdcattr-t_pass-fname
    {&create-record}
    &scop attr-code trdcattr-t_pass-position
    {&create-record}
    &scop attr-code trdcattr-t_accept-fname
    {&create-record}
    &scop attr-code trdcattr-t_accept-position
    {&create-record}
    &scop attr-code trdcattr-ndovwho
    {&create-record}
    &scop attr-code trdcattr-nosn
    {&create-record}
/*    &scop attr-code trdcattr-cargo-desc   */
/*    {&create-record}                      */
/*    &scop attr-code trdcattr-carry-type   */
/*    {&create-record}                      */
/*    &scop attr-code trdcattr-cargo-mass   */
/*    {&create-record}                      */
/*    &scop attr-code trdcattr-exp-trans    */
/*    {&create-record}                      */
/*    &scop attr-code trdcattr-zakaz-number */
/*    {&create-record}                      */
/*    &scop attr-code trdcattr-delivery-date*/
/*    {&create-record-date}                 */
/*    &scop attr-code trdcattr-delivery-time*/
/*    {&create-record}                      */
/*    &scop attr-code trdcattr-zakaz-date   */
/*    {&create-record-date}                 */

    
  end.
  
  method private void writeprts ():

    def var vsds as class vsdsubs no-undo.
    def var vsdstr as class vsdtostorage no-undo.
    def var vsdsts as class vsdstatustype no-undo.
    def var ii as integer no-undo.
    define variable v-mercury-value as character no-undo .
    define variable v-mercury-type  as character no-undo .
    define variable v-mercury-prod as logical init false.
    define variable tagPrts as logical init false.

    vsdstr = new vsdtostorage ().
    vsdsts = new vsdstatustype ().
    
    for each buf_doc-line no-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code:
  
      find first buf_gds no-lock where
            buf_gds.artic = buf_doc-line.artic 
        and buf_gds.prod-code = buf_doc-line.prod-code
        and buf_gds.prod-type = buf_doc-line.prod-type.

      { gbl/gdscdat.i
        buf_gds.gds-code
        "'mercur_FGIS=request':u"
        v-mercury-prod
        no-error
      }
      
      if not v-mercury-prod 
        then next.
      
      if not tagPrts 
      then do: 
        sw:start-element ("prts").
        tagPrts = true.
      end.
      
      for each buf_parts no-lock where buf_parts.out-code = buf_doc-line.doc-code
          and buf_parts.artic = buf_doc-line.artic
          and buf_parts.prod-type = buf_doc-line.prod-type
          and buf_parts.prod-code = buf_doc-line.prod-code:
        vsds = new vsdsubs ().
        vsds = vsdstr:getVSDsubs(buffer buf_parts).
        sw:start-element ("prt").      
          write-data-element ("gd-line-num", string-mth (buf_doc-line.line-num)).
          write-data-element ("prt-id", buf_parts.part-code).
          if vsds:iCounter > 0
          then do:
            do ii = 1 to vsds:GetItem(ii):
              if vsds:VsdObjCurr:VSDType = vsdsts:VSDTrans or vsds:VsdObjCurr:VSDType = vsdsts:VSDIn 
              then do:
                write-data-element ("vad-guid", vsds:VsdObjCurr:UUID).
                leave.
              end.
            end.
          end.
          else do:
            write-data-element ("vad-guid", "").
          end.
          write-data-element ("qnty", string-mth (buf_parts.fact-qnty)).
        sw:end-element ("prt").
        
        delete object vsds no-error.        
      
      end.      
    end.
    
    if tagPrts
      then sw:end-element ("prts").
    
    delete object vsdsts no-error.
    delete object vsdstr no-error.    

    
  end.

end class.
