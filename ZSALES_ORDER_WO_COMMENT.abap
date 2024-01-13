REPORT ZPRAC_02.

TYPE-POOLS SLIS.

TYPES : BEGIN OF gty_vbak,
          vbeln TYPE vbak-vbeln,
          erdat TYPE vbak-erdat,
          ernam TYPE vbak-ernam,
          erzet TYPE vbak-erzet,
        END OF gty_vbak.

TYPES : BEGIN OF gty_vbap,
          vbeln TYPE vbap-vbeln,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
        END OF gty_vbap.

TYPES : BEGIN OF gty_mara,
          matnr TYPE mara-matnr,
          mtart TYPE mara-mtart,
        END OF gty_mara.

TYPES : BEGIN OF gty_makt,
          matnr TYPE makt-matnr,
          maktx TYPE makt-maktx,
        END OF gty_makt.

TYPES : BEGIN OF gty_final,            " final
          vbeln TYPE vbak-vbeln,
          erdat TYPE vbak-erdat,
          ernam TYPE vbak-ernam,
          erzet TYPE vbak-erzet,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
          mtart TYPE mara-mtart,
          maktx TYPE makt-maktx,
        END OF gty_final.

DATA :   gt_vbak   TYPE TABLE OF gty_vbak,
         gt_vbap   TYPE TABLE OF gty_vbap,
         gt_mara   TYPE TABLE OF gty_mara,
         gt_makt   TYPE TABLE OF gty_makt,
         gt_vbap_1 TYPE TABLE OF gty_vbap,
         gt_final  TYPE TABLE OF gty_final,
         gt_fldcat TYPE slis_t_fieldcat_alv.


DATA :  gs_vbak  TYPE gty_vbak,
        gs_vbap  TYPE gty_vbap,
        gs_mara  TYPE gty_mara,
        gs_makt  TYPE gty_makt,
        gs_final TYPE gty_final,
        gs_fldcat TYPE slis_fieldcat_alv,
        gs_layo TYPE SLIS_LAYOUT_ALV.

START-OF-SELECTION.

  SELECT vbeln erdat ernam erzet
    FROM vbak
    INTO TABLE gt_vbak
    UP TO 100 ROWS.

    IF gt_vbak[] IS NOT INITIAL.
    SELECT vbeln posnr matnr
      FROM vbap
      INTO TABLE gt_vbap
      FOR ALL ENTRIES IN gt_vbak
      WHERE vbeln = gt_vbak-vbeln.


    IF gt_vbap[] IS NOT INITIAL.
      CLEAR gt_vbap_1[].
      gt_vbap_1[] = gt_vbap[].
      SORT gt_vbap_1 BY matnr.
      DELETE ADJACENT DUPLICATES FROM gt_vbap_1 COMPARING matnr.



    IF gt_vbap_1[] IS NOT INITIAL.
      SELECT matnr mtart
      FROM mara
      INTO TABLE gt_mara
      FOR ALL ENTRIES IN gt_vbap_1
      WHERE matnr = gt_vbap_1-matnr.


        IF gt_mara[] IS NOT  INITIAL.
          SELECT matnr maktx
            FROM makt
            INTO TABLE gt_makt
            FOR ALL ENTRIES IN gt_mara
            WHERE matnr = gt_mara-matnr.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.


CLEAR gt_final.

LOOP AT gt_vbap INTO gs_vbap.
    CLEAR gs_final.
    gs_final-vbeln = gs_vbap-vbeln.
    gs_final-posnr = gs_vbap-posnr.
    gs_final-matnr = gs_vbap-matnr.

    CLEAR gs_vbak.
    READ TABLE gt_vbak INTO gs_vbak WITH KEY vbeln = gs_vbap-vbeln.
    IF sy-subrc = 0.
      gs_final-erdat = gs_vbak-erdat.
      gs_final-erzet = gs_vbak-erzet.
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

    APPEND gs_final TO gt_final.

        CLEAR gs_vbap.
  ENDLOOP.


    CLEAR gs_fldcat.
  gs_fldcat-col_pos = 1.
  gs_fldcat-fieldname = 'VBELN'.
  gs_fldcat-tabname = 'GT_FINAL'.
  gs_fldcat-seltext_m = 'Sales Document'.
  APPEND gs_fldcat to gt_fldcat.

  CLEAR gs_fldcat.
  gs_fldcat-col_pos = 1.
  gs_fldcat-fieldname = 'ERDAT'.
  gs_fldcat-tabname = 'GT_FINAL'.
  gs_fldcat-seltext_m = 'Creation Date'.
  APPEND gs_fldcat to gt_fldcat.

    CLEAR gs_fldcat.
  gs_fldcat-col_pos = 1.
  gs_fldcat-fieldname = 'ERZET'.
  gs_fldcat-tabname = 'GT_FINAL'.
  gs_fldcat-seltext_m = 'Time'.
  APPEND gs_fldcat to gt_fldcat.

    CLEAR gs_fldcat.
  gs_fldcat-col_pos = 1.
  gs_fldcat-fieldname = 'ERNAM'.
  gs_fldcat-tabname = 'GT_FINAL'.
  gs_fldcat-seltext_m = 'Created by'.
  APPEND gs_fldcat to gt_fldcat.


      CLEAR gs_fldcat.
  gs_fldcat-col_pos = 1.
  gs_fldcat-fieldname = 'POSNR'.
  gs_fldcat-tabname = 'GT_FINAL'.
  gs_fldcat-seltext_m = 'Itemno'.
  APPEND gs_fldcat to gt_fldcat.

    CLEAR gs_fldcat.
  gs_fldcat-col_pos = 1.
  gs_fldcat-fieldname = 'MATNR'.
  gs_fldcat-tabname = 'GT_FINAL'.
  gs_fldcat-seltext_m = 'Material'.
  APPEND gs_fldcat to gt_fldcat.

    CLEAR gs_fldcat.
  gs_fldcat-col_pos = 1.
  gs_fldcat-fieldname = 'MTART'.
  gs_fldcat-tabname = 'GT_FINAL'.
  gs_fldcat-seltext_m = 'Material type'.
  APPEND gs_fldcat to gt_fldcat.

    CLEAR gs_fldcat.
  gs_fldcat-col_pos = 1.
  gs_fldcat-fieldname = 'MAKTX'.
  gs_fldcat-tabname = 'GT_FINAL'.
  gs_fldcat-seltext_m = 'Material Desc.'.
  APPEND gs_fldcat to gt_fldcat.

  CLEAR gs_layo.
gs_layo-colwidth_optimize = 'X'.
gs_layo-zebra = 'X'.


CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
*   I_CALLBACK_PROGRAM                = sy-repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   IS_LAYOUT                         = gs_layo
   IT_FIELDCAT                       = gt_fldcat[]
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
   I_SAVE                            = 'A'
*   I_SAVE                            = 'U'
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
    t_outtab                          = gt_final[]
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
   .

IF sy-subrc <> 0.
* Implement suitable error handling here
               ENDIF.
