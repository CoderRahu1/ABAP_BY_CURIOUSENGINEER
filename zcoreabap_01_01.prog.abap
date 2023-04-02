REPORT zcoreabap_01_01.


*DATA : V_Z TYPE I.    " VARIABLE FOR STORING THE VALUE FROM INPUT FIELD
*
*
*
*
*
******************   ARITHMETIC OPERATORS ********************
**DATA : X TYPE i,   " DECLARING VARIBLES.
**       Y TYPE I,
**       Z TYPE I.
**
**
**X = 10.  " Initialization.
**Y = 10.
**
**WRITE :/ 'The Values Of Two Numbers Are X = ', X, 'Y = ', Y.
**
**
**Z = X + Y.  " Addition
**
**ULINE.
**WRITE :/ 'The Sum Of Two Numbers  Is :', Z COLOR 1 CENTERED.  " Display statemenet.
**
**ULINE.
**X = 10.  " Initialization.
**Y = 10.
**
**Z = X - Y.  " Addition
**
**WRITE :/ 'The Substraction Of Two Numbers  Is :', Z COLOR 2 CENTERED.  " Display statemenet.
**
**ULINE.
**
**Z = X * Y.
**
**
**WRITE :/ 'The Multiplication Of Two Variables Is :' , Z COLOR 3 CENTERED.
**
**ULINE.
**
**Z = X / Y.
**
**
**WRITE :/ 'The Division Of Two Variables Is :' , Z COLOR 4 LEFT-JUSTIFIED.
**
**ULINE.
**
**
**
*****************   ANOTHER METHOD FOR DEFINING OPERATORS *******************************
**
**
**
**DATA : V1 TYPE I VALUE 10,
**       V2 TYPE I VALUE 10.
**
**
**
**
**
**
**
**DATA : V_X TYPE C,
**       V_Y TYPE I.
**
**
**V_X = 'RAHUL PILLAI'.
**V_Y = 20 .
**
**
**WRITE :/ 'V_X IS ', V_X,    " THIS VALUE IS UNITIALIZED TO SPACE AND INTEGER TO 0
**       / 'V_Y IS', V_Y.
**
**
**uline.
**
**data : v_z(16) type c.
**
**v_z = 'RAHUL PILLAI'.
**
**
**WRITE :/ V_Z.
**
**
**
*
*
*
*
*
************************ DAY 6 *************************************
*
*
*
*
** SELECTION SCREEN PROGRAMMMING SCREENE DEVELOPMENT
*
*
*
**PARAMETERS : P_X TYPE I DEFAULT 20,
**             P_Y TYPE I DEFAULT 15.
*
*SELECTION-SCREEN BEGIN OF BLOCK BK1 WITH FRAME title t1.   " Selctiom screen block layout.
*
*SELECTION-SCREEN BEGIN OF LINE.
*  SELECTION-SCREEN COMMENT 8(20) LB1.
**                             8 MEANS STARTING FROM 8 FROM LEFT POSITION AND RESERVE 20 CHAR OR SPACES NOW FOR ENTIRE TEXT GIVING SOME VARIABLE NAME LB1
*  PARAMETERS : P_X TYPE I DEFAULT 20 OBLIGATORY.
*
*
*SELECTION-SCREEN END OF LINE.
*
*SELECTION-SCREEN BEGIN OF LINE.
*  SELECTION-SCREEN COMMENT 8(20) LB2.
**                             8 MEANS STARTING FROM 8 FROM LEFT POSITION AND RESERVE 20 CHAR OR SPACES NOW FOR ENTIRE TEXT GIVING SOME VARIABLE NAME LB1
*  PARAMETERS : P_Y TYPE I DEFAULT 15 OBLIGATORY.
*
*
*SELECTION-SCREEN END OF LINE.
*
*SELECTION-SCREEN END OF BLOCK BK1.
*
*SELECTION-SCREEN BEGIN OF BLOCK BK2 WITH FRAME TITLE T2.
*
*
*
*PARAMETERS : P_R1 RADIOBUTTON GROUP GRP1,
*             P_R2 RADIOBUTTON GROUP GRP1,
*             P_R3 RADIOBUTTON GROUP GRP1,
*             P_R4 RADIOBUTTON GROUP GRP1,
*             P_R5 RADIOBUTTON GROUP GRP1 DEFAULT 'X'.
*
*SELECTION-SCREEN END OF BLOCK BK2.
*
*INITIALIZATION.
*
*LB1 = 'ENTER FIRST NUMBER'.
*LB2 = 'ENTER SECOND NUMBER'.
*T1 = 'ENTER INPUT VALUES'.
*T2 = 'ARITHMETIC OPERATIONS'.
*
*START-OF-SELECTION.
*
*IF P_R1 = 'X'.
*  V_Z = P_X + P_Y.
*  WRITE :/ 'SUM IS :', V_Z.
*
*ELSEIF P_R2 = 'X'.
*  V_Z = P_X - P_Y.
*
*  if V_Z >= 0.
*    WRITE :/ 'DIFFERENCE IS :', V_Z.
*  ELSE.
*    WRITE :/ 'DIFFERENCE IS : -' NO-GAP,V_Z NO-SIGN LEFT-JUSTIFIED.
*  ENDIF.
*
*
*ELSEIF P_R3 = 'X'.
*  V_Z = P_X * P_Y.
*  WRITE :/ 'PRODUCT IS :', V_Z.
*ELSEIF P_R4 = 'X'.
*  V_Z = P_X / P_Y.
*  WRITE :/ ' IS :', V_Z.
*
*ELSE.
**  write :/ 'NONE OF THE BUTTON IS SELECTED'.
*   MESSAGE 'NONE RADIOBUTTON SELECTED' TYPE 'I'.
*ENDIF.
*
*

*************************** DAY 7 **********************************

**PARAMETERS : P_X TYPE I DEFAULT 20 OBLIGATORY,
**             P_Y TYPE I DEFAULT 10 OBLIGATORY,
**             P_STR  TYPE STRING LOWER CASE DEFAULT 'HELLO WORLD'.
**
**
**DATA : V_Z TYPE I. " VARIABLE DECLARED NORMALLY USING V_ AND THIS VARIBLE IS USED TO STORE USER INPUT
**
**V_Z = P_X + P_Y.
**
**
**WRITE :/ 'SUM OF TWO NUMBERS IS :', V_Z COLOR 2 LEFT-JUSTIFIED.
**
***WRITE :/ 'ENTERED STRING IS :', P_STR COLOR 2 LEFT-JUSTIFIED.      "(OR )
**
**FORMAT COLOR 6.
**
**WRITE :/ 'ENTERED STRING IS :', P_STR.
**
**FORMAT COLOR off.
**
**WRITE :/ 'CURRENT DATE IS ', SY-datum.
**WRITE :/ 'CURRENT TIME IS ', SY-uzeit.
**WRITE :/ 'CURRENT TIME IS ', SY-UNAME.
**WRITE :/ 'CURRENT TIME IS ', SY-REPID.
**WRITE :/ 'CURRENT TIME IS ', SY-PAGNO.




************************************   DAY 8 **********************************************

******* this program is for displaying all parameters in message box.

DATA : V_Z TYPE I.

DATA : V_STR1 TYPE STRING,
       V_STR2 TYPE STRING,
       V_MSG TYPE STRING,
       V_TEMP TYPE STRING,  " DECLARED FOR REMOVING THE -VE SIGN.
       V_LEN TYPE I,  " DECLARED FOR REMOVING THE -VE SIGN.
       V_POS TYPE I.  " DECLARED FOR REMOVING THE -VE SIGN.



SELECTION-SCREEN BEGIN OF BLOCK bk1 WITH FRAME TITLE t1.   " Selctiom screen block layout.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 8(20) lb1.
"8 MEANS STARTING FROM 8 FROM LEFT POSITION AND RESERVE 20 CHAR OR SPACES NOW FOR ENTIRE TEXT GIVING SOME VARIABLE NAME LB1
PARAMETERS : p_x TYPE i DEFAULT 20 OBLIGATORY.


SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 8(20) lb2.
"8 MEANS STARTING FROM 8 FROM LEFT POSITION AND RESERVE 20 CHAR OR SPACES NOW FOR ENTIRE TEXT GIVING SOME VARIABLE NAME LB1
PARAMETERS : p_y TYPE i DEFAULT 15 OBLIGATORY.


SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK bk1.

SELECTION-SCREEN BEGIN OF BLOCK bk2 WITH FRAME TITLE t2.



PARAMETERS : p_r1 RADIOBUTTON GROUP grp1 USER-COMMAND fc1,
             p_r2 RADIOBUTTON GROUP grp1,
             p_r3 RADIOBUTTON GROUP grp1,
             p_r4 RADIOBUTTON GROUP grp1,
             p_r5 RADIOBUTTON GROUP grp1 DEFAULT 'X'.

SELECTION-SCREEN END OF BLOCK bk2.

INITIALIZATION.

  lb1 = 'ENTER FIRST NUMBER'.
  lb2 = 'ENTER SECOND NUMBER'.
  t1 = 'ENTER INPUT VALUES'.
  t2 = 'ARITHMETIC OPERATIONS'.

**START-OF-SELECTION.
**
**IF P_R1 = 'X'.
**  V_Z = P_X + P_Y.
**   MESSAGE 'SUM IS :', V_Z TYPE.
**
**ELSEIF P_R2 = 'X'.
**  V_Z = P_X - P_Y.
**
**  if V_Z >= 0.
**    WRITE :/ 'DIFFERENCE IS :', V_Z.
**  ELSE.
**    WRITE :/ 'DIFFERENCE IS : -' NO-GAP,V_Z NO-SIGN LEFT-JUSTIFIED.
**  ENDIF.
**
**
**ELSEIF P_R3 = 'X'.
**  V_Z = P_X * P_Y.
**  WRITE :/ 'PRODUCT IS :', V_Z.
**ELSEIF P_R4 = 'X'.
**  V_Z = P_X / P_Y.
**  WRITE :/ ' IS :', V_Z.
**
**ELSE.
**  write :/ 'NONE OF THE BUTTON IS SELECTED'.
**   MESSAGE 'NONE RADIOBUTTON SELECTED' TYPE 'I'.
**ENDIF.

AT SELECTION-SCREEN ON RADIOBUTTON GROUP grp1.
  CASE sy-ucomm.
    WHEN 'FC1'.
      IF p_r1 = 'X'.
        v_z = p_x + p_y.
        V_STR1 = 'SUM OF TWO NUMBERS IS ' .
        V_STR2 = V_Z.
        CLEAR V_MSG.
        CONCATENATE V_STR1 V_STR2 INTO V_MSG SEPARATED BY SPACE.
        MESSAGE V_MSG TYPE 'I'.



      ELSEIF p_r2 = 'X'.
        v_z = p_x - p_y.

        IF V_Z >= 0.
           V_STR1 = 'DIFFERENCE OF TWO NUMBERS IS :'.
           V_STR2 = V_Z.
           CLEAR V_MSG.
           CONCATENATE V_STR1 V_STR2 INTO V_MSG SEPARATED BY SPACE.
           MESSAGE V_MSG TYPE 'I'.
        ELSE.
          V_STR1 = 'DIFFERENCE OF TWO NUMBERS IS : -'.
          V_STR2 = V_Z.
          CLEAR V_TEMP.
          CONCATENATE V_STR1 V_STR2 INTO V_TEMP SEPARATED BY SPACE.
          V_LEN = STRLEN( V_TEMP ).
          V_POS = V_LEN - 1.
          CLEAR V_MSG.
          V_MSG = V_TEMP+0(V_POS).   """" 0(V_POS) MEANS LETS SAY IF V_TEMP WAS 24 THEN 0(V_POS ) MEANS IT WILL FETCH ALL VALUES FROM 0 TILL 24.

        ENDIF.
        MESSAGE V_MSG TYPE 'I'.

      ELSEIF p_r3 = 'X'.
        v_z = p_x * p_y.
        V_STR1 = 'PRODUCT OF TWO NUMBERS IS ' .
        V_STR2 = V_Z.
        CLEAR V_MSG.
        CONCATENATE V_STR1 V_STR2 INTO V_MSG SEPARATED BY SPACE.
        MESSAGE V_MSG TYPE 'I'.
      ELSEIF p_r4 = 'X'.
        v_z = p_x / p_y.
        V_STR1 = 'DIVISION OF TWO NUMBERS IS ' .
        V_STR2 = V_Z.
        CLEAR V_MSG.
        CONCATENATE V_STR1 V_STR2 INTO V_MSG SEPARATED BY SPACE.
        MESSAGE V_MSG TYPE 'I'.

      ELSE.
        WRITE :/ 'NONE OF THE BUTTON IS SELECTED'.
        MESSAGE 'NONE RADIOBUTTON SELECTED' TYPE 'I'.
      ENDIF.


  ENDCASE.








************************************ DAY 9 *********************************************
*********** Check Box Program





****PARAMETERS : p_x TYPE i DEFAULT 20 OBLIGATORY,
****             p_y TYPE i DEFAULT 10 OBLIGATORY.
****
****
****DATA : v_z TYPE i.
****
****PARAMETERS : p_c1 AS CHECKBOX DEFAULT 'x' USER-COMMAND fc1,
****             p_c2 AS CHECKBOX USER-COMMAND fc2,
****             p_c3 AS CHECKBOX DEFAULT 'x' USER-COMMAND fc3,
****             p_c4 AS CHECKBOX USER-COMMAND fc4.
****
**********START-OF-SELECTION.
**********
**********    IF P_C1 = 'X'.
**********      V_Z = P_X + P_Y.
**********      WRITE :/ 'SUM IS :', V_Z.
**********    ENDIF.
**********
**********      IF P_C2 = 'X'.
**********      V_Z = P_X - P_Y.
**********      WRITE :/ 'DIFFERENCE IS :', V_Z.
**********    ENDIF.
**********
**********        IF P_C3 = 'X'.
**********      V_Z = P_X * P_Y.
**********      WRITE :/ 'PRODUCT IS :', V_Z.
**********    ENDIF.
**********
**********
**********        IF P_C4 = 'X'.
**********      V_Z = P_X / P_Y.
**********      WRITE :/ 'DIVISION IS :', V_Z.
**********    ENDIF.
**********
**********    END-OF-SELECTION.
**********
****
****
****AT SELECTION-SCREEN.
****
****  CASE sy-ucomm.
****    WHEN 'FC1'.
****      IF p_c1 = 'X'.
****        MESSAGE 'ADDITION CHECKBOX SELECTED :' TYPE 'I'.
****      ELSE.
****        MESSAGE 'ADDITION CHECKBOX DESELECTED : ' TYPE 'I'.
****      ENDIF.
****
****    WHEN 'FC2'.
****      IF p_c2 = 'X'.
****        MESSAGE 'DIFFERENCE CHECKBOX SELECTED :' TYPE 'I'.
****      ELSE.
****        MESSAGE 'DIFFERENCE CHECKBOX DESELECTED : ' TYPE 'I'.
****      ENDIF.
****
****
****    WHEN 'FC3'.
****            IF P_C3 = 'X'.
****        MESSAGE 'PRODUCT CHECKBOX SELECTED :' TYPE 'I'.
****      ELSE.
****        MESSAGE 'PRODUCT CHECKBOX DESELECTED : ' TYPE 'I'.
****      ENDIF.
****
****    WHEN 'FC4'.
****            IF P_C1 = 'X'.
****        MESSAGE 'DIVISION CHECKBOX SELECTED :' TYPE 'I'.
****      ELSE.
****        MESSAGE 'DIVISION CHECKBOX DESELECTED : ' TYPE 'I'.
****      ENDIF.
****
****    WHEN OTHERS.
****      MESSAGE 'NONE OF THE CHECKBOXES SELECTED OR DESELECTED' TYPE 'I'.
****
****
****  ENDCASE.




******************************** DAY 9 PROGRAM 2 ****************************************
***************** PROGRAM FOR PUSHBUTTONS *****************

****PARAMETERS : P_X TYPE I DEFAULT 20 OBLIGATORY,
****             P_Y TYPE I DEFAULT 10 OBLIGATORY,
****             P_Z TYPE I.
****
****
****
****SELECTION-SCREEN SKIP 2.
****SELECTION-SCREEN PUSHBUTTON /6(12) B1 USER-COMMAND FC1.     """"" CAN USE /6(12) FOR NEW LINE
****SELECTION-SCREEN PUSHBUTTON 20(12) B2 USER-COMMAND FC2.
****SELECTION-SCREEN SKIP 2.
****SELECTION-SCREEN PUSHBUTTON 10(12) B3 USER-COMMAND FC3.
****
****
****
****INITIALIZATION.
****
****B1 = 'ADDITION'.
****B2 = 'CLEAR'.
****B3 = 'EXIT'.
