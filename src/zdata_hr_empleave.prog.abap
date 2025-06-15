*&---------------------------------------------------------------------*
*& Include          ZDATA_HR_EMPLEAVE
*&---------------------------------------------------------------------*

DATA : lv_pernr TYPE persno.
DATA : lv_ename TYPE emnam.

DATA : lo_alv TYPE REF TO cl_salv_table.
DATA : lo_alv1 TYPE REF TO cl_salv_table.

DATA : lo_functions TYPE REF TO cl_salv_functions_list.
DATA : lo_functions1 TYPE REF TO cl_salv_functions_list.

DATA : lo_columns TYPE REF TO cl_salv_columns_table.
DATA : lo_pernr_col TYPE REF TO cl_salv_column.
DATA : lo_ename_col TYPE REF TO cl_salv_column.

DATA : lo_columns1 TYPE REF TO cl_salv_columns_table.
DATA : lo_pernr_col1 TYPE REF TO cl_salv_column.
DATA : lo_abwtg_col TYPE REF TO cl_salv_column.
DATA : lo_remarks_col TYPE REF TO cl_salv_column.


DATA : lo_sorts TYPE REF TO cl_salv_sorts.
DATA : lo_sorts1 TYPE REF TO cl_salv_sorts.

DATA : lo_events TYPE REF TO cl_salv_events_table.

DATA: lo_aggregations TYPE REF TO cl_salv_aggregations.


TYPES: BEGIN OF lty_header_data,
         pernr TYPE persno,
         ename TYPE emnam,
       END OF lty_header_data.

DATA : lt_employees TYPE TABLE OF lty_header_data.

TYPES: BEGIN OF lty_item_data,
         pernr   TYPE persno,
         begda   TYPE begda,
         endda   TYPE endda,
         awart   TYPE awart,
         atext   TYPE zatext,
         abwtg   TYPE abwtg,
         remarks TYPE char50,
       END OF lty_item_data.

DATA : lt_absence_details TYPE TABLE OF lty_item_data.
