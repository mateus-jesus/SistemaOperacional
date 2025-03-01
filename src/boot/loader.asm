    bits 16
    org 0x7c00

jmp short main
nop

BPB_OEM     db  'MSWIN4.1'  
BPB_BPS     dw  512         
BPB_SPC     db  1           
BPB_RSC     dw  1           
BPB_FATC    db  2           
BPB_DEC     dw  0xe0        
BPB_NTS     dw  2880        
BPB_MDT     db  0xf0        
BPB_SPFAT   dw  9           
BPB_SPT     dw  18          
BPB_NH      dw  2           
BPB_HS      dd  0           
BPB_LSC     dd  0           

EBR_DN      db  0               
EBR_RES     db  0               
EBR_SIG     db  0x29            
EBR_VID     dd  0x12345678      
EBR_LBL     db  'LEARNING OS'   
EBR_SYS     db  'FAT12   '      

main:
    xor ax, ax      
    mov ds, ax      
    mov es, ax      

    mov ss, ax      
    mov sp, 0x7c00  

clr_screen:
    mov al, 0x03    
    int 0x10

    mov si, msg         
    mov cx, msg_len     
    call print_str

    mov ax, [BPB_SPFAT] 
    mov bl, [BPB_FATC]  
    xor bh, bh          
    mul bx              
    add ax, [BPB_RSC]   
    push ax             

    mov ax, [BPB_DEC]
    shl ax, 5           
    xor dx, dx          
    div word [BPB_BPS]  
    test dx, dx         
    jz read_root_dir    
    inc ax              

read_root_dir:
    mov cl, al          
    pop ax              
    mov dl, [EBR_DN]    
    mov bx, buffer      
    call disk_read      

    xor bx, bx          
    mov di, buffer      
find_kernel:
    mov si, kernel_bin  
    mov cx, 11          
    push di             
    repe cmpsb          
    pop di              
    je kernel_found     
    add di, 32          
    inc bx              
    cmp bx, [BPB_DEC]   
    jl find_kernel      

kernel_not_found:
    mov si, kernel_nf           
    mov cx, kernel_nf_len       
    call print_str              
    jmp halt                    

kernel_found:
    mov ax, [di + 26]           
    mov [kernel_cluster], ax    

    mov ax, [BPB_RSC]           
    mov bx, buffer              
    mov cl, [BPB_SPFAT]         
    mov dl, [EBR_DN]            
    call disk_read              

    mov bx, kernel_ls           
    mov es, bx                  
    mov bx, kernel_lo           

load_kernel_loop:
    mov ax, [kernel_cluster]    
    add ax, 31                  
    mov cl, 1                   
    mov dl, [EBR_DN]            
    call disk_read              

    add bx, [BPB_BPS]           

    mov ax, [kernel_cluster]    
    mov cx, 3                   
    mul cx                      
    mov cx, 2                   
    div cx                      

    mov si, buffer              
    add si, ax                  
    mov ax, [ds:si]             
    test dx, dx                 
    jz is_even                  

is_odd:                         
    shr ax, 4                   
    jmp next_cluster

is_even:                        
    and ax, 0x0fff              

next_cluster:
    cmp ax, 0x0ff8              
    jae read_end                

    mov [kernel_cluster], ax    
    jmp load_kernel_loop        

read_end:                       
    mov dl, [EBR_DN]            
    mov ax, kernel_ls           
    mov ds, ax                  
    mov es, ax                  
    jmp kernel_ls:kernel_lo     

halt:
    cli                 
    hlt                 

print_str:
    pusha
    mov ah, 0x0e        
.char_loop:
    lodsb               
    int 0x10
    loop .char_loop     
    popa
    ret

lba_to_chs:
    push ax             
    push dx             
    xor dx, dx          
    div word [BPB_SPT]  
    inc dx              
    mov cx, dx          
    xor dx, dx          
    div word [BPB_NH]   
    mov dh, dl          
    mov ch, al          
    shl ah, 6           
    or cl, ah           
    pop ax              
    mov dl, al          
    pop ax              
    ret

disk_read:
    pusha               
    push cx             
    ret

