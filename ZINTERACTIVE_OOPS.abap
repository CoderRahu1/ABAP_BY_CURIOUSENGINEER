*&---------------------------------------------------------------------*
*& Report  ZINTERACTIVE_OOPS.
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
REPORT ZINTERACTIVE_OOPS.
tables: MARA.
data: begin of it_tab occurs 0,
      matnr like mara-matnr,
      ersda like mara-ersda,  "creation date
      ernam like mara-ernam,  "person created
      pstat like mara-pstat,  "maint stat
      lvorm like mara-lvorm,  "flg for deletion
      mtart like mara-mtart,  "mat type
      meins like mara-meins,  "uom
      end of it_tab.

data: wa_it_tab like line of it_tab.  "making work area
data: i_modified TYPE STANDARD TABLE OF mara,"For getting modified rows
      w_modified TYPE mara.

CLASS lcl_events_d0100 DEFINITION DEFERRED.

DATA: event_receiver1  TYPE REF TO lcl_events_d0100,
      i_selected_rows TYPE lvc_t_row,                "Selected Rows
      w_selected_rows TYPE lvc_s_row.
*---------------------------------------------------------------------*
*       CLASS lcl_events_d0100 DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_events_d0100 DEFINITION.
  PUBLIC SECTION.
    METHODS
        handle_hotspot_click
        FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
             e_row_id
             e_column_id
             es_row_no
             sender.
*---code addition for ALV pushbuttons
*--for placing buttons
    METHODS handle_toolbar_set
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING
              e_object
              e_interactive.
*---user command on clicking a button
    METHODS handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING
             e_ucomm.
ENDCLASS.                    "lcl_events_d0100 DEFINITION
TYPE-POOLS cndp.
DATA ok_code TYPE sy-ucomm.
*----------------------------------------------------------------------*
*                       FOR VARIANT
*----------------------------------------------------------------------*
DATA st_var TYPE disvariant .
DATA save TYPE c.
st_var-report = 'YKC_ALV_OOPS'.
save = 'A'.
*----------------------------------------------------------------------*
*         FOR LAYOUT
*----------------------------------------------------------------------*
DATA loyo TYPE lvc_s_layo.
loyo-zebra = 'X'.
loyo-detailinit = 'X'.
loyo-info_fname = 'RED'.
*----------------------------------------------------------------------*
*           FOR FIELD CATALOG
*----------------------------------------------------------------------*
DATA fcat TYPE lvc_t_fcat.
DATA wa_fcat LIKE LINE OF fcat.
*--Declaration for toolbar buttons
DATA : ty_toolbar      TYPE stb_button.
DATA : e_object        TYPE REF TO cl_alv_event_toolbar_set,
       io_alv_toolbar  TYPE REF TO cl_alv_event_toolbar_set.
*---custom container
DATA container TYPE REF TO cl_gui_custom_container.
DATA ref_grid TYPE REF TO cl_gui_alv_grid.

CREATE OBJECT container EXPORTING container_name = 'CONTAINER'.
CREATE OBJECT ref_grid  EXPORTING i_parent       = container.

*---------------------------------------------------------------------*
*       CLASS lcl_events_d0100 IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_events_d0100 IMPLEMENTATION.
*---method for hotspot
  METHOD handle_hotspot_click.
    DATA:ls_col_id   TYPE lvc_s_col.
    READ TABLE it_tab INTO wa_it_tab
                             INDEX e_row_id-index.
    IF sy-subrc = 0.
      CHECK ( wa_it_tab-matnr IS NOT INITIAL ).
      CASE e_column_id-fieldname.
        WHEN 'MATNR'.
          leave program.
*---put your own logic as per requirement on hotspot click
        WHEN OTHERS.
*       do nothing
      ENDCASE.
      CALL METHOD ref_grid->set_current_cell_via_id
        EXPORTING
          is_row_id    = e_row_id
          is_column_id = ls_col_id.
    ENDIF.
  ENDMETHOD.                    "handle_hotspot_click

**---method for handling toolbar
  METHOD handle_toolbar_set.
    CLEAR ty_toolbar.
    ty_toolbar-function  = 'EDIT'. "name of btn to  catch click
    ty_toolbar-butn_type = 0.
    ty_toolbar-text      = 'EDIT'.
    APPEND ty_toolbar    TO e_object->mt_toolbar.
  ENDMETHOD.                    "handle_toolbar_set

  METHOD handle_user_command.
    DATA: wr_data_changed TYPE REF TO cl_alv_changed_data_protocol.
    DATA: lt_rows TYPE lvc_t_row,
          lt_index TYPE  lvc_s_row-index.
    CASE e_ucomm.
      WHEN 'EDIT'.
      perform save_database.
      CALL METHOD ref_GRID->REFRESH_TABLE_DISPLAY.
    ENDCASE.
  ENDMETHOD.                    "handle_user_command
ENDCLASS.                    "lcl_events_d0100 IMPLEMENTATION

START-OF-SELECTION.
  PERFORM: get_data, field_catalog.

*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       text : getting data into internal table
*----------------------------------------------------------------------*
form get_data .
  select matnr ersda ernam pstat lvorm mtart meins
         into table it_tab
         from mara
         where matnr GE '000000000000000001'.
endform.                    " get_data
*&---------------------------------------------------------------------*
*&      Form  field_catalog
*&---------------------------------------------------------------------*
*       text  :setting field cat
*----------------------------------------------------------------------*
form field_catalog .
  CLEAR fcat.

  fcat = value #( ( col_pos = 1 fieldname = 'MATNR' coltext = 'Material No'       outputlen = 18 hotspot = 'X'               )
                  ( col_pos = 2 fieldname = 'ERSDA' coltext = 'Creation Date'     outputlen = 18               edit    = 'X' )
                  ( col_pos = 3 fieldname = 'ERNAM' coltext = 'Person Created'    outputlen = 18                             )
                  ( col_pos = 4 fieldname = 'PSTAT' coltext = 'Maint Stat'        outputlen = 18                             )
                  ( col_pos = 5 fieldname = 'LVORM' coltext = 'Flag for Deletion' outputlen = 18                             )
                  ( col_pos = 6 fieldname = 'MTART' coltext = 'Material Type'     outputlen = 18                             )
                  ( col_pos = 6 fieldname = 'MEINS' coltext = 'UOM'               outputlen = 18                             ) ).

  CREATE OBJECT event_receiver1.

  SET HANDLER event_receiver1->handle_toolbar_set   FOR ref_grid.
  SET HANDLER event_receiver1->handle_user_command  FOR ref_grid.
  SET HANDLER event_receiver1->handle_hotspot_click FOR ref_grid.
*----------------------------------------------------------------------*
*           ALV GRID DISPLAY
*----------------------------------------------------------------------*
  CALL METHOD ref_grid->set_table_for_first_display
    EXPORTING
      is_variant      = st_var
      i_save          = save
      is_layout       = loyo
    CHANGING
      it_outtab       = it_tab[]
      it_fieldcatalog = fcat.
  CALL SCREEN 100.
endform.                    " field_catalog
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module STATUS_0100 output.
*  CREATE OBJECT gr_events_d0100.
*
*  SET HANDLER gr_events_d0100->double_click
*
*                 FOR ref_grid.
CALL METHOD ref_grid->register_edit_event
  EXPORTING i_event_id = cl_gui_alv_grid=>mc_evt_modified.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'XXX'.
endmodule.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  exit  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module exit input.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      CLEAR ok_code.
      SET SCREEN 0.
*      LEAVE PROGRAM.
  ENDCASE.
endmodule.                 " exit  INPUT
*&---------------------------------------------------------------------*
*&      Form  SAVE_DATABASE
*&---------------------------------------------------------------------*
*       text : saving into DDIC from internal table
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SAVE_DATABASE .
*--- Getting the selected rows index
    CALL METHOD ref_grid->get_selected_rows
                IMPORTING  et_index_rows = i_selected_rows.
*--- Through the index capturing the values of selected rows
    LOOP AT i_selected_rows INTO w_selected_rows.
    READ TABLE it_tab INTO wa_it_tab INDEX w_selected_rows-index.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING wa_it_tab TO w_modified.
      APPEND w_modified TO i_modified.
    ENDIF.
  ENDLOOP.
  MODIFY mara FROM TABLE i_modified.
ENDFORM.                    " SAVE_DATABASE
