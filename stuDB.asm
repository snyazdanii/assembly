stacksg segment para stack ;'stack'
   sb    db      1024 dup('0')
stacksg ends
;---------------------------------

datasg  segment para common 'data'
list	     db 10,13,'1:Add student'
             db 10,13,'2:Remove student'
			 db	10,13,'3:Defrag'
			 db	10,13,'4:Search'
			 db	10,13,'5:Load from file'
			 db	10,13,'6:Save to file'
             db 10,13,'7:Exit'
			 db 10,13,'$'	
choice 	     db 10,13,"Enter your choice: $"	
name1        db 10,13,"Enter Name: $"	
Family       db 10,13,"Enter Family: $"
Stu_no       db 10,13,"Enter Student NO.: $"	
message1     db 10,13,"Press 'r' for Repeat or 'e' for Exit: $"		
data         db  20,?,20 dup ('0'),'$'
index        dw  0
stu_db  db  1024 dup('0')

datasg  ends
;---------------------------------
codesg  segment para common 'code'
main    proc    far
        assume  ds:datasg,cs:codesg,ss:stacksg;es:datasg
		
        mov     ax,datasg
        mov     ds,ax
		mov     es,ax   
		
		;-----clear screen
pl:		mov   ah,6
		mov   al,0 ;0 blank whole window
		mov   ch,0
		mov   cl,0
		mov   dh,24
		mov   dl,79
		mov   bh,14
		int   10h
		;----- print list-----
		lea dx,list
		mov ah,9
		int 21h
		;------ message for choice--------------
		lea dx,choice
		mov ah,9
		int 21h
		;----- get the choice-----
		mov ah,1
		int 21h
		;-----------------
		cmp al,31h
		je as
		cmp al,32h
		je rs
		cmp al,33h
		je de
		cmp al,34h
		je se
		cmp al,35h
		je lf
		cmp al,36h
		je sf
		cmp al,37h
		je exit
   as:	call ast
        jmp pl
   rs:  call rst
        jmp pl
   de:	call dfd
        jmp pl
   se:  call ser
        jmp pl
   lf:	call lfi
        jmp pl
   sf:  call sfi
        jmp pl
		;-----------------
exit:   mov ax,4c00h
        int 21h

main    endp
;------------------------
ast   proc
        ;------ message for data--------------
ast1:	lea  dx,name1
		call getdata
		lea  dx,family
		call getdata
		lea  dx,Stu_no
		call getdata
		mov stu_db[bx-1],';'
		
ast2:	lea dx,message1
		mov ah,9
		int 21h
		
		mov ah,1
		int 21h
		
    	cmp al,'r'
		je ast1
		cmp al,'e'
		jne ast2
		
		
        ret 
ast   endp
;------------------------
rst   proc
        
        ret 
rst   endp
;------------------------
dfd   proc
        
        ret 
dfd   endp
;------------------------
ser   proc
        
        ret 
ser   endp
;------------------------
lfi   proc
        
        ret 
lfi   endp
;------------------------
sfi   proc
        
        ret
sfi   endp
;------------------------
getdata  proc
          ;------ message for data--------------
		mov ah,9
		int 21h
		;----- get input string
		mov ah,0ah
		lea dx,data
		int 21h
		;---------------------
		mov bx,index   ;bx index from stu_db
		lea si,data+2
		lea di,stu_db[bx]
		mov cl,data+1
		mov ch,0
		add bx,cx
		cld
		rep movsb
		mov stu_db[bx],','
		inc bx
		mov index,bx
        ;---------------------
         ret
getdata  endp
codesg  ends
        end        main
       