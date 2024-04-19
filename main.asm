.data
filename_prompt:    .asciiz "Digite o nome do arquivo: "        # String de prompt para o usuário.
buffer_filename:    .space 80                                   # Buffer de 80 bytes para armazenar o nome do arquivo.
buffer_line:     .space 1024
buffer_byte: .space 1                                 # Buffer de 1024 bytes para armazenar o conteúdo do arquivo lido.

# Tratamento de erros
error_file_not_found:	.asciiz "\nArquivo não encontrado. Verifique se o arquivo está no mesmo diretório\n"  

.text
main:
    
    # Imprime o prompt	
    li $v0, 4				# syscall para imprimir uma string
    la $a0, filename_prompt		# carrega o endereço do filename_prompt no registrador $a0	
    syscall	

    # Lê o nome do arquivo 
    li $v0, 8				# syscall para ler entrada do usuário
    la $a0, buffer_filename		# carrega o endereço do buffer_filename no registrador $a0
    li $a1, 80				# quantidade de bytes a ler do nome do arquivo
    syscall
       
    jal filenameClean			
    
    # Abrir o arquivo para leitura
    li $v0, 13                        	# syscall para abrir arquivo
    la $a0, buffer_filename           	# carrega o endereço do buffer_filename no registrador $a0
    li $a1, 0                         	# flag para leitura (0=read)
    li $a2, 0                         	# mode (não necessário para leitura)
    syscall
    move $s0, $v0                     	# armazena o descritor do arquivo em $s0
    
    # Tratamento de erro para verificar se o arquivo existe
    slt $t1, $s0, $zero			# verifica se $s0<0. Caso True, o arquivo não foi encontrado e $t1=1
    beq $t1, 1, fileError		# se $t1=1, pula pra branch fileError
    
    # Prepara os registradores para o readFile
    la $s1, buffer_byte			# carrega o endereço do buffer_byte no registrador $s1
    la $s2, buffer_line			# carrega o endereço do buffer_line no registrador $s2  	
    li $s3, 0				# comprimento da linha atual
 			
    jal readFile
    
    # Fechar o arquivo
    li $v0, 16                        	# syscall para fechar arquivo
    move $a0, $s6                     	# descritor do arquivo
    syscall

    FIM:
    # Sair do programa
    li $v0, 10                        	# syscall para terminar a execução
    syscall
    
# Ler o conteúdo do arquivo linha a linha
readFile:
    li $v0, 14                        	# syscall para ler de arquivo
    move $a0, $s0                     	# descritor do arquivo
    move $a1, $s1			# endereço do buffer destino
    li $a2, 1                     	# quantidade de bytes a ler no máximo
    syscall

    blez $v0, readDone			# continua lendo até o byte for menor ou igual a zero (termina o arquivo)
    
    # verifica se foi excedido o tamanho máximo de linha. Termina o read caso True
    slti $t0, $s4, 1024 
    beqz $t0, readDone
    
    # verifica se o byte atual é caractere de quebra de linha (ASCII 10).
    # Caso True, pula pra branch consumeLine pra receber a próxima linha
    lb $s4, ($s1)
    li $t0, 10
    beq $s4, $t0, consumeLine
    
    # Adiciona o byte na linha atual
    add $s5, $s3, $s2
    sb $s4, ($s5) 
    

    addi $s3, $s3, 1			# incrementa o comprimento da linha
    
    b readFile
    		
consumeLine:
    
    # define o fim da linha
    add $s5, $s3, $s2
    sb $zero, ($s5)
    
    li $s3, 0				# reseta o comprimento da linha
    
    # --------------------------------------------------------#
    # Deixei esse trecho pra mostrar que tá imprimindo a linha
    # mas a gente pode começar a tratar cada linha (com a instrução)
    # por meio do $s2
    # - by Henrique Givisiez			
    move $a0, $s2
    li $v0, 4
    syscall
    # --------------------------------------------------------#
    
    # syscall para quebra de linha
    li $a0, 10
    li $v0, 11
    syscall
    
    b readFile

readDone:
    jr $ra
    
# Procedimento que vai "limpar" o caractere de quebra de linha
filenameClean:
    li $t0, 0       			# Inicializa contador do loop.
    li $t1, 80      			# Define limite do loop (tamanho do buffer_filename).
clean: 
    beq $t0, $t1, L2  			# Se atingir o fim do buffer, sai do loop.
    lb $t3, buffer_filename($t0)  	# Carrega byte por byte do buffer_filename.
    bne $t3, 0x0a, L1  			# Se o byte não é uma nova linha, pula para incremento.
    sb $zero, buffer_filename($t0)  	# Se é nova linha, substitui por 0.
L1:
    addi $t0, $t0, 1  			# Incrementa contador do loop.
    j clean           			# Retorna ao início do loop.
L2:
    jr $ra            			# Retorna ao chamador.
    
# Procedimento para imprimir o erro em caso de arquivo não encontrado
fileError:
	la $a0, error_file_not_found    
	li $v0, 4
	syscall
	j FIM
