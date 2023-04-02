REPORT ZBAPI_DEMO.

TYPES : BEGIN OF gty_excel,
          matnr TYPE RMMG1-MATNR,
          MBRSH TYPE RMMG1-MTART,

          MTART TYPE RMMG1-MTART,
          MAKTX TYPE MAKT-MAKTX,
          MEINS TYPE MARA-MEINS,
        END OF gty_excel.

types : BEGIN OF gty_final,
          matnr TYPE mara-matnr,
          desc TYPE BAPI_MSG,
          status TYPE char10,
        END OF gty_final.

DATA : gt_data TYPE TABLE OF gty_excel,
      gs_data TYPE gty_excel.

DATA : gt_rawtab TYPE TRUXS_T_TEXT_DATA,
       gs_header TYPE BAPIMATHEAD,
*       gt_return TYPE TABLE OF BAPIRET2,
       gs_return TYPE BAPIRET2,
       gt_matdesc TYPE TABLE OF BAPI_MAKT,
       gs_matdesc TYPE BAPI_MAKT,
       gt_uom TYPE TABLE OF BAPI_MARM,
       gs_uom TYPE BAPI_MARM,
       gt_uomx TYPE TABLE OF BAPI_MARMX,
       gs_uomx TYPE BAPI_MARMX,
       GS_CLIENTDATA TYPE BAPI_MARA,
       GS_CLIENTDATAX TYPE BAPI_MARAX.


SELECTION-SCREEN : BEGIN OF block b1 with frame TITLE text-000.
  PARAMETERS : p_file TYPE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN : END OF block b1.


at SELECTION-SCREEN on VALUE-REQUEST FOR P_FILE.

CALL FUNCTION 'F4_FILENAME'
 EXPORTING
   PROGRAM_NAME        = SYST-CPROG
   DYNPRO_NUMBER       = SYST-DYNNR
 IMPORTING
   FILE_NAME           = p_file.

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

LOOP AT gt_data INTO gs_data.

CLEAR : gs_header, gs_return, gt_matdesc[], gs_matdesc,
        gt_uom[], gs_uom, gt_uomx[], gs_uomx,
        GS_CLIENTDATA, GS_CLIENTDATAX.

gs_header-MATERIAL = gs_data-MATNR.
gs_header-IND_SECTOR = gs_data-MBRSH.
gs_header-MATL_TYPE = gs_data-mtart.
gs_header-BASIC_VIEW = abap_true.

GS_MATDESC-LANGU = 'E'.
GS_MATDESC-MATL_DESC = gs_data-MAKTX.
APPEND GS_MATDESC to GT_MATDESC.

*gs_uom-UNIT_OF_WT = gs_data-MEINS.
*APPEND gs_uom to gt_uom.

GS_CLIENTDATA-BASE_UOM = GS_DATA-MEINS.
*GS_CLIENTDATA-BASE_UOM_ISO = GS_DATA-MEINS.
GS_CLIENTDATAX-BASE_UOM = ABAP_TRUE.


CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
  EXPORTING
    HEADDATA                   = gs_header
   CLIENTDATA                 =  GS_CLIENTDATA
   CLIENTDATAX                = GS_CLIENTDATAX
 IMPORTING
   RETURN                     = gs_return
 TABLES
   MATERIALDESCRIPTION        = GT_MATDESC
   UNITSOFMEASURE             = GT_UOM
   UNITSOFMEASUREX            = GT_UOMX.

if sy-subrc = 0.

           CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*            EXPORTING
*              WAIT          = abap_true.
*  commit work.

*gs_return-matnr = gs_data-matnr.
*gs_return-desc = gs_data-matnr.

  else.
*  ROLLBACK work.
CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
* IMPORTING
*   RETURN        =
          .

endif.

CLEAR gs_data.
ENDLOOP.
