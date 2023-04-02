REPORT ZMAT_CREATE_BDC.

TYPES : BEGIN OF gty_excel,
          matnr TYPE RMMG1-MATNR,
          MBRSH TYPE RMMG1-MTART,
          MTART TYPE RMMG1-MTART,
          MAKTX TYPE MAKT-MAKTX,
          MEINS TYPE MARA-MEINS,
        END OF gty_excel.

DATA : gt_data TYPE TABLE OF gty_excel,
      gs_data TYPE gty_excel,
      gt_bdcdata TYPE TABLE OF BDCDATA,
      gs_bdcdata TYPE BDCDATA,
      gt_MESSTAB TYPE TABLE OF BDCMSGCOLL,
      gs_messtab TYPE BDCMSGCOLL.


DATA : gt_rawtab TYPE TRUXS_T_TEXT_DATA,
      gv_CTUMODE TYPE ctu_mode,
      gv_CUPDATE TYPE ctu_update,"For BDC update in sync or asynch
      gv_tcode TYPE syst_tcode.

SELECTION-SCREEN : BEGIN OF block b1 with frame TITLE text-000.
  PARAMETERS : p_file TYPE rlgrap-filename OBLIGATORY,
               p_mode TYPE c OBLIGATORY.
SELECTION-SCREEN : END OF block b1.

at SELECTION-SCREEN on VALUE-REQUEST FOR P_FILE.

CALL FUNCTION 'F4_FILENAME'
 EXPORTING
   PROGRAM_NAME        = SYST-CPROG
   DYNPRO_NUMBER       = SYST-DYNNR
 IMPORTING
   FILE_NAME           = p_file.
          .

START-OF-SELECTION.

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
   I_FIELD_SEPERATOR          = 'X'
   I_LINE_HEADER              = 'X'
    I_TAB_RAW_DATA             = gt_rawtab[]
    I_FILENAME                 = p_file
  TABLES
    I_TAB_CONVERTED_DATA       = gt_data[]
 EXCEPTIONS
   CONVERSION_FAILED          = 1
   OTHERS                     = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

CLEAR : gv_tcode, gv_CTUMODE, GV_CUPDATE.
GV_CTUMODE = P_MODE.
GV_CUPDATE = 'S'.
gv_tcode = 'MM01'.
LOOP AT gt_data INTO gs_data.

CLEAR GT_BDCDATA[].
perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MTART'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR'
                              gs_data-matnr.
perform bdc_field       using 'RMMG1-MBRSH'
                              gs_data-mbrsh.
perform bdc_field       using 'RMMG1-MTART'
                              gs_data-mtart.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(01)'
                              abap_true.
perform bdc_dynpro      using 'SAPLMGMM' '4004'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'MAKT-MAKTX'
                              gs_data-maktx.
perform bdc_field       using 'BDC_CURSOR'
                              'MARA-MEINS'.
perform bdc_field       using 'MARA-MEINS'
                              gs_data-meins.
perform bdc_dynpro      using 'SAPLSPO1' '0300'.
perform bdc_field       using 'BDC_OKCODE'
                              '=YES'.
CLEAR GT_MESSTAB[].
perform bdc_transaction using gv_tcode.

CLEAR gs_data.
ENDLOOP.
CLEAR gv_tcode.


FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR gs_BDCDATA.
  gs_BDCDATA-PROGRAM  = PROGRAM.
  gs_BDCDATA-DYNPRO   = DYNPRO.
  gs_BDCDATA-DYNBEGIN = 'X'.
  APPEND gs_BDCDATA to gt_bdcdata.
ENDFORM.

FORM BDC_FIELD USING FNAM FVAL.
    CLEAR gs_BDCDATA.
    gs_BDCDATA-FNAM = FNAM.
    gs_BDCDATA-FVAL = FVAL.
    APPEND gs_BDCDATA to gt_bdcdata.
ENDFORM.

FORM BDC_TRANSACTION USING TCODE.

    CALL TRANSACTION TCODE USING gt_BDCDATA
                     MODE   gv_CTUMODE
                     UPDATE gv_CUPDATE
                     MESSAGES INTO gt_MESSTAB.


ENDFORM.
