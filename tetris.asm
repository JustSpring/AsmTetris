;Tetris Game Made By Aviv Friedman 2023

;████████╗███████╗████████╗██████╗░██╗░██████╗
;╚══██╔══╝██╔════╝╚══██╔══╝██╔══██╗██║██╔════╝
;░░░██║░░░█████╗░░░░░██║░░░██████╔╝██║╚█████╗░
;░░░██║░░░██╔══╝░░░░░██║░░░██╔══██╗██║░╚═══██╗
;░░░██║░░░███████╗░░░██║░░░██║░░██║██║██████╔╝
;░░░╚═╝░░░╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝╚═════╝░
;▄▀█ █░█ █ █░█   █▀▀ █▀█ █ █▀▀ █▀▄ █▀▄▀█ ▄▀█ █▄░█
;█▀█ ▀▄▀ █ ▀▄▀   █▀░ █▀▄ █ ██▄ █▄▀ █░▀░█ █▀█ █░▀█

;general notes:

;Printing system (x=cx, y=dx)     ;My grid system (x=index, y=indexC)  

;(0,0)                            y (indexC)
;│━━━━━━━━━ x (cx)                │
;│                                │
;│         ד                       │
;│                                │━━━━━━━━━ x (index)   
;y (dx)                           (0,0)

IDEAL
MODEL small
STACK 100h
DATASEG
    ; ꧁LCG- for random part and random color꧂

    multiplier dw 16645 ; LCG multiplier (a)
    increment  dw 10139 ; LCG increment (c)
    modulus    dw 32768 ; LCG modulus (m)
    seed       dw 12345 ; Seed value (initial value)

    multiplier2 dw 17835 ; LCG multiplier (a)
    increment2  dw 12821 ; LCG increment (c)
    modulus2    dw 32762 ; LCG modulus (m)
    seed2       dw 12345 ; Seed value (initial value)

    multiplier_2 dw 16645 ; LCG multiplier (a)
    increment_2  dw 10139 ; LCG increment (c)
    modulus_2    dw 32768 ; LCG modulus (m)
    seed_2       dw 12345 ; Seed value (initial value)

    multiplier2_2 dw 17835 ; LCG multiplier (a)
    increment2_2  dw 12821 ; LCG increment (c)
    modulus2_2    dw 32762 ; LCG modulus (m)
    seed2_2       dw 12345 ; Seed value (initial value)


    ; ꧁Arrays to save position and the shapes of the parts꧂

    grid db 200 dup(0) ; declare 20x10 array for the left game grid
    grid2 db 200 dup(0) ; declare a 20x10 array for the right game grid

    part db 16 dup(?) ; curret shape of left player part
    ;part_2 db 0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0 ; curret shape of right player part
    part_2 db 16 dup(?) ; curret shape of right player part


    Temp_part db 16 dup(0) ;used for rotation ; Saves the shape of the last part before rotating it in case it doesn't fit

    preview db  16 dup(1) ;set preview grid for left player
    preview_2 db 16 dup(1) ;set preview grid for right player

    ;| CHANGE_PARTS |
    ;I
    part1 db 0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,64 dup() ;I ;Light blue; shaped like a capital I; four Minos in a straight line
    ;O
    part2 db 0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,64 dup() ;O ;Yellow; a square shape; four Minos in a 2×2 square
    ;T
    part3 db 0,0,0,0,0,0,0,0,1,1,1,0,0,1,0,0,64 dup() ;T ;Purple; shaped like a capital T; a row of three Minos with one added above the center.
    ;S
    part4 db 0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,0,64 dup() ;S ;Green; shaped like a capital S; two stacked horizontal diminos with the top one offset to the right.
    ;Z
    part5 db 0,0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,64 dup() ;Z ;Red; shaped like a capital Z; two stacked horizontal diminos with the top one offset to the left.
    ;J
    part6 db 0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,0,64 dup() ;J ;Blue; shaped like a capital J; a row of three Minos with one added above the left side
    ;L
    part7 db 0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,0,64 dup() ;L ;Orange; shaped like a capital L; a row of three Minos with one added above the right side.
    
    Plast db 16 dup(?) ; var to save the last part for SetPreview proc
    PartLast db 16 dup(?) ; save the last value for left part block to see if you can rotate
    PartLast2 db 16 dup(?) ; save the last value for right part block to see if you can rotate


    ; ꧁vars to print text and numbers꧂

    TEXT_PLAYER_ONE_POINTS_TENTHOUSANDS db '0', '$' ; number of ten thousands for left score
    TEXT_PLAYER_ONE_POINTS_THOUSANDS db '0', '$' ; number of thousands for left score
    TEXT_PLAYER_ONE_POINTS_HUNDREDS db '0', '$' ; number of hundreds for left score
    TEXT_PLAYER_ONE_POINTS_TENS db '0', '$' ; number of tens for left score
    TEXT_PLAYER_ONE_POINTS_ONES db '0', '$' ; number of ones for left score
    TEXT_SPEED db 'X','$' ; text speed for left player
    
    TEXT_PLAYER_ONE_POINTS_TENTHOUSANDS2 db '0', '$' ; number of ten thousands for right score
    TEXT_PLAYER_ONE_POINTS_THOUSANDS2 db '0', '$' ; number of thousands for right score
    TEXT_PLAYER_ONE_POINTS_HUNDREDS2 db '0', '$' ; number of hundreds for right score
    TEXT_PLAYER_ONE_POINTS_TENS2 db '0', '$' ; number of tens for right score
    TEXT_PLAYER_ONE_POINTS_ONES2 db '0', '$' ; number of ones for right score
    TEXT_SPEED2 db 'X','$' ; text speed for left player

    speed db 5 ; speed of left player | CHANGE_SPEED |
    speed2 db 5 ; speed of right player | CHANGE_SPEED |
    score dw 0 ; score of left player | CHANGE_SCORE |
    score2 dw 0 ; score of right player | CHANGE_SCORE |
    SpeedMSG  db 'Speed:','$' ; Speed text $-terminated message
    ScoreMSG  db 'Score:','$' ; Score text $-terminated message

    ; ꧁vars to present location of objects꧂

    PART_X dw 5 ; x position of part for the left player
    PART_Y dw 7 ; y position of part for the left player
    PART_X2 dw 5 ; x position of part for the right player
    PART_Y2 dw 7 ; y position of part for the right player
    GRID_X dw 70h ; x temp position to save the part position 
	GRID_Y dw 04h ; y temp position to save the part position
    SETX dw 00h ; x temp for setting a color to a pixel via SetBlock
    SETY dw 50h ; y temp for setting a color to a pixel via SetBlock
    index dw 0h ; temp var that saves the x index of the block
    indexC dw 0h ; temp var that saves the y index of the block
    PIndex dw ? ; temp var that saves the x index of the part
    PIndexC dw ? ; temp var that saves the y index of the part

    ; ꧁bool vars꧂

    StopGame db 0 ; 0=don't stop | 1= stop game of left player
    StopGame2 db 0 ; 0=don't stop | 1= stop game of right player
    IsFull db 1 ; 0= row is not full | 1= row is full
    BCollision db ? ; 0= There is no collision | 1= There is a collision
    BlockGrid db ? ;0= There is no color in the checked block | 1= There is color in the checked block

    ; ꧁time related vars꧂

    TIME_AUX db 0 ; var used when checking if left player time had changed
	TIME_AUX2 db 0 ; var used when checking if right player time had changed
    Seconds db 0 ; countes the seconds; every 50 seconds the speed is sped up
    DelayMove db 0 ; countes delay between moveing left part
    DelayMove2 db 0 ; countes delay between moveing right part
    Clock equ es:6Ch

    ; ꧁feture game vars꧂

    SQUARE_SIZE dw 08h ;size of the block (how many pixels the block have in width and height)
    WINDOW_HEIGHT DW 0C8h                ;the height of the window (200 pixels)
	WINDOW_BOUNDS dw 6					 ; var to check collisions early
    START_X dw 60 ; starting position of the left grid
    START_PRINT_X db 0 ; starting position of the left score and speed
    START_PRINT_PREVIEW_X dw 8 ; starting position of the left preview
    START_X2 dw 161 ; starting position of the right grid
    START_PRINT_X2 db 33 ; starting position of the right score and speed
    START_PRINT_PREVIEW_X2 dw 265 ; starting position of the right preview

    ; ꧁general vars꧂

    DRAW_COLOR db 1h ; current color of left player part
    DRAW_COLOR2 db 1h ; current color of left player part
    GridColor db ? ; temp value for color in grid
    PreviewColor db ? ; color of the left player preview
    PreviewColor2 db ? ; color of the right player preview
    PRINT_PART_COLOR db ? ; color of the right player printpart proc
    PRINT_PART_COLOR2 db ? ; color of the left player printpart proc

    counter db 0 ; temp var to count things
    IndexGame db ? ;presented the current player (right or left), the proc act diffrenet of indexgame=1/2 (1= left player | 2= right player)
    PartNumber db 1 ; current shape of left player part
    PartNumber2 db 1 ; current shape of left player part
    currentValue db ? ; current color that had checked
    AmountToDecrese dw 0h ; temp value to decrese amount of pixels in printing blocks
    MaxY dw 0 ; result of PmaxY proc; the max height of the current part
    MinY dw 0 ; result of PminY proc; the min height of the current part
	SetValueColor db 1h ; temp value used to select the color to set the value
    SetBlockColor db ? ; temp value used to select the color to set the blcok for left player
    SetBlockColor2 db ? ; temp value used to select the color to set the block for right player
    LastBlockColor db ? ; temp store value used in the RemoveRow proc to save the val of a color for left player
    LastBlockColor2 db ? ; temp store value used in the RemoveRow proc to save the val of a color for right player


    ; ꧁print BMP image vars꧂

    stor   	 	dw      0      ;our memory location storage
    imgHeight dw 200  ;Height of image that fits screen
    imgWidth dw 320   ;Width of image that fits screen
    adjustCX dw ?     ;Adjusts register CX
    filename db 20 dup (?) ;Generates the file's name 
    filehandle dw ?  ;Handles the file
    Header db 54 dup (0)  ;Read BMP file header, 54 bytes
    Palette db 256*4 dup (0)  ;Enable colors
    ScrLine db 320 dup (0)   ;Screen Line
    Errormsg db 'Error', 13, 10, '$'   ;In case of not having all the files, Error message pops
    printAdd dw ?   ;Enable to add new graphics

    BgImage db 'bg.bmp', 0   ;Openning image (bmp)
    StartImage db 'start.bmp', 0   ;Openning image (bmp)
    KeysImage db 'keys.bmp', 0   ;Openning image (bmp)
    overL db 'overL.bmp', 0   ;Openning image (bmp)
    overR db 'overR.bmp', 0   ;Openning image (bmp)
    overT db 'overT.bmp', 0   ;Openning image (bmp)



CODESEG

proc SwitchToGraphicsMode
    mov ax, 13h
    int 10h
    ret
endp SwitchToGraphicsMode

proc Exit
    mov ax, 4c00h
    int 21h

    ret
endp Exit

; Clears the screen
proc ClearScreen
    mov ah, 00h
    mov al, 13h ;set video mode
    int 10h ;execute
    mov ah,0Bh; set configuration
    mov bh, 00h ;set backgorund color
    mov bl, 00h ;choose black as background
    int 10h
    ret
endp ClearScreen

; Print left part
proc PrintPart
    mov [SetBlockColor],0
    mov [PIndex],0
    mov [PIndexC],0
    mov ax, [PART_X]
    mov [index], ax
    mov ax, [PART_Y]
    mov [indexC], ax
    mov bx,0
    PrintLoop:
        cmp [part+bx], 1
        jne SkipPrintPart
        mov al, [PRINT_PART_COLOR]
        ;mov al, [DRAW_COLOR2]
        mov [SetBlockColor], al
        call SetBlock
        SkipPrintPart:
        inc bx
        inc [index]
        inc [PIndex]
        cmp [PIndex],4
        jb PrintLoop
        inc [indexC]
        inc [PIndexC]
        sub [index],4
        sub [Pindex],4
        cmp [PindexC],4
        jb PrintLoop
    ret

endp PrintPart

; Print Right part
proc PrintPart2
    cmp [StopGame2],1
    jne ContinuePrintPart2
    ret
    ContinuePrintPart2:
    mov [SetBlockColor],0
    mov [PIndex],0
    mov [PIndexC],0
    mov ax, [PART_X2]
    mov [index], ax
    mov ax, [PART_Y2]
    mov [indexC], ax
    mov bx,0
    PrintLoop_2:
        cmp [part_2+bx], 1
        jne SkipPrintPart_2
        mov al, [PRINT_PART_COLOR2]
        mov [SetBlockColor], al
        call SetBlock
        SkipPrintPart_2:
        inc bx
        inc [index]
        inc [PIndex]
        cmp [PIndex],4
        jb PrintLoop_2
        inc [indexC]
        inc [PIndexC]
        sub [index],4
        sub [Pindex],4
        cmp [PindexC],4
        jb PrintLoop_2
    ret

endp PrintPart2

; Get value from left and right grid
proc GetValue
    mov ax, [indexC] ; column (y)
    mov dx, [index] ; row (x)
    mov bx, 10
    mul bx ;ax*bx=ax
    mov dx, [index]
    add ax, dx
    mov bx, ax
    cmp [IndexGame],1
    jne skipgame
    mov al, [grid+bx] ; get the value at the offset
    jmp skipgame_2
    skipgame:
    mov al, [grid2+bx] ; get the value at the offset
    skipgame_2:
    mov [currentValue],al ; store the result in a variable called currentValue
    ret
endp GetValue

; Get value from left and right preview grid
proc GetPreviewValue ;get value form preview array by row and column
    mov ax, [indexC] ; column (y)
    mov dx, [index] ; row (x)
    mov bx, 4
    mul bx ;ax*bx=ax
    mov dx, [index]
    add ax, dx
    mov bx, ax
    cmp [IndexGame],1
    jne skipgame19
    mov al, [preview+bx] ; get the value at the offset
    jmp skipgame19_2
    skipgame19:
    mov al, [preview_2+bx] ; get the value at the offset
    skipgame19_2:
    mov [currentValue],al ; store the result in a variable called currentValue
    ret
endp GetPreviewValue

; Set value to left and right grid array
proc SetValue
    push ax
    push bx
    push dx
    mov ax, [indexC] ; column (y)
    mov dx, [index] ; row (x)
    mov bx, 10
    mul bx ;ax*bx=ax
    mov dx, [index]
    add ax, dx
    mov bx, ax
	mov al, [SetValueColor]
	;mov[grid+bx],al

    cmp [IndexGame],1
    jne skipgame4
    mov [grid+bx], al ; get the value at the offset
    jmp skipgame4_2
    skipgame4:
    mov [grid2+bx], al
    skipgame4_2:

    pop dx
    pop bx
    pop ax
	
    ret

endp SetValue

; Color the pixels of the right and left grid arrays
proc SetBlock
    mov [AmountToDecrese],0 ; initialize the variable to store the amount to decrease by to 0


    mov ax, [indexC] ; get the current column index (y)
    mov dx, [index] ; get the current row index (x)

    push bx
    mov bx, [indexC] ; get the current column index (y)
    mov ax, [SQUARE_SIZE]
    mul bx ;bx*ax=ax ((colum-1)*SQUARE_SIZE) multiply the current column index by the ball size
    mov [AmountToDecrese],ax ; store the result in a variable to decrease the grid y position later
    pop bx

    ; calculate the x coordinate for the grid pixel based on the current row index
    mov ax, [index]
    mov cx, [SQUARE_SIZE]
    add cx, 1
    mul cx ; save the result at ax
    mov cx, ax

    cmp [IndexGame],1
    jne skipgame3
    add cx, [START_X] ; adjust for the starting x coordinate of the grid
    jmp skipgame3_2
    skipgame3:
    add cx, [START_X2]
    skipgame3_2:
    mov [SetX],cx

    mov dx, [WINDOW_HEIGHT] ; calculate the y coordinate for the grid pixel
    sub dx, [WINDOW_BOUNDS]
    sub dx, 6h
    sub dx, [AmountToDecrese] ; decrease the y coordinate based on the amount calculated earlier
    mov [SetY],dx

    DRAW_SET_HORIZONTAL:
        mov ah, 0Ch ; set configuration to write a pixel
        mov al, [SetBlockColor] ; set the pixel color
        ;mov al, 5
        mov bh, 00h ; set page number to 0
        int 10h ; call interrupt to draw the pixel

        inc cx ; move to the next pixel in the row
        mov ax, cx
        sub ax, [SetX]
        cmp ax, [SQUARE_SIZE]
        jng DRAW_SET_HORIZONTAL ; continue drawing the row until the end of the ball size is reached

        mov cx, [SetX] ; reset the x coordinate to the start of the row
        inc dx ; move to the next row
        mov ax, dx
        sub ax, [SetY]
        ;add ax,1
        cmp ax, [SQUARE_SIZE]
        jng DRAW_SET_HORIZONTAL ; continue drawing the rows until the end of the ball size is reached

    ret
endp SetBlock

; Calculate the score of left and right players
proc CalculateScore
    ;check how many rows are full
    mov ax,0
    mov cx, 0
    mov [index],0
    mov [indexC],0
    mov [IsFull], 0
    mov bx,0
    RowsLoop:
    ColumnLoop:
    call GetValue
    cmp [currentValue],0
    je IncreaseRow
    inc [index]
    cmp [index],10
    jb ColumnLoop
    inc [IsFull]

    IncreaseRow:
    inc [indexC]
    mov [index],0
    cmp [indexC],20
    jb RowsLoop
    
    ; | CHANGE_SCORE |
    xor cx, cx
    mov al, [IsFull]
    ;amount of rows is saved in ax
    cmp al, 1
    jne CalculateContinue1_2
    mov cx, 100
    CalculateContinue1_2:
    cmp al, 2
    jne CalculateContinue2_2
    mov cx, 300
    CalculateContinue2_2:
    cmp al, 3
    jne CalculateContinue3_2
    mov cx, 500
    CalculateContinue3_2:
    cmp al, 4
    jne CalculateContinue4_2
    mov cx, 800
    CalculateContinue4_2:
        ;update score
    cmp [IndexGame],1
    jne CalculateScore2
    add [score],cx
    ret
    CalculateScore2:
    add [score2],cx
    ret
endp CalculateScore

; Print left player score
proc PrintScore
    call CalculateScore

    call SetScore
    
    xor cx, cx
    mov ah,002h
    mov bh,00h
    mov dh,03                           ;set row y
	mov dl,[START_PRINT_X]   	    	;set column x
	int 10h

    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[ScoreMSG]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

	mov ah,02h                       ;set cursor position
	mov bh,00h                       ;set page number
	mov dh,04                        ;set row y
	mov dl, [START_PRINT_X]			 ;set column x
	int 10h							 
		
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_PLAYER_ONE_POINTS_TENTHOUSANDS]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
    ;mov cx, 1000h
    mov al, 20h ;
    mov bl, 23  ; This is Blue & White.
	int 21h                          ;print the string 

    mov dl, [START_PRINT_X]
    add dl,1						 ;set column x
	int 10h	
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_PLAYER_ONE_POINTS_THOUSANDS]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

    mov dl, [START_PRINT_X]
    add dl,2						 ;set column x
	int 10h	
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_PLAYER_ONE_POINTS_HUNDREDS]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 
        
    mov dl, [START_PRINT_X]
    add dl,3						 ;set column x
	int 10h	
	mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_PLAYER_ONE_POINTS_TENS]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

    mov dl, [START_PRINT_X]
    add dl,4						 ;set column x
	int 10h	
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_PLAYER_ONE_POINTS_ONES]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

    ret
endp PrintScore

; Print right player score
proc PrintScore2
    mov [IndexGame],2
    call CalculateScore

    call SetScore2
    
    xor cx, cx
    mov ah,002h
    mov bh,00h
    mov dh,03                       ;set row y
	mov dl,[START_PRINT_X2]   	    	;set column x
	int 10h							 
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[ScoreMSG]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

	mov ah,02h                       ;set cursor position
	mov bh,00h                       ;set page number
	mov dh,04                        ;set row y
	mov dl, [START_PRINT_X2]			 ;set column x
	int 10h							 
		
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_PLAYER_ONE_POINTS_TENTHOUSANDS2]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

    mov dl, [START_PRINT_X2]
    add dl,1						 ;set column x
	int 10h	
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_PLAYER_ONE_POINTS_THOUSANDS2]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

    mov dl, [START_PRINT_X2]
    add dl,2						 ;set column x
	int 10h	
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_PLAYER_ONE_POINTS_HUNDREDS2]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 
        
    mov dl, [START_PRINT_X2]
    add dl,3						 ;set column x
	int 10h	
	mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_PLAYER_ONE_POINTS_TENS2]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

    mov dl, [START_PRINT_X2]
    add dl,4						 ;set column x
	int 10h	
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_PLAYER_ONE_POINTS_ONES2]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

    ret
endp PrintScore2

; Convert the left player score to be ready to get printed
proc SetScore
    mov ax, [score]
    cmp ax, 10000
    jb SKIPTENTHOUSANDS
    mov bx, 10000
    xor dx, dx
    div bx ;ax/bx= AX(quotient), DX(remainder)
    add al, 30h
    mov [TEXT_PLAYER_ONE_POINTS_TENTHOUSANDS],al
    mov ax, dx
    jmp DSKIPTENTHOUSANDS
    SKIPTENTHOUSANDS:
    mov [TEXT_PLAYER_ONE_POINTS_TENTHOUSANDS],30h ;0
    DSKIPTENTHOUSANDS:
    cmp ax, 1000
    jb SKIPTHOUSANDS
    mov bx, 1000
    xor dx, dx
    div bx ;ax/bx= AX(quotient), DX(remainder)
    add al, 30h
    mov [TEXT_PLAYER_ONE_POINTS_THOUSANDS],al
    mov ax, dx
    jmp DSKIPTHOUSANDS
    SKIPTHOUSANDS:
    mov [TEXT_PLAYER_ONE_POINTS_THOUSANDS],30h ;0
    DSKIPTHOUSANDS:

    cmp ax, 100
    jb SKIPHUNDREDS
    mov bx, 100
    xor dx, dx
    div bx ;ax/bx= AX(quotient), DX(remainder)
    add al, 30h
    mov [TEXT_PLAYER_ONE_POINTS_HUNDREDS],al
    mov ax, dx
    jmp DSKIPHUNDREDS
    SKIPHUNDREDS:
    mov [TEXT_PLAYER_ONE_POINTS_HUNDREDS],30h ;0
    DSKIPHUNDREDS:
    cmp ax, 10
    jb SKIPTENS
    mov bl, 10
    xor dx, dx
    div bl ;ax/bl= AL(quotient), AH(remainder)
    add al, 30h
    mov [TEXT_PLAYER_ONE_POINTS_TENS],al
    mov al, ah
    xor ah, ah
    jmp SKIPTENS
    DSKIPTENS:
    mov [TEXT_PLAYER_ONE_POINTS_TENS],30h ;0
    SKIPTENS:
    add al, 30h
    mov [TEXT_PLAYER_ONE_POINTS_ONES],al

    ret
endp SetScore

; Convert the right player score to be ready to get printed
proc SetScore2
    mov ax, [score2]
    cmp ax, 10000
    jb SKIPTENTHOUSANDS2
    mov bx, 10000
    xor dx, dx
    div bx ;ax/bx= AX(quotient), DX(remainder)
    add al, 30h
    mov [TEXT_PLAYER_ONE_POINTS_TENTHOUSANDS2],al
    mov ax, dx
    jmp DSKIPTENTHOUSANDS2
    SKIPTENTHOUSANDS2:
    mov [TEXT_PLAYER_ONE_POINTS_TENTHOUSANDS2],30h ;0
    DSKIPTENTHOUSANDS2:
    cmp ax, 1000
    jb SKIPTHOUSANDS2
    mov bx, 1000
    xor dx, dx
    div bx ;ax/bx= AX(quotient), DX(remainder)
    add al, 30h
    mov [TEXT_PLAYER_ONE_POINTS_THOUSANDS2],al
    mov ax, dx
    jmp DSKIPTHOUSANDS2
    SKIPTHOUSANDS2:
    mov [TEXT_PLAYER_ONE_POINTS_THOUSANDS2],30h ;0
    DSKIPTHOUSANDS2:

    cmp ax, 100
    jb SKIPHUNDREDS2
    mov bx, 100
    xor dx, dx
    div bx ;ax/bx= AX(quotient), DX(remainder)
    add al, 30h
    mov [TEXT_PLAYER_ONE_POINTS_HUNDREDS2],al
    mov ax, dx
    jmp DSKIPHUNDREDS2
    SKIPHUNDREDS2:
    mov [TEXT_PLAYER_ONE_POINTS_HUNDREDS2],30h ;0
    DSKIPHUNDREDS2:
    cmp ax, 10
    jb SKIPTENS2
    mov bl, 10
    xor dx, dx
    div bl ;ax/bl= AL(quotient), AH(remainder)
    add al, 30h
    mov [TEXT_PLAYER_ONE_POINTS_TENS2],al
    mov al, ah
    xor ah, ah
    jmp SKIPTENS2
    DSKIPTENS2:
    mov [TEXT_PLAYER_ONE_POINTS_TENS2],30h ;0
    SKIPTENS2:
    add al, 30h
    mov [TEXT_PLAYER_ONE_POINTS_ONES2],al
    ret
endp SetScore2

; Print left player speed to screen
proc PrintSpeed
    mov al, 6 ;Speed+1 | CHANGE_SPEED |
    sub al, [SPEED]

    add al, 30h
    mov [TEXT_SPEED],al
    
    xor cx, cx
    mov ah,002h
    mov bh,00h
    mov dh,01                       ;set row y
    mov dl, [START_PRINT_X]         ;set column x
	int 10h							 

    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[SpeedMSG]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

	mov ah,02h                       ;set cursor position
	mov bh,00h                       ;set page number
	mov dh,01                       ;set row y
	mov dl, [START_PRINT_X]
    add dl,6						 ;set column x
	int 10h							 
	
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_SPEED]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 
    ret
endp PrintSpeed

; Print right player speed to screen
proc PrintSpeed2
    mov al, 6
    sub al, [SPEED2]

    add al, 30h
    mov [TEXT_SPEED2],al
    
    xor cx, cx
    mov ah,002h
    mov bh,00h
    mov dh,01                       ;set row y
    mov dl, [START_PRINT_X2]         ;set column x
	int 10h							 

    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[SpeedMSG]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 

	mov ah,02h                       ;set cursor position
	mov bh,00h                       ;set page number
	mov dh,01                       ;set row y
	mov dl, [START_PRINT_X2]
    add dl,6						 ;set column x
	int 10h							 
	
    mov ah,09h                       ;WRITE STRING TO STANDARD OUTPUT
	lea dx,[TEXT_SPEED2]    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
	int 21h                          ;print the string 
    ret
endp PrintSpeed2

; delete row stored in [indexC]
proc DeleteRow
    push ax
    push cx
    push bx
    push dx
    mov [index],0
    ;mov [indexC],0
    mov ax, [indexC] ; column (y)
    mov bx, 10
    mul bx ;ax*bx=ax
    mov bx, ax
	mov al, 00h ;black
    mov cx, bx
    add cx, 10
    DeleteLoop:
        cmp [IndexGame],1
        jne skipgame14
        mov [grid+bx],00h
        mov [SetBlockColor], 00h
        call SetBlock
        jmp skipgame14_2
        skipgame14:
        mov [grid2+bx],00h
        mov [SetBlockColor], 00h
        call SetBlock
        skipgame14_2:
        inc bx
        inc [index]
        cmp [index],10
        jb DeleteLoop

    pop dx
    pop bx
    pop cx
    pop ax

    ret
endp DeleteRow

; Check if rows are full and delete and add score if needed
proc RemoveRows
    mov [counter], 0
    StartAgainRemoveRows: ;go over all the rows so if there is more than 1 row full (max 4)
    mov [indexC],0
    RemoveLoopStart:
    mov [index],0
    mov [IsFull], 1
    RemoveLoop:
        call GetValue
        cmp [currentValue], 00h
        jne RemoveSkip
        mov [IsFull], 0
        RemoveSkip:
        inc [index]
        cmp [index],10
        jb RemoveLoop
    cmp [IsFull], 1
    je DRemoveDo ;small jump
    jmp RemoveDo
    DRemoveDo:

    ;if it was with color and now it doesn't have color, draw black.
    mov [index],0
    MoveRowDown:
        call GetValue
        mov al, [currentValue]
        mov [LastBlockColor],al ;get last color
        inc [indexC]
        call GetValue
        cmp [LastBlockColor],0
        je SkipRemoveBlock
        ;lastblock not black

        cmp [currentValue],0
        jne SkipRemoveBlock
        mov [SetBlockColor],0
        mov [SetValueColor],0
        call SetBlock
        call SetValue
        mov bl, [SetValueColor]
        
        SkipRemoveBlock:
        dec [indexC]
        mov bl, [currentValue]
        
        mov [SetBlockColor], bl
        call SetBlock
        mov [SetValueColor], bl
        call SetValue
        inc [index]
        cmp [index],10
        jb MoveRowDown

    inc [indexC]
    cmp [indexC],19
    mov [index],0
    jb MoveRowDown
    mov [indexC],19
    call DeleteRow
    inc [counter]
    cmp [counter], 5
    jnb ENDREMOVEROWS
    jmp StartAgainRemoveRows
    ENDREMOVEROWS:
    ret
    RemoveDo:
        inc [indexC]
        cmp [indexC],19
        jb SRemoveLoopStart
        ret
        SRemoveLoopStart:
            jmp RemoveLoopStart

    ret 
endp RemoveRows

; Print the pixels from the grid for both players
proc DRAW_GRID
    mov [indexC], 0 ; initialize the column index 
    
    StartDrawGrid:
        mov [index], 0 ; initialize the row index to 0
        mov [AmountToDecrese],0 ; initialize the variable to store the amount to decrease by to 0

        DRAW_FROM_ARRAY:
            push ax
            push cx
            push dx

            mov ax, [indexC] ; get the current column index (y)
            mov dx, [index] ; get the current row index (x)
            call GetValue ; call a function to get the value from an array based on the indices

            pop dx
            pop cx
            pop ax

            push bx
            mov bx, [indexC] ; get the current column index (y)
            mov ax, [SQUARE_SIZE]
            mul bx ;bx*ax=ax ((colum-1)*SQUARE_SIZE) multiply the current column index by the ball size
            mov [AmountToDecrese],ax ; store the result in a variable to decrease the grid y position later
            pop bx

            mov bl, [currentValue] ; get the current value from the array
            mov [GridColor], bl ; store it in a variable for the grid color

            cmp bl, 0 ; if the current value is 0, skip drawing this pixel
            je GSKIP

            ; calculate the x coordinate for the grid pixel based on the current row index
            mov ax, [index]
            mov cx, [SQUARE_SIZE]
            add cx, 1
            mul cx ; save the result at ax
            mov cx, ax
            ;ofset the x for left or right side of game

            cmp [IndexGame],1
            jne skipgame2
            add cx, [START_X] ; adjust for the starting x coordinate of the grid
            jmp skipgame2_2
            skipgame2:
            add cx, [START_X2]
            skipgame2_2:
            ;add cx, [START_X]

            mov [GRID_X], cx 

            mov dx, [WINDOW_HEIGHT] ; calculate the y coordinate for the grid pixel
            sub dx, [WINDOW_BOUNDS]
            sub dx, 6h
            sub dx, [AmountToDecrese] ; decrease the y coordinate based on the amount calculated earlier
            ;inc dx
            mov [GRID_Y], dx

            ;sub [GRID_Y],1 ; decrease the y coordinate by 1

            DRAW_GRID_HORIZONTAL:
                mov ah, 0Ch ; set configuration to write a pixel
                mov al, [GridColor] ; set the pixel color
                mov bh, 00h ; set page number to 0
                int 10h ; call interrupt to draw the pixel

                inc cx ; move to the next pixel in the row
                mov ax, cx
                sub ax, [GRID_X]
                cmp ax, [SQUARE_SIZE]
                jng DRAW_GRID_HORIZONTAL ; continue drawing the row until the end of the ball size is reached

                mov cx, [GRID_X] ; reset the x coordinate to the start of the row
                inc dx ; move to the next row
                mov ax, dx
                sub ax, [GRID_Y]
                cmp ax, [SQUARE_SIZE]
                jng DRAW_GRID_HORIZONTAL ; continue drawing the rows until the end of the ball size is reached

        GSKIP:
            inc [index] ; increment the row index
            cmp [index], 10
            jae SmallSkip ; if the end of the row is reached, jump to SmallSkip
            jmp DRAW_FROM_ARRAY ; otherwise, continue drawing pixels for the current row
        SmallSkip:
            inc [indexC] ; increment the column index
            cmp [indexC], 20
            jb JStartDrawGrid ; if the end of the column is not reached, jump to JStartDrawGrid to draw the next column
            ret
        JStartDrawGrid:
            jmp StartDrawGrid
    ret
endp DRAW_GRID

; Set the preview for left player
proc SetPreview
    mov [PreviewColor], 0
    call DRAW_PREVIEW
    xor bx, bx ;bx=0
    mov bl, [PartNumber]
    ;push bx
    mov [Plast],bl
    mov ax, [seed]
    push ax
    call RandomPart
    pop ax
    mov [seed],ax
    mov ax, [seed2]
    mov bl, [DRAW_COLOR]
    push bx
    push ax
    call RandomColor
    mov al, [DRAW_COLOR]
    mov [PreviewColor], al
    pop ax
    pop bx
    mov [DRAW_COLOR], bl 
    mov [seed2],ax

    mov bx,0
    SetPreviewLoop:
    ;check what part
    xor ax, ax
    cmp [PartNumber],1
    jne PreviewSkip1
    mov al, [part1+bx]
    PreviewSkip1:
    cmp [PartNumber],2
    jne PreviewSkip2
    mov al, [part2+bx]
    PreviewSkip2:
    cmp [PartNumber],3
    jne PreviewSkip3
    mov al, [part3+bx]
    PreviewSkip3:
    cmp [PartNumber],4
    jne PreviewSkip4
    mov al, [part4+bx]
    PreviewSkip4:
    cmp [PartNumber],5
    jne PreviewSkip5
    mov al, [part5+bx]
    PreviewSkip5:
    cmp [PartNumber],6
    jne PreviewSkip6
    mov al, [part6+bx]
    PreviewSkip6:
    cmp [PartNumber],7
    jne PreviewSkip7
    mov al, [part7+bx]
    PreviewSkip7:
    cmp [PartNumber],8
    jne PreviewSkip8
    PreviewSkip8:
    mov [preview+bx],al
    inc bx
    cmp bx,16
    jb SetPreviewLoop
    ;mov [PreviewColor], 255
    call DRAW_PREVIEW
    ;pop bx
    mov bl, [Plast]
    mov [PartNumber],bl
    ret
endp SetPreview

; Set the preview for right player
proc SetPreview2
    mov [IndexGame],2
    mov [PreviewColor2], 0
    call DRAW_PREVIEW
    xor bx, bx ;bx=0
    mov bl, [PartNumber2]
    ;push bx
    mov [Plast],bl
    mov ax, [seed_2]
    push ax
    call RandomPart2
    pop ax
    mov [seed_2],ax
    mov ax, [seed2_2]
    mov bl, [DRAW_COLOR2]
    push bx
    push ax
    call RandomColor2
    mov al, [DRAW_COLOR2]
    mov [PreviewColor2], al
    pop ax
    pop bx
    mov [DRAW_COLOR2], bl 
    mov [seed2_2],ax

    mov bx,0
    SetPreviewLoop2:
    ;check what part
    xor ax, ax
    cmp [PartNumber2],1
    jne PPreviewSkip1
    mov al, [part1+bx]
    PPreviewSkip1:
    cmp [PartNumber2],2
    jne PPreviewSkip2
    mov al, [part2+bx]
    PPreviewSkip2:
    cmp [PartNumber2],3
    jne PPreviewSkip3
    mov al, [part3+bx]
    PPreviewSkip3:
    cmp [PartNumber2],4
    jne PPreviewSkip4
    mov al, [part4+bx]
    PPreviewSkip4:
    cmp [PartNumber2],5
    jne PPreviewSkip5
    mov al, [part5+bx]
    PPreviewSkip5:
    cmp [PartNumber2],6
    jne PPreviewSkip6
    mov al, [part6+bx]
    PPreviewSkip6:
    cmp [PartNumber2],7
    jne PPreviewSkip7
    mov al, [part7+bx]
    PPreviewSkip7:
    cmp [PartNumber2],8
    jne PPreviewSkip8
    PPreviewSkip8:
    mov [preview_2+bx],al
    inc bx
    cmp bx,16
    jb SetPreviewLoop2
    ;mov [PreviewColor], 255
    call DRAW_PREVIEW
    ;pop bx
    mov bl, [Plast]
    mov [PartNumber2],bl
    ret
endp SetPreview2

; Print the pixels from the preview for both players
proc DRAW_PREVIEW
    mov [indexC], 0 ; initialize the column index 
    
    StartDrawPreview:
        mov [index], 0 ; initialize the row index to 0
        mov [AmountToDecrese],0 ; initialize the variable to store the amount to decrease by to 0

        DRAW_FROM_Preview:
            call GetPreviewValue ; cthi all a function to get the value from an array based on the indices

            mov bl, [currentValue] ; get the current value from the array
            
            push bx
            ; calculate the y coordinate for the preview pixel based on the current row index
            mov bx, [indexC] ; get the current column index (y)
            mov ax, [SQUARE_SIZE]
            mul bx ;bx*ax=ax ((colum-1)*SQUARE_SIZE) multiply the current column index by the ball size
            mov [AmountToDecrese],ax ; store the result in a variable to decrease the grid y position later
            pop bx

            cmp bl, 0 ; if the current value is 0, skip drawing this pixel
            je PreviewSKIP

            ; calculate the x coordinate for the preview pixel based on the current row index
            mov ax, [index]
            mov cx, [SQUARE_SIZE]
            add cx, 1
            mul cx ; save the result at ax
            mov cx, ax
            cmp [IndexGame],1
            jne skipgame20
            add cx, [START_PRINT_PREVIEW_X] ; adjust for the starting x coordinate of the preview
            jmp skipgame20_2
            skipgame20:
            add cx, [START_PRINT_PREVIEW_X2] ; adjust for the starting x coordinate of the preview
            skipgame20_2:
            mov [GRID_X], cx 
            
            

            mov dx, [WINDOW_HEIGHT] ; calculate the y coordinate for the preview pixel
            sub dx, [WINDOW_BOUNDS]
            sub dx, [AmountToDecrese]
            sub dx, 120 ; decrease the y coordinate based on the amount calculated earlier
            ;inc dx
            mov [GRID_Y], dx


            DRAW_Preview_HORIZONTAL:
                mov ah, 0Ch ; set configuration to write a pixel
                cmp [IndexGame],1
                jne skipgame21
                mov al, [PreviewColor] ; set the pixel color
                jmp skipgame21_2
                skipgame21:
                mov al, [PreviewColor2] ; set the pixel color
                skipgame21_2:
                mov bh, 00h ; set page number to 0
                int 10h ; call interrupt to draw the pixel

                inc cx ; move to the next pixel in the row
                mov ax, cx
                sub ax, [GRID_X]
                cmp ax, [SQUARE_SIZE]
                jng DRAW_Preview_HORIZONTAL ; continue drawing the row until the end of the ball size is reached

                mov cx, [GRID_X] ; reset the x coordinate to the start of the row
                inc dx ; move to the next row
                mov ax, dx
                sub ax, [GRID_Y]
                cmp ax, [SQUARE_SIZE]
                jng DRAW_Preview_HORIZONTAL ; continue drawing the rows until the end of the ball size is reached

        PreviewSKIP:
            inc [index] ; increment the row index
            cmp [index], 4
            jae PreviewSmallSkip ; if the end of the row is reached, jump to SmallSkip
            jmp DRAW_FROM_Preview ; otherwise, continue drawing pixels for the current row
        PreviewSmallSkip:
            inc [indexC] ; increment the column index
            cmp [indexC], 4
            jb JStartDrawPreview ; if the end of the column is not reached, jump to JStartDrawPreview to draw the next column
            ret
        JStartDrawPreview:
            jmp StartDrawPreview
    ret
endp DRAW_PREVIEW

; Creates a random seed every game
proc RandomSeed
    push ax
    push es
    push cx
    push bx
    mov ax, 40h
    mov es, ax
    mov cx, 10
    mov bx, 0
    mov ax, [Clock] ; read timer counter
    mov ah, [byte cs:bx] ; read one byte from memory
    xor al, ah ; xor memory and counter
    and al, 7 ; leave result between 0-7
    xor ah, ah
    add [seed],ax
    add [seed_2],ax
    add [seed2],ax
    add [seed2_2],ax
    inc bx
    pop bx
    pop cx
    pop es
    pop ax
    ret
endp RandomSeed

; Calculates the left player color
proc RandomColor
    ;result between 0-7
    StartRandomColorAgain:
    ; Generate random number using LCG
    ;new_seed = (seed * multiplier + increment) % modulus
    mov ax, [seed2] ; Load seed into ax register
    mov bx, [multiplier2]
    mul bx ; Multiply seed by multiplier, saves at DX:AX (Ax is the least significant 16 bits) | Range: 0-65535
    add ax, [increment2] ; Add increment to the result | Range: 0-65535
    and ax, 32767 ; Apply modulus by masking the 16th bit (0x7FFF) reduce the result to halfe | Range: 0-32767
    mov [seed2], ax ; Store the new seed value

    ; Scale to the desired range (1-7)
    mov cx, 7 
    mul cx ; multiplies the value in the ax (the seed) by cx | Range: 0-65636 (AX) Doesn't have to be 7
    shr ax, 13          ; Shift Right, Divide by 2^13 since the range is 2^16 | Range 0-7

    ;add ax, 1           ; Shift range from 0-6 to 1-7
    ;check if it is really in range
    cmp al, 7
    jg StartRandomColorAgain
    cmp al,1
    jb StartRandomColorAgain
    mov [DRAW_COLOR], al
    ret

endp RandomColor

; Calculates the right player color
proc RandomColor2
    ;result between 0-7
    StartRandomColorAgain2:
    ; Generate random number using LCG
    ;new_seed = (seed * multiplier + increment) % modulus
    mov ax, [seed2_2] ; Load seed into ax register
    mov bx, [multiplier2_2]
    mul bx ; Multiply seed by multiplier, saves at DX:AX (Ax is the least significant 16 bits) | Range: 0-65535
    add ax, [increment2_2] ; Add increment to the result | Range: 0-65535
    and ax, 32767 ; Apply modulus by masking the 16th bit (0x7FFF) reduce the result to halfe | Range: 0-32767
    mov [seed2_2], ax ; Store the new seed value

    ; Scale to the desired range (1-7)
    mov cx, 7 
    mul cx ; multiplies the value in the ax (the seed) by cx | Range: 0-65636 (AX) Doesn't have to be 7
    shr ax, 13          ; Shift Right, Divide by 2^13 since the range is 2^16 | Range 0-7

    ;add ax, 1           ; Shift range from 0-6 to 1-7
    ;check if it is really in range
    cmp al, 7
    jg StartRandomColorAgain2
    cmp al,1
    jb StartRandomColorAgain2
    mov [DRAW_COLOR2], al
    ret

endp RandomColor2

; Calculates the left player shape
proc RandomPart
    StartRandomAgain:
    ; Generate random number using LCG
    ;new_seed = (seed * multiplier + increment) % modulus
    mov ax, [seed] ; Load seed into ax register
    mov bx, [multiplier]
    mul bx ; Multiply seed by multiplier, saves at DX:AX (Ax is the least significant 16 bits) | Range: 0-65535
    add ax, [increment] ; Add increment to the result | Range: 0-65535
    and ax, 32767 ; Apply modulus by masking the 16th bit (0x7FFF) reduce the result to halfe | Range: 0-32767
    mov [seed], ax ; Store the new seed value

    ;make the results more random
    mov cx, 7 
    mul cx ; multiplies the value in the ax (the seed) by cx | Range: 0-65636 (AX) Doesn't have to be 7
    
    ; Scale to the desired range (1-7)
    shr ax, 13          ; Shift Right, Divide by 2^13 since the range is 2^16 | Range 0-7

    ;check if it is really in range
    cmp al, 7
    jg StartRandomAgain
    cmp al,1
    jb StartRandomAgain
    mov [PartNumber], al
    ret

endp RandomPart

; Calculates the right player shape
proc RandomPart2
    StartRandomAgain2:
    ; Generate random number using LCG
    ;new_seed = (seed * multiplier + increment) % modulus
    mov ax, [seed_2] ; Load seed into ax register
    mov bx, [multiplier_2]
    mul bx ; Multiply seed by multiplier, saves at DX:AX (Ax is the least significant 16 bits) | Range: 0-65535
    add ax, [increment_2] ; Add increment to the result | Range: 0-65535
    and ax, 32767 ; Apply modulus by masking the 16th bit (0x7FFF) reduce the result to halfe | Range: 0-32767
    mov [seed_2], ax ; Store the new seed value

    ; Scale to the desired range (1-7)
    mov cx, 7 
    mul cx ; multiplies the value in the ax (the seed) by cx | Range: 0-65636 (AX) Doesn't have to be 7
    shr ax, 13          ; Shift Right, Divide by 2^13 since the range is 2^16 | Range 0-7

    ;add ax, 1           ; Shift range from 0-6 to 1-7
    ;check if it is really in range
    cmp al, 7
    jg StartRandomAgain2
    cmp al, 1
    jb StartRandomAgain2
    mov [PartNumber2], al
    ret
endp RandomPart2


;12 13 14 15      0  4  8  12
;8  9  10 11 ---> 1  5  9  13
;4  5  6  7  ---> 2  6  10 14
;0  1  2  3       3  7  11 15

; Rotate the left or Right Part 
proc RotatePart
    call SaveLastPart
    ;save the colors to stop flikering
    mov al, [PRINT_PART_COLOR]
    mov ah, [PRINT_PART_COLOR2]
    push ax

    ;print the last position in black
    cmp [IndexGame],1
    jne skipgame16
    mov [PRINT_PART_COLOR],0
    call PrintPart
    jmp skipgame16_2
    skipgame16:
    mov [PRINT_PART_COLOR2],0
    call PrintPart2
    skipgame16_2:
	
    ; Save the original array 
    mov bx,0
    RotateLoop:
    cmp [IndexGame],1
    jne skipgame7
    mov al, [part+bx]
    jmp skipgame7_2
    skipgame7:
    mov al, [part_2+bx]
    skipgame7_2:
    mov [Temp_part+bx], al
    inc bx
    cmp bx, 16
    jb RotateLoop

    mov bx, 0
    mov [counter],0
    mov si, 3
    RotateLoop1:
    mov cx, 4 ;run the loop 4 times
    RotateLoop2:
    mov al, [Temp_part+si]

    cmp [IndexGame],1
    jne skipgame17
    mov [part+bx],al
    jmp skipgame17_2
    skipgame17:
    mov [part_2+bx],al
    skipgame17_2:

    add si, 4
    inc bx
    loop RotateLoop2


    inc [counter]
    sub si, 17 ;13+4
    cmp [counter], 4
    jb RotateLoop1
    call CheckCollisionAndFix
    ;move to top left

    call SaveLastPart
    call MovePartUp
    call CheckCollisionAndFix
    
    call SaveLastPart
    call MovePartUp
    call CheckCollisionAndFix

    call SaveLastPart
    call MovePartLeft
    call CheckCollisionAndFix

    call SaveLastPart
    call MovePartLeft
    call CheckCollisionAndFix
    
    cmp [IndexGame],1
    jne skipgame18
    mov al, [DRAW_COLOR]
    mov [PRINT_PART_COLOR],al
    call PrintPart
    jmp skipgame18_2
    skipgame18:
    mov al, [DRAW_COLOR2]
    mov [PRINT_PART_COLOR2],al
    call PrintPart2
    skipgame18_2:

    pop ax
    mov [PRINT_PART_COLOR],al
    mov [PRINT_PART_COLOR2],ah
    ret
endp RotatePart


;moves the part a block above if the top line is empty
proc MovePartUp
    cmp [IndexGame],1
    jne MovePartUp2

    mov bx, 15 ;top right index of array
    MovePartUpLoop:
    cmp [part+bx], 0 ;check if there is a block in the top row
    jne StopMovePartUp ;if there is a block in the top row don't move
    dec bx 
    cmp bx, 12 ;check all the top row
    jae MovePartUpLoop

    ;empty line
    mov bx, 15

    ;goes on every place and moves the object 4 items forward
    MoveRowUp:
    sub bx,4 ;get the block in the below row
    mov al, [part+bx]
    add bx,4
    mov [part+bx],al ;move it to the row above

    dec bx
    cmp bx,4
    jae MoveRowUp
    ;set the bottom row to 0
    mov [part+0],0
    mov [part+1],0
    mov [part+2],0
    mov [part+3],0
    
    ;line not empty
    StopMovePartUp:

    ret
    ;game
    MovePartUp2:
    mov bx, 15 ;top right index of array
    MovePartUpLoop2:
    cmp [part_2+bx], 0 ;check if there is a block in the top row
    jne StopMovePartUp2 ;if there is a block in the top row don't move
    dec bx 
    cmp bx, 12 ;check all the top row
    jae MovePartUpLoop2

    ;empty line
    mov bx, 15

    ;goes on every place and moves the object 4 items forward
    MoveRowUp2:
    sub bx,4 ;get the block in the below row
    mov al, [part_2+bx]
    add bx,4
    mov [part_2+bx],al ;move it to the row above

    dec bx
    cmp bx,4
    jae MoveRowUp2
    ;set the bottom row to 0
    mov [part_2+0],0
    mov [part_2+1],0
    mov [part_2+2],0
    mov [part+2+3],0
    
    ;line not empty
    StopMovePartUp2:
    
    ret 
endp MovePartup


;moves the part a block left if the left column is empty
proc MovePartLeft
    cmp [IndexGame],1
    jne MovePartLeft2

    mov bx, 16 ;top left index of array, starts from 16 and not 12 so it can't be under 0
    MovePartLeftLoop:
    sub bx, 4
    cmp [part+bx], 0
    jne StopMovePartLeft
    cmp bx, 0 ;check all the left column
    ja MovePartLeftLoop

    ;empty line
    mov bx, 0
    mov dx, 0 ;counter
    MoveRowLeft:
    MoveRowLeft2:
    inc bx
    mov al, [part+bx]
    dec bx
    mov [part+bx],al
    add bx,4
    cmp bx,15
    jb MoveRowLeft2
    inc dx
    mov bx, dx
    cmp dx, 3
    jb MoveRowLeft
    ;set the left column to 0
    mov [part+15],0
    mov [part+11],0
    mov [part+7],0
    mov [part+3],0

    ;line not empty
    StopMovePartLeft:
    ret 

    MovePartLeft2:
    mov bx, 16 ;top left index of array, starts from 16 and not 12 so it can't be under 0
    MovePartLeftLoop2:
    sub bx, 4
    cmp [part_2+bx], 0
    jne StopMovePartLeft2
    cmp bx, 0 ;check all the left column
    ja MovePartLeftLoop2

    ;empty line
    mov bx, 0
    mov dx, 0 ;counter
    MoveRowLeft_2:
    MoveRowLeft2_2:
    inc bx
    mov al, [part_2+bx]
    dec bx
    mov [part_2+bx],al
    add bx,4
    cmp bx,15
    jb MoveRowLeft2_2
    inc dx
    mov bx, dx
    cmp dx, 3
    jb MoveRowLeft_2
    ;set the left column to 0
    mov [part_2+15],0
    mov [part_2+11],0
    mov [part_2+7],0
    mov [part_2+3],0

    ;line not empty
    StopMovePartLeft2:
    ret 
endp MovePartLeft

; Store the last part array if it cannot be moved or rotated
proc SaveLastPart
    cmp [IndexGame],1
    jne skipgame9
    mov bx, 0
    LSaveLastPart:
    mov al, [part+bx]
    mov [PartLast+bx],al
    inc bx
    cmp bx, 16
    jb LSaveLastPart
    ret

    skipgame9:
    mov bx, 0
    LSaveLastPart2:
    mov al, [part_2+bx]
    mov [PartLast2+bx],al
    inc bx
    cmp bx, 16
    jb LSaveLastPart2
    ret

endp SaveLastPart

;Check for collision and fix it if needed
proc CheckCollisionAndFix
    call checkcollision
    cmp [BCollision],1
    jne EndCheckCollisionAndFix
    mov bx, 0
    CheckCollisionAndFixLoop:
    cmp [IndexGame],1
    jne skipgame10
    mov al,[PartLast+bx]
    mov [part+bx],al
    jmp skipgame10_2
    skipgame10:
    mov al,[PartLast2+bx]
    mov [part_2+bx],al
    skipgame10_2:
    inc bx
    cmp bx, 16
    jb CheckCollisionAndFixLoop
    EndCheckCollisionAndFix:
    ret
endp CheckCollisionAndFix

; Change left player part
proc ChangePart
    ;get PartNumber and then
    mov bx, 0
    ChangePartLoop:

    cmp [PartNumber],1
    jne sk1
    mov al, [part1+bx]

    sk1:
    cmp [PartNumber],2
    jne sk2
    mov al, [part2+bx]

    sk2:
    cmp [PartNumber],3
    jne sk3
    mov al, [part3+bx]
    
    sk3:
    cmp [PartNumber],4
    jne sk4
    mov al, [part4+bx]

    sk4:
    cmp [PartNumber],5
    jne sk5
    mov al, [part5+bx]

    sk5:
    cmp [PartNumber],6
    jne sk6
    mov al, [part6+bx]

    sk6:
    cmp [PartNumber],7
    jne sk7
    mov al, [part7+bx]

    sk7:
    mov [part+bx],al
    inc bx
    cmp bx, 16
    jb ChangePartLoop
    ret
endp ChangePart

; Change right player part
proc ChangePart2
    ;get PartNumber and then

    mov bx, 0
    ChangePartLoop2:

    cmp [PartNumber2],1
    jne ssk1
    mov al, [part1+bx]

    ssk1:
    cmp [PartNumber2],2
    jne ssk2
    mov al, [part2+bx]

    ssk2:
    cmp [PartNumber2],3
    jne ssk3
    mov al, [part3+bx]
    
    ssk3:
    cmp [PartNumber2],4
    jne ssk4
    mov al, [part4+bx]

    ssk4:
    cmp [PartNumber2],5
    jne ssk5
    mov al, [part5+bx]

    ssk5:
    cmp [PartNumber2],6
    jne ssk6
    mov al, [part6+bx]

    ssk6:
    cmp [PartNumber2],7
    jne ssk7
    mov al, [part7+bx]

    ssk7:
    mov [part_2+bx],al
    
    inc bx
    cmp bx, 16
    jb ChangePartLoop2
    ret
endp ChangePart2

; Find the highest part pixel 
proc PMaxY
    push ax
    push bx
    push cx
    mov [index],0
    mov [indexC],0
    mov [MaxY],0
    mov bx, 0
    MaxLoop:
        cmp [IndexGame],1
        jne skipgame6
        mov al,[part+bx]
        jmp skipgame6_2
        skipgame6:
        mov al,[part_2+bx]
        skipgame6_2:
        ;mov al,[part+bx]
        cmp al, 1
        jne SkipMax
        mov cx, [MaxY]
        cmp [indexC],cx
        jng SkipMax
        mov cx, [indexC]
        mov [MaxY],cx
        SkipMax:
        inc [index]
        inc bx
        cmp [index],4
        jb MaxLoop
        inc [indexC]
        mov [index],0
        cmp [indexC],4
        jb MaxLoop  
    pop cx
    pop bx
    pop ax

    ret
endp PMaxY

; Find the lowest part pixel 
proc PMinY
    push ax
    push bx
    push cx
    mov [index],0
    mov [indexC],0
    mov [MinY],3
    mov bx, 0
    MinLoop:
        cmp [IndexGame],1
        jne skipgame11
        mov al,[part+bx]
        jmp skipgame11_2
        skipgame11:
        mov al,[part_2+bx]
        skipgame11_2:
        cmp al, 1
        jne SkipMin
        mov ax, [indexC]
        mov [MinY],ax
        jmp EndPMinY
        ret
        SkipMin:
        inc [index]
        inc bx
        cmp [index],4
        jb MinLoop
        inc [indexC]
        mov [index],0
        cmp [indexC],4
        jb MinLoop

    EndPMinY:
    pop cx
    pop bx
    pop ax

    ret
endp PMinY

; Move left player part
proc MovePart
    mov [IndexGame],1
    cmp [StopGame],1
    jne ContinueMovePart
    ret
    ContinueMovePart:
    
    inc [DelayMove]
    mov al, [speed]
    cmp [DelayMove],al
    jnb SmallSkipPart
    jmp SkipMovePart
    SmallSkipPart:
    mov [DelayMove],0
    dec [part_y]
    call CheckCollision
    inc [part_y]
    cmp [BCollision],1
    je STOPMOVE
    mov [PRINT_PART_COLOR],0
    call PrintPart
    dec [part_y]

    mov al, [DRAW_COLOR]
    mov [PRINT_PART_COLOR],al
    call PrintPart
    ret

    STOPMOVE:
        call PMaxY
        ;check if the blocks are above grid
        mov ax, [part_y]
        add [MaxY],ax
        cmp [MaxY],20
        jnae sStopGame
        mov [StopGame],1
        jmp SkipMovePart
        sStopGame:

        mov [SetBlockColor],0
        mov [PIndex],0
        mov [PIndexC],0
        mov ax, [PART_X]
        mov [index], ax
        mov ax, [PART_Y]
        mov [indexC], ax
        mov bx,0
        PrintLoop2:
            cmp [part+bx], 1
            jne SkipPrintPart2
            mov al, [DRAW_COLOR]
            mov [SetValueColor], al
            call SetValue
            SkipPrintPart2:
            inc bx
            inc [index]
            inc [PIndex]
            cmp [PIndex],4
            jb PrintLoop2
            inc [indexC]
            inc [PIndexC]
            sub [index],4
            sub [Pindex],4
            cmp [PindexC],4
            jb PrintLoop2
        
        call RandomColor
        ;set the new color so the next time it will print at the top it will be at the same color
        mov al, [DRAW_COLOR]
        mov [PRINT_PART_COLOR],al

        call RandomPart
        
        ;mov [DontCheck],1

        call ChangePart
        

        ResetY:
        ;check if the x position is out of grid and fix it; check if index 0-9 can't use jb and ja for several reasons
        mov [part_x],4
        call PMaxY
        call PMinY
        mov [part_y],18
        mov ax, [MinY]
        add [part_y],ax
        mov ax, [MaxY]
        sub [part_y],ax
        ;mov [DontCheck],0
        call SetPreview
        call RotatePart
        call PrintPart
        ret

    SkipMovePart:
        
    ret
endp MovePart

; Move right player part
proc MovePart2
    cmp [StopGame2],1
    jne ContinueMovePart2
    ret
    ContinueMovePart2:
    
    mov [IndexGame],2
    ;call SetPreview
    inc [DelayMove2]
    mov al, [speed2]
    cmp [DelayMove2],al
    jnb SmallSkipPart2
    jmp SkipMovePart2
    SmallSkipPart2:
    mov [DelayMove2],0
    ;check if the currnet or next move will collide
    
    dec [part_y2]
    call CheckCollision
    inc [part_y2]
    cmp [BCollision],1
    je STOPMOVE2
    mov [PRINT_PART_COLOR2],0
    call PrintPart2
    dec [part_y2]
    mov al, [DRAW_COLOR2]
    mov [PRINT_PART_COLOR2],al
    call PrintPart2
    ret

    STOPMOVE2:
        call PMaxY

        ;check if the blocks are above grid
        mov ax, [part_y2]
        add [MaxY],ax
        cmp [MaxY],20
        jnae sStopGame2
        mov [StopGame2],1
        jmp SkipMovePart2
        sStopGame2:

        mov [SetBlockColor],0
        mov [PIndex],0
        mov [PIndexC],0
        mov ax, [PART_X2]
        mov [index], ax
        mov ax, [PART_Y2]
        mov [indexC], ax
        mov bx,0
        PrintLoop22:
            ;draw the last position in black
            cmp [part_2+bx], 1
            jne SkipPrintPart21
            mov al, [DRAW_COLOR2]
            mov [SetValueColor], al
            mov [IndexGame],2
            call SetValue
            SkipPrintPart21:
            inc bx
            inc [index]
            inc [PIndex]
            cmp [PIndex],4
            jb PrintLoop22
            inc [indexC]
            inc [PIndexC]
            sub [index],4
            sub [Pindex],4
            cmp [PindexC],4
            jb PrintLoop22
        
        call RandomColor2
        ;set the new color so the next time it will print at the top it will be at the same color
        mov al, [DRAW_COLOR2]
        mov [PRINT_PART_COLOR2],al

        call RandomPart2
        ;mov [PartNumber2],4
        
        ;mov [DontCheck],1

        call ChangePart2
        ResetY2:
        ;check if the x position is out of grid and fix it; check if index 0-9 can't use jb and ja for several reasons
        mov [part_x2],4
        ;ret
        ;mov [part_y],16
        ;ret
        call PMaxY
        call PMinY
        mov [part_y2],18
        mov ax, [MinY]
        add [part_y2],ax
        mov ax, [MaxY]
        sub [part_y2],ax
        ;mov [DontCheck],0
        call SetPreview2
    SkipMovePart2:
        
    ret
endp MovePart2

; make the speed faster if possible 
proc Makefaster
    cmp [Speed],1
    je StopMakeFaster
    dec [Speed]
    dec [Speed2]
    StopMakeFaster:
    ret
endp Makefaster

; Reset both player grids
proc ResetGrid
    mov bx, 0
    ResetGridL:
    mov [grid+bx],0
    inc bx
    cmp bx, 200
    jb ResetGridL
    mov bx, 0
    ResetGridL2:
    mov [grid2+bx],0
    inc bx
    cmp bx, 200
    jb ResetGridL2
    ret
endp ResetGrid

; Reset both players preview arrays
proc ResetPreview
    mov bx, 0
    ResetPreviewL:
    mov [preview+bx],1
    inc bx
    cmp bx, 16
    jb ResetPreviewL

    mov bx, 0
    ResetPreviewL2:
    mov [preview_2+bx],1
    inc bx
    cmp bx, 16
    jb ResetPreviewL2
    ret
endp ResetPreview

; Check if there is a block in the grid in a specific position
proc checkBlockGrid
    push ax
    push bx
    push cx
    push dx
    mov ax, [indexC]
    mov cx, 10
    mul cx ;save at ax
    add ax, [index]
    mov bx,ax
    cmp [IndexGame],1
    jne skipgame13
    mov al, [grid+bx]
    jmp skipgame13_2
    skipgame13:
    mov al, [grid2+bx]
    skipgame13_2:
    cmp al, 0
    je Noblock
    mov [BlockGrid], 1
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    Noblock:
        mov [BlockGrid], 0
        pop dx
        pop cx
        pop bx
        pop ax
    ret
endp checkBlockGrid

; Check if there is a collision
proc CheckCollision

    mov [Pindex],0
    mov [PindexC],0
    mov bx, 0
    CheckCollisionLOOP:
        cmp [IndexGame],1
        jne skipgame8
        mov al, [part+bx]
        jmp skipgame8_2
        skipgame8:
        mov al, [part_2+bx]
        skipgame8_2:
        cmp al, 1
        je SContinueCollisionLoop
        jmp ContinueCollisionLoop
        SContinueCollisionLoop:
        mov cx, [Pindex]
        mov dx, [PindexC]
        cmp [IndexGame],1
        jne skipgame12
        add cx, [PART_X]
        add dx, [PART_Y]
        jmp skipgame12_2
        skipgame12:
        add cx, [PART_X2]
        add dx, [PART_Y2]
        skipgame12_2:
        mov [index],cx
        mov [indexC],dx

        cmp [index],10
        jb CCC2
        jmp COLLISION_TRUE
        CCC2:
        cmp [indexC],0
        jae CC2
        jmp COLLISION_TRUE
        CC2:
        cmp [indexC],20
        jb CCC
        jmp COLLISION_TRUE
        CCC:
        cmp [indexC],0
        jae CC
        jmp COLLISION_TRUE
        CC:

        cmp [indexC],0
        jb COLLISION_TRUE

        call checkBlockGrid
        cmp [BlockGrid],1
        je COLLISION_TRUE
        ContinueCollisionLoop:
        inc [Pindex]
        inc bx
        cmp [Pindex],4;4
        jnb SCheckCollisionLOOP1
        jmp CheckCollisionLOOP
        SCheckCollisionLOOP1:
        mov [Pindex],0
        inc [PindexC]
        cmp [PindexC],4
        jnb SCheckCollisionLOOP2
        jmp CheckCollisionLOOP
        SCheckCollisionLOOP2:
        mov [BCollision],0

        ret
        COLLISION_TRUE:
            mov [BCollision],1

    ret
endp CheckCollision

; Move left player part to the Right
proc MoveRight
    cmp [part_x],10 
    jg STOPRIGHT
    inc [part_x] ; | CHANGE_AMOUNT_OF_MOVMENT |
    call CheckCollision
    dec [part_x]
    cmp [BCollision],1
    je STOPRIGHT
    mov [PRINT_PART_COLOR],0
    call PrintPart
    inc [part_x]
    mov al, [Draw_color]
    mov [PRINT_PART_COLOR],al

    STOPRIGHT:
        ret
endp MoveRight

; Move right player part to the Right
proc MoveRight2
    mov [IndexGame],2
    cmp [part_x2],10
    jg STOPRIGHT2
    inc [part_x2]
    call CheckCollision
    dec [part_x2]
    cmp [BCollision],1
    je STOPRIGHT2
    mov [PRINT_PART_COLOR2],0
    call PrintPart2
    inc [part_x2]
    mov al, [Draw_color2]
    mov [PRINT_PART_COLOR2],al

    STOPRIGHT2:
        ret
endp MoveRight2

; Move left player part to the Left
proc MoveLeft
    dec [part_x]
    call CheckCollision
    inc [part_x]
    
    cmp [BCollision],1
    je STOPLEFT
    mov [PRINT_PART_COLOR],0
    call PrintPart
    dec [part_x]
    mov al, [Draw_color]
    mov [PRINT_PART_COLOR],al

    STOPLEFT:
        ret
endp MoveLeft

; Move left player part to the Right
proc MoveLeft2
    mov [IndexGame],2
    dec [part_x2]
    call CheckCollision
    inc [part_x2]
    
    cmp [BCollision],1
    je STOPLEFT2
    mov [PRINT_PART_COLOR2],0
    call PrintPart2
    dec [part_x2]
    mov al, [Draw_color2]
    mov [PRINT_PART_COLOR2],al

    STOPLEFT2:
        ret
endp MoveLeft2

; Move left player part Down
proc MoveDown ;Left Player
    cmp [part_y],0
    jbe STOPDOWN
    dec [part_y]
    call CheckCollision
    inc [part_y]
    cmp [BCollision],1
    je STOPDOWN

    mov [PRINT_PART_COLOR],0
    call PrintPart
    dec [part_y]
    mov al, [Draw_color]
    mov [PRINT_PART_COLOR],al

    STOPDOWN:
        ;insert into array
        ret

endp MoveDown

; Move right player part Down
proc MoveDown2 ;Right Player
    mov [IndexGame],2
    cmp [part_y2],0
    jbe STOPDOWN
    dec [part_y2]
    call CheckCollision
    inc [part_y2]
    cmp [BCollision],1
    je STOPDOWN2
    mov [PRINT_PART_COLOR2],0
    call PrintPart2
    dec [part_y2]
    mov al, [Draw_color2]
    mov [PRINT_PART_COLOR2],al

    STOPDOWN2:
        ;insert into array
    ret
endp MoveDown2


;print image on screen

proc PrintBmp
	xor di, di
	mov di, ax
	mov si, offset filename
	mov cx, 20
Copy:
	mov al, [di]
	mov [si], al
	inc di
	inc si
	loop Copy
	call OpenFile
	call ReadHeader
	call ReadPalette
	call CopyPal
	call CopyBitMap
	call CloseFile
	
	ret
endp PrintBmp


proc GraphicsMode	
	mov ax, 13h
	int 10h
		
	ret
endp GraphicsMode


;in proc PrintBmp
proc OpenFile
	mov ah,3Dh
	xor al,al ;for reading only
	mov dx, offset filename
	int 21h
	jc OpenError
	mov [filehandle],ax
	ret
OpenError:
    ret
	mov dx,offset Errormsg
	mov ah,9h
	int 21h
	ret
endp OpenFile


;in proc PrintBmp
proc ReadHeader
;Read BMP file header, 54 bytes
	mov ah,3Fh
	mov bx,[filehandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	ret
endp ReadHeader


;in proc PrintBmp
proc ReadPalette
;Read BMP file color palette, 256 colors*4bytes for each (400h)
	mov ah,3Fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	ret
endp ReadPalette


;in proc PrintBmp
proc CopyPal
; Copy the colors palette to the video memory
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h ;port of Graphics Card
	mov al,0 ;number of first color
	;Copy starting color to port 3C8h
	out dx,al
	;Copy palette itself to port 3C9h
	inc dx
PalLoop:
	;Note: Colors in a BMP file are saved as BGR values rather than RGB.	
	mov al,[si+2] ;get red value
	shr al,2 	; Max. is 255, but video palette maximal value is 63. Therefore dividing by 4
	out dx,al ;send it to port
	mov al,[si +1];get green value
	shr al,2
	out dx,al	;send it
	mov al,[si]
	shr al,2
	out dx,al 	;send it
	add si,4	;Point to next color (There is a null chr. after every color)
	loop PalLoop
	ret
endp CopyPal


;in proc PrintBmp
proc CopyBitMap
; BMP graphics are saved upside-down.
; Read the graphic line by line ([height] lines in VGA format),
; displaying the lines from bottom to top.
	mov ax,0A000h ;value of start of video memory
	mov es,ax	
	push ax
	push bx
	mov ax, [imgWidth]
	mov bx, 4
	div bl
	
	cmp ah, 0
	jne NotZero
Zero:
	mov [adjustCX], 0
	jmp Continue
NotZero:
	mov [adjustCX], 4
	xor bx, bx
    mov bl, ah
	sub [adjustCX], bx
Continue:
	pop bx
	pop ax
	mov cx, [imgHeight]	;reading the BMP data - upside down
	
PrintBMPLoop:
	push cx
	xor di, di
	push cx
	dec cx
	Multi:
		add di, 320
		loop Multi
	pop cx

    add di, [printAdd]
	mov ah, 3fh
	mov cx, [imgWidth]
	add cx, [adjustCX]
	mov dx, offset ScrLine
	int 21h
	;Copy one line into video memory
	cld	;clear direction flag - due to the use of rep
	mov cx, [imgWidth]
	mov si, offset ScrLine
	rep movsb 	;do cx times:
				;mov es:di,ds:si -- Copy single value form ScrLine to video memory
				;inc si --inc - because of cld
				;inc di --inc - because of cld
	pop cx
	loop PrintBMPLoop
	ret
endp CopyBitMap


;in proc PrintBmp
proc CloseFile
    ret
	mov ah,3Eh
	mov bx,[filehandle]
	int 21h
endp CloseFile


proc SetFirstImages
    mov ah, 00h
    mov al, 13h ;set video mode
    int 10h ;execute

    mov ah,0Bh; set configuration
    mov bh, 00h ;set background color
    mov bl, 00h ;choose black as background
    int 10h


    ;print welcome image
    mov ax, offset StartImage
	mov [printAdd], 0
	call PrintBmp

    ;Press any key to start
	mov ah, 1
	int 21h
    ;call ClearScreen

    mov ax, offset KeysImage
	mov [printAdd], 0
    call PrintBmp
    call PrintPart

    ;Press any key to start
    mov ah, 1
	int 21h

    ret
endp SetFirstImages

proc SetStartVars
    call RandomSeed
    mov [IndexGame],1 ;    | CHANGE_START_POSITION_PART |
    mov [Part_x],4
    mov [PART_Y],16
    mov [Part_x2],4
    mov [PART_Y2],16    

    ;start with part1
    mov [PartNumber],1
    ;call RandomPart
    call ChangePart

    mov [PartNumber2],1
    ;call RandomPart2
    call ChangePart2
    ret
endp SetStartVars

proc SetStartScreen
    mov ax, offset BgImage
	mov [printAdd], 0
    call PrintBmp
    call PrintPart

    mov [PartNumber],1

    call SetPreview
    mov [IndexGame],2
    call SetPreview2
    mov [PRINT_PART_COLOR2],1
    call DRAW_GRID
    call PrintPart2
    mov [IndexGame],1
    ret
endp SetStartScreen

proc ResetTime
    mov ah, 2ch ;get system time
    int 21h ;ch= hour cl= minute dh=second dl= 1/100 seconds
    mov [Seconds],0
    ret
endp ResetTime



proc SecondPast
    mov ah, 2ch ;get system time
        int 21h ;ch= hour cl= minute dh=second dl= 1/100 seconds
        ;every 30 seconds make the game faster
        cmp dh, [TIME_AUX2]
        je ContinueMinutes
        ;passed
        inc [Seconds]
        cmp [Seconds], 50
        jb ContinueMinutes
        call Makefaster
        mov [Seconds], 0
        ContinueMinutes:
        mov [TIME_AUX2], dh
        ;cmp dl, [TIME_AUX]
    ret
endp SecondPast

proc CheckKey
mov [TIME_AUX], dl
        ;check when 1 second is passed
        ;the time passed
        ;check for right,down,left,R arrow key and move part or rotate it if pressed
        CHECK_KEY:
            mov ah, 01h ; check keyboard buffer
            int 16h ; check for key press
            ;jz SKIP2 ; skip if no key pressed
            jnz JNOKEYPRESSED ; skip if  key pressed
            jmp NOKEYPRESSED    ;no key pressed
            JNOKEYPRESSED:
            mov ah, 00h ; read keyboard buffer
            int 16h ; get key pressed
            cmp ah, 20h ; check if D key (ASCII code 20h)
            jne SKIP2 ; skip if not right arrow key
            call MoveRight ; call function to move right
            SKIP2: ; check if A key (ASCII code 1Eh)
                cmp ah, 1Eh ;A
                jne SKIP3
                call MoveLeft
            SKIP3: ; check if S key (ASCII code 20h)
                cmp ah, 1Fh ;S
                jne SKIP4
                call MoveDown
            SKIP4: ; check if R key (ASCII code 13h)
                cmp ah, 13h ;R
                jne SKIP5
                mov [IndexGame],1
                call RotatePart
            SKIP5: ; check if right arrow key (ASCII code 4Dh)
                cmp ah, 4Dh ; Right
                jne SKIP6
                call MoveRight2
            SKIP6: ; check if left arrow key (ASCII code 4Dh)
                cmp ah, 4bh ;Left
                jne SKIP7
                call MoveLeft2
            SKIP7: ; check if down arrow key (ASCII code 4Dh)
                cmp ah, 50h ;Down
                jne SKIP8
                call MoveDown2
            SKIP8: ; check if Space key (ASCII code 4Dh)
                cmp ah, 39h ;Space
                jne NOKEYPRESSED
                mov [IndexGame],2
                call RotatePart

            NOKEYPRESSED:
                ;just skip
        
    ret
endp CheckKey

proc DoActions
    mov [IndexGame],1
    call MovePart
    call PrintPart
    call PrintScore
    call PrintSpeed
    call RemoveRows ;check if a row is full, if it is reomve it and move the above layers down
    call DRAW_GRID
        
    mov [IndexGame],2
    call MovePart2
    call PrintPart2
    call PrintScore2
    call PrintSpeed2
    call RemoveRows ;check if a row is full, if it is reomve it and move the above layers down
    call DRAW_GRID
    mov [IndexGame],1
    ret
endp DoActions

proc EndGameActions
    mov ax, [score]
    cmp ax,[score2]
    ja WinL
    cmp ax,[score2]
    jb WinR

    ;its a tie
    mov ax, offset overT
	mov [printAdd], 0
	call PrintBmp
    jmp ContinueEndGame

    WinL:
    mov ax, offset overL
	mov [printAdd], 0
	call PrintBmp
    jmp ContinueEndGame

    WinR:
    mov ax, offset overR
	mov [printAdd], 0
	call PrintBmp
    jmp ContinueEndGame

    ContinueEndGame:
    ;ask to reset game
    mov ah, 00h ; read keyboard buffer
    int 16h ; get key pressed
    cmp ah, 01h ; check if right arrow key (ASCII code 4Dh)
    je FinalEndGame
    ;reset game
    mov [StopGame],0
    mov [speed],5
    mov [score],0
    mov [StopGame2],0
    mov [speed2],5
    mov [score2],0
    call ResetGrid
    mov [PreviewColor],0
    mov [PreviewColor2],0


    call ResetPreview
    call ClearScreen
    ;reset to be the same parts and colors
    mov ax, [seed]
    mov [seed_2],ax
    mov ax, [seed2]
    mov [seed2_2],ax
    mov al, [DRAW_COLOR]
    mov [DRAW_COLOR2],al
    ret
    ;end game
    FinalEndGame:
    call ClearScreen
    call Exit
    ret
endp EndGameActions

proc ResetVarsAndImage
    call SetStartVars
        call SetStartScreen
        call ResetTime
    ret
endp ResetVarsAndImage


; Main game runs here
proc MainGame
    call SetFirstImages

    NewGame:
        call ResetVarsAndImage

    CHECK_TIME:
        call SecondPast ; check when a second had passed and increase speed if needed
        cmp dl, [TIME_AUX] 
        je CHECK_TIME ;if it is the same check again
		call CheckKey ; Check all keyboard buttons and make the movments
		call DoActions ; Make all the actions like moving parts, updating preview, score and delete rows if needed
	
		; Check if the game has ended
        cmp [StopGame],1 
        je JSTOPGAME_A
        jmp CHECK_TIME ; check again

        JSTOPGAME_A:
        cmp [StopGame2],1
        je JSTOPGAME

        jmp CHECK_TIME ; check again
    JSTOPGAME:
    call EndGameActions
    jmp NewGame
    ret
endp MainGame

; Start the game
Start:
    mov ax, @data
    mov ds, ax
    
    call SwitchToGraphicsMode
    call MainGame
    
	ret
END Start