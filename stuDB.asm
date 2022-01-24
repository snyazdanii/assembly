stacksg segment para stack
   sb    db      1024 dup('0')
stacksg ends
datasg  segment para common 'data'
       
list	     db 10,13,'1:Add student'
             db 10,13,'2:Remove student'
	         db	10,13,'3:Defrag'
	         db	10,13,'4:Search' 
	         db	10,13,'5:SHOW DATABASE' 
			 db	10,13,'6:Load from file'
			 db	10,13,'7:Save to file'                   
             db 10,13,'8:Exit'
			 db 10,13,'$'	  
			 
choice 	     db 10,13,"Enter your choice: $"  
	
name1        db 10,13,"Enter Name: $"
	
Family       db 10,13,"Enter Family: $"     

Stu_no       db 10,13,"Enter Student Number: $"

point        db 10,13,"Enter point: $"
                                       
message1     db 10,13,"Press 'r' for Repeat or 'e' for Exit: $"

message2     db 10,13,"do you want see all data? 'y' for yes or 'n' for no(after that you should choose which record that you want see): $"

message3     db 10,13,"Enter your keyNAME: $"	

message4     db 10,13,"NO MATCH $"

message5     db 10,13,"data base is empty $" 

message6     db 10,13,"some record found $"    

message7     db 10,13,"no record for defrag $"  

message8     db 10,13,"replase @ was done successfully $" 

message9     db 10,13,"defrag operated successfully $" 
	                                 
data         db  20,?,20 dup ('0'),'$'                    ;max,len,initialization,/0  
        
index        dw  0000h    ;stu_db

i            db  00h      ;key_db

j            db  00h      ;removed_db

stu_db       db  256  dup('0')           

key_db       db  5    dup('0')        

removed_db   db  5    dup('0')
                                          
namekey      db  15   dup('0')  

temp         db  00 

handle_file  dw  ?

path         db '/databse.txt',00h 
                           
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
		;-----print list
		lea dx,list
		mov ah,9
		int 21h
		;-----message for choice
		lea dx,choice
		mov ah,9
		int 21h
		;-----get the choice
		mov ah,1
		int 21h
		;-----check user choice
		cmp al,31h  ;hex('1')=31H  :)
		je addstu
		cmp al,32h
		je removestu
		cmp al,33h
		je defragdb
		cmp al,34h
		je search
		cmp al,35h
		je show_db
		cmp al,36h
		je loadfile
		cmp al,37h
		je savefile
		cmp al,38h
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
show_db:
        call show
        jmp pl
loadfile:	
        call lofi
        jmp pl
savefile:  
        call safi
        jmp pl
exit:   
        mov ax,4c00h
        int 21h
main    endp


;************add student proce*************
adst    proc 
    
adst1:	lea  dx,name1              ;message for get name and ...
		call getdata
		lea  dx,family 
		call getdata
		lea  dx,Stu_no
		call getdata 	
        
        call addpoints             ;add points
        ;add avg:                       	 
		mov  stu_db[bx],al         ;add d
		inc  bx  
		mov  stu_db[bx],ah         ;add u
		inc  bx 
		mov  stu_db[bx],','
		inc  bx
		mov  stu_db[bx],'1'        ;name,lastname,stuno,p1,p2,p3,avg,1;
		inc  bx
		mov  stu_db[bx],';' 
		inc  bx
		mov  index,bx
		
adst2:	lea dx,message1  ;continue or not
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
;************add points*************
addpoints proc
		
;calc sum of point:
		mov temp,00h    
;for point1        	
		lea dx,point
		call getdata
		mov ah,00h
		cmp data+1,01h
		je  lt10_1
		jmp egt10_1
		                         ;9 12 20
lt10_1:
                           ;temp=00
        mov al,data+2      ;temp=00+09=09H
        sub al,30h         ;temp=09+0a=13H   13+02=15H                      
        add temp,al        ;temp=15+14=29H   29+00=29H
        jmp p2
egt10_1:
        mov al,data+2
        sub al,30h   
        mov bl,0ah      
        mul bl        
        add temp,al
                          
		mov al,data+3
        sub al,30h
        add temp,al       		
            
               
;for point2:
p2:  		                                   
        lea dx,point
		call getdata
		mov ah,00h
		cmp data+1,01h
		je  lt10_2
		jmp egt10_2 
		                         
lt10_2:                    
        mov al,data+2      
        sub al,30h         
        add temp,al        
        jmp p3
egt10_2:	
        mov al,data+2
        sub al,30h   
        mov dl,0ah      
        mul dl        
        add temp,al  
                          
		mov al,data+3
        sub al,30h
        add temp,al       		
                
;for point3: 
p3:       
		lea dx,point    
		call getdata
		mov ah,00h
		cmp data+1,01h
		je  lt10_3
		jmp egt10_3
                                     
lt10_3:                      
        mov al,data+2      
        sub al,30h         
        add temp,al        
        jmp cavg
egt10_3:	
        mov al,data+2
        sub al,30h   
        mov dl,0ah      
        mul dl        
        add temp,al
                          
		mov al,data+3
        sub al,30h
        add temp,al       		
        
;avg<-ax<-xx
cavg:
        mov al,temp
        mov ah,00h 
        mov dl,03h
        div dl	     ;ax/dl=al   ->al(quotiont) ,ah(remininder)
                              
        mov ah,00h      
        mov dl,0ah 
        div dl      ;->al(quotiont-dahgan) ,ah(remininder-yecan)
        add al,30h
        add ah,30h
        
        ret
addpoints endp         

;************get data*************
getdata  proc
        ;------ message for get data
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

;************search*************
ser proc 
    mov i,00h
    mov bx,0000h
 re:
    mov key_db[bx],'0'
    inc bx
    cmp bx,0005h
    jne re
     
    ;get name key and store it      
    lea dx,message3
    mov ah,9
    int 21h      
    mov ah,0ah
	lea dx,data
	int 21h            ;data: max len d-a-t-a  	
	mov cl,data+1
	inc cl
	mov ch,0
	lea si,data+1
	lea di,namekey
    cld         
	rep movsb
	
	;search   
    mov si, 0000h     ;first index of stu_db
    mov di, 0001h     ;first index of valied namekey       ;len d-a-t-a
    
matching:
    cmp  index,si    ;len(stu_db) == si 
    je   endser      
    
    mov bl, stu_db[si]
    mov cl, namekey[di]
    cmp bl, cl
    je    eq  
    
    ;if not equal 
    ;re init di 
    
    mov   di,0001h
    inc   si 
    jmp matching
      
eq: 
    inc si 
    inc di
    
    ;end of namekey?
    mov cl, namekey 
    mov ch, 0h
    inc cx
    cmp cx,di
    je  addkey     
    
    jmp matching
        
addkey:
    ;we want use si without modify it 
    mov dx,si  
                     
    ;rafte bodim jolo barmigardim :))
    mov bl, namekey
    sub dl, bl   ;sub len of key from dl for finding first of key on the stu_db     
    mov temp, dl ;temp->first index of record                                  
    ;store temp:                                                   
    mov dx,si ;backup si                                          
    mov bl, i
    mov bh, 00h                          
	lea si, temp        ;source -> arrkey : xxxx
	lea di, key_db[bx]  ;destination -> arrarrkey[i]                 
	;len
	mov cl, 01h
	mov ch, 0  
	cld         
	rep movsb
	
	
    inc i   ;i->index of key_db
    ;re init si:
    mov si, dx
    ;re init di:
    mov di, 0001h 
    
    jmp matching
    
;serach finished                 
endser: 
    cmp index,00h  ;stu_db is empty
    je  show_databaseisempty
    cmp index,00h  ;stu_db is not empty and some record found
    jg  show_found
    cmp i,00h      ;stu_db is not empty and no match found
    je  show_notfound
 
show_databaseisempty:
    lea dx,message5
    mov ah,09h
    int 21h 
    jmp finishser
show_found:
    lea dx,message6
    mov ah,09h
    int 21h
    jmp finishser    
show_notfound:
    lea dx,message4
    mov ah,09h
    int 21h
    jmp finishser
finishser:     
    ret           
ser endp    
 
;************remove student proce************* 
rst  proc 
    ;stu_db is empty ?
    cmp index,00h
    je  endrm
     
    call ser
    	
	;start removing
    mov al,i
    mov ah,00h
    mov si,ax  ;si= index+1 of key_db array
del:  
    dec si
    cmp si,0ffffh 
    je  endrm   
    
    mov ah, 00h 
    mov al,key_db[si] 
    mov di, ax     ;di index of a finded record     
s1:      
    mov bl,stu_db[di]
    cmp bl, 3Bh
    jne inc_di
    dec di 
    jmp replacment    
    
inc_di:
    inc di 
    jmp s1  
  
replacment:   
    ;age az ghabl sefr nabod :)
    cmp stu_db[di],30h
    je  del     
    
    ;1 -> 0 
    mov stu_db[di],'0' 
;removed_db <- key_db   
    mov ax,si
    mov dx,di
        
    mov bl,j
    mov bh,00h                    
	lea si, key_db[si] 
	lea di, removed_db[bx] 
	inc j              
	;len
	mov cx,0001h   
	cld         
	rep movsb
	 
	mov si,ax 
	mov di,dx
	  
    jmp  del  
    
endrm:   
    ret  
    
rst  endp    

;************show student proce*************
show proc
    
    lea dx,message2
    mov ah,9
    int 21h
    mov ah,1
	int 21h 
    cmp al,'y'
	je showall
	cmp al,'n'
	je showkey
	
showall: 
    cmp index,00h ;if no record -> index=0 -> there is nothing for show 
	je  endshow
	
    mov   ah,6 ;scroll up window
	mov   al,0 ;0 blank whole window
	mov   ch,0
	mov   cl,0
	mov   dh,24
	mov   dl,79
	mov   bh,14
	int   10h 
	
	;show stu_db
	mov si,00h
l1:   
    mov	dl, offset stu_db[si]
    mov ah,02h ;ah=05h for show in the printer :))))
    int 21h
    inc si
    cmp si,index
    jne l1
	jmp endshow
	
showkey:  
    mov   ah,6 ;scroll up window
	mov   al,0 ;0 blank whole window
	mov   ch,0
	mov   cl,0
	mov   dh,24
	mov   dl,79
	mov   bh,14
	int   10h
	
	call ser
		
	cmp i,00h ;if no match -> i=0 -> there is nothing for show :)
	je  endshow           
	
	;show stu_db with a index key_db 
	
	mov di,00h     ;index of key_db
l2:
    mov al, key_db[di] 
    mov ah,00h
    mov si,ax      ;si->index of a student  
    
l4:
    mov	dl, offset stu_db[si]       ;for show
    
    mov bl, stu_db[si]
    cmp bl,3Bh
    jne l3
    
    inc di
    mov al, i  
    mov ah,00h
    cmp di,ax        ;cmp length of key_db
    jne l2
    	 
	jmp endshow
l3:
    mov ah,02h
    int 21h
    inc si
    jmp l4	 
    
endshow:
	mov ah,1          ;just for wait
    int 21h	
    
    ret
show endp    
                   
;************defrag stu_db proce*************                   
dfd proc     
    cmp j,00h   ;removed_db is empty    
    je  nodfd    
    ;j>0  
    mov al, j
    mov ah, 00h    
    mov si,ax    ;si->index for checking removed data base
     
st: 
    dec si  
    cmp si,0ffffh
    je  enddfd       
              
    mov bl,removed_db[si] 
    mov bh,00h            ;bx->index of removed std on the stu_db
     
replace:    
    mov stu_db[bx],'@'  
    inc bx
    cmp stu_db[bx],';' 
    je replsemi
    jmp replace 
    
replsemi: 
    mov stu_db[bx],'@'
    jmp st

nodfd:
    lea dx,message7
    mov ah,9
    int 21h          
    ret
         
enddfd:
    lea dx,message8
    mov ah,9
    int 21h
    mov j,00h
    mov bx,0000h
    
reinitremoved_db:
    mov removed_db[bx],'0'
    inc bx
    cmp bx,0005h
    jne reinitremoved_db 
    
    ;go to the main defrag function
    call maindfd 
          
    lea dx,message9    ;defrag is done
    mov ah,09h
    int 21h  
       
    ret        
dfd endp
;************main_defrag proce************* 
maindfd proc
    mov bx,0ffffh   ;index for checking stu_db
      
star:
    inc bx
    cmp stu_db[bx],'@'
    je  findendof@    ;index of @ is in the bx
    jmp star  
    
findendof@:
    mov si,bx         
    
inc_si:
    cmp si,index                       
    je  endmaindfd
    inc si   
    cmp stu_db[si],'@' 
    je  inc_si
    
    jmp exchang       ;index of endof@ is in the si   
    
exchang: 
 
    cmp si,index                       
    je  endmaindfd
    
    mov al,stu_db[bx]
    mov cl,stu_db[si] 
    mov stu_db[bx] , cl
    mov stu_db[si] , al
      
    jmp star
     
endmaindfd:
    mov index,bx       
    ret   
maindfd endp    

;************load from file proce************* 
lofi proc
    ;open
    mov ah, 3dh
    mov al, 10b    ;read/write  no limitation 
    lea dx, path
    int 21h
    mov handle_file, ax
    ;read   
    mov ah,3fh
    mov bx,handle_file
    mov cx,00ffh
    lea dx,stu_db
    int 21h
    ;initial index 
    dec ax
    mov index,ax
    ret
lofi endp 
   
;************save to file proce*************    
safi proc 
    ;creat 
    mov ah,3ch
    lea dx,path
    int 21h
    ;open
    mov ah, 3dh
    mov al, 10b         ;read/write  no limitation 
    lea dx,path
    int 21h    
    mov handle_file, ax 
    ;write
    mov ah,40h
    mov bx,handle_file
    mov cx,index
    add al,cl
    lea dx,stu_db
    int 21h
    ret
safi endp  
        
codesg  ends
        end        main