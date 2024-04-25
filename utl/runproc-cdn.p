
/*------------------------------------------------------------------------
    File        : runproc-cdn.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Belova Marina
    Created     : Mon Apr 08 11:31:14 MSK 2024
    Notes       :
  ----------------------------------------------------------------------*/
  
/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":u .
define variable vss-author      as character no-undo init "$Author$":u .
define variable vss-date        as character no-undo init "$Date$":u .
define variable vss-workfile    as character no-undo init "$Workfile$":u .
define variable vss-archive     as character no-undo init "$Archive$":u .
define variable vss-description as character no-undo init "Асинхронные процессы" .
{ cmp/vssrevis.i }

{cmp\str-glbl.i}

{utl/asuncprocauto.i}

run AddTask in this-procedure("utl/proc-gismtcdn", "*").
