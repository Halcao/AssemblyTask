D_SEG SEGMENT
MSG DB 'Please input the number:', '$'
ERROR DB 0DH, 0AH, 'Input error', '$'
NEXTLINE DB 0AH, 0DH, '$'
CHARS DB 74,  97, 110 ;Jan
      DB 70, 101,  98 ;Feb
      DB 77,  97, 114 ;Mar
      DB 65, 112, 114 ;Apr
      DB 77,  97, 121 ;May
      DB 74, 117, 110 ;Jun
      DB 74, 117, 108 ;Jul
      DB 65, 117, 103 ;Aug
      DB 83, 101, 112 ;Sep
      DB 79,  99, 116 ;Oct
      DB 78, 111, 118 ;Nov
      DB 68, 101,  99 ;Dec
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
    MOV AH, 09H
    MOV DX, OFFSET MSG
    INT 21H
    CALL INPUT
    TEST DX, DX
    JZ QUIT
    CALL OUTPUT
QUIT:
    RET
;-----------------------------------------------
INPUT PROC NEAR
MOV DL, 0 ; save the input number
MOV CL, 2H ; counter
ILOP:
    MOV AH, 01H
    INT 21H
    SUB AL, 30H ; TODO: Validate the input
    CMP AL, 0AH
    JAE EXIT
    XCHG AX, DX
    MOV CH, 0AH
    MUL CH
    XCHG AX, DX
    ADD DL, AL
    MOV CH, 0
    LOOP ILOP
    CMP DX, 0CH
    JA EXIT ; bigger than 12
    CMP DX, 0H
    JE EXIT
    RET
EXIT:
    MOV DX, OFFSET ERROR
    MOV AH, 09H
    INT 21H
    MOV DX, 0
    RET
INPUT ENDP
;----------------------------------------------------------
OUTPUT PROC NEAR
    MOV AH, 09H
    XCHG BX, DX
    MOV DX, OFFSET NEXTLINE
    INT 21H
    XCHG BX, DX
    MOV CL, 03H
    DEC DX ; -1 offset
    MOV AX, DX
    MUL CL
    MOV DI, AX
    MOV CX, 03H
OLOP:
    MOV AL, CHARS[DI]
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    INC DI
    LOOP OLOP
    RET
OUTPUT ENDP
;----------------------------------------------------------
CODE ENDS
  END START
