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

Stu_no       db 10,13,"Enter Student Number: $"

point1       db 10,13,"Enter point1: $"
                                       
point2       db 10,13,"Enter point2: $"

point3       db 10,13,"Enter point3: $"	 

message1     db 10,13,"Press 'r' for Repeat or 'e' for Exit: $"

message2     db 10,13,"do you want see all data? 'y' for yes or 'n' for no: $"

message3     db 10,13,"Enter your keyNAME: $"	
	                                 
data         db  20,?,20 dup ('0'),'$'  ;max,len,initialization,/0  
        
index        dw  0 

ikeyarr      dw  0        

stu_db       db  1024 dup('0')

namekey      db ''

keyarr       dw 10 dup('0')
                                          
datasg  ends            

;---------------------------------
codesg  segment para common 'code'
main    proc    far
        assume  ds:datasg,cs:codesg,ss:stacksg;es:datasg
		
        mov     ax,datasg
        mov     ds,ax
		mov     es,ax   
		 		 
		;-----clear screen
pl:		mov   ah,6 ;scroll up window
		mov   al,0 ;0 blank whole window
		mov   ch,0
		mov   cl,0
		mov   dh,24
		mov   dl,79
		mov   bh,14
		int   10h
		;print list
		lea dx,list
		mov ah,9
		int 21h
		;message for choice
		lea dx,choice
		mov ah,9
		int 21h
		;get the choice
		mov ah,1
		int 21h
		;check user choice
		cmp al,31h  ;hex('1')=31H  :)
		je addstu
		cmp al,32h
		je removestu
		cmp al,33h
		je defragdb
		cmp al,34h
		je search
		cmp al,35h
		je loadfile
		cmp al,36h
		je savefile
		cmp al,37h
		je exit 
		
addstu:	
        call adst
        jmp pl
removestu:  
        ;call rst
        jmp pl
defragdb:	
        ;call dfd
        jmp pl
search:  
        call ser
        jmp pl
loadfile:	
        ;call lfi
        jmp pl
savefile:  
        ;call sfi
        jmp pl
exit:   
        mov ax,4c00h
        int 21h
main    endp


;add student proce
adst    proc 
    
adst1:	lea  dx,name1 ;message for get name and ...
		call getdata
		lea  dx,family ;enter
		call getdata
		lea  dx,Stu_no
		call getdata
		;get points
		lea dx,point1
		call getdata
		lea dx,point2
		call getdata
		lea dx,point3
		call getdata
		mov stu_db[bx],'1' ;name,lastname,stuno,p1,p2,p3,1;
		inc bx
		mov stu_db[bx],';' 
		inc bx
		mov index,bx
		
adst2:	lea dx,message1  ;continue add student
		mov ah,9
		int 21h
		
		mov ah,1
		int 21h
		
    	cmp al,'r'
		je adst1
		cmp al,'e'
		jne adst2
		
        ret 
        
adst   endp       

;some code cutted

getdata  proc
        ;------ message for data--------------
		mov ah,9
		int 21h
		;----- get input string
		mov ah,0ah
		lea dx,data
		int 21h
		;-------add stu to DB
		mov bx,index   ;bx index of start stu_db
		lea si,data+2 ;data: 20 5 s a e e d
		lea di,stu_db[bx]                   
		;len+index:
		mov cl,data+1
		mov ch,0
		add bx,cx
		;add data   
		cld         
		rep movsb
		mov stu_db[bx],','   ;firstname,lastname,...
		inc bx
		mov index,bx
        ret
getdata  endp


ser proc
        ;get name key
        lea dx,message3
        mov ah,9
        int 21h 
        
        mov ah,0ah
		lea dx,data
		int 21h              
		
		mov cl,data+1
		mov ch,0
		lea si,data+1
		lea di,namekey
        cld         
		rep movsb
		;search  
   ; mov   cx,index
   ; mov   bx,namekey 
    
    mov   si,0 ;stu[0]
    mov   di,0 ;key[0]
    
matching:
    mov   ax, si
    cmp   ax,di
    je    eq    
    inc   si
    cmp   index-1,si
    je  exit
    jmp matching
      
eq: 
    inc si 
    inc di 
    
    cmp di ,word ptr namekey[0] ;compare di ,len(key)
    je  addkey 
    jmp matching
    
addkey:
    ;add key to arrkey
    mov ax,keyarr[ikeyarr]
    mov ax, si
    inc ikeyarr 
    ;re init di
    lea   di,0 
    jmp matching              
    
    ret
ser endp    


codesg  ends
        end        main
       