org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A 

start: 
  jmp main




puts: 
  push si 
  push ax 


.loop: 
  lodsb ; carrega o proximo em al 
  or al, al 
  jz .done ; se al for zero, termina



  mov ah, 0x0e 
  int 0x10

  jmp .loop


.done: 
  pop ax
  pop si 
  ret 

main: 
  mov ax, 0
  mov ds, ax
  mov es, ax

   mov ss, ax
   mov sp, 0x7C00 ; define pra stack crescer no sentido decrescente a onde comeca o programa

  ;mensagem de boas vindas
  mov si, msg_bemvindo
  call puts 


hlt


.halt:

  jmp .halt





msg_bemvindo: db 'Bem vindo ao sistema Operacional do Mateus', ENDL, 0


times 510-($-$$) db 0
dw 0AA55h
