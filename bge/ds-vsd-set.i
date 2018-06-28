DEFINE TEMP-TABLE t-obj-list NO-UNDO
    FIELD obj-type  AS CHARACTER
    FIELD obj-code  AS INTEGER
    FIELD host-code AS INTEGER
    INDEX pi IS UNIQUE PRIMARY obj-type  obj-code
    INDEX firm                 host-code.

{ cmp/gds-list.i tt-gds-list def  }

DEFINE TEMP-TABLE tt-vsd-filt NO-UNDO
FIELD date-end AS DATE
FIELD date-start AS DATE
FIELD fTime  AS INTEGER  
FIELD FalExting AS LOGICAL
FIELD FalVerif  AS LOGICAL
FIELD Rep       AS LOGICAL
FIELD ReqVerif  AS LOGICAL
FIELD ToExtin   AS LOGICAL
FIELD doc-code  AS CHARACTER 
.

DEFINE DATASET ds-vsd-set
FOR tt-vsd-filt,t-obj-list, tt-gds-list . 
