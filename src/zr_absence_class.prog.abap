*&---------------------------------------------------------------------*
*& Include          ZR_ABSENCE_CLASS
*&---------------------------------------------------------------------*

*------------------------------------- LOCAL CLASS WITH DATA FETCHING LOGIC WITH 2 STATIC METHODS FOR HEADER AND ITEM DATA -----------------------------------
CLASS lcl_empleave DEFINITION.
  PUBLIC SECTION.

    TYPES: BEGIN OF lty_header_data,
             pernr TYPE persno,
             ename TYPE emnam,
           END OF lty_header_data.

    TYPES: BEGIN OF lty_item_data,
             pernr   TYPE persno,
             begda   TYPE begda,
             endda   TYPE endda,
             awart   TYPE awart,
             atext   TYPE zatext,
             abwtg   TYPE abwtg,
             remarks TYPE char50,
           END OF lty_item_data.

    TYPES : lt_header_data TYPE STANDARD TABLE OF lty_header_data WITH DEFAULT KEY.
    TYPES : lt_item_data TYPE STANDARD TABLE OF lty_item_data WITH DEFAULT KEY.

    TYPES : ty_s_pernr TYPE RANGE OF persno,
            ty_s_ename TYPE RANGE OF emnam.

    CLASS-METHODS: fetch_empleave_header_data
      IMPORTING
        it_s_pernr     TYPE ty_s_pernr
        it_s_ename     TYPE ty_s_ename
      EXPORTING
        et_header_data TYPE lt_header_data,

      fetch_empleave_item_data
        IMPORTING
          iv_pernr     TYPE persno
        EXPORTING
          et_item_data TYPE lt_item_data.

ENDCLASS.



CLASS lcl_empleave IMPLEMENTATION.

  METHOD fetch_empleave_header_data.
    SELECT pernr, ename
    FROM zhremployees
    INTO TABLE @et_header_data
    WHERE pernr  IN @it_s_pernr AND ename  IN @it_s_ename.
  ENDMETHOD.

  METHOD fetch_empleave_item_data.
    SELECT a~pernr, a~begda, a~endda, a~awart, b~atext, a~abwtg, a~remarks
    INTO TABLE @et_item_data
    FROM zhrabsences AS a
    LEFT JOIN zhrabsencetypes AS b
    ON a~awart = b~awart AND b~sprsl = @sy-langu
    WHERE a~pernr = @iv_pernr.

  ENDMETHOD.

ENDCLASS.
