REPORT ZPO_REPORT_01.

"""" REQUIREMENT - BASED ON THE SELECTION CRITERIA GIVEN DISPLAY THE PURCHASE ORDER HEADER DATA , LINE ITEM DETAILS AND VENDOR NAME.


**************************** REPORT FOR DISPLAYING PURCHASE ORDER ***************************************

"""" TABLES : EKKO - PURCHASE ORDER HEADER TABLE.
""""          EKPO - PURCHASE ORDER LINE ITEM.
""""          LFA1 - FOR VENDOR NAME.




TYPE-POOLS : SLIS.


TABLES : EKKO, EKPO.

TYPES : BEGIN OF GTY_LIST,                           """" CREATING STRUCTURE FOR THE OUTPUT TABLE.
        SEL,
"""" FROM HEADER EKKO
        EBELN TYPE EKKO-EBELN, "Purchasing Document Number
        BSART TYPE EKKO-BSART, "Purchasing Document Type
        AEDAT TYPE EKKO-AEDAT, "Date on Which Record Was Created
        ERNAM TYPE EKKO-ERNAM, "Name of Person who Created the Object
        LIFNR TYPE EKKO-LIFNR, "Vendor Account Number
"""" FROM VENDOR NAME LFA1.
        NAME1 TYPE LFA1-NAME1, "Name 1
"""" FROM ITEM TABLE EKPO
        EBELP TYPE EKPO-EBELP, "Item Number of Purchasing Document
        TXZ01 TYPE EKPO-TXZ01, "Short Text
        MATNR TYPE EKPO-MATNR, "Material Number
        MENGE TYPE EKPO-MENGE, "Purchase Order Quantity
        MEINS TYPE EKPO-MEINS, "Purchase Order Unit of Measure
        NETPR TYPE EKPO-NETPR, "Net Price in Purchasing Document (in Document Currency)
        NETWR TYPE EKPO-NETWR, "Net Order Value in PO Currency
        END OF GTY_LIST.

"""" NOW DECLARING INTERNAL TABLE AND WORK AREA.

DATA : GT_LIST TYPE STANDARD TABLE OF GTY_LIST,
       GS_LIST TYPE GTY_LIST,
       GT_LFA1 TYPE STANDARD TABLE OF LFA1,
       GS_LFA1 TYPE LFA1.


"""" DEFINING DATA DECLARARIONS FOR ALV FIELDCAT.

DATA :: GT_FCAT TYPE LVC_T_FCAT,                       """" SLIS_T_FIELDCAT_ALV.
        GS_FCAT LIKE LINE OF GT_FCAT,
        GS_LAYOUT TYPE LVC_S_LAYO,
*        GS_VARIENT TYPE DISVARIENT,                    """" FOR VARIENT SAVE.
        GS_GRID TYPE LVC_S_GLAY,
        GV_CNT TYPE I.


"""" DEFINING SELECTION SCREEN TO BE SHOWN ON THE SCREEN.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : S_EBELN FOR EKKO-EBELN,
                   S_AEDAT FOR EKKO-AEDAT,
                   S_BSART FOR EKKO-BSART.

SELECTION-SCREEN END OF BLOCK B1.


"""" NOW SELCTING DATA FROM THE DATABASE.


START-OF-SELECTION.


PERFORM GET_DATA.                  """" FETCHING DATA FROM THE DATABASE

PERFORM BUILD_DATA.                """" FINALLY MOVING DATA TO FINAL TABLE. HENCE BUILDING THE DATABASE.

PERFORM DISPLAY_DATA.





END-OF-SELECTION.


*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

"""" SELECTING DATA FROM EKKP AND EKPO BASED ON INNER JOIN

    SELECT A~EBELN A~BSART A~AEDAT A~ERNAM A~LIFNR
           B~EBELP B~TXZ01 B~MATNR B~MENGE B~MEINS B~NETPR B~NETWR
           FROM EKKO AS A INNER JOIN EKPO AS B ON A~EBELN = B~EBELN INTO CORRESPONDING FIELDS OF TABLE GT_LIST
           WHERE A~EBELN IN S_EBELN
           AND A~BSTYP = 'F'
           AND A~BSART IN S_BSART
           AND A~AEDAT IN S_AEDAT.


"""" NOW SELECTING VENDOR NAME FOR THE COMPANY TABLE

      IF GT_LIST IS NOT INITIAL.
"""" NOW IN THE LIFNR WE HAVE TO PASS VENDOR ID


        SELECT * FROM LFA1 INTO CORRESPONDING FIELDS OF TABLE GT_LFA1 FOR ALL ENTRIES IN GT_LIST              """" WHAT DOES FOR ALL ENTRY DO? LETS SAY IN THE ABOVE SELECT QUERY THERE IS 10 DIFFERENT PURCHASE ORDER FOR 5 DIFFERENT VENDORS SO WHAT
          """" FOR ALL ENTRIES WILL FETCH ONLY THOSE 5 DIFFERENT PO WITH THOSE 5 DIFFERENT VEDORS.

          WHERE LIFNR = GT_LIST-LIFNR.



      ENDIF.

ENDFORM.



*&---------------------------------------------------------------------*
*&      Form  BUILD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_DATA .
      LOOP AT GT_LIST INTO GS_LIST.

        READ TABLE GT_LFA1 INTO GS_LFA1 WITH KEY LIFNR = GS_LIST-LIFNR.         """" GS_LIST-LIFNR WILL HAVE THE VENDOR ID AND THEN USING THAT TO SELECT THE VENDOR NAME FROM THE LFA1 TABLE.
                                                            """" SELECTING VENDOR NAMAE FROM THE LFA1 TABLE AND ADDING IN THE GS_LIST.
        GS_LIST-NAME1 = GS_LFA1-NAME1.

        MODIFY GT_LIST FROM GS_LIST TRANSPORTING NAME1.             """"" BECAUSE WE ARE ADDING ONLY THE NAME.

        CLEAR : GS_LIST, GS_LFA1.                           """" ALWAYS CLEAR THE WORK AREA.

       
      ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY_DATA .
     """" WHENEVER DISPLAYING DATA ALWAYS CLEAR THE EXISTING FIELD CATALOG.

  CLEAR : GV_CNT, GT_FCAT[], GS_FCAT.

     GS_LAYOUT-CWIDTH_OPT = 'X'.
*     GS_LAYOUT-STYLEFNAME = 'CELLSTYLE'.
*     GS_LAYOUT-CTAB_FNAME = 'TCOLOR'.
     GS_LAYOUT-BOX_FNAME = 'SEL'.                  """" IN THE OUTPUT CAN SEE FIRST ROW AS ADDITIONAL ROW .
*      GS_VARIENT-REPORT = SY-REPID.


     GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'EBELN'.
     GS_FCAT-COLTEXT = 'PO NUMBER'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.


          GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'AEDAT'.
     GS_FCAT-COLTEXT = 'PO DATE'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.

          GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'ERNAM'.
     GS_FCAT-COLTEXT = 'ERNAM'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.

          GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'BSART'.
     GS_FCAT-COLTEXT = 'PO DOCUMENT TYPE'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.

          GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'LIFNR'.
     GS_FCAT-COLTEXT = 'VENDOR CODE'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     GS_FCAT-NO_ZERO = 'X'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.

               GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'NAME1'.
     GS_FCAT-COLTEXT = 'VENDOR NAME'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.
     
     
          GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'EBELP'.
     GS_FCAT-COLTEXT = 'LINE ITEM'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     GS_FCAT-NO_ZERO = 'X'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.

          GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'TXZ01'.
     GS_FCAT-COLTEXT = 'MATERIAL TEXT'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     GS_FCAT-NO_ZERO = 'X'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.

               GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'MATNR'.
     GS_FCAT-COLTEXT = 'MATERIAL CODE'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     GS_FCAT-NO_ZERO = 'X'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.

               GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'MENGE'.
     GS_FCAT-COLTEXT = 'QUANTITY'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     GS_FCAT-NO_ZERO = 'X'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.

               GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'MEINS'.
     GS_FCAT-COLTEXT = 'QUANTITY'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     GS_FCAT-NO_ZERO = 'X'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.


               GV_CNT = GV_CNT + 1.
     GS_FCAT-COL_POS = GV_CNT.
     GS_FCAT-FIELDNAME = 'MEINS'.
     GS_FCAT-COLTEXT = 'QUANTITY'.
*     GS_FCAT-EMPHASIZE = 'C3'.
     GS_FCAT-NO_ZERO = 'X'.
     APPEND GS_FCAT TO GT_FCAT.
     CLEAR GS_FCAT.

*               GV_CNT = GV_CNT + 1.
*     GS_FCAT-COL_POS = GV_CNT.
*     GS_FCAT-FIELDNAME = ''.
*     GS_FCAT-COLTEXT = ''.
**     GS_FCAT-EMPHASIZE = 'C3'.
*     GS_FCAT-NO_ZERO = 'X'.
*     APPEND GS_FCAT TO GT_FCAT.
*     CLEAR GS_FCAT.


     CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
*        I_INTERFACE_CHECK                 = ' '
*        I_BYPASSING_BUFFER                =
*        I_BUFFER_ACTIVE                   =
        I_CALLBACK_PROGRAM                = SY-REPID
*        I_CALLBACK_PF_STATUS_SET          = ' '
*        I_CALLBACK_USER_COMMAND           = ' '
*        I_CALLBACK_TOP_OF_PAGE            = ' '
*        I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*        I_CALLBACK_HTML_END_OF_LIST       = ' '
*        I_STRUCTURE_NAME                  =
*        I_BACKGROUND_ID                   = ' '
*        I_GRID_TITLE                      =
*        I_GRID_SETTINGS                   =
        IS_LAYOUT_LVC                     = GS_LAYOUT
        IT_FIELDCAT_LVC                   = GT_FCAT[]              """" CONTAINS FIELD NAME AND FIELD LABEL.
*        IT_EXCLUDING                      =
*        IT_SPECIAL_GROUPS_LVC             =
*        IT_SORT_LVC                       =
*        IT_FILTER_LVC                     =
*        IT_HYPERLINK                      =
*        IS_SEL_HIDE                       =
*        I_DEFAULT                         = 'X'
        I_SAVE                            = 'A'
*        IS_VARIANT                        = GS_VARIENT
*        IT_EVENTS                         =
*        IT_EVENT_EXIT                     =
*        IS_PRINT_LVC                      =
*        IS_REPREP_ID_LVC                  =
*        I_SCREEN_START_COLUMN             = 0
*        I_SCREEN_START_LINE               = 0
*        I_SCREEN_END_COLUMN               = 0
*        I_SCREEN_END_LINE                 = 0
*        I_HTML_HEIGHT_TOP                 =
*        I_HTML_HEIGHT_END                 =
*        IT_ALV_GRAPHICS                   =
*        IT_EXCEPT_QINFO_LVC               =
*        IR_SALV_FULLSCREEN_ADAPTER        =
*      IMPORTING
*        E_EXIT_CAUSED_BY_CALLER           =
*        ES_EXIT_CAUSED_BY_USER            =
       TABLES
         T_OUTTAB                          = GT_LIST[]
      EXCEPTIONS
        PROGRAM_ERROR                     = 1
        OTHERS                            = 2
               .
     IF SY-SUBRC <> 0.
* Implement suitable error handling here
     ENDIF.
ENDFORM.
