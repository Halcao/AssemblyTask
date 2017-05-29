D_SEG SEGMENT
POSSTRING DB 'POSITIVE NUMBERS: ', 0DH, 0AH, '$'
NEGSTRING DB 0DH, 0AH, 'NEGATIVE NUMBERS: ', 0DH, 0AH, '$'
ARRAY DB 7, 5, -4, 2, -3, 9, 3, 8, 9, -6, 7, -8, -9, 3, 5, -3, 3, 2, -2, 6
POSITIVE DB 21 DUP(?)
NEGATIVE DB 21 DUP(?)
D_SEG ENDS

S_SEG SEGMENT STACK
      DW 128 DUP(?)
S_SEG ENDS

CODE SEGMENT
ASSUME CS: CODE, DS: D_SEG, SS: S_SEG
START PROC FAR
    PUSH DS
    XOR AX, AX
    PUSH AX
    MOV AX, D_SEG
    MOV DS, AX

    MOV BX, 0
    MOV SI, 0
    MOV DI, 0
    MOV CX, 20
LOP:
    MOV AL, ARRAY[BX]
    SUB AL, 0
    JNS POS
    INC NEGATIVE   ; negative
    INC DI
    MOV NEGATIVE[DI], AL
    JMP NEXT
POS:
    INC POSITIVE   ; positive
    INC SI
    MOV POSITIVE[SI], AL
NEXT:
    INC BX
    LOOP LOP
    MOV DX, OFFSET POSSTRING
    MOV BX, OFFSET POSITIVE
    CALL PRINT
    MOV DX, OFFSET NEGSTRING
    MOV BX, OFFSET NEGATIVE
    CALL PRINT
    RET
;----------------------------------------------------------
PRINT PROC NEAR ; message: DX, array: BX
    MOV AH, 09H
    INT 21H
    MOV CL, [BX]
    MOV CH, 0
    MOV SI, 1
    MOV AH, 02H
LOOP1:
    MOV DL, [BX][SI]
    SUB DL, 0
    JNS POSI
    XCHG DH, DL
    MOV DL, '-'
    INT 21H
    XCHG DH, DL
    NEG DL
POSI:
    ADD DL, 30H
    INT 21H
    MOV DL, ' '
    INT 21H
    INC SI
    CMP SI, CX
    JNA LOOP1
    RET
PRINT ENDP
CODE ENDS
  END START
