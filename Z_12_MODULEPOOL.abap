REPORT ZTRY_MODULEPOOL.

DATA : io_vbeln TYPE vbeln_va,
       io_bsart TYPE vbak-auart,
       io_erdat TYPE char10.

TYPES : BEGIN OF gty_vbak,
          vbeln TYPE vbak-vbeln,
          erdat TYPE vbak-erdat,
          auart TYPE vbak-auart,
        END OF gty_vbak.

DATA : gs_vbak TYPE gty_vbak.

SELECTION-SCREEN: PUSHBUTTON 2(20) tyu USER-COMMAND ABC.

INITIALIZATION.
tyu = 'Go To Next Screen'.

*START-OF-SELECTION.
At SELECTION-SCREEN.
*but1 = 'Go To Next Screen'.
if sy-ucomm = 'ABC'.
 call screen 0900.
endif.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0900  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0900 INPUT.
BREAK-POINT.


CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    INPUT         = io_vbeln
 IMPORTING
   OUTPUT        = io_vbeln
          .

if sy-ucomm = 'DISP'.
  call SCREEN 0902 STARTING AT 16 8
                   ENDING AT 50 36.
ENDIF.



SELECT SINGLE vbeln erdat auart
  from vbak
  into gs_vbak
  WHERE vbeln = io_vbeln.
if sy-subrc = 0.
  CONCATENATE gs_vbak-erdat+6(2) gs_vbak-erdat+4(2) gs_vbak-erdat+0(4) INTO io_erdat SEPARATED BY '.'.
*io_erdat = gs_vbak-erdat.
io_bsart = gs_vbak-auart.
endif.


if sy-ucomm = 'E' OR sy-ucomm = 'ENDE' or sy-ucomm = 'ECAN'.
  set SCREEN 0.
endif.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0902  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0902 OUTPUT.
  SET PF-STATUS 'PFSTAT_0902'.
  SET TITLEBAR 'TIT'.

  types : BEGIN OF gty_vbap,
    vbeln TYPE vbap-vbeln,
    posnr TYPE vbap-posnr,
    matnr TYPE vbap-matnr,
    END OF gty_vbap.

  DATA : gt_vbap TYPE gty_vbap OCCURS 0 WITH HEADER LINE,
        GS_VBAP TYPE GTY_VBAP,
*                GS_FIELDCAT TYPE SLIS_FIELDCAT_ALV,
*                GT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.
                GS_FIELDCAT TYPE lvc_s_fcat,
                GT_FIELDCAT TYPE lvc_t_fcat.


DATA : alv_cont TYPE REF TO cl_gui_custom_container,
       alv_grid TYPE REF TO cl_gui_alv_grid.


CREATE OBJECT ALV_CONT
  EXPORTING
    CONTAINER_NAME              = 'CUST_CNTL_0902'
  EXCEPTIONS
    CNTL_ERROR                  = 1
    CNTL_SYSTEM_ERROR           = 2
    CREATE_ERROR                = 3
    LIFETIME_ERROR              = 4
    LIFETIME_DYNPRO_DYNPRO_LINK = 5
    others                      = 6
    .
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

CREATE OBJECT ALV_GRID
  EXPORTING
*    I_SHELLSTYLE      = 0
*    I_LIFETIME        =
    I_PARENT          = ALV_CONT
*    I_APPL_EVENTS     = space
*    I_PARENTDBG       =
*    I_APPLOGPARENT    =
*    I_GRAPHICSPARENT  =
*    I_NAME            =
*    I_FCAT_COMPLETE   = SPACE
  EXCEPTIONS
    ERROR_CNTL_CREATE = 1
    ERROR_CNTL_INIT   = 2
    ERROR_CNTL_LINK   = 3
    ERROR_DP_CREATE   = 4
    others            = 5
    .
IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.



  SELECT vbeln posnr matnr
    from vbap
    INTO TABLE gt_vbap
    WHERE vbeln = io_vbeln.


   CLEAR : GS_FIELDCAT, GT_FIELDCAT[].
   GS_FIELDCAT-FIELDNAME = 'VBELN'.
*   GS_FIELDCAT-COL_POS = 1.
*   GS_FIELDCAT-SELTEXT_M = 'SALES DOCUMENT'.
   GS_FIELDCAT-REPTEXT = 'SALES DOCUMENT'.
   GS_FIELDCAT-OUTPUTLEN = 20.
   APPEND GS_FIELDCAT TO GT_FIELDCAT.

   GS_FIELDCAT-FIELDNAME = 'POSNR'.
*   GS_FIELDCAT-COL_POS = 4.
*   GS_FIELDCAT-SELTEXT_M = 'ITEM NO'.
   GS_FIELDCAT-REPTEXT = 'ITEM NO'.
   GS_FIELDCAT-OUTPUTLEN = 12.
   APPEND GS_FIELDCAT TO GT_FIELDCAT.

   GS_FIELDCAT-FIELDNAME = 'MATNR'.
   GS_FIELDCAT-COL_POS = 5.
   GS_FIELDCAT-REPTEXT = 'MATERIAL'.
   GS_FIELDCAT-OUTPUTLEN = 30.
   APPEND GS_FIELDCAT TO GT_FIELDCAT.

CALL METHOD ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
*  EXPORTING
*    I_BUFFER_ACTIVE               =
*    I_BYPASSING_BUFFER            =
*    I_CONSISTENCY_CHECK           =
*    I_STRUCTURE_NAME              =
*    IS_VARIANT                    =
*    I_SAVE                        =
*    I_DEFAULT                     = 'X'
*    IS_LAYOUT                     =
*    IS_PRINT                      =
*    IT_SPECIAL_GROUPS             =
*    IT_TOOLBAR_EXCLUDING          =
*    IT_HYPERLINK                  =
*    IT_ALV_GRAPHICS               =
*    IT_EXCEPT_QINFO               =
*    IR_SALV_ADAPTER               =
  CHANGING
    IT_OUTTAB                     = GT_VBAP[]
    IT_FIELDCATALOG               = GT_FIELDCAT[]
*    IT_SORT                       =
*    IT_FILTER                     =
  EXCEPTIONS
    INVALID_PARAMETER_COMBINATION = 1
    PROGRAM_ERROR                 = 2
    TOO_MANY_LINES                = 3
    others                        = 4
        .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


*   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
* EXPORTING
**      I_INTERFACE_CHECK                 = ' '
**      I_BYPASSING_BUFFER                = ' '
**      I_BUFFER_ACTIVE                   = ' '
**      I_CALLBACK_PROGRAM                = ' '
**      I_CALLBACK_PF_STATUS_SET          = ' '
**      I_CALLBACK_USER_COMMAND           = ' '
**      I_CALLBACK_TOP_OF_PAGE            = ' '
**      I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**      I_CALLBACK_HTML_END_OF_LIST       = ' '
**      I_STRUCTURE_NAME                  =
**      I_BACKGROUND_ID                   = ' '
**      I_GRID_TITLE                      =
**      I_GRID_SETTINGS                   =
**      IS_LAYOUT                         =
*    IT_FIELDCAT                       = GT_FIELDCAT[]
**      IT_EXCLUDING                      =
**      IT_SPECIAL_GROUPS                 =
**      IT_SORT                           =
**      IT_FILTER                         =
**      IS_SEL_HIDE                       =
**      I_DEFAULT                         = 'X'
**      I_SAVE                            = ' '
**      IS_VARIANT                        =
**      IT_EVENTS                         =
**      IT_EVENT_EXIT                     =
**      IS_PRINT                          =
**      IS_REPREP_ID                      =
**      I_SCREEN_START_COLUMN             = 0
**      I_SCREEN_START_LINE               = 0
**      I_SCREEN_END_COLUMN               = 0
**      I_SCREEN_END_LINE                 = 0
**      I_HTML_HEIGHT_TOP                 = 0
**      I_HTML_HEIGHT_END                 = 0
**      IT_ALV_GRAPHICS                   = 'C:\Users\RP\Desktop\NEW_IMAGE.bmp'
**      IT_HYPERLINK                      =
**      IT_ADD_FIELDCAT                   =
**      IT_EXCEPT_QINFO                   =
**      IR_SALV_FULLSCREEN_ADAPTER        =
**    IMPORTING
**      E_EXIT_CAUSED_BY_CALLER           =
**      ES_EXIT_CAUSED_BY_USER            =
*     TABLES
*       T_OUTTAB                          = GT_VBAP[]
* EXCEPTIONS
*     PROGRAM_ERROR                     = 1
*    OTHERS                            = 2
*             .
*   IF SY-SUBRC <> 0.
** Implement suitable error handling here
*   ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0902  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0902 INPUT.

if sy-ucomm = '&FLT'.
*  BREAK-POINT.
  set SCREEN 0900.
endif.

ENDMODULE.

***&SPWIZARD: DATA DECLARATION FOR TABLECONTROL 'TABL_CTRL_0901'
*&SPWIZARD: DEFINITION OF DDIC-TABLE
TABLES:   VBAP.

*&SPWIZARD: TYPE FOR THE DATA OF TABLECONTROL 'TABL_CTRL_0901'
TYPES: BEGIN OF T_TABL_CTRL_0901,
         VBELN LIKE VBAP-VBELN,
         POSNR LIKE VBAP-POSNR,
         MATNR LIKE VBAP-MATNR,
       END OF T_TABL_CTRL_0901.

*&SPWIZARD: INTERNAL TABLE FOR TABLECONTROL 'TABL_CTRL_0901'
DATA:     G_TABL_CTRL_0901_ITAB   TYPE T_TABL_CTRL_0901 OCCURS 0,
          G_TABL_CTRL_0901_WA     TYPE T_TABL_CTRL_0901. "work area
DATA:     G_TABL_CTRL_0901_COPIED.           "copy flag

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TABL_CTRL_0901' ITSELF
CONTROLS: TABL_CTRL_0901 TYPE TABLEVIEW USING SCREEN 0901.

*&SPWIZARD: LINES OF TABLECONTROL 'TABL_CTRL_0901'
DATA:     G_TABL_CTRL_0901_LINES  LIKE SY-LOOPC.

DATA:     OK_CODE LIKE SY-UCOMM.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TABL_CTRL_0901'. DO NOT CHANGE THIS LI
*&SPWIZARD: COPY DDIC-TABLE TO ITAB
MODULE TABL_CTRL_0901_INIT OUTPUT.
  IF G_TABL_CTRL_0901_COPIED IS INITIAL.
*&SPWIZARD: COPY DDIC-TABLE 'VBAP'
*&SPWIZARD: INTO INTERNAL TABLE 'g_TABL_CTRL_0901_itab'
    SELECT * FROM VBAP
       INTO CORRESPONDING FIELDS
       OF TABLE G_TABL_CTRL_0901_ITAB.
    G_TABL_CTRL_0901_COPIED = 'X'.
    REFRESH CONTROL 'TABL_CTRL_0901' FROM SCREEN '0901'.
  ENDIF.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TABL_CTRL_0901'. DO NOT CHANGE THIS LI
*&SPWIZARD: MOVE ITAB TO DYNPRO
MODULE TABL_CTRL_0901_MOVE OUTPUT.
  MOVE-CORRESPONDING G_TABL_CTRL_0901_WA TO VBAP.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TABL_CTRL_0901'. DO NOT CHANGE THIS LI
*&SPWIZARD: GET LINES OF TABLECONTROL
MODULE TABL_CTRL_0901_GET_LINES OUTPUT.
  G_TABL_CTRL_0901_LINES = SY-LOOPC.
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'TABL_CTRL_0901'. DO NOT CHANGE THIS LIN
*&SPWIZARD: PROCESS USER COMMAND
MODULE TABL_CTRL_0901_USER_COMMAND INPUT.
  OK_CODE = SY-UCOMM.
  PERFORM USER_OK_TC USING    'TABL_CTRL_0901'
                              'G_TABL_CTRL_0901_ITAB'
                              'FLAG'
                     CHANGING OK_CODE.
  SY-UCOMM = OK_CODE.
ENDMODULE.

*----------------------------------------------------------------------*
*   INCLUDE TABLECONTROL_FORMS                                         *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  USER_OK_TC                                               *
*&---------------------------------------------------------------------*
 FORM USER_OK_TC USING    P_TC_NAME TYPE DYNFNAM
                          P_TABLE_NAME
                          P_MARK_NAME
                 CHANGING P_OK      LIKE SY-UCOMM.

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
   DATA: L_OK              TYPE SY-UCOMM,
         L_OFFSET          TYPE I.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

*&SPWIZARD: Table control specific operations                          *
*&SPWIZARD: evaluate TC name and operations                            *
   SEARCH P_OK FOR P_TC_NAME.
   IF SY-SUBRC <> 0.
     EXIT.
   ENDIF.
   L_OFFSET = STRLEN( P_TC_NAME ) + 1.
   L_OK = P_OK+L_OFFSET.
*&SPWIZARD: execute general and TC specific operations                 *
   CASE L_OK.
     WHEN 'INSR'.                      "insert row
       PERFORM FCODE_INSERT_ROW USING    P_TC_NAME
                                         P_TABLE_NAME.
       CLEAR P_OK.

     WHEN 'DELE'.                      "delete row
       PERFORM FCODE_DELETE_ROW USING    P_TC_NAME
                                         P_TABLE_NAME
                                         P_MARK_NAME.
       CLEAR P_OK.

     WHEN 'P--' OR                     "top of list
          'P-'  OR                     "previous page
          'P+'  OR                     "next page
          'P++'.                       "bottom of list
       PERFORM COMPUTE_SCROLLING_IN_TC USING P_TC_NAME
                                             L_OK.
       CLEAR P_OK.
*     WHEN 'L--'.                       "total left
*       PERFORM FCODE_TOTAL_LEFT USING P_TC_NAME.
*
*     WHEN 'L-'.                        "column left
*       PERFORM FCODE_COLUMN_LEFT USING P_TC_NAME.
*
*     WHEN 'R+'.                        "column right
*       PERFORM FCODE_COLUMN_RIGHT USING P_TC_NAME.
*
*     WHEN 'R++'.                       "total right
*       PERFORM FCODE_TOTAL_RIGHT USING P_TC_NAME.
*
     WHEN 'MARK'.                      "mark all filled lines
       PERFORM FCODE_TC_MARK_LINES USING P_TC_NAME
                                         P_TABLE_NAME
                                         P_MARK_NAME   .
       CLEAR P_OK.

     WHEN 'DMRK'.                      "demark all filled lines
       PERFORM FCODE_TC_DEMARK_LINES USING P_TC_NAME
                                           P_TABLE_NAME
                                           P_MARK_NAME .
       CLEAR P_OK.

*     WHEN 'SASCEND'   OR
*          'SDESCEND'.                  "sort column
*       PERFORM FCODE_SORT_TC USING P_TC_NAME
*                                   l_ok.

   ENDCASE.

 ENDFORM.                              " USER_OK_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_INSERT_ROW                                         *
*&---------------------------------------------------------------------*
 FORM fcode_insert_row
               USING    P_TC_NAME           TYPE DYNFNAM
                        P_TABLE_NAME             .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
   DATA L_LINES_NAME       LIKE FELD-NAME.
   DATA L_SELLINE          LIKE SY-STEPL.
   DATA L_LASTLINE         TYPE I.
   DATA L_LINE             TYPE I.
   DATA L_TABLE_NAME       LIKE FELD-NAME.
   FIELD-SYMBOLS <TC>                 TYPE CXTAB_CONTROL.
   FIELD-SYMBOLS <TABLE>              TYPE STANDARD TABLE.
   FIELD-SYMBOLS <LINES>              TYPE I.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

   ASSIGN (P_TC_NAME) TO <TC>.

*&SPWIZARD: get the table, which belongs to the tc                     *
   CONCATENATE P_TABLE_NAME '[]' INTO L_TABLE_NAME. "table body
   ASSIGN (L_TABLE_NAME) TO <TABLE>.                "not headerline

*&SPWIZARD: get looplines of TableControl                              *
   CONCATENATE 'G_' P_TC_NAME '_LINES' INTO L_LINES_NAME.
   ASSIGN (L_LINES_NAME) TO <LINES>.

*&SPWIZARD: get current line                                           *
   GET CURSOR LINE L_SELLINE.
   IF SY-SUBRC <> 0.                   " append line to table
     L_SELLINE = <TC>-LINES + 1.
*&SPWIZARD: set top line                                               *
     IF L_SELLINE > <LINES>.
       <TC>-TOP_LINE = L_SELLINE - <LINES> + 1 .
     ELSE.
       <TC>-TOP_LINE = 1.
     ENDIF.
   ELSE.                               " insert line into table
     L_SELLINE = <TC>-TOP_LINE + L_SELLINE - 1.
     L_LASTLINE = <TC>-TOP_LINE + <LINES> - 1.
   ENDIF.
*&SPWIZARD: set new cursor line                                        *
   L_LINE = L_SELLINE - <TC>-TOP_LINE + 1.

*&SPWIZARD: insert initial line                                        *
   INSERT INITIAL LINE INTO <TABLE> INDEX L_SELLINE.
   <TC>-LINES = <TC>-LINES + 1.
*&SPWIZARD: set cursor                                                 *
   SET CURSOR LINE L_LINE.

 ENDFORM.                              " FCODE_INSERT_ROW

*&---------------------------------------------------------------------*
*&      Form  FCODE_DELETE_ROW                                         *
*&---------------------------------------------------------------------*
 FORM fcode_delete_row
               USING    P_TC_NAME           TYPE DYNFNAM
                        P_TABLE_NAME
                        P_MARK_NAME   .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
   DATA L_TABLE_NAME       LIKE FELD-NAME.

   FIELD-SYMBOLS <TC>         TYPE cxtab_control.
   FIELD-SYMBOLS <TABLE>      TYPE STANDARD TABLE.
   FIELD-SYMBOLS <WA>.
   FIELD-SYMBOLS <MARK_FIELD>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

   ASSIGN (P_TC_NAME) TO <TC>.

*&SPWIZARD: get the table, which belongs to the tc                     *
   CONCATENATE P_TABLE_NAME '[]' INTO L_TABLE_NAME. "table body
   ASSIGN (L_TABLE_NAME) TO <TABLE>.                "not headerline

*&SPWIZARD: delete marked lines                                        *
   DESCRIBE TABLE <TABLE> LINES <TC>-LINES.

   LOOP AT <TABLE> ASSIGNING <WA>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
     ASSIGN COMPONENT P_MARK_NAME OF STRUCTURE <WA> TO <MARK_FIELD>.

     IF <MARK_FIELD> = 'X'.
       DELETE <TABLE> INDEX SYST-TABIX.
       IF SY-SUBRC = 0.
         <TC>-LINES = <TC>-LINES - 1.
       ENDIF.
     ENDIF.
   ENDLOOP.

 ENDFORM.                              " FCODE_DELETE_ROW

*&---------------------------------------------------------------------*
*&      Form  COMPUTE_SCROLLING_IN_TC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*      -->P_OK       ok code
*----------------------------------------------------------------------*
 FORM COMPUTE_SCROLLING_IN_TC USING    P_TC_NAME
                                       P_OK.
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
   DATA L_TC_NEW_TOP_LINE     TYPE I.
   DATA L_TC_NAME             LIKE FELD-NAME.
   DATA L_TC_LINES_NAME       LIKE FELD-NAME.
   DATA L_TC_FIELD_NAME       LIKE FELD-NAME.

   FIELD-SYMBOLS <TC>         TYPE cxtab_control.
   FIELD-SYMBOLS <LINES>      TYPE I.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

   ASSIGN (P_TC_NAME) TO <TC>.
*&SPWIZARD: get looplines of TableControl                              *
   CONCATENATE 'G_' P_TC_NAME '_LINES' INTO L_TC_LINES_NAME.
   ASSIGN (L_TC_LINES_NAME) TO <LINES>.


*&SPWIZARD: is no line filled?                                         *
   IF <TC>-LINES = 0.
*&SPWIZARD: yes, ...                                                   *
     L_TC_NEW_TOP_LINE = 1.
   ELSE.
*&SPWIZARD: no, ...                                                    *
     CALL FUNCTION 'SCROLLING_IN_TABLE'
          EXPORTING
               ENTRY_ACT             = <TC>-TOP_LINE
               ENTRY_FROM            = 1
               ENTRY_TO              = <TC>-LINES
               LAST_PAGE_FULL        = 'X'
               LOOPS                 = <LINES>
               OK_CODE               = P_OK
               OVERLAPPING           = 'X'
          IMPORTING
               ENTRY_NEW             = L_TC_NEW_TOP_LINE
          EXCEPTIONS
*              NO_ENTRY_OR_PAGE_ACT  = 01
*              NO_ENTRY_TO           = 02
*              NO_OK_CODE_OR_PAGE_GO = 03
               OTHERS                = 0.
   ENDIF.

*&SPWIZARD: get actual tc and column                                   *
   GET CURSOR FIELD L_TC_FIELD_NAME
              AREA  L_TC_NAME.

   IF SYST-SUBRC = 0.
     IF L_TC_NAME = P_TC_NAME.
*&SPWIZARD: et actual column                                           *
       SET CURSOR FIELD L_TC_FIELD_NAME LINE 1.
     ENDIF.
   ENDIF.

*&SPWIZARD: set the new top line                                       *
   <TC>-TOP_LINE = L_TC_NEW_TOP_LINE.


 ENDFORM.                              " COMPUTE_SCROLLING_IN_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_MARK_LINES
*&---------------------------------------------------------------------*
*       marks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM FCODE_TC_MARK_LINES USING P_TC_NAME
                               P_TABLE_NAME
                               P_MARK_NAME.
*&SPWIZARD: EGIN OF LOCAL DATA-----------------------------------------*
  DATA L_TABLE_NAME       LIKE FELD-NAME.

  FIELD-SYMBOLS <TC>         TYPE cxtab_control.
  FIELD-SYMBOLS <TABLE>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <WA>.
  FIELD-SYMBOLS <MARK_FIELD>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (P_TC_NAME) TO <TC>.

*&SPWIZARD: get the table, which belongs to the tc                     *
   CONCATENATE P_TABLE_NAME '[]' INTO L_TABLE_NAME. "table body
   ASSIGN (L_TABLE_NAME) TO <TABLE>.                "not headerline

*&SPWIZARD: mark all filled lines                                      *
  LOOP AT <TABLE> ASSIGNING <WA>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
     ASSIGN COMPONENT P_MARK_NAME OF STRUCTURE <WA> TO <MARK_FIELD>.

     <MARK_FIELD> = 'X'.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_DEMARK_LINES
*&---------------------------------------------------------------------*
*       demarks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM FCODE_TC_DEMARK_LINES USING P_TC_NAME
                                 P_TABLE_NAME
                                 P_MARK_NAME .
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA L_TABLE_NAME       LIKE FELD-NAME.

  FIELD-SYMBOLS <TC>         TYPE cxtab_control.
  FIELD-SYMBOLS <TABLE>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <WA>.
  FIELD-SYMBOLS <MARK_FIELD>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (P_TC_NAME) TO <TC>.

*&SPWIZARD: get the table, which belongs to the tc                     *
   CONCATENATE P_TABLE_NAME '[]' INTO L_TABLE_NAME. "table body
   ASSIGN (L_TABLE_NAME) TO <TABLE>.                "not headerline

*&SPWIZARD: demark all filled lines                                    *
  LOOP AT <TABLE> ASSIGNING <WA>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
     ASSIGN COMPONENT P_MARK_NAME OF STRUCTURE <WA> TO <MARK_FIELD>.

     <MARK_FIELD> = SPACE.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines
