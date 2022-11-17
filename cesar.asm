global	main
extern  gets
extern  puts
extern sscanf
extern printf

section     .data
    msjTexto   db  "Ingrese un texto:",0
    msjDecod       db  "Ingrese un factor de dezplazamiento (entre 0 y 9) y si desea codificar o decodificar (c o d) separados por un espacio:",0
    formato   db  "%hi %s",0
    msjInvalido db  "Los datos ingresados son invalidos. Intente nuevamente",0
    formatoPrint    db  "%s",0
    formatonum      db  "%hi",0
    desplazar   db  1
    fin_dicc  db  "z",0
    minusc db  "a",0
    Mayusc  db  "A",0
    fin_diccM   db  "Z",0
    trucazo     dq  2
section     .bss
    DatosValidos    resb 1
    datoValido		resb	1
    texto           resb    100
    factor_y_carac  resb    50
    factorDezplaz	resw   1
    cod_o_decod resb    1
    inicio_dicc resb 1
section     .text
main:
    mov     rdi, msjTexto
    sub		rsp,8	
    call    puts     
	add		rsp,8

    mov     rdi,texto
    sub     rsp,8
    call    gets  
    add     rsp,8

msj:
    mov     rdi, msjDecod 
    sub		rsp,8	
    call    puts     
	add		rsp,8

    mov     rdi,factor_y_carac
    sub     rsp,8
    call    gets  
    add     rsp,8

    mov     rdi,factor_y_carac 
    mov     rsi,formato
	mov		rdx,factorDezplaz
	mov		rcx,cod_o_decod
    sub		rsp,8
	call	sscanf
	add		rsp,8

    cmp     rax,2
    jl      invalido

	sub		rsp,8
    call	validarDatos
	add		rsp,8
    cmp		byte[DatosValidos],'N'

    je		invalido
    mov     rbx,0
    mov     rax,0
    mov     r8,0
    mov     r9,[desplazar]
    mov     r10,[fin_dicc]
cifrado:    
    mov     rax,r8
    cmp     byte[texto+eax]," "
    je      sig_carac
    cmp     byte[texto+eax],0
    je      fin_cod
    mov     rcx,[factorDezplaz]
    add     rcx,[trucazo] ;??????????

desplaz:
    push    rcx
    mov     rcx,1
    lea     rsi,[fin_dicc]
    lea     rdi,[texto+eax]
repe    cmpsb
    pop     rcx
    je      inicio
    push    rcx
    mov     rcx,1
    lea     rsi,[fin_diccM]
    lea     rdi,[texto+eax]
repe    cmpsb
    pop     rcx
    je      inicioM
    add     byte[texto+eax],r9b
    loop    desplaz


sig_carac:
    inc     r8
    jmp     cifrado
inicioM:
    mov     r12b,[Mayusc]
    mov     [inicio_dicc],r12b
    jmp     inicio_abc
inicio:
    mov     r12b,[minusc]
    mov     [inicio_dicc],r12b
inicio_abc:
    mov     r12,0
    push    rcx
    mov     rcx,1
    lea     rsi,[inicio_dicc]
    lea     rdi,[texto+eax]      
rep  movsb
    pop     rcx
    dec     rcx
    cmp     rcx,0
    je      sig_carac
    jmp     desplaz
invalido:
    mov     rdi, msjInvalido
    sub		rsp,8	
    call    puts     
	add		rsp,8
    jmp     msj

validarDatos:
    mov     byte[DatosValidos],'N'

	sub		rsp,8
	call	validarDezplaz
	add		rsp,8
	cmp		byte[datoValido],'N'
	je		finValidarDatos

	sub		rsp,8
	call	validarCod
	add		rsp,8
	cmp		byte[datoValido],'N'
	je		finValidarDatos


	mov     byte[DatosValidos],'S' 
finValidarDatos:
    ret


validarDezplaz:
    mov     byte[datoValido],'N'
	cmp		word[factorDezplaz],0
	jl		DesplazError
    cmp		word[factorDezplaz],9
	jg		DesplazError    
	mov     byte[datoValido],'S'
DesplazError:
    ret

validarCod:
    mov     byte[datoValido],'N'
	cmp		byte[cod_o_decod],"c"
	je		cod
    cmp		byte[cod_o_decod],"d"
	jne		CodError
    neg     byte[desplazar]
    mov     byte[fin_dicc],"a"
    mov     byte[fin_diccM],"A"
    mov     byte[minusc],"z"
    mov     byte[Mayusc],"Z"
    mov     byte[trucazo],12
cod:   
	mov     byte[datoValido],'S'
CodError:
    ret
    
fin_cod:
    mov     rdi,texto
    sub		rsp,8	
    call    puts 
 	add		rsp,8
    ret
