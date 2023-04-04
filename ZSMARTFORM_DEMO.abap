REPORT ZDEMO_SMARTFORM.

*TYPES : BEGIN OF gty_header,
*          vbeln TYPE vbeln_va,
*          AUART TYPE auart,
*          erdat TYPE erdat,
*          ernam TYPE ernam,
*          erzet TYPE erzet,
*        END OF gty_header.

*TYPES : BEGIN OF gty_item,
*          posnr TYPE vbap-posnr,
*          matnr TYPE matnr,
*          MATKL TYPE MATKL,
*          charg TYPE charg_d,
*          KWMENG TYPE KWMENG,
*          MEINS TYPE MEINS,
*        END OF gty_item.

DATA : gs_header TYPE ZSMART_HEADER,
       gt_item TYPE ZSMART_ITEM_TAB,
       gs_item TYPE ZSMART_ITEM,
       GV_FMNAM TYPE RS38L_FNAM.


PARAMETERS : p_vbeln TYPE vbeln_va.

START-OF-SELECTION.

select SINGLE vbeln auart erdat ernam erzet
  from vbak
  into gs_header
  WHERE vbeln = p_vbeln.

if   gs_header is NOT INITIAL.
  SELECT posnr matnr matkl charg kwmeng meins
    from vbap
    INTO TABLE gt_item
    WHERE vbeln = gs_header-vbeln.
endif.


CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    FORMNAME                 = 'ZSMARTFORM_RITURAJ'
*   VARIANT                  = ' '
*   DIRECT_CALL              = ' '
 IMPORTING
   FM_NAME                  = GV_FMNAM
 EXCEPTIONS
   NO_FORM                  = 1
   NO_FUNCTION_MODULE       = 2
   OTHERS                   = 3
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


CALL FUNCTION GV_FMNAM
 EXPORTING
*   ARCHIVE_INDEX              =
*   ARCHIVE_INDEX_TAB          =
*   ARCHIVE_PARAMETERS         =
*   CONTROL_PARAMETERS         =
*   MAIL_APPL_OBJ              =
*   MAIL_RECIPIENT             =
*   MAIL_SENDER                =
*   OUTPUT_OPTIONS             =
*   USER_SETTINGS              = 'X'
   GS_HEADER_FORM             = GS_HEADER
   GT_ITEM_FORM               = GT_ITEM
* IMPORTING
*   DOCUMENT_OUTPUT_INFO       =
*   JOB_OUTPUT_INFO            =
*   JOB_OUTPUT_OPTIONS         =
 EXCEPTIONS
   FORMATTING_ERROR           = 1
   INTERNAL_ERROR             = 2
   SEND_ERROR                 = 3
   USER_CANCELED              = 4
   OTHERS                     = 5
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
