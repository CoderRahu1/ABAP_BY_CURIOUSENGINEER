REPORT ZSALESORDER_AYUSHI.

TYPE-pools : slis.

Types: Begin of gty_vbak,
  vbeln type vbak-vbeln,
  erdat type vbak-erdat,
  ernam type vbak-ernam,
  End of gty_vbak.

  Types: Begin of gty_final,
          vbeln TYPE vbeln,
          erdat TYPE erdat,
          ernam TYPE ernam,

  END OF gty_final.

  Data : gt_vbak type table of gty_vbak,
        gs_vbak type gty_vbak,
        gt_final TYPE TABLE OF gty_final,
       gs_final TYPE gty_final,
       gt_fcat type slis_t_fieldcat_alv,
        gw_fcat type slis_fieldcat_alv.


   Start-OF-SELECTION.


   Select vbeln erdat ernam
     from vbak
     into TABLE gt_vbak
     UP TO 10 ROWS.

loop at gt_vbak into gs_final.
*  gs_final-vbeln = gs_vbak-vbeln.
*  gs_final-erdat = gs_vbak-erdat.
*  gs_final-ernam = gs_vbak-ernam.

  append gs_final to gt_final.
  clear : gs_vbak.
  ENDLOOP.



     CLEAR : gw_fcat, gt_fcat[].

     gw_fcat-FIELDNAME = 'VBELN'.
     gw_fcat-TABNAME = 'GT_FINAL'.
     gw_fcat-SELTEXT_M = 'Sales Doc'.
     gw_fcat-OUTPUTLEN = 10.
*     gw_fcat-DATATYPE = 'CHAR'.

     append gw_fcat to gt_fcat.

     CLEAR gw_fcat.
     gw_fcat-fieldname = 'ERDAT'.
     gw_fcat-TABNAME = 'GT_FINAL'.
     gw_fcat-SELTEXT_M = 'Creation Date'.
     gw_fcat-OUTPUTLEN = 10.
*     gw_fcat-DATATYPE = 'CHAR'.
     append gw_fcat to gt_fcat.

     Clear gw_fcat.
     gw_fcat-fieldname ='ERNAM'.
     gw_fcat-tabname ='GT_FINAL'.
*     gw_fcat-datatype ='CHAR'.
     gw_fcat-SELTEXT_M = 'Created Obj'.
     gw_fcat-OUTPUTLEN = 10.
     append gw_fcat to gt_fcat.


     CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
*        I_INTERFACE_CHECK                 = ' '
*        I_BYPASSING_BUFFER                = ' '
*        I_BUFFER_ACTIVE                   = ' '
*        I_CALLBACK_PROGRAM                = ' '
*        I_CALLBACK_PF_STATUS_SET          = ' '
*        I_CALLBACK_USER_COMMAND           = ' '
*        I_CALLBACK_TOP_OF_PAGE            = ' '
*        I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*        I_CALLBACK_HTML_END_OF_LIST       = ' '
*        I_STRUCTURE_NAME                  =
*        I_BACKGROUND_ID                   = ' '
*        I_GRID_TITLE                      =
*        I_GRID_SETTINGS                   =
*        IS_LAYOUT                         =
        IT_FIELDCAT                       = gt_fcat[]
*        IT_EXCLUDING                      =
*        IT_SPECIAL_GROUPS                 =
*        IT_SORT                           =
*        IT_FILTER                         =
*        IS_SEL_HIDE                       =
*        I_DEFAULT                         = 'X'
*        I_SAVE                            = ' '
*        IS_VARIANT                        =
*        IT_EVENTS                         =
*        IT_EVENT_EXIT                     =
*        IS_PRINT                          =
*        IS_REPREP_ID                      =
*        I_SCREEN_START_COLUMN             = 0
*        I_SCREEN_START_LINE               = 0
*        I_SCREEN_END_COLUMN               = 0
*        I_SCREEN_END_LINE                 = 0
*        I_HTML_HEIGHT_TOP                 = 0
*        I_HTML_HEIGHT_END                 = 0
*        IT_ALV_GRAPHICS                   =
*        IT_HYPERLINK                      =
*        IT_ADD_FIELDCAT                   =
*        IT_EXCEPT_QINFO                   =
*        IR_SALV_FULLSCREEN_ADAPTER        =
*      IMPORTING
*        E_EXIT_CAUSED_BY_CALLER           =
*        ES_EXIT_CAUSED_BY_USER            =
       TABLES
         T_OUTTAB                          = gt_final[]
      EXCEPTIONS
        PROGRAM_ERROR                     = 1
        OTHERS                            = 2
               .
     IF SY-SUBRC <> 0.
* Implement suitable error handling here
     ENDIF.
