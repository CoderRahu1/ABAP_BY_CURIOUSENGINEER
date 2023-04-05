REPORT ZSESSION_METHOD1.

TYPES: BEGIN OF ST_MM01,
       MATNR TYPE MATNR,
       MBRSH TYPE MBRSH,
       MTART TYPE MTART,
       MAKTX TYPE MAKTX,
       MEINS TYPE MEINS,
    END OF ST_MM01.

DATA: IT_MM01 TYPE STANDARD TABLE OF ST_MM01,
      WA_MM01 TYPE ST_MM01,

      IT_BDCDATA TYPE STANDARD TABLE OF BDCDATA,
      WA_BDCDATA TYPE BDCDATA.

CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename                      = 'C:\Users\Sandhya\Desktop\session.txt'
   FILETYPE                      = 'ASC'
   HAS_FIELD_SEPARATOR           = '#'
*   HEADER_LENGTH                 = 0
*   READ_BY_LINE                  = 'X'
*   DAT_MODE                      = ' '
*   CODEPAGE                      = ' '
*   IGNORE_CERR                   = ABAP_TRUE
*   REPLACEMENT                   = '#'
*   CHECK_BOM                     = ' '
*   VIRUS_SCAN_PROFILE            =
*   NO_AUTH_CHECK                 = ' '
* IMPORTING
*   FILELENGTH                    =
*   HEADER                        =
  tables
    data_tab                      = IT_MM01
* CHANGING
*   ISSCANPERFORMED               = ' '
* EXCEPTIONS
*   FILE_OPEN_ERROR               = 1
*   FILE_READ_ERROR               = 2
*   NO_BATCH                      = 3
*   GUI_REFUSE_FILETRANSFER       = 4
*   INVALID_TYPE                  = 5
*   NO_AUTHORITY                  = 6
*   UNKNOWN_ERROR                 = 7
*   BAD_DATA_FORMAT               = 8
*   HEADER_NOT_ALLOWED            = 9
*   SEPARATOR_NOT_ALLOWED         = 10
*   HEADER_TOO_LONG               = 11
*   UNKNOWN_DP_ERROR              = 12
*   ACCESS_DENIED                 = 13
*   DP_OUT_OF_MEMORY              = 14
*   DISK_FULL                     = 15
*   DP_TIMEOUT                    = 16
*   OTHERS                        = 17
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'BDC_OPEN_GROUP'
 EXPORTING
   CLIENT                    = SY-MANDT
*   DEST                      = FILLER8
   GROUP                     = 'GENIOUS'
*   HOLDDATE                  = FILLER8
*   KEEP                      = FILLER1
   USER                      = SY-UNAME "FILLER12
*   RECORD                    = FILLER1
   PROG                      = SY-CPROG
*   DCPFM                     = '%'
*   DATFM                     = '%'
* IMPORTING
*   QID                       =
* EXCEPTIONS
*   CLIENT_INVALID            = 1
*   DESTINATION_INVALID       = 2
*   GROUP_INVALID             = 3
*   GROUP_IS_LOCKED           = 4
*   HOLDDATE_INVALID          = 5
*   INTERNAL_ERROR            = 6
*   QUEUE_ERROR               = 7
*   RUNNING                   = 8
*   SYSTEM_LOCK_ERROR         = 9
*   USER_INVALID              = 10
*   OTHERS                    = 11
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

lOOP AT IT_MM01 INTO WA_MM01.

  REFRESH IT_BDCDATA.


perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR' WA_MM01-MATNR.
*                              'A1891'.
perform bdc_field       using 'RMMG1-MBRSH' WA_MM01-MBRSH.
*                              '1'.
perform bdc_field       using 'RMMG1-MTART' WA_MM01-MTART.
*                              'FERT'.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(01)'
                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '4004'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'MAKT-MAKTX' WA_MM01-MAKTX.
*                              'Horn1'.
perform bdc_field       using 'BDC_CURSOR'
                              'MARA-MEINS'.
perform bdc_field       using 'MARA-MEINS' WA_MM01-MEINS.
*                              'KG'.
perform bdc_field       using 'MARA-MTPOS_MARA'
                              'NORM'.
perform bdc_dynpro      using 'SAPLSPO1' '0300'.
perform bdc_field       using 'BDC_OKCODE'
                              '=YES'.

ENDLOOP.

CALL FUNCTION 'BDC_INSERT'
 EXPORTING
   TCODE                  = 'MM01' "FILLER4
*   POST_LOCAL             = NOVBLOCAL
*   PRINTING               = NOPRINT
*   SIMUBATCH              = ' '
*   CTUPARAMS              = ' '
  TABLES
    dynprotab              = IT_BDCDATA
* EXCEPTIONS
*   INTERNAL_ERROR         = 1
*   NOT_OPEN               = 2
*   QUEUE_ERROR            = 3
*   TCODE_INVALID          = 4
*   PRINTING_INVALID       = 5
*   POSTING_INVALID        = 6
*   OTHERS                 = 7
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'BDC_CLOSE_GROUP'
* EXCEPTIONS
*   NOT_OPEN          = 1
*   QUEUE_ERROR       = 2
*   OTHERS            = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR WA_BDCDATA.
  WA_BDCDATA-PROGRAM  = PROGRAM.
  WA_BDCDATA-DYNPRO   = DYNPRO.
  WA_BDCDATA-DYNBEGIN = 'X'.
  APPEND WA_BDCDATA TO IT_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
  IF FVAL <> SPACE. "NODATA.
    CLEAR WA_BDCDATA.
    WA_BDCDATA-FNAM = FNAM.
    WA_BDCDATA-FVAL = FVAL.
    APPEND WA_BDCDATA TO IT_BDCDATA.
  ENDIF.

ENDFORM.
