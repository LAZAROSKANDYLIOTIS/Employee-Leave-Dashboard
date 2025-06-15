*&---------------------------------------------------------------------*
*& Include          ZSEL_HR_EMPLEAVE
*&---------------------------------------------------------------------*

SELECTION-SCREEN : BEGIN OF BLOCK  b1 WITH FRAME TITLE TEXT-000.
  SELECT-OPTIONS : s_pernr FOR lv_pernr.
  SELECT-OPTIONS : s_ename FOR lv_ename NO INTERVALS NO-EXTENSION.
SELECTION-SCREEN: END OF BLOCK b1.
