.data
filename_prompt:    .asciiz "Digite o nome do arquivo: "        # String de prompt para o usu�rio.
buffer_filename:    .space 80                                   # Buffer de 80 bytes para armazenar o nome do arquivo.
buffer_line:     .space 4096                                    # Buffer para armazenar a linha do arquivo.
buffer_byte: .space 1                                           # Buffer para armazenar um byte lido.
data_string: .asciiz ".data"
text_string: .asciiz ".text"
string_text_ok: .asciiz "aqui entrou text\n"
string_data_ok: .asciiz "aqui entrou data\n"

# Tratamento de erros
error_file_not_found:	.asciiz "\nArquivo nao encontrado. Verifique se o arquivo esta no mesmo diretorio\n"  # Mensagem de erro se o arquivo n�o for encontrado.

.text
main:
    # Imprime o prompt
    li $v0, 4                      # syscall para imprimir uma string
    la $a0, filename_prompt        # carrega o endere�o do filename_prompt no registrador $a0
    syscall

    # L� o nome do arquivo 
    li $v0, 8                      # syscall para ler entrada do usu�rio
    la $a0, buffer_filename        # carrega o endere�o do buffer_filename no registrador $a0
    li $a1, 80                     # quantidade de bytes a ler do nome do arquivo
    syscall

    jal filenameClean              # Chama a fun��o para limpar o nome do arquivo
    
    # Abrir o arquivo para leitura
    li $v0, 13                     # syscall para abrir arquivo
    la $a0, buffer_filename        # carrega o endere�o do buffer_filename no registrador $a0
    li $a1, 0                      # flag para leitura (0=read)
    li $a2, 0                      # modo (n�o necess�rio para leitura)
    syscall
    move $s0, $v0                  # armazena o descritor do arquivo em $s0
    
    # Tratamento de erro para verificar se o arquivo existe
    slt $t1, $s0, $zero            # verifica se $s0 < 0. Caso verdadeiro, o arquivo n�o foi encontrado e $t1 = 1
    beq $t1, 1, fileError          # se $t1 = 1, pula para branch fileError
    
    # Prepara os registradores para o readFile
    la $s1, buffer_byte            # carrega o endere�o do buffer_byte no registrador $s1
    la $s2, buffer_line            # carrega o endere�o do buffer_line no registrador $s2
    li $s3, 0                      # comprimento da linha atual
    li $s6, 0                      # flag para ignorar linha ap�s '#'
    jal readFile                   # Chama a fun��o para ler o arquivo
fecharArquivo:    
    # Fechar o arquivo
    li $v0, 16                     # syscall para fechar arquivo
    move $a0, $s6                  # descritor do arquivo
    syscall

FIM:
    # Sair do programa
    li $v0, 10                     # syscall para terminar a execu��o
    syscall
    
# Ler o conte�do do arquivo linha a linha
readFile:
    li $v0, 14                     # syscall para ler de arquivo
    move $a0, $s0                  # descritor do arquivo
    move $a1, $s1                  # endere�o do buffer destino
    li $a2, 1                      # quantidade de bytes a ler no m�ximo
    syscall

    blez $v0, readDone             # continua lendo at� o byte ser menor ou igual a zero (fim do arquivo)
    
    lb $t2, ($s1)                  # l� o byte atual
    li $t3, 35                     # caractere '#'
    beq $t2, $t3, commentFound     # se for '#', pula para commentFound
    
    # verifica se foi excedido o tamanho m�ximo de linha. Termina o read caso verdadeiro
    slti $t0, $s4, 1024 
    beqz $t0, readDone
    
    # verifica se o byte atual � caractere de quebra de linha (ASCII 10).
    # Caso verdadeiro, pula para branch consumeLine para receber a pr�xima linha
    lb $s4, ($s1)
    li $t0, 10
    beq $s4, $t0, consumeLine
    
    beq $s6, 1, skipByte           # se encontrou '#', ignora o byte atual
    
    # Adiciona o byte na linha atual
    add $s5, $s3, $s2
    sb $s4, ($s5) 

    addi $s3, $s3, 1               # incrementa o comprimento da linha
    
    b readFile                     # volta a ler o pr�ximo byte
        		   		   		
commentFound:
    li $s6, 1                      # seta a flag para ignorar o resto da linha
    b readFile                     # volta a ler o pr�ximo byte

skipByte:
    b readFile                     # pula o byte atual e volta a ler o pr�ximo byte
           		   		   		    		   		   		    		   		   		    		   		   		
consumeLine:
    # define o fim da linha
    add $s5, $s3, $s2
    sb $zero, ($s5)
    li $s3, 0                      # reseta o comprimento da linha
    li $s6, 0                      # reseta a flag de coment�rio
    
    
    # verifica se a proxima linha eh a secao ".data"
    la $a2, data_string 	
    jal whichSection
    beqz $v0, dataSegment
    
    # zera o registrador $v0 para comparar a secao .text
    li $v0, 0
    
    # verifica se a proxima linha eh a secao ".text"
    la $a2, text_string 
    jal whichSection
    beqz $v0, textSegment
    
    li $v0, 4                      # syscall para imprimir a linha
    move $a0, $s2
    syscall

    # syscall para quebra de linha
    li $a0, 10
    li $v0, 11
    syscall
    
    b readFile                     # volta a ler o pr�ximo byte

textSegment:
    # LOGICA A IMPLEMENTAR: essa parte so imprime uma string 
    li $v0, 4
    la $a3, string_text_ok
    move $a0, $a3
    syscall
    jr $ra
	
dataSegment:
    # LOGICA A IMPLEMENTAR: essa parte so imprime uma string 
    li $v0, 4
    la $a3, string_data_ok
    move $a0, $a3
    syscall
    jr $ra
	
whichSection:
    # zera os registradores a serem testados
    li $t0, 0 				
    li $t1, 0

    # atribui o endereco das memorias para os registradores $t0 e $t1		
    move $t0, $a2
    move $t1, $s2
    j compare_loop
	
compare_loop:
    lb $t2, 0($t0)          		# Carrega o byte atual da primeira string em $t2
    lb $t3, 0($t1)          		# Carrega o byte atual da segunda string em $t3
    beq $t2, $zero, end_compare 	# Se $t2 for nulo, chegou ao final da string
    beq $t2, $t3, next_char 		# Se $t2 == $t3, pula para a pr�xima compara��o de caractere
    li $v0, 1               		# Define $v0 como 1, strings s�o diferentes
    jr $ra

next_char:
    addi $t0, $t0, 1        # Incrementa o endere�o da primeira string
    addi $t1, $t1, 1        # Incrementa o endere�o da segunda string
    j compare_loop          # Continua a compara��o

end_compare:
    beq $t3, $zero, equal   # Se $t3 tamb�m for nulo, as strings s�o iguais
    li $v0, 1               # Define $v0 como 1, strings s�o diferentes
    jr $ra

equal:
    li $v0, 0               # Define $v0 como 0, strings s�o iguais
    jr $ra
  
readDone:
    li $v0, 4                      # syscall para imprimir a linha final
    move $a0, $s2
    syscall
    j fecharArquivo
    
# Procedimento que vai "limpar" o caractere de quebra de linha
filenameClean:
    li $t0, 0                      # Inicializa contador do loop.
    li $t1, 80                     # Define limite do loop (tamanho do buffer_filename).
clean: 
    beq $t0, $t1, L2               # Se atingir o fim do buffer, sai do loop.
    lb $t3, buffer_filename($t0)   # Carrega byte por byte do buffer_filename.
    bne $t3, 0x0a, L1              # Se o byte n�o � uma nova linha, pula para incremento.
    sb $zero, buffer_filename($t0) # Se � nova linha, substitui por 0.
L1:
    addi $t0, $t0, 1               # Incrementa contador do loop.
    j clean                        # Retorna ao in�cio do loop.
L2:
    jr $ra                         # Retorna ao chamador.
    
# Procedimento para imprimir o erro em caso de arquivo n�o encontrado
fileError:
    la $a0, error_file_not_found   # carrega o endere�o da mensagem de erro
    li $v0, 4                      # syscall para imprimir uma string
    syscall
    j FIM                          # pula para o final do programa
