.data
filename_prompt:    .asciiz "Digite o nome do arquivo: "        # String de prompt para o usuário.
buffer_filename:    .space 80                                   # Buffer de 80 bytes para armazenar o nome do arquivo.
buffer_line:     .space 4096                                    # Buffer para armazenar a linha do arquivo.
buffer_byte: .space 1                                           # Buffer para armazenar um byte lido.

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
    la $s1, buffer_byte            # carrega o endereço do buffer_byte no registrador $s1
    la $s2, buffer_line            # carrega o endereço do buffer_line no registrador $s2
    li $s3, 0                      # comprimento da linha atual
    li $s6, 0                      # flag para ignorar linha após '#'
    jal readFile                   # Chama a função para ler o arquivo
    
    # Fechar o arquivo
    li $v0, 16                     # syscall para fechar arquivo
    move $a0, $s6                  # descritor do arquivo
    syscall

FIM:
    # Sair do programa
    li $v0, 10                     # syscall para terminar a execução
    syscall
    
# Ler o conteúdo do arquivo linha a linha
readFile:
    li $v0, 14                     # syscall para ler de arquivo
    move $a0, $s0                  # descritor do arquivo
    move $a1, $s1                  # endereço do buffer destino
    li $a2, 1                      # quantidade de bytes a ler no máximo
    syscall

    blez $v0, readDone             # continua lendo até o byte ser menor ou igual a zero (fim do arquivo)
    
    lb $t2, ($s1)                  # lê o byte atual
    li $t3, 35                     # caractere '#'
    beq $t2, $t3, commentFound     # se for '#', pula para commentFound
    
    # verifica se foi excedido o tamanho máximo de linha. Termina o read caso verdadeiro
    slti $t0, $s4, 1024 
    beqz $t0, readDone
    
    # verifica se o byte atual é caractere de quebra de linha (ASCII 10).
    # Caso verdadeiro, pula para branch consumeLine para receber a próxima linha
    lb $s4, ($s1)
    li $t0, 10
    beq $s4, $t0, consumeLine
    
    beq $s6, 1, skipByte           # se encontrou '#', ignora o byte atual
    
    # Adiciona o byte na linha atual
    add $s5, $s3, $s2
    sb $s4, ($s5) 

    addi $s3, $s3, 1               # incrementa o comprimento da linha
    
    b readFile                     # volta a ler o próximo byte
        		   		   		
commentFound:
    li $s6, 1                      # seta a flag para ignorar o resto da linha
    b readFile                     # volta a ler o próximo byte

skipByte:
    b readFile                     # pula o byte atual e volta a ler o próximo byte
           		   		   		    		   		   		    		   		   		    		   		   		
consumeLine:
    # define o fim da linha
    add $s5, $s3, $s2
    sb $zero, ($s5)
    li $s3, 0                      # reseta o comprimento da linha
    li $s6, 0                      # reseta a flag de comentário
    
    li $v0, 4                      # syscall para imprimir a linha
    move $a0, $s2
    syscall

    # syscall para quebra de linha
    li $a0, 10
    li $v0, 11
    syscall
    
    b readFile                     # volta a ler o próximo byte

readDone:
    li $v0, 4                      # syscall para imprimir a linha final
    move $a0, $s2
    syscall
    jr $ra                         # retorna para o chamador
    
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
