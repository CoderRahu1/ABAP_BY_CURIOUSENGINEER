*Order sales detail
REPORT Z_INTERACTIVE_ALV.
*type group declaration
TYPE-POOLS: slis.

*structure declaration
TYPES:BEGIN OF gty_vbak,
        vbeln type VBELN_va,
        erdat TYPE vbak-erdat,
        ernam TYPE vbak-ernam,
      END OF gty_vbak.

TYPES: BEGIN OF gty_vbap,
          vbeln TYPE vbeln_va,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
        END OF gty_vbap.

TYPES: BEGIN OF gty_mara,
          matnr TYPE mara-matnr,
          mtart TYPE mara-mtart,
       END OF gty_mara.

TYPES: BEGIN OF gty_makt,
          matnr TYPE makt-matnr,
          maktx TYPE makt-maktx,
       END OF gty_makt.

TYPES: BEGIN OF gty_final,
       vbeln TYPE VBELN_va,
       posnr TYPE posnr,
       erdat TYPE erdat,
       ernam TYPE ernam,
       matnr TYPE matnr,
       maktx TYPE maktx,
       mtart TYPE mtart,
       END OF gty_final.


*internal table
DATA:gt_vbak TYPE TABLE OF gty_vbak,
     gt_vbap TYPE TABLE OF gty_vbap,
     gt_mara TYPE TABLE OF gty_mara,
     gt_makt TYPE TABLE OF gty_makt,
     gt_vbap_1 TYPE TABLE OF gty_vbap,
     gt_final TYPE TABLE OF gty_final,
     gt_fieldcat TYPE slis_t_fieldcat_alv.

*work area declaration
DATA : gs_final TYPE gty_final,
      gs_vbap TYPE gty_vbap,
      gs_vbak TYPE gty_vbak,
      gs_mara TYPE gty_mara,
      gs_makt TYPE gty_makt,
      gs_fieldcat TYPE slis_fieldcat_alv.


*start of execution
START-OF-SELECTION.

CLEAR : gt_vbak[], gt_vbap[], gt_mara[], gt_makt[],
        gt_final[].
SELECT vbeln erdat ernam
  FROM vbak
  INTO TABLE gt_vbak
  UP TO 10 rows.

IF gt_vbak[] is NOT INITIAL.
  SELECT vbeln posnr matnr
    FROM vbap
    INTO TABLE gt_vbap
    FOR ALL ENTRIES IN gt_vbak
    WHERE vbeln = gt_vbak-vbeln.
ENDIF.

CLEAR : gt_vbap_1[].
gt_vbap_1[] = gt_vbap[].
SORT gt_vbap_1 by matnr.
DELETE ADJACENT DUPLICATES FROM gt_vbap_1 COMPARING matnr.

IF gt_vbap_1[] IS NOT INITIAL.
  SELECT matnr mtart
    FROM mara
    INTO TABLE gt_mara
    FOR ALL ENTRIES IN gt_vbap_1
    WHERE matnr = gt_vbap_1-matnr.
ENDIF.

IF gt_mara[] IS NOT INITIAL.
  SELECT matnr maktx
    FROM makt
    INTO TABLE gt_makt
    FOR ALL ENTRIES IN gt_mara
    WHERE matnr = gt_mara-matnr.
ENDIF.

LOOP AT gt_vbap INTO gs_vbap.

  CLEAR gs_final.
  gs_final-vbeln = gs_vbap-vbeln.
  gs_final-posnr = gs_vbap-posnr.
  gs_final-matnr = gs_vbap-matnr.

  CLEAR gs_vbak.
  READ TABLE gt_vbak INTO gs_vbak WITH KEY vbeln = gs_vbap-vbeln.
  IF sy-subrc = 0.
    gs_final-erdat = gs_vbak-erdat.
    gs_final-ernam = gs_vbak-ernam.
  ENDIF.

  CLEAR gs_mara.
  READ TABLE gt_mara INTO gs_mara WITH KEY matnr = gs_vbap-matnr.
  IF sy-subrc = 0.
    gs_final-mtart = gs_mara-mtart.
  ENDIF.

  CLEAR gs_makt.
  READ TABLE gt_makt INTO gs_makt WITH KEY matnr = gs_vbap-matnr.
  IF sy-subrc = 0.
    gs_final-maktx = gs_makt-maktx.
  ENDIF.
  APPEND gs_final to gt_final.
  CLEAR gs_vbap.

ENDLOOP.

CLEAR gt_fieldcat[].

CLEAR gs_fieldcat.
gs_fieldcat-SELTEXT_M = 'Sales Documents'.
gs_fieldcat-OUTPUTLEN = 12.
gs_fieldcat-FIELDNAME = 'VBELN'.
gs_fieldcat-COL_POS  = 1.
gs_fieldcat-HOTSPOT  = abap_true.
APPEND gs_fieldcat to gt_fieldcat.

CLEAR gs_fieldcat.
gs_fieldcat-SELTEXT_M = 'Item no'.
gs_fieldcat-OUTPUTLEN = 10.
gs_fieldcat-FIELDNAME = 'POSNR'.
gs_fieldcat-COL_POS  = 2.
APPEND gs_fieldcat to gt_fieldcat.

CLEAR gs_fieldcat.
gs_fieldcat-SELTEXT_M = 'creation date'.
gs_fieldcat-OUTPUTLEN = 15.
gs_fieldcat-FIELDNAME = 'ERDAT'.
gs_fieldcat-COL_POS  = 3.
APPEND gs_fieldcat to gt_fieldcat.

CLEAR gs_fieldcat.
gs_fieldcat-SELTEXT_M = 'Name of Person who Created the Object'.
gs_fieldcat-OUTPUTLEN = 15.
gs_fieldcat-FIELDNAME = 'ERNAM'.
gs_fieldcat-COL_POS = 4.
APPEND gs_fieldcat to gt_fieldcat.

CLEAR gs_fieldcat.
gs_fieldcat-SELTEXT_M = 'Material Number'.
gs_fieldcat-OUTPUTLEN = 10.
gs_fieldcat-FIELDNAME = 'MATNR'.
gs_fieldcat-COL_POS = 5.
APPEND gs_fieldcat to gt_fieldcat.

CLEAR gs_fieldcat.
gs_fieldcat-SELTEXT_M = 'Material Descriptio'.
gs_fieldcat-OUTPUTLEN = 10.
gs_fieldcat-FIELDNAME = 'MAKTX'.
gs_fieldcat-EDIT = 'X'.
gs_fieldcat-COL_POS = 6.
APPEND gs_fieldcat to gt_fieldcat.

CLEAR gs_fieldcat.
gs_fieldcat-SELTEXT_M = 'Material Type'.
gs_fieldcat-OUTPUTLEN = 15.
gs_fieldcat-FIELDNAME = 'MTART'.
gs_fieldcat-COL_POS = 7.
APPEND gs_fieldcat to gt_fieldcat.


CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = sy-repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
   I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
   IT_FIELDCAT                       = gt_fieldcat[]
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
   I_SAVE                            = 'A'
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
   T_OUTTAB                          = gt_final[]

 EXCEPTIONS
  PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


form USER_COMMAND USING r_ucomm LIKE sy-ucomm
                                   rs_selfield TYPE slis_selfield.

  if r_ucomm = '&IC1'.


    if RS_SELFIELD-FIELDNAME = 'MATNR'.

      set PARAMETER ID 'MAT' FIELD RS_SELFIELD-value.
      call transaction 'MM03'.
      set PARAMETER ID 'MAT' FIELD space.
    ELSEIF  RS_SELFIELD-FIELDNAME = 'VBELN'.
      set PARAMETER ID 'AUN' FIELD RS_SELFIELD-value.
      call transaction 'VA03'.
      set PARAMETER ID 'AUN' FIELD space.
    endif.

  endif.

*  BREAK-POINT.
ENDFORM.
