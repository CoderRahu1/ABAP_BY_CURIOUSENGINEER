REPORT ZDEMOALV_HIERSEQ.
TYPE-POOLs : slis.

TYPES : BEGIN OF gty_vbak,
          vbak_vbeln TYPE vbeln_va,
          erdat TYPE erdat,
          ernam TYPE ernam,
          erzet TYPE erzet,
        END OF gty_vbak.

TYPES : BEGIN OF gty_vbap,
          vbap_vbeln TYPE vbeln_va,
          posnr TYPE posnr_va,
          matnr TYPE matnr,
        END OF gty_vbap.

DATA : gt_vbak TYPE TABLE OF gty_vbak,
       gt_vbap TYPE TABLE OF gty_vbap,
       gs_keyinfo TYPE slis_keyinfo_alv,
       gt_fcat TYPE SLIS_T_FIELDCAT_ALV,
       gs_fcat TYPE SLIS_FIELDCAT_ALV,
       gs_layo TYPE SLIS_LAYOUT_ALV.

START-OF-SELECTION.

SELECT vbeln erdat ernam erzet
  from vbak
  into TABLE gt_vbak UP TO 10 ROWS.

if gt_vbak[] is NOT INITIAL.
  SELECT vbeln posnr matnr
    from vbap
    INTO TABLE gt_vbap
    FOR ALL ENTRIES IN gt_vbak
    WHERE vbeln = gt_vbak-vbak_vbeln.
endif.

GS_KEYINFO-HEADER01 = 'VBAK_VBELN'.
GS_KEYINFO-ITEM01 = 'VBAP_VBELN'.

PERFORM fcat_create.

CLEAR GS_LAYO.
gs_layo-COLWIDTH_OPTIMIZE = abap_true.
gs_layo-EXPAND_FIELDNAME = 'VBAK_VBELN'.
gs_layo-WINDOW_TITLEBAR = 'Hierachy ALV for sales order and item Data'.

CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
  EXPORTING
*   I_INTERFACE_CHECK              = ' '
*   I_CALLBACK_PROGRAM             =
*   I_CALLBACK_PF_STATUS_SET       = ' '
*   I_CALLBACK_USER_COMMAND        = ' '
   IS_LAYOUT                      = gs_layo
   IT_FIELDCAT                    = GT_FCAT[]
*   IT_EXCLUDING                   =
*   IT_SPECIAL_GROUPS              =
*   IT_SORT                        =
*   IT_FILTER                      =
*   IS_SEL_HIDE                    =
*   I_SCREEN_START_COLUMN          = 0
*   I_SCREEN_START_LINE            = 0
*   I_SCREEN_END_COLUMN            = 0
*   I_SCREEN_END_LINE              = 0
*   I_DEFAULT                      = 'X'
*   I_SAVE                         = ' '
*   IS_VARIANT                     =
*   IT_EVENTS                      =
*   IT_EVENT_EXIT                  =
    I_TABNAME_HEADER               = 'GT_VBAK'
    I_TABNAME_ITEM                 = 'GT_VBAP'
*   I_STRUCTURE_NAME_HEADER        =
*   I_STRUCTURE_NAME_ITEM          =
    IS_KEYINFO                     = gs_keyinfo
*   IS_PRINT                       =
*   IS_REPREP_ID                   =
*   I_BYPASSING_BUFFER             =
*   I_BUFFER_ACTIVE                =
*   IR_SALV_HIERSEQ_ADAPTER        =
*   IT_EXCEPT_QINFO                =
*   I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER        =
*   ES_EXIT_CAUSED_BY_USER         =
  TABLES
    T_OUTTAB_HEADER                = gt_vbak[]
    T_OUTTAB_ITEM                  = gt_vbap[]
 EXCEPTIONS
   PROGRAM_ERROR                  = 1
   OTHERS                         = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FCAT_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FCAT_CREATE .

clear GS_FCAT.
gs_fcat-FIELDNAME = 'VBAK_VBELN'.
gs_fcat-SELTEXT_M = 'Sales Header'.
gs_fcat-TABNAME = 'GT_VBAK'.
GS_FCAT-OUTPUTLEN = 12.
APPEND gs_fcat to gt_fcat.

clear GS_FCAT.
gs_fcat-FIELDNAME = 'ERDAT'.
gs_fcat-SELTEXT_M = 'Creation Date'.
gs_fcat-TABNAME = 'GT_VBAK'.
GS_FCAT-OUTPUTLEN = 10.
APPEND gs_fcat to gt_fcat.

clear GS_FCAT.
gs_fcat-FIELDNAME = 'ERNAM'.
gs_fcat-SELTEXT_M = 'Created BY'.
gs_fcat-TABNAME = 'GT_VBAK'.
GS_FCAT-OUTPUTLEN = 30.
APPEND gs_fcat to gt_fcat.

clear GS_FCAT.
gs_fcat-FIELDNAME = 'ERZET'.
gs_fcat-SELTEXT_M = 'Creation Time'.
gs_fcat-TABNAME = 'GT_VBAK'.
GS_FCAT-OUTPUTLEN = 12.
APPEND gs_fcat to gt_fcat.

clear GS_FCAT.
gs_fcat-FIELDNAME = 'VBAP_VBELN'.
gs_fcat-SELTEXT_M = 'Sales Item Header'.
gs_fcat-TABNAME = 'GT_VBAP'.
GS_FCAT-OUTPUTLEN = 12.
APPEND gs_fcat to gt_fcat.

clear GS_FCAT.
gs_fcat-FIELDNAME = 'POSNR'.
gs_fcat-SELTEXT_M = 'Sales Item'.
gs_fcat-TABNAME = 'GT_VBAP'.
GS_FCAT-OUTPUTLEN = 12.
APPEND gs_fcat to gt_fcat.

clear GS_FCAT.
gs_fcat-FIELDNAME = 'MATNR'.
gs_fcat-SELTEXT_M = 'Material'.
gs_fcat-TABNAME = 'GT_VBAP'.
GS_FCAT-OUTPUTLEN = 30.
APPEND gs_fcat to gt_fcat.



ENDFORM.
