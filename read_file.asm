.data
filename_prompt:    .asciiz "Digite o nome do arquivo: "        # String de prompt para o usuário.
buffer_filename:    .space 80                                   # Buffer de 80 bytes para armazenar o nome do arquivo.
buffer_content:     .space 1024                                 # Buffer de 1024 bytes para armazenar o conteúdo do arquivo lido.

.text
main:
    # Imprime o prompt	
    li $v0, 4				# syscall para imprimir uma string
    la $a0, filename_prompt		# endereço do filename_prompt	
    syscall	
    
    # Lê o nome do arquivo 
    li $v0, 8				# syscall para ler entrada do usuário
    la $a0, buffer_filename		# endereço do buffer_filename
    li $a1, 80				# quantidade de bytes a ler 
    syscall
    
    jal filenameClean			
    	
    # Abrir o arquivo para leitura
    li $v0, 13                        	# syscall para abrir arquivo
    la $a0, buffer_filename           	# endereço do nome do arquivo
    li $a1, 0                         	# flag para leitura (0=read)
    li $a2, 0                         	# mode (não necessário para leitura)
    syscall
    move $s6, $v0                     	# armazena o descritor do arquivo em $s6

    # Ler o conteúdo do arquivo
    li $v0, 14                        	# syscall para ler de arquivo
    move $a0, $s6                     	# descritor do arquivo
    la $a1, buffer_content            	# ponteiro para o buffer
    li $a2, 1024                      	# quantidade de bytes a ler
    syscall
    move $s7, $v0                     	# armazena o número de bytes lidos em $s7

    # Fechar o arquivo
    li $v0, 16                        	# syscall para fechar arquivo
    move $a0, $s6                     	# descritor do arquivo
    syscall

    # Imprimir o conteúdo do buffer
    li $v0, 4                         	# syscall para imprimir string
    la $a0, buffer_content            	# endereço do buffer
    syscall

    # Sair do programa
    li $v0, 10                        	# syscall para terminar a execução
    syscall
    
filenameClean:
    li $t0, 0       			# Inicializa contador do loop.
    li $t1, 80      			# Define limite do loop (tamanho do buffer_filename).
clean:
    beq $t0, $t1, L5  			# Se atingir o fim do buffer, sai do loop.
    lb $t3, buffer_filename($t0)  	# Carrega byte por byte do buffer_filename.
    bne $t3, 0x0a, L6  			# Se o byte não é uma nova linha, pula para incremento.
    sb $zero, buffer_filename($t0)  	# Se é nova linha, substitui por 0.
L1:
    addi $t0, $t0, 1  			# Incrementa contador do loop.
    j clean           			# Retorna ao início do loop.
L2:
    jr $ra            			# Retorna ao chamador.
