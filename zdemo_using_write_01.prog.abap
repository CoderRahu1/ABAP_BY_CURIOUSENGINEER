REPORT ZDEMO_USING_WRITE.

TYPES : BEGIN OF gty_vbak,
          vbeln TYPE vbeln_va,
          erdat TYPE erdat,
          ernam TYPE ernam,
          erzet TYPE erzet,
        END OF gty_vbak.

DATA : gt_vbak TYPE TABLE OF gty_vbak,
       gs_vbak TYPE gty_vbak.

start-OF-SELECTION.

SELECT vbeln erdat ernam erzet
  from vbak
  into TABLE gt_vbak UP TO 10 ROWS.


write : 'Sales No.', 'Creation Date', 'Created By', 'Created at'.
write : / ''.

loop at gt_vbak INTO gs_vbak.

WRITE :/ gs_vbak-vbeln, gs_vbak-ERDAT, gs_vbak-ERNAM, gs_vbak-ERZET.

ENDLOOP.
