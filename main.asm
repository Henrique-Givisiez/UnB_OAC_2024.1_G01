.data
filename_prompt:    .asciiz "Digite o nome do arquivo: "        # String de prompt para o usuário.

buffer_filename:    .space 80                                   # Buffer de 80 bytes para armazenar o nome do arquivo.
buffer_line:     .space 4096                                    # Buffer para armazenar a linha do arquivo.
buffer_byte: .space 1                                           # Buffer para armazenar um byte lido.

conteudo_data: .space 1048576					# Espaço de 1MB para guardar o conteúdo da parte .data do arquivo
conteudo_text: .space 1048576					# Espaço de 1MB para guardar o conteúdo da parte .text do arquivo

posicao_atual_data: .word 0
posicao_atual_text: .word 0

data_string: .asciiz ".data"
text_string: .asciiz ".text"
string_text_ok: .asciiz "aqui entrou text\n"
string_data_ok: .asciiz "aqui entrou data\n"

# Tratamento de erros
error_file_not_found:	.asciiz "\nArquivo nao encontrado. Verifique se o arquivo esta no mesmo diretorio\n"  # Mensagem de erro se o arquivo não for encontrado.

.text
main:
    # Imprime o prompt
    li $v0, 4                      # syscall para imprimir uma string
    la $a0, filename_prompt        # carrega o endereço do filename_prompt no registrador $a0
    syscall

    # Lê o nome do arquivo 
    li $v0, 8                      # syscall para ler entrada do usuário
    la $a0, buffer_filename        # carrega o endereço do buffer_filename no registrador $a0
    li $a1, 80                     # quantidade de bytes a ler do nome do arquivo
    syscall

    jal filenameClean              # Chama a função para limpar o nome do arquivo
    
    # Abrir o arquivo para leitura
    li $v0, 13                     # syscall para abrir arquivo
    la $a0, buffer_filename        # carrega o endereço do buffer_filename no registrador $a0
    li $a1, 0                      # flag para leitura (0=read)
    li $a2, 0                      # modo (não necessário para leitura)
    syscall
    move $s0, $v0                  # armazena o descritor do arquivo em $s0
    
    # Tratamento de erro para verificar se o arquivo existe
    slt $t1, $s0, $zero            # verifica se $s0 < 0. Caso verdadeiro, o arquivo não foi encontrado e $t1 = 1
    beq $t1, 1, fileError          # se $t1 = 1, pula para branch fileError
    
    # Prepara os registradores para o readFile
    li $s3, 0                      # comprimento da linha atual
    
    li $s6, 0                      # flag para ignorar linha após '#'
    
    li $s7, 1			   # flag para saber se é parte do .data ou do .text
    
    li $s1, 0 			   # Verificador de string .data
    li $s2, 0 			   # Verificador de string .text
    
    jal readFile                   # Chama a função para ler o arquivo
 
quebras_linha:
    
    li $v0, 11
    
    li $a0, 10
    syscall
    syscall 
   
    j imprimir_tudo_text
    
fecharArquivo:    
    # Fechar o arquivo
    li $v0, 16                     # syscall para fechar arquivo
    move $a0, $s6                  # descritor do arquivo
    syscall

checar_conteudo_data_text:
    
    move $t0, $zero
    move $t1, $zero
    
    li $v0, 11
    
    li $a0, 10
    syscall
    syscall 
    
    imprimir_tudo_data:
    	li $v0, 11
    	lb $a0, conteudo_data($t0)
    	beq $a0, $zero, quebras_linha
    	syscall
    	
    	addi $t0, $t0, 1
    	j imprimir_tudo_data
    	
    imprimir_tudo_text:
    	li $v0, 11
    	lb $a0, conteudo_text($t1)
    	beq $a0, $zero, FIM
    	syscall
    	
    	addi $t1, $t1, 1
    	j imprimir_tudo_text
    	
FIM:
    # Sair do programa
    li $v0, 10                     # syscall para terminar a execução
    syscall
    
# Ler o conteúdo do arquivo linha a linha
readFile:
    li $v0, 14                     # syscall para ler de arquivo
    move $a0, $s0                  # descritor do arquivo
    la $t5, buffer_byte
    move $a1, $t5                  # endereço do buffer destino
    li $a2, 1                      # quantidade de bytes a ler no máximo
    syscall
    
    blez $v0, readDone             # continua lendo até o byte ser menor ou igual a zero (fim do arquivo)
    
    # Verifica se o contexto atual é .data ou .text
    ###############################################################################################
    slti $t7, $s3, 5		   # Verifica se o atual caracter já é o quinto caractere lido
    
    seq $t8, $s1, $s3		   # Verifica se a contagem atual de caracteres na linha é igual ao comparador de .data
    seq $t9, $s2, $s3		   # Verifica se a contagem atual de caracteres na linha é igual ao comparador de .text
    
    or $t1, $t8, $t9		   # Verifica se uma das string ".data" ou ".text" ainda está sendo formada
    
    and $t2, $t1, $t7		   # Verifica se uma das string foi atingida e se já passamos do caractere 5
    
    li $t3, 1
    beq $t2, $t3, analise_data_text
    
    li $t6, 5
    
    # Apenas um dos dois é 1, ou nenhum dos dois
    seq $t1, $t6, $s1	           # Reconhece como ".data"
    seq $t2, $t6, $s2		   # Reconhece como ".text"
    
    beq $t1, $t2, preencher_buffer # Caso tanto $t1, quanto $t2 forem 0
     
    li $t3, 1
    seq $s7, $t1, $t3		  # Verifica se a flag deve mudar para o contexto de ".data"
    sub $s7, $s7, $t1		  # Mantem o valor de $s7 como sendo 0
    
    seq $s7, $t2, $t3		  # Verifica se a flag deve mudar para o contexto de ".text"
    ###############################################################################################

    j preencher_buffer
    
preencher_buffer:
    lb $t2, buffer_byte($zero)     # lê o byte atual
    li $t3, 35                     # caractere '#'
    beq $t2, $t3, commentFound     # se for '#', pula para commentFound
    
    # verifica se foi excedido o tamanho máximo de linha. Termina o read caso verdadeiro
    slti $t0, $s4, 1024
    beqz $t0, readDone
    
    # verifica se o byte atual é caractere de quebra de linha (ASCII 10).
    # Caso verdadeiro, pula para branch consumeLine para receber a próxima linha
    lb $s4, buffer_byte($zero)
    li $t0, 10
    beq $s4, $t0, consumeLine

    beq $s6, 1, skipByte           # se encontrou '#', ignora o byte atual
    
    # Adiciona o byte na linha atual
    la $t5, buffer_line
    add $s5, $s3, $t5
    sb $s4, ($s5) 

    addi $s3, $s3, 1               # incrementa o comprimento da linha
    
    seq $t1, $s7, $zero		   # $t1 é 1 se o contexto é ".data"
    bnez $t1, contexto_data	   # Caso o contexto seja .data
    j contexto_text		   # Caso o contexto não seja .data
    
analise_data_text:
    lb $t2, buffer_byte($zero)	   # Último caracter lido
    lb $t6, data_string($s3)	   # Código para o caracter correspondente na string ".data"
    
    seq $t7, $t2, $t6		   # 1 Se o último caracter lido for igual ao correspondente em ".data"
    
    add $s1, $s1, $t7		   # Adiciona 1 se os caracteres foram iguais, e 0 se não

    lb $t6, text_string($s3)	   # Código para o caracter correspondente na string ".text"
    
    seq $t7, $t2, $t6		   # 1 Se o último caracter lido for igual ao correspondente em ".text"
    
    add $s2, $s2, $t7		   # Adiciona 1 se os caracteres foram iguais, e 0 se não
    
    j preencher_buffer
    
contexto_data:
    lb $t2, buffer_byte($zero)	       # Último caracter lido
    lw $t1, posicao_atual_data($zero)         # Próximo endereço no array
    
    sb $t2, conteudo_data($t1)	       # Inclui o caractere no espaço destinado a .data
    
    addi $t1, $t1, 1
    sw $t1, posicao_atual_data($zero)         # Incrementa uma posição para o próximo acesso
    
    j readFile
    
contexto_text:
    lb $t2, buffer_byte($zero)	       # Último caracter lido
    lw $t1, posicao_atual_text($zero)         # Próximo endereço no array
    
    sb $t2, conteudo_text($t1)	       # Inclui o caractere no espaço destinado a .text
    
    addi $t1, $t1, 1
    sw $t1, posicao_atual_text($zero)         # Incrementa uma posição para o próximo acesso
    
    j readFile  
    
commentFound:
    li $s6, 1                      # seta a flag para ignorar o resto da linha
    b readFile                     # volta a ler o próximo byte
    
skipByte:
    b readFile                     # pula o byte atual e volta a ler o próximo byte
    
consumeLine:
    # define o fim da linha
    la $t5, buffer_line
    add $s5, $s3, $t5
    sb $zero, ($s5)
    li $s3, 0                      # reseta o comprimento da linha
    li $s6, 0                      # reseta a flag de comentário
    li $s1, 0 			   # reseta a contagem de ".data"
    li $s2, 0 			   # reseta a contagem de ".text"
    
    li $v0, 4                      # syscall para imprimir a linha
    la $t5, buffer_line
    move $a0, $t5
    syscall

    # syscall para quebra de linha
    li $a0, 10
    li $v0, 11
    syscall
    
    b readFile                     # volta a ler o próximo byte
    
readDone:
    li $v0, 4                      # syscall para imprimir a linha final
    la $t5, buffer_line
    move $a0, $t5
    syscall
    j fecharArquivo
    
# Procedimento que vai "limpar" o caractere de quebra de linha
filenameClean:
    li $t0, 0                      # Inicializa contador do loop.
    li $t1, 80                     # Define limite do loop (tamanho do buffer_filename).
clean: 
    beq $t0, $t1, L2               # Se atingir o fim do buffer, sai do loop.
    lb $t3, buffer_filename($t0)   # Carrega byte por byte do buffer_filename.
    bne $t3, 0x0a, L1              # Se o byte não é uma nova linha, pula para incremento.
    sb $zero, buffer_filename($t0) # Se é nova linha, substitui por 0.
L1:
    addi $t0, $t0, 1               # Incrementa contador do loop.
    j clean                        # Retorna ao início do loop.
L2:
    jr $ra                         # Retorna ao chamador.
    
# Procedimento para imprimir o erro em caso de arquivo não encontrado
fileError:
    la $a0, error_file_not_found   # carrega o endereço da mensagem de erro
    li $v0, 4                      # syscall para imprimir uma string
    syscall
    j FIM                          # pula para o final do programa
    
    
    
 #######################################
