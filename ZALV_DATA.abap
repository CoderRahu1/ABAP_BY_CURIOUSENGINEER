REPORT ZALVDATA.
WRITE:'DATA'.
tables:mara.
PARAMETERs:D_PARA TYPE MARA-PSTAT,
          D_PARA1 TYPE mara-ernam.
PARAMETERs:R_rad RADIOBUTTON GROUP gr1,
          R_rad2 RADIOBUTTON GROUP gr1,
          R_rad3 RADIOBUTTON GROUP gr1 DEFAULT 'X'.
SELECTION-SCREEN BEGIN OF BLOCK c1 WITH FRAME TITLE text-003.
PARAMETER: CH_BOX AS CHECKBOX.
PARAMETER: CH_BOX2 AS CHECKBOX.
PARAMETER: CH_BOX3 AS CHECKBOX DEFAULT 'X'.
PARAMETER: CH_BOX4 AS CHECKBOX.
PARAMETER: CH_BOX5 AS CHECKBOX.
SELECTION-SCREEN END  of BLOCK c1.
SELECTION-SCREEN BEGIN OF BLOCK d1 WITH FRAME TITLE text-004.
SELECT-OPTIONS : s_matnr1 FOR mara-matnr.
SELECT-OPTIONS : s_matnr2 FOR mara-matnr OBLIGATORY.
SELECT-OPTIONS : s_matnr3 FOR mara-matnr NO INTERVALS.
SELECT-OPTIONS : s_matnr4 FOR mara-matnr NO-EXTENSION.
SELECT-OPTIONS : s_matnr5 FOR mara-matnr NO INTERVALS NO-EXTENSION.
SELECT-OPTIONS : s_matnr6 FOR mara-matnr NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK D1.
