.data
filename_prompt:    .asciiz "Digite o nome do arquivo: "        # String de prompt para o usuario.
buffer_filename:    .space 80                                   # Buffer de 80 bytes para armazenar o nome do arquivo.
buffer_line:     .space 4096
buffer_byte: .space 1                              

# Tratamento de erros
error_file_not_found:	.asciiz "\nArquivo nao encontrado. Verifique se o arquivo esta no mesmo diretorio\n"  

.text
main:
    
    # Imprime o prompt	
    li $v0, 4				# syscall para imprimir uma string
    la $a0, filename_prompt		# carrega o endereco do filename_prompt no registrador $a0	
    syscall	

    # Le o nome do arquivo 
    li $v0, 8				# syscall para ler entrada do usuario
    la $a0, buffer_filename		# carrega o endereco do buffer_filename no registrador $a0
    li $a1, 80				# quantidade de bytes a ler do nome do arquivo
    syscall
       
    jal filenameClean			
    
    # Abrir o arquivo para leitura
    li $v0, 13                        	# syscall para abrir arquivo
    la $a0, buffer_filename           	# carrega o endereco do buffer_filename no registrador $a0
    li $a1, 0                         	# flag para leitura (0=read)
    li $a2, 0                         	# mode (nao necessario para leitura)
    syscall
    move $s0, $v0                     	# armazena o descritor do arquivo em $s0
    
    # Tratamento de erro para verificar se o arquivo existe
    slt $t1, $s0, $zero			# verifica se $s0<0. Caso True, o arquivo nao foi encontrado e $t1=1
    beq $t1, 1, fileError		# se $t1=1, pula pra branch fileError
    
    # Prepara os registradores para o readFile
    la $s1, buffer_byte			# carrega o endereco do buffer_byte no registrador $s1
    la $s2, buffer_line			# carrega o endereco do buffer_line no registrador $s2  	
    li $s3, 0				# comprimento da linha atual
    li $s6, 0			
    jal readFile
    
    # Fechar o arquivo
    li $v0, 16                        	# syscall para fechar arquivo
    move $a0, $s6                     	# descritor do arquivo
    syscall

    FIM:
    # Sair do programa
    li $v0, 10                        	# syscall para terminar a execucao
    syscall
    
# Ler o conteudo do arquivo linha a linha
readFile:
    li $v0, 14                        	# syscall para ler de arquivo
    move $a0, $s0                     	# descritor do arquivo
    move $a1, $s1			# endereco do buffer destino
    li $a2, 1                     	# quantidade de bytes a ler no maximo
    syscall

    blez $v0, readDone			# continua lendo ate o byte for menor ou igual a zero (termina o arquivo)
    
    lb $t2, ($s1)                      # lê o byte atual
    li $t3, 35                         # caractere '#'
    beq $t2, $t3, commentFound         # se for '#', pula para commentFound
    
    # verifica se foi excedido o tamanho maximo de linha. Termina o read caso True
    slti $t0, $s4, 1024 
    beqz $t0, readDone
    
    # verifica se o byte atual eh caractere de quebra de linha (ASCII 10).
    # Caso True, pula pra branch consumeLine pra receber a proxima linha
    lb $s4, ($s1)
    li $t0, 10
    beq $s4, $t0, consumeLine
    
    beq $s6, 1, skipByte               # se encontrou '#', ignora o byte atual
    
    
    # Adiciona o byte na linha atual
    add $s5, $s3, $s2
    sb $s4, ($s5) 

    addi $s3, $s3, 1			# incrementa o comprimento da linha
    
    b readFile
    
        		   		   		
        		   		   		    		   		   		
commentFound:
    li $s6, 1                           # seta a flag para ignorar o resto da linha
    b readFile

skipByte:
    b readFile 
           		   		   		    		   		   		    		   		   		    		   		   		
consumeLine:
    
    # define o fim da linha
    add $s5, $s3, $s2
    sb $zero, ($s5)
    li $s3, 0				# reseta o comprimento da linha
    li $s6, 0
    
    li $v0, 4
    move $a0, $s2
    syscall

    # syscall para quebra de linha
    li $a0, 10
    li $v0, 11
    syscall
    
    b readFile                        

     
readDone:
    li $v0, 4
    move $a0, $s2
    syscall
    jr $ra
    
# Procedimento que vai "limpar" o caractere de quebra de linha
filenameClean:
    li $t0, 0       			# Inicializa contador do loop.
    li $t1, 80      			# Define limite do loop (tamanho do buffer_filename).
clean: 
    beq $t0, $t1, L2  			# Se atingir o fim do buffer, sai do loop.
    lb $t3, buffer_filename($t0)  	# Carrega byte por byte do buffer_filename.
    bne $t3, 0x0a, L1  			# Se o byte nao eh uma nova linha, pula para incremento.
    sb $zero, buffer_filename($t0)  	# Se eh nova linha, substitui por 0.
L1:
    addi $t0, $t0, 1  			# Incrementa contador do loop.
    j clean           			# Retorna ao inicio do loop.
L2:
    jr $ra            			# Retorna ao chamador.
    
# Procedimento para imprimir o erro em caso de arquivo nao encontrado
fileError:
	la $a0, error_file_not_found    
	li $v0, 4
	syscall
	j FIM
