    define temp-table tt-coins no-undo
    field id          as decimal
    field qnty        as decimal
    field sum-qnty    as decimal
    index pi id .
    
    define temp-table tt-banknots no-undo
    field id          as integer
    field qnty        as integer
    field sum-qnty    as integer
    index pi id .

define dataset ds-banknots for tt-banknots .

