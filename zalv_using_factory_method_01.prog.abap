REPORT ZALV_USING_FACTORY_METHOD_01 .


TYPES : BEGIN OF gty_vbak,
*          vbeln TYPE vbeln_va,
          vbeln TYPE c LENGTH 10,
          erdat TYPE erdat,
          ernam TYPE ernam,
          erzet TYPE erzet,
        END OF gty_vbak.

DATA : gt_vbak TYPE TABLE OF gty_vbak,
       gs_vbak TYPE gty_vbak.

DATA : cl_ref TYPE REF TO CL_SALV_TABLE,
       obj_ref TYPE REF TO CL_SALV_TABLE.


start-OF-SELECTION.

*create OBJECT cl_ref.
*  create OBJECT obj_ref."As class cl_salv_table is private so its object cannot be craeted outside it(the same class).

SELECT vbeln erdat ernam erzet
  from vbak
  into TABLE gt_vbak UP TO 10 ROWS.


*write : 'Sales No.', 'Creation Date', 'Created By', 'Created at'.
*write : / ''.
*
*loop at gt_vbak INTO gs_vbak.
*
*WRITE :/ gs_vbak-vbeln, gs_vbak-ERDAT, gs_vbak-ERNAM, gs_vbak-ERZET.
*
*ENDLOOP.






TRY.
CALL METHOD CL_SALV_TABLE=>FACTORY
  EXPORTING
    LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>true
*    R_CONTAINER    =
*    CONTAINER_NAME =
  IMPORTING
    R_SALV_TABLE   = cL_ref
  CHANGING
    T_TABLE        = gt_vbak[]
    .
 CATCH CX_SALV_MSG .
ENDTRY.

*BREAK-POINT.

*CALL METHOD OBJ_REF->DISPLAY
*    .

CALL METHOD CL_REF->DISPLAY
    .
