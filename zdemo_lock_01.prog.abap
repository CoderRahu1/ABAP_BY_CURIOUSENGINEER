REPORT ZDEMO_LOCK_1.

DATA : gt_ZVEND_DET TYPE TABLE OF ZVEND_DET,
       gs_ZVEND_DET TYPE ZVEND_DET.


START-OF-SELECTION.

SELECT *
  from ZVEND_DET
  into TABLE gt_ZVEND_DET.

loop at GT_ZVEND_DET INTO GS_ZVEND_DET.

GS_ZVEND_DET-DES = 'pranav'.

*GS_ZVEND_DET-DEPT = 'AK'.

CALL FUNCTION 'ENQUEUE_EZVEND_DET'
 EXPORTING
   LIFNR                = GS_ZVEND_DET-LIFNR
   NAME1                = GS_ZVEND_DET-NAME1
 EXCEPTIONS
   FOREIGN_LOCK         = 1
   SYSTEM_FAILURE       = 2
   OTHERS               = 3
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


*UPDATE zvend_det from GS_ZVEND_DET.

*UPDATE zvend_det set DEPT = GS_ZVEND_DET-DEPT.

UPDATE zvend_det set des = GS_ZVEND_DET-DES WHERE lifnr = GS_ZVEND_DET-lifnr.

if sy-subrc = 0.
commit work.
else.
ROLLBACK WORK.
endif.

CALL FUNCTION 'DEQUEUE_EZVEND_DET'
EXPORTING
*   MODE_ZVEND_DET       = 'E'
*   MANDT                = SY-MANDT
   LIFNR                = GS_ZVEND_DET-LIFNR
   NAME1                = GS_ZVEND_DET-name1
*   X_LIFNR              = ' '
*   X_NAME1              = ' '
*   _SCOPE               = '3'
*   _SYNCHRON            = ' '
*   _COLLECT             = ' '
          .



ENDLOOP.

clear GS_ZVEND_DET.
GS_ZVEND_DET-LIFNR = 10.
GS_ZVEND_DET-name1 = 'AA'.
GS_ZVEND_DET-des = 'vashi'.

insert zvend_det from GS_ZVEND_DET.

clear GS_ZVEND_DET.
GS_ZVEND_DET-LIFNR = 20.
GS_ZVEND_DET-name1 = 'AA'.
GS_ZVEND_DET-des = 'vashi'.
CLEAR GT_ZVEND_DET[].
APPEND GS_ZVEND_DET to GT_ZVEND_DET.


clear GS_ZVEND_DET.
GS_ZVEND_DET-LIFNR = 30.
GS_ZVEND_DET-name1 = 'AA'.
GS_ZVEND_DET-des = 'vashi'.
APPEND GS_ZVEND_DET to GT_ZVEND_DET.



clear GS_ZVEND_DET.
GS_ZVEND_DET-LIFNR = 40.
GS_ZVEND_DET-name1 = 'AA'.
GS_ZVEND_DET-des = 'vashi'.
APPEND GS_ZVEND_DET to GT_ZVEND_DET.

*insert ZVEND_DET FROM TABLE GT_ZVEND_DET.

*delete FROM zvend_det WHERE LIFNR = 20.
