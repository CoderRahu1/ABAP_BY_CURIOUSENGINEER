REPORT zhello_world2022.

*heading
*write:/'list of consultants' color 5.
*write:/ 'list of consultants' color 5 INTENSIFIED OFF.
*write:/ 'list of consultants' color 5 INTENSIFIED ON INVERSE ON.
*
*FORMAT COLOR 3.
*ULINE.
*WRITE:/ SY-DATUM.
*WRITE:/ SY-UZEIT.
*WRITE:/ SY-UNAME.
*
*FORMAT COLOR OFF.
*
*ULINE.
*
*FORMAT COLOR COL_HEADING.
*WRITE :/5 'Name' ,10 '|' , 20 'Role',40 sy-vline, 50 'email', 80 sy-vline.
*FORMAT COLOR OFF.
*ULINE.
*WRITE :/5 'virat',10 '|' , 20 'it',  40 sy-vline, 50  'gmail@email', 80 sy-vline.
*ULINE.
*WRITE :/5 'rohan',10 '|' , 20 'it', 40  sy-vline, 50  'gmail@email', 80 sy-vline.
*ULINE.


*type c

*data : gv_title(5) type c,
*       gv_firstname(25) type c,
*       gv_lastname(25) type c.
*
**type i
*
*data : gv_salary type i,
*      gv_bonus type i,
*      gv_total type f,
*      gv_totall type p DECIMALS 2.
*
*
*WRITE :/ 'DATE :', sy-datum.
*WRITE :/ 'TIME :', sy-uzeit.
*WRITE :/ 'User :', sy-uname.
*WRITE :/ 'Program name :', sy-cprog.





*gv_salary = 125.
*gv_bonus = 37.
*
*gv_total = gv_salary / gv_bonus.
*gv_totall = gv_salary / gv_bonus.


*gv_salary = 100000.
*gv_bonus = ( gv_salary / 100 ) * 10.
*gv_total = gv_salary + gv_bonus.
*
*WRITE :/ 'Salary:', gv_salary.
*WRITE :/ 'Bonus:', gv_bonus.
**WRITE :/ 'Total Salary:' COLOR 3, gv_total COLOR 5.
**WRITE :/ 'Total Salary:' COLOR 3, gv_totall COLOR 5.
**
**
**CONSTANTS : gv_incentive type i VALUE '50000'.
**
**uline.
**
**
**gv_title = 'Mr.'.
**gv_firstname = 'John'.
**gv_lastname = 'David'.
**
**write :/ gv_title , gv_firstname , gv_lastname.
**
**uline.
**gv_title = 'Mr.'.
**gv_firstname = 'Vishal'.
**gv_lastname = 'Kadam'.
**
**write :/ gv_title , gv_firstname , gv_lastname.
**
**uline.



*************************** INTERNAL TABLE ***************************************



TYPES : BEGIN OF tp_itab,                           " Declaring Internal Table With A Structure.
          emp_id     TYPE zemp_id,
          title       TYPE ztitle,
          first_name TYPE zfirst_name,
          last_name   TYPE zlast_name,
          doj         TYPE psg_datjo,
          department TYPE zemp_dept,
          fullname   TYPE char100,

        END OF tp_itab.



DATA : gs_itab TYPE tp_itab,                      "Work Area Declaration
       gt_itab TYPE TABLE OF tp_itab.    " 1st Method Internal Table Declaration.
*       gs_itab type ZEMP_MASTER001.
*       gt_itab type standard table of ZEMP_MASTER001. "2Nd Method To Declare Internal Table - this takes complete field from the master table which consume more space.

DATA : gv_lines type i. "For Number Of Records.



*Adding Record To work area "" remember add the values always to work area.

gs_itab-emp_id = 'SAP001'.
gs_itab-title = 'Mr.'.
gs_itab-first_name = 'john'.
gs_itab-last_name = 'david'.
gs_itab-doj = '20200812'.  "YYYYMMDD
gs_itab-department = 'IT'.
APPEND gs_itab TO gt_itab.  " To add the recod
CLEAR gs_itab.

gs_itab-emp_id = 'SAP002'.
gs_itab-title = 'Mr.'.
gs_itab-first_name = 'Vishal'.
gs_itab-last_name = 'Kadam'.
gs_itab-doj = '20190814'.  "YYYYMMDD
gs_itab-department = 'IT'.
APPEND gs_itab TO gt_itab.
CLEAR gs_itab.

gs_itab-emp_id = 'SAP003'.
gs_itab-title = 'Mrs.'.
gs_itab-first_name = 'Surbhi'.
gs_itab-last_name = 'S.'.
gs_itab-doj = '20000815'.  "YYYYMMDD
gs_itab-department = 'IT'.
APPEND gs_itab TO gt_itab.
CLEAR gs_itab.

gs_itab-emp_id = 'SAP004'.
gs_itab-title = 'Mr.'.
gs_itab-first_name = 'Sammer'.
gs_itab-last_name = 'jain'.
gs_itab-doj = '20000817'.  "YYYYMMDD
gs_itab-department = 'ADMIN'.
APPEND gs_itab TO gt_itab.
CLEAR gs_itab.


gs_itab-emp_id = 'SAP005'.
gs_itab-title = 'Mr.'.
gs_itab-first_name = 'Aakash'.
gs_itab-last_name = 'Verma'.
gs_itab-doj = '20000817'.  "YYYYMMDD
gs_itab-department = 'Finance'.
INSERT gs_itab INTO gt_itab INDEX 2.
CLEAR gs_itab.


WRITE / 'Original Record' COLOR 5.

DESCRIBE TABLE gt_itab LINES gv_lines.

WRITE :/ 'total number of records ', gv_lines.

*sort gt_itab by first_name.

LOOP AT gt_itab INTO gs_itab.

  WRITE :/5 gs_itab-emp_id, 25 gs_itab-first_name, 45 gs_itab-doj, 60 gs_itab-department.
  CONCATENATE gs_itab-title gs_itab-first_name gs_itab-last_name INTO gs_itab-fullname SEPARATED BY SPACE.
  MODIFY gt_itab FROM gs_itab TRANSPORTING fullname.

*  WRITE :/ gs_itab-fullname.
  CLEAR : gs_itab.

ENDLOOP.

ULINE.


*DELETE gt_itab where department = 'IT'.
*DELETE gt_itab INDEX 2.
*
*
WRITE :/ 'Record After Modification' COLOR 6.

*sort gt_itab by department.

DELETE ADJACENT DUPLICATES FROM gt_itab COMPARING department.

*DESCRIBE TABLE gt_itab LINES gv_lines.

WRITE :/ 'total number of records ', gv_lines.

LOOP AT gt_itab INTO gs_itab.

  WRITE :/5 gs_itab-emp_id, 25 gs_itab-fullname, 60 gs_itab-department.
  CONCATENATE gs_itab-title gs_itab-fullname gs_itab-last_name INTO gs_itab-fullname SEPARATED BY space.      " DOING MODIFICATION AND CONCATENATION.
  CLEAR : gs_itab.

ENDLOOP.


ULINE.


***********************************   CONTROL STATEMENTS  *****************************************


*PARAMETERS : P_INT TYPE I.  " FOR SINGLE VALUE INPUT SCREEN
*
*START-OF-SELECTION.
*
*  IF P_INT > 10.
*    WRITE:/ 'VALUE OF THE INPUT FIELD IS > 10 : ' COLOR 5, p_int.
*
*  ELSEIF P_INT BETWEEN 5 AND 9.
*        WRITE:/ 'VALUE OF THE INPUT FIELD IS BETWEEN 5 TO 10 : ' COLOR 3, p_int.
*
*  ELSE.
*    WRITE:/ 'VALUE OF THE INPUT FIELD IS < 5' COLOR 7,p_int.
*
*  ENDIF.
*
*  SKIP 3.
*
*  CASE p_int.
*
*    WHEN 10.
*    WRITE:/ 'VALUE OF THE INPUT FIELD IS 10 : ' COLOR 5, p_int.
*    WHEN 5.
*      WRITE:/ 'VALUE OF THE INPUT FIELD IS 5: ' COLOR 7, p_int.
*    WHEN OTHERS.
*      WRITE:/ 'VALUE OF THE INPUT FIELD IS NOT 5 & 10 : ' COLOR 3, p_int.
*
*
*    ENDCASE.
*
*

*END-OF-SELECTION.


"DO END DO STATMENT

*WRITE :/ 'PROGRAM CLIENT IS: ' COLOR 1 ,sy-MANDT.
*WRITE :/ 'PROGRAM USER IS: ' COLOR 2 ,sy-UNAME.
*WRITE :/ 'PROGRAM NAME IS: ' COLOR 3 ,sy-cprog.
*WRITE :/ 'PROGRAM DATE IS: ' COLOR 4 ,sy-datum.
*WRITE :/ 'PROGRAM TIME IS: ' COLOR 5 ,sy-uzeit.
*
*
*
*ULINE.
*PARAMETERS : p_date TYPE sy-datum DEFAULT sy-datum.
*
*
*START-OF-SELECTION.
*
*  DO 10 TIMES.
*    p_date = p_date + 1.
**    WRITE :/ sy-index.
*    WRITE :/ sy-index , 'Date :', p_date.
*    ULINE.
*
*  ENDDO.
*
*
*END-OF-SELECTION.
