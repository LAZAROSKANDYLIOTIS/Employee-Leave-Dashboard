*&---------------------------------------------------------------------*
*& Report ZPRG_HR_EMPLEAVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_hr_empleave.

INCLUDE zdata_hr_empleave.

INCLUDE zsel_hr_empleave.

INCLUDE zr_absence_class.

* ------------------------------- LOCAL CLASS  WITH INSTANCE (EVENT_HANDLER) METHOD FOR EVENT HANDLING ----------------------------------
CLASS lcl_handling DEFINITION.
  PUBLIC SECTION.
    METHODS event_handler_double_click FOR EVENT double_click OF cl_salv_events_table IMPORTING row column.
ENDCLASS.

CLASS lcl_handling IMPLEMENTATION.
  METHOD event_handler_double_click.
* ------------------------------- GET THE CORRECT TABLE ENTRY TO FETCH THE ITEM DATA ----------------------------------
    SORT lt_employees BY ename.
    READ TABLE lt_employees INTO DATA(lwa_employees) INDEX row.

    IF sy-subrc = 0.
* ------------------------------- FETCH ITEM DATA ----------------------------------
      lcl_empleave=>fetch_empleave_item_data( EXPORTING iv_pernr  = lwa_employees-pernr
                                              IMPORTING et_item_data = lt_absence_details ).

* ------------------------------- CL_SALV_TABLE FACTORY METHOD TO GET CL_SALV_TABLE OBJECT ---------------------------------

      TRY.
          CALL METHOD cl_salv_table=>factory
*        EXPORTING
*          list_display   = IF_SALV_C_BOOL_SAP=>FALSE
*          r_container    =
*          container_name =
            IMPORTING
              r_salv_table = lo_alv1
            CHANGING
              t_table      = lt_absence_details.
        CATCH cx_salv_msg.
      ENDTRY.

* ------------------------------- SET ALL ALV FUNCTIONS ----------------------------------
      CALL METHOD lo_alv1->if_salv_gui_om_table_info~get_functions
        RECEIVING
          value = lo_functions1.

      CALL METHOD lo_functions1->set_all
        EXPORTING
          value = if_salv_c_bool_sap=>true.

* ------------------------------- ADD SUM TO ABWTG COLUMN ----------------------------------

      CALL METHOD lo_alv1->if_salv_gui_om_table_info~get_aggregations
        RECEIVING
          value = lo_aggregations.
      TRY.
          CALL METHOD lo_aggregations->add_aggregation
            EXPORTING
              columnname  = 'ABWTG'
              aggregation = if_salv_c_aggregation=>total
*             receiving
*             value       =
            .
        CATCH cx_salv_data_error.
        CATCH cx_salv_not_found.
        CATCH cx_salv_existing.
      ENDTRY.

* ------------------------------- ADD SORTING FOR ABSENCE DAYS IN DESCENDING ORDER ----------------------------------
      CALL METHOD lo_alv1->if_salv_gui_om_table_info~get_sorts
        RECEIVING
          value = lo_sorts1.

      TRY.
          CALL METHOD lo_sorts1->add_sort
            EXPORTING
              columnname = 'ABWTG'
*             position   =
              sequence   = if_salv_c_sort=>SORT_down
*             subtotal   = IF_SALV_C_BOOL_SAP=>FALSE
*             group      = IF_SALV_C_SORT=>GROUP_NONE
*             obligatory = IF_SALV_C_BOOL_SAP=>FALSE
*  receiving
*             value      =
            .
        CATCH cx_salv_not_found.
        CATCH cx_salv_existing.
        CATCH cx_salv_data_error.
      ENDTRY.


* ------------------------------- CHANGE THE NAMES OF THREE COLUMNS ----------------------------------
      CALL METHOD lo_alv1->if_salv_gui_om_table_info~get_columns
        RECEIVING
          value = lo_columns1.

      TRY.
          CALL METHOD lo_columns1->get_column
            EXPORTING
              columnname = 'PERNR'
            RECEIVING
              value      = lo_pernr_col1.
        CATCH cx_salv_not_found.
      ENDTRY.

      CALL METHOD lo_pernr_col1->set_long_text
        EXPORTING
          value = TEXT-001.

      TRY.
          CALL METHOD lo_columns1->get_column
            EXPORTING
              columnname = 'ABWTG'
            RECEIVING
              value      = lo_abwtg_col.
        CATCH cx_salv_not_found.
      ENDTRY.

      CALL METHOD lo_abwtg_col->set_long_text
        EXPORTING
          value = TEXT-004.

      TRY.
          CALL METHOD lo_columns1->get_column
            EXPORTING
              columnname = 'REMARKS'
            RECEIVING
              value      = lo_remarks_col.
        CATCH cx_salv_not_found.
      ENDTRY.

      CALL METHOD lo_remarks_col->set_long_text
        EXPORTING
          value = TEXT-005.

* ------------------------------- DISPLAY ALV ----------------------------------
      CALL METHOD lo_alv1->if_salv_gui_om_table_action~display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.





AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_ename-low.
  SELECT ename
    FROM zhremployees
    INTO TABLE @DATA(lt_emp_names).

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE  = ' '
      retfield        = 'ENAME'
*     PVALKEY         = ' '
      dynpprog        = sy-repid
     DYNPNR          = SY-DYNNR
*     DYNPROFIELD     = ' '
*     STEPL           = 0
*     WINDOW_TITLE    =
*     VALUE           = ' '
     VALUE_ORG       = 'S'
*     MULTIPLE_CHOICE = ' '
*     DISPLAY         = ' '
*     CALLBACK_PROGRAM       = ' '
*     CALLBACK_FORM   = ' '
*     CALLBACK_METHOD =
*     MARK_TAB        =
*     IMPORTING
*     USER_RESET      =
    TABLES
      value_tab       = lt_emp_names
*     FIELD_TAB       =
*     RETURN_TAB      = DATA(LT_RETURN_TAB)
*     DYNPFLD_MAPPING =
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



START-OF-SELECTION.

* ------------------------------- FETCH HEADER DATA ---------------------------------

  lcl_empleave=>fetch_empleave_header_data( EXPORTING it_s_pernr = s_pernr[]
                                                      it_s_ename = s_ename[]
                                            IMPORTING et_header_data = lt_employees ).


* ------------------------------- CL_SALV_TABLE FACTORY METHOD TO GET CL_SALV_TABLE OBJECT ---------------------------------

  TRY.
      CALL METHOD cl_salv_table=>factory
*   EXPORTING
*     list_display   = IF_SALV_C_BOOL_SAP=>FALSE
*     r_container    =
*     container_name =
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = lt_employees.
    CATCH cx_salv_msg.
  ENDTRY.

* ------------------------------- SET ALL ALV FUNCTIONS ----------------------------------
  CALL METHOD lo_alv->if_salv_gui_om_table_info~get_functions
    RECEIVING
      value = lo_functions.

  CALL METHOD lo_functions->set_all
    EXPORTING
      value = if_salv_c_bool_sap=>true.

  CALL METHOD lo_alv->if_salv_gui_om_table_info~get_columns
    RECEIVING
      value = lo_columns.

* ------------------------------- CHANGE THE POSITION OF THE COLUMNS ----------------------------------

  CALL METHOD lo_columns->set_column_position
    EXPORTING
      columnname = 'PERNR'
      position   = 2.

  CALL METHOD lo_columns->set_column_position
    EXPORTING
      columnname = 'ENAME'
      position   = 1.

* ------------------------------- CHANGE THE NAMES OF THE COLUMNS ----------------------------------
  TRY.
      CALL METHOD lo_columns->get_column
        EXPORTING
          columnname = 'PERNR'
        RECEIVING
          value      = lo_pernr_col.
    CATCH cx_salv_not_found.
  ENDTRY.

  CALL METHOD lo_pernr_col->set_long_text
    EXPORTING
      value = TEXT-001.

  TRY.
      CALL METHOD lo_columns->get_column
        EXPORTING
          columnname = 'ENAME'
        RECEIVING
          value      = lo_ename_col.
    CATCH cx_salv_not_found.
  ENDTRY.

  CALL METHOD lo_ename_col->set_long_text
    EXPORTING
      value = TEXT-002.

* ------------------------------- ADD ALPHABETICAL SORTING ON FULL NAMES ----------------------------------
  CALL METHOD lo_alv->if_salv_gui_om_table_info~get_sorts
    RECEIVING
      value = lo_sorts.


  TRY.
      CALL METHOD lo_sorts->add_sort
        EXPORTING
          columnname = 'ENAME'
*         position   =
          sequence   = if_salv_c_sort=>sort_up
*         subtotal   = IF_SALV_C_BOOL_SAP=>FALSE
*         group      = IF_SALV_C_SORT=>GROUP_NONE
*         obligatory = IF_SALV_C_BOOL_SAP=>FALSE
*  receiving
*         value      =
        .
    CATCH cx_salv_not_found.
    CATCH cx_salv_existing.
    CATCH cx_salv_data_error.
  ENDTRY.


* ---------------------------- GET EVENTS OBJECT AND SET HANDLER METHOD FOR DOUBLE CLICKING -----------------------------

  CALL METHOD lo_alv->if_salv_gui_om_table_info~get_event
    RECEIVING
      value = lo_events.

  DATA(lo_object_handler) = NEW lcl_handling( ).
  SET HANDLER lo_object_handler->event_handler_double_click FOR lo_events.

* ------------------------------- DISPLAY ALV ----------------------------------
  CALL METHOD lo_alv->if_salv_gui_om_table_action~display.
