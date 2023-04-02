REPORT ZSALES_ORDER_RAHUL02.




**he main use of creating these types of structures in ABAP, creating an internal table with the same structure, and then using it to store data from the database tables, in this case, the VBAP table which contains the data of sales order items. The
*structure fields are used to map the data fields from the VBAP table. The internal table can be used to join with other tables and to display the data in the final output. It can also be used to perform calculations, validations, and other operations on
*the data. The data is stored in this internal table in RAM so it's much faster to access and process than reading the data from the database tables every time. It's a common practice in ABAP programming to use these custom data structures to organize
*and handle data efficiently.

*Type pool

*The "TYPE-POOLS" statement is used to include a pool of global types and their components in the current ABAP program. The type pool "SLIS" (short for "Standard List) is a built-in type pool in ABAP that contains various types and interfaces that are
*elated to lists and list processing. The type pool SLIS is used for creating lists and the ALV grid.
*By including the "TYPE-POOLS : slis." statement at the beginning of the program, the developer is making available the types and interfaces from the SLIS pool for use in the program. This means that the developer can use the types and interfaces from
*the SLIS pool to create lists and the ALV grid, which is used for displaying data in a tabular format.

TYPE-POOLS : slis.

* Structure Declaration

*This code defines a structure called "gty_vbak" which is used to store data from the VBAK table in SAP.
*thestructure has four fields, each of which corresponds to a field in the VBAK table:
*vbeln is the field for the sales order number
*erdat is the field for the date the sales order was created
*ernam is the field for the name of the user who created the sales order
*erzet is the field for the time the sales order was created
*The structure is then used to create an internal table called "gt_vbak" which will store multiple rows of data from the VBAK table, with each row having the same structure as the "gty_vbak" structure.



TYPES : BEGIN OF gty_vbak,
          vbeln TYPE vbak-vbeln,
          erdat TYPE vbak-erdat,
          ernam TYPE vbak-ernam,
          erzet TYPE vbak-erzet,
        END OF gty_vbak.

*This code defines a structure called "gty_vbap" which is used to store data from the VBAP table in SAP. The structure has three fields, each of which corresponds to a field in the VBAP table:
*vbeln is the field for the sales order number
*posnr is the field for the item number of the sales order
*matnr is the field for the material number
*The structure is then used to create an internal table called "gt_vbap" which will store multiple rows of data from the VBAP table, with each row having the same structure as the "gty_vbap" structure.
*It looks like the ABAP program is using these structures to store data from the VBAP table in the internal table gt_vbap, and then using this table to join with other tables and display the data in the final output.


TYPES : BEGIN OF gty_vbap,
          vbeln TYPE vbap-vbeln,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
        END OF gty_vbap.

*This code defines a structure called "gty_mara" which is used to store data from the MARA table in SAP. The structure has two fields, each of which corresponds to a field in the MARA table:
*matnr is the field for the material number
*mtart is the field for the material type
*The structure is then used to create an internal table called "gt_mara" which will store multiple rows of data from the MARA table, with each row having the same structure as the "gty_mara" structure.
*It looks like the ABAP program is using these structures to store data from the MARA table in the internal table gt_mara, and then using this table to join with other tables and display the data in the final output. The material type can be used to
*identify the different types of materials like raw materials, finished goods, packaging materials etc.


TYPES : BEGIN OF gty_mara,
          matnr TYPE mara-matnr,
          mtart TYPE mara-mtart,
        END OF gty_mara.

*This code defines a structure called "gty_makt" which is used to store data from the MAKT table in SAP. The structure has two fields, each of which corresponds to a field in the MAKT table:
*matnr is the field for the material number
*maktx is the field for the material description
*The structure is then used to create an internal table called "gt_makt" which will store multiple rows of data from the MAKT table, with each row having the same structure as the "gty_makt" structure.
*It looks like the ABAP program is using these structures to store data from the MAKT table in the internal table gt_makt, and then using this table to join with other tables and display the data in the final output. The material description can be used
*to provide more information about the material, for example, the properties, usage or other details.


TYPES : BEGIN OF gty_makt,
          matnr TYPE makt-matnr,
          maktx TYPE makt-maktx,
        END OF gty_makt.

*This code defines a structure called "gty_final" which is used to store a combination of data from several SAP database tables, specifically VBAK, VBAP, MARA, and MAKT.
*The structure has eight fields, each of which corresponds to a field in one of the tables:
*vbeln, erdat, ernam, and erzet are the fields for the sales order number, the date the sales order was created, the name of the user who created the sales order, and the time the sales order was created respectively, which are from the VBAK table
*posnr, matnr are the fields for the item number of the sales order, and the material number, which are from the VBAP table
*mtart is the field for the material type, which is from the MARA table
*maktx is the field for the material description, which is from the MAKT table
*The structure is then used to create an internal table called "gt_final" which will store multiple rows of data, with each row having the same structure as the "gty_final" structure.
*the ABAP program is using these structures to store data from all the tables in a single internal table gt_final and then display the final output of the program based on this table. This final table can be used for further reporting and analysis
*purpose.

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


* Final Internal Table Declaration

"This code declares several internal tables that are used to store data in the program. Each internal table is declared with the following syntax:
"gt_vbak" is an internal table of type "gty_vbak" which stores data from the sales order header table.
"gt_vbap" is an internal table of type "gty_vbap" which stores data from the sales order item table.
"gt_mara" is an internal table of type "gty_mara" which stores data from the material master table.
"gt_makt" is an internal table of type "gty_makt" which stores data from the material text table.
"gt_vbap_1" is an internal table of type "gty_vbap" which stores data from the sales order item table, it's similar to "gt_vbap" but it's probably used for a different purpose.
"gt_final" is an internal table of type "gty_final" which stores the final output data of the program, it's probably used to store the result after joining data from different tables.
"gt_fldcat" is an internal table of type "slis_t_fieldcat_alv" which is used to store.

DATA :   gt_vbak   TYPE TABLE OF gty_vbak,
         gt_vbap   TYPE TABLE OF gty_vbap,
         gt_mara   TYPE TABLE OF gty_mara,
         gt_makt   TYPE TABLE OF gty_makt,
         gt_vbap_1 TYPE TABLE OF gty_vbap,
         gt_final  TYPE TABLE OF gty_final,
         gt_fldcat TYPE slis_t_fieldcat_alv.

*Final Work Area Declaration
"This code declares several ABAP variables, each of them is assigned a specific name and is defined with a specific data structure.
""gs_vbak" is a variable of type "gty_vbak" which stores data from the sales order header table.
"gs_vbap" is a variable of type "gty_vbap" which stores data from the sales order item table.
"gs_mara" is a variable of type "gty_mara" which stores data from the material master table.
"gs_makt" is a variable of type "gty_makt" which stores data from the material text table.
"gs_final" is a variable of type "gty_final" which stores the final output data of the program, it's probably used to store the result after joining data from different tables.
"gs_fldcat" is a variable of type "slis_fieldcat_alv" which is used to store the field catalog for ALV (ABAP List Viewer) output.
"gs_layo" is a variable of type "SLIS_LAYOUT_ALV" which is used to store layout options for the ALV output.
"These variables are called Work Area Variables, it's used to temporarily store data throughout the program and manipulate them. These variables can store only one row of data at a time, unlike internal tables that can store multiple rows. These
*variables can be used to store data from database tables, perform calculations, and hold the results of intermediate steps in the program.


DATA :  gs_vbak  TYPE gty_vbak,
        gs_vbap  TYPE gty_vbap,
        gs_mara  TYPE gty_mara,
        gs_makt  TYPE gty_makt,
        gs_final TYPE gty_final,
        gs_fldcat TYPE slis_fieldcat_alv,
        gs_layo TYPE SLIS_LAYOUT_ALV.

*The code is the start of selection event in an ABAP program. The "START-OF-SELECTION" event is triggered when the program is executed and it's typically used to retrieve data from the database and perform initial processing on it.
"The code uses a SELECT statement to retrieve data from the "vbak" table, which stands for sales order header. The SELECT statement retrieves specific fields from the table, such as "vbeln", "erdat", "ernam", and "erzet".
"The INTO TABLE clause is used to store the retrieved data into an internal table "gt_vbak" which is defined earlier in the program with the same structure of gty_vbak.
"The UP TO 10 ROWS clause is used to limit the number of rows retrieved to 10. This is useful when testing or when only a small subset of data is needed.
"This code is used to retrieve the data from the sales order header table and store it in the internal table gt_vbak, which can then be used in the program for further processing.


START-OF-SELECTION.
*BREAK-POINT.
*BREAK ECCABAP26.
  SELECT vbeln erdat ernam erzet
    FROM vbak
    INTO TABLE gt_vbak
    UP TO 100 ROWS.
*This code is checking if the internal table "gt_vbak" has any data in it by checking if it is not initial. If the table is not initial, it means that it contains data from the previous SELECT statement.
"The code then uses another SELECT statement to retrieve data from the "vbap" table, which stands for sales order item. The SELECT statement retrieves specific fields from the table, such as "vbeln", "posnr", and "matnr".
"The INTO TABLE clause is used to store the retrieved data into an internal table "gt_vbap" which is defined earlier in the program with the same structure of gty_vbap.
"The FOR ALL ENTRIES IN clause is used to limit the selection of data to only those rows where the "vbeln" field in the "vbap" table matches the "vbeln" field in the "gt_vbak" internal table.
"This code is used to retrieve the data from the sales order item table and store it in the internal table gt_vbap, based on the matching sales order numbers in the gt_vbak table.


  IF gt_vbak[] IS NOT INITIAL.
    SELECT vbeln posnr matnr
      FROM vbap
      INTO TABLE gt_vbap
      FOR ALL ENTRIES IN gt_vbak
      WHERE vbeln = gt_vbak-vbeln.

*This code is checking if the internal table "gt_vbap" has any data in it by checking if it is not initial. If the table is not initial, it means that it contains data from the previous SELECT statement.
"The first line "CLEAR gt_vbap_1[]" is used to clear any existing data in the internal table "gt_vbap_1"
"Then, the line "gt_vbap_1[] = gt_vbap[]" is used to copy all the data from "gt_vbap" to "gt_vbap_1".
"The next line "SORT gt_vbap_1 BY matnr." sorts the internal table "gt_vbap_1" by the field "matnr" in ascending order.
"The last line "DELETE ADJACENT DUPLICATES FROM gt_vbap_1 COMPARING matnr." is used to remove duplicate entries in the internal table "gt_vbap_1" based on the field "matnr".
"This code is used to sort the data in the gt_vbap_1 internal table by the material number, and then remove any duplicate entries in the table based on the material number. This would be useful in cases when you only want to have distinct materials in
*the table, and it's useful in avoiding data redundancy.


    IF gt_vbap[] IS NOT INITIAL.
      CLEAR gt_vbap_1[].
      gt_vbap_1[] = gt_vbap[].
      SORT gt_vbap_1 BY matnr.
      DELETE ADJACENT DUPLICATES FROM gt_vbap_1 COMPARING matnr.

*This code is checking if the internal table "gt_vbap_1" has any data in it by checking if it is not initial. If the table is not initial, it means that it contains data from the previous SELECT statement.
"The code then uses another SELECT statement to retrieve data from the "mara" table, which stands for material master table. The SELECT statement retrieves specific fields from the table, such as "matnr" and "mtart".
"The INTO TABLE clause is used to store the retrieved data into an internal table "gt_mara" which is defined earlier in the program with the same structure of gty_mara.
"The FOR ALL ENTRIES IN clause is used to limit the selection of data to only those rows where the "matnr" field in the "mara" table matches the "matnr" field in the "gt_vbap_1" internal table.
"This code is used to retrieve the data from the material master table and store it in the internal table gt_mara, based on the matching material numbers in the gt_vbap_1 table. The material master table contains information about the materials such as
*material type, unit of measure, etc. This data can be used in combination with the data from the sales order item table to provide a more detailed view of the materials in the sales order.


      IF gt_vbap_1[] IS NOT INITIAL.
        SELECT matnr mtart
          FROM mara
          INTO TABLE gt_mara
          FOR ALL ENTRIES IN gt_vbap_1
          WHERE matnr = gt_vbap_1-matnr.

*This code is checking if the internal table "gt_mara" has any data in it by checking if it is not initial. If the table is not initial, it means that it contains data from the previous SELECT statement.
"The code then uses another SELECT statement to retrieve data from the "makt" table, which stands for material text table. The SELECT statement retrieves specific fields from the table, such as "matnr" and "maktx".
"The INTO TABLE clause is used to store the retrieved data into an internal table "gt_makt" which is defined earlier in the program with the same structure of gty_makt.
"The FOR ALL ENTRIES IN clause is used to limit the selection of data to only those rows where the "matnr" field in the "makt" table matches the "matnr" field in the "gt_mara" internal table.
"This code is used to retrieve the data from the material text table and store it in the internal table gt_makt, based on the matching material numbers in the gt_mara table. The material text table contains information about the text description of the
*materials. This data can be used in combination with the data from the material master table and sales order item table to provide a more detailed view of the materials in the sales order.


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

*code clears any existing data in the internal table "gt_final". The gt_final table is used to store the final output of the program, after data from different tables has been joined and processed. By clearing the table, the program is making sure that
*it starts with an empty table before populating it with the new data.

  CLEAR gt_final.
*This code is using a LOOP AT statement to loop through the internal table "gt_vbap" and retrieve each row one by one. The INTO clause assigns each row to the work area variable "gs_vbap".
"Inside the loop, the code uses the "CLEAR" statement to clear any existing data in the "gs_final" work area variable. Then it assigns the values of "vbeln", "posnr", and "matnr" fields from the "gs_vbap" to the corresponding fields in the "gs_final"
*work area variable.
"This code is probably used to copy the data from the internal table gt_vbap to the gs_final work area variable. This can be useful if the program needs to modify the data in gs_final, or if it needs to use the data in gs_final for some other purpose.


  LOOP AT gt_vbap INTO gs_vbap.
    CLEAR gs_final.
    gs_final-vbeln = gs_vbap-vbeln.
    gs_final-posnr = gs_vbap-posnr.
    gs_final-matnr = gs_vbap-matnr.

**This code is using the "CLEAR" statement to clear any existing data in the "gs_vbak" work area variable.
*"Then the READ TABLE statement is used to read a specific row from the internal table "gt_vbak" by using the key field "vbeln" and comparing it to the "vbeln" field of the current row in the "gs_vbap" work area variable. If the READ TABLE statement
*finds a matching row, it assigns that row to the "gs_vbak" work area variable
*"The code then uses an IF statement to check if the READ TABLE statement was successful by checking the value of the system variable "sy-subrc". If the system variable is set to 0, it means that the READ TABLE statement was successful and the matching
*row was found. In this case, the code assigns the values of the fields "erdat", "erzet", and "ernam" from the "gs_vbak" work area variable to the corresponding fields in the "gs_final" work area variable.
*"This code is used to read the data from the gt_vbak internal table based on the matching sales order number in the gs_vbap work area variable, and then copy the data to the gs_final work area variable. The data from gt_vbak contains information about
*the sales order header, such as the order date, order time, and the name of the person who created the order, this data can be used in combination with the data from the sales order item table and material master table to provide a more detailed view of
*the materials in the sales order.

    CLEAR gs_vbak.
    READ TABLE gt_vbak INTO gs_vbak WITH KEY vbeln = gs_vbap-vbeln.
    IF sy-subrc = 0.
      gs_final-erdat = gs_vbak-erdat.
      gs_final-erzet = gs_vbak-erzet.
      gs_final-ernam = gs_vbak-ernam.
    ENDIF.
"This code is using the "CLEAR" statement to clear any existing data in the "gs_mara" work area variable.
"Then the READ TABLE statement is used to read a specific row from the internal table "gt_mara" by using the key field "matnr" and comparing it to the "matnr" field of the current row in the "gs_vbap" work area variable. If the READ TABLE statement
*finds a matching row, it assigns that row to the "gs_mara" work area variable.
*"The code then uses an IF statement to check if the READ TABLE statement was successful by checking the value of the system variable "sy-subrc". If the system variable is set to 0, it means that the READ TABLE statement was successful and the matching
*row was found. In this case, the code assigns the values of the field "mtart" from the "gs_mara" work area variable to the corresponding field in the "gs_final" work area variable.
*"This code is used to read the data from the gt_mara internal table based on the matching material number in the gs_vbap work area variable, and then copy the data to the gs_final work area variable. The data from gt_mara contains information about the
*material type and it can be used in combination with the data from the sales order item table and material master table to provide a more detailed view of the materials in the sales order.


    CLEAR gs_mara.
    READ TABLE gt_mara INTO gs_mara WITH KEY matnr = gs_vbap-matnr.
    IF sy-subrc = 0.
      gs_final-mtart = gs_mara-mtart.
    ENDIF.

**This code is using the "CLEAR" statement to clear any existing data in the "gs_makt" work area variable.
*"Then the READ TABLE statement is used to read a specific row from the internal table "gt_makt" by using the key field "matnr" and comparing it to the "matnr" field of the current row in the "gs_vbap" work area variable. If the READ TABLE statement
*finds a matching row, it assigns that row to the "gs_makt" work area variable.
*"The code then uses an IF statement to check if the READ TABLE statement was successful by checking the value of the system variable "sy-subrc". If the system variable is set to 0, it means that the READ TABLE statement was successful and the matching
*row was found. In this case, the code assigns the values of the field "maktx" from the "gs_makt" work area variable to the corresponding field in the "gs_final" work area variable.
*"This code is used to read the data from the gt_makt internal table based on the matching material number in the gs_vbap work area variable, and then copy the data to the gs_final work area variable. The data from gt_makt contains information about the
*material text and it can be used in combination with the data from the sales order item table, material master table and material type table to provide a more detailed view of the materials in the sales order.

    CLEAR gs_makt.
    READ TABLE gt_makt INTO gs_makt WITH KEY matnr = gs_vbap-matnr.
    IF sy-subrc = 0.
      gs_final-maktx = gs_makt-maktx.
    ENDIF.

**This line of code is using the APPEND statement to add the current row in the "gs_final" work area variable to the internal table "gt_final". The APPEND statement is used to add new rows to the internal table, and it is typically used after data has
*been read and processed into a work area variable.
*"It looks like the program is using the "gt_final" table to store the final output, after data from different tables has been joined, processed, and stored in the "gs_final" work area variable. The data in gt_final table contains the final output of the
*program, which would be a detailed view of the materials in the sales order containing the sales order number, item number, material number, material type, and material text.

    APPEND gs_final TO gt_final.
**This line of code uses the "CLEAR" statement to clear the contents of the "gs_vbap" work area variable. This is done after the current row of data in gs_vbap has been used to read data from other internal tables, join it and store in the gs_final work
*area variable and then append to the gt_final internal table. Clearing the gs_vbap work area variable allows the program to use it again to store new data from the gt_vbap internal table in the next iteration of the loop.


    CLEAR gs_vbap.
  ENDLOOP.

*  BREAK-POINT.

*This code is defining the field catalog for the ALV (ABAP List Viewer) output using an internal table "gt_fldcat" and a work area "gs_fldcat".
*The "CLEAR" statement is used to clear the contents of the "gs_fldcat" work area variable before adding new data to it.
"The code then assigns values to the different fields of the "gs_fldcat" work area variable.
""gs_fldcat-col_pos" is the column position of the field in the output.
"gs_fldcat-fieldname" is the name of the field in the internal table.
"gs_fldcat-tabname" is the name of the internal table.
"gs_fldcat-seltext_m" is the column title of the field to be displayed in the output.

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
