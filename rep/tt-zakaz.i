define {1} shared temp-table tt-zakaz no-undo 
  field artic        as character
  field gds-code     as integer
  field gds-name     as character
  field prod-type    as character
  field prod-code    as integer
  field ostatokToday as decimal
  field tempSale     as decimal
  field minZapas     as decimal
  field volTemp      as integer
  field volSale      as decimal
  field volMinZapas  as integer
  field volMinGarant as integer
  field ostatokDay   as decimal
  field promo        as logical 
  field qntyDaySale  as integer
  field qntyDayGoods as integer
  field garantZapas  as integer
  field ostatokGoods as decimal
  field qntyDay      as integer
  field contract     as character
  field contract-code as integer
  index pi    gds-code contract
  index artic artic    prod-type prod-code 
  index contr contract.

define {1} shared temp-table temp-gds-qnty no-undo
  field day      as date
  field ost      as decimal
  field gds-code as integer
  index pi is unique primary day gds-code
  index by-ost               ost .
  