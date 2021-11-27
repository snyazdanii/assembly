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

pORa         db 10,13,"1" ;1 peresent and 0 absent in DB
	
name1        db 10,13,"Enter Name: $"
	
Family       db 10,13,"Enter Family: $"     

Stu_no       db 10,13,"Enter Student Number: $"

point1       db 10,13,"Enter point1: $"
                                       
point2       db 10,13,"Enter point2: $"

point3       db 10,13,"Enter point3: $"	 

message1     db 10,13,"Press 'r' for Repeat or 'e' for Exit: $"

message2     db 10,13,"do you want see all data? 'y' for yes or 'n' for no: $"

message3     db 10,13,"Enter your keyNAME: $"	
	                                 
data         db  20,?,20 dup ('0'),'$'    
        
index        dw  0          

stu_db       db  2048 dup('0')

namekey      db '' 
                                          
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
        call rst
        jmp pl
defragdb:	
        call dfd
        jmp pl
search:  
        call ser
        jmp pl
loadfile:	
        call lfi
        jmp pl
savefile:  
        call sfi
        jmp pl
exit:   
        mov ax,4c00h
        int 21h
main    endp
;add student proce
adst   proc
adst1:	lea  dx,name1 ;message for get name and ...
		call getdata
		lea  dx,family
		call getdata
		lea  dx,Stu_no
		call getdata
		lea dx,point1
		call getdata
		lea dx,point2
		call getdata
		lea dx,point3
		call getdata
		mov stu_db[bx-1],'1' ;name,lastname,stuno,p1,p2,p3,1;
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
;remove student
rst   proc
        
        ret 
rst   endp
;------------------------
dfd   proc
        
        ret 
dfd   endp
;search
ser   proc
      ;request for all data or a key?
      lea dx,message2
      mov ah,9
      int 21h
	  ;get choise
	  mov ah,1
	  int 21h
	  ;compare 
	  cmp al,'y'
	  jmp ser1
	  cmp al,'n'
	  jmp ser2

sr1:  call ser1
sr2:  call ser2
	  ret
ser endp

ser1 proc
     lea dx,message1
     mov ah,9
     int 21h 
     ret
end proc
ser2 proc
     ;get nameKAy   
	  lea dx,message3
      mov ah,9
	  int 21h
	  mov ah , 01h
	  lea dx,  namekey 
	  int 21h
end proc        
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
		;-------add stu to DB
		mov bx,index   ;bx index of start stu_db
		lea si,data+2
		lea di,stu_db[bx]
		mov cl,data+1
		mov ch,0
		add bx,cx
		cld         
		rep movsb
		mov stu_db[bx],','   ;st1,st2,...
		inc bx
		mov index,bx
        ;---------------------
         ret
getdata  endp
codesg  ends
        end        main
       