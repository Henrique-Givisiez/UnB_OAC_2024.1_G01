.data
filename_prompt:    .asciiz "Digite o nome do arquivo: "        # String de prompt para o usu?rio.
buffer_filename:    .space 80       # Buffer de 80 bytes para armazenar o nome do arquivo.
buffer_line:     .space 4096                                    # Buffer para armazenar a linha do arquivo.
buffer_byte: .space 1                                           # Buffer para armazenar um byte lido.
localArquivoData: .space 80 # Caminho do arquivo _data.mif que ser� criado
localArquivoText: .space 80 # Caminho do arquivo _text.mif que ser� criado
data_string: .asciiz ".data"
text_string: .asciiz ".text"
string_text_ok: .asciiz "aqui entrou text\n"
string_data_ok: .asciiz "aqui entrou data\n"

dataExtension: .asciiz "_data.mif"
textExtension: .asciiz "_text.mif"
startData: .ascii "DEPTH = 16384;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
startText: .ascii "DEPTH = 4096;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"

# Tratamento de erros
error_file_not_found: .asciiz "\nArquivo nao encontrado. Verifique se o arquivo esta no mesmo diretorio\n"  # Mensagem de erro se o arquivo n�o for encontrado.

# Strings instruções
add_string:    .asciiz "add"
sub_string:    .asciiz "sub"
and_string:    .asciiz "and"
or_string:     .asciiz "or"
nor_string:    .asciiz "nor"
xor_string:    .asciiz "xor"
slt_string:    .asciiz "slt"
addu_string:   .asciiz "addu"
subu_string:   .asciiz "subu"
sllv_string:   .asciiz "sllv"
srav_string:   .asciiz "srav"
mult_string:   .asciiz "mult"
div_string:    .asciiz "div"
mfhi_string:   .asciiz "mfhi"
mflo_string:   .asciiz "mflo"
clo_string:    .asciiz "clo"
clz_string:    .asciiz "clz"
movn_string:   .asciiz "movn"
mul_string:    .asciiz "mul"
jr_string:     .asciiz "jr"
jalr_string:   .asciiz "jalr"
lw_string:     .asciiz "lw"
sw_string:     .asciiz "sw"
beq_string:    .asciiz "beq"
bne_string:    .asciiz "bne"
lui_string:    .asciiz "lui"
sll_string:    .asciiz "sll"
srl_string:    .asciiz "srl"
addi_string:   .asciiz "addi"
andi_string:   .asciiz "andi"
ori_string:    .asciiz "ori"
xori_string:   .asciiz "xori"
bgez_string:   .asciiz "bgez"
sra_string:    .asciiz "sra"
bgezal_string: .asciiz "bgezal"
addiu_string:  .asciiz "addiu"
lb_string:     .asciiz "lb"
sb_string:     .asciiz "sb"
slti_string:   .asciiz "slti"
sltu_string:   .asciiz "sltu"
bltzal_string: .asciiz "bltzal"
lhu_string:    .asciiz "lhu"
j_string:      .asciiz "j"
jal_string:    .asciiz "jal"

# Valores de opcode de cada comando
add_opcode:    .asciiz "000000"
sub_opcode:    .asciiz "000000"
and_opcode:    .asciiz "000000"
or_opcode:     .asciiz "000000"
nor_opcode:    .asciiz "000000"
xor_opcode:    .asciiz "000000"
slt_opcode:    .asciiz "000000"
addu_opcode:   .asciiz "000000"
subu_opcode:   .asciiz "000000"
sllv_opcode:   .asciiz "000000"
srav_opcode:   .asciiz "000000"
mult_opcode:   .asciiz "000000"
div_opcode:    .asciiz "000000"
mfhi_opcode:   .asciiz "000000"
mflo_opcode:   .asciiz "000000"
clo_opcode:    .asciiz "011100"
clz_opcode:    .asciiz "011100"
movn_opcode:   .asciiz "000000"
mul_opcode:    .asciiz "011100"
jr_opcode:     .asciiz "000000"
jalr_opcode:   .asciiz "000000"
lw_opcode:     .asciiz "000010"
sw_opcode:     .asciiz "101011"
beq_opcode:    .asciiz "000100"
bne_opcode:    .asciiz "000101"
lui_opcode:    .asciiz "001111"
sll_opcode:    .asciiz "000000"
srl_opcode:    .asciiz "000000"
addi_opcode:   .asciiz "001000"
andi_opcode:   .asciiz "001100"
ori_opcode:    .asciiz "001101"
xori_opcode:   .asciiz "001110"
bgez_opcode:   .asciiz "000001"
sra_opcode:    .asciiz "000000"
bgezal_opcode: .asciiz "000001"
addiu_opcode:  .asciiz "001001"
lb_opcode:     .asciiz "100000"
sb_opcode:     .asciiz "101000"
slti_opcode:   .asciiz "001010"
sltu_opcode:   .asciiz "000000"
bltzal_opcode: .asciiz "000001"
lhu_opcode:    .asciiz "100101"
j_opcode:      .asciiz "000010"
jal_opcode:    .asciiz "000011"

add_funct:  .asciiz "100000" # valores de funct
sub_funct:  .asciiz "100010"
and_funct:  .asciiz "100100"
or_funct:   .asciiz "100101"
nor_funct:  .asciiz "100111"
xor_funct:  .asciiz "100110"
jr_funct:   .asciiz "001000"
jalr_funct: .asciiz "001001"
slt_funct:  .asciiz "101010"
addu_funct: .asciiz "100001"
subu_funct: .asciiz "100011"
mult_funct: .asciiz "011000"
div_funct:  .asciiz "011010"
mfhi_funct: .asciiz "010000"
mflo_funct: .asciiz "010010"
clo_funct:  .asciiz "100001" 
clz_funct:  .asciiz "100000"
sllv_funct: .asciiz "000100"
srav_funct: .asciiz "000111"
sra_funct:  .asciiz "000011"
movn_funct: .asciiz "001011"
mul_funct:  .asciiz "000010"
srl_funct:  .asciiz "000010"
sll_funct:  .asciiz "000000"
sltu_funct: .asciiz "101011"

reg_zero: .asciiz "00000" # endereços dos registradores
reg_at:   .asciiz "00001"
reg_v0:   .asciiz "00010"
reg_v1:   .asciiz "00011"
reg_a0:   .asciiz "00100"
reg_a1:   .asciiz "00101"
reg_a2:   .asciiz "00110"
reg_a3:   .asciiz "00111"
reg_t0:   .asciiz "01000"
reg_t1:   .asciiz "01001"
reg_t2:   .asciiz "01010"
reg_t3:   .asciiz "01011"
reg_t4:   .asciiz "01100"
reg_t5:   .asciiz "01101"
reg_t6:   .asciiz "01110"
reg_t7:   .asciiz "01111"
reg_s0:   .asciiz "10000"
reg_s1:   .asciiz "10001"
reg_s2:   .asciiz "10010"
reg_s3:   .asciiz "10011"
reg_s4:   .asciiz "10100"
reg_s5:   .asciiz "10101"
reg_s6:   .asciiz "10110"
reg_s7:   .asciiz "10111"
reg_t8:   .asciiz "11000"
reg_t9:   .asciiz "11001"
reg_k0:   .asciiz "11010"
reg_k1:   .asciiz "11011"
reg_gp:   .asciiz "11100"
reg_sp:   .asciiz "11101"
reg_fp:   .asciiz "11110"
reg_ra:   .asciiz "11111"

tipo_j: .word j_string, jal_string
size_tipo_j: .word 2
tipo_i: .word

.text
main:
    # Imprime o prompt
    li $v0, 4                      # syscall para imprimir uma string
    la $a0, filename_prompt        # carrega o endereço do filename_prompt no registrador $a0
    syscall

    # Le o nome do arquivo 
    li $v0, 8                      # syscall para ler entrada do usuario
    la $a0, buffer_filename        # carrega o endereco do buffer_filename no registrador $a0
    li $a1, 80                     # quantidade de bytes a ler do nome do arquivo
    syscall

    jal filenameClean              # Chama a funcao para limpar o nome do arquivo
    
    # Inicialize registradores
    la $s0, buffer_filename  # Aponte para o inicio de localArquivo
    la $s1, localArquivoData  # Aponte para o espaco de localArquivoData
    la $s2, localArquivoText  # Aponte para o espaco de localArquivoText

    # Copie o conteudo de localArquivo em localArquivoData e localArquivoText
    copy_loop:
        lb $t7, ($s0)  # Carregue o caractere de localArquivo
        beqz $t7, copy_extensions  # Se for nulo, va para a copia das extensoes
        beq $t7, 46, copy_extensions  # Se for um ponto, va para a copia das extensoes
        sb $t7, ($s1)  # Copie o caractere para localArquivoData
        sb $t7, ($s2)  # Copie o caractere para localArquivoText
        addi $s0, $s0, 1  # Avance para o proximo caractere em localArquivo
        addi $s1, $s1, 1  # Avance para o proximo caractere em localArquivoData
        addi $s2, $s2, 1  # Avance para o proximo caractere em localArquivoText
        j copy_loop

    copy_extensions:
    # Copie as extensoes em localArquivoData e localArquivoText
    la $s6, dataExtension  # Aponte para a extensao "_data.mif"
    la $s7, textExtension  # Aponte para a extensao "_text.mif"

    copy_data_extension:
        lb $t7, ($s6)  # Carregue o caractere da extensao "_data.mif"
        beqz $t7, copy_text_extension  # Se for nulo, va para a copia da extensao "_text.mif"
        sb $t7, ($s1)  # Copie o caractere para localArquivoData
        addi $s1, $s1, 1  # Avance para o proximo caractere em localArquivoData
        addi $s6, $s6, 1  # Avance para o proximo caractere na extensao "_data.mif"
        j copy_data_extension

    copy_text_extension:
        lb $t7, ($s7)  # Carregue o caractere da extensao "_text.mif"
        beqz $t7, copy_done  # Se for nulo, termine
        sb $t7, ($s2)  # Copie o caractere para localArquivoText
        addi $s2, $s2, 1  # Avance para o proximo caractere em localArquivoText
        addi $s7, $s7, 1  # Avance para o proximo caractere na extensao "_text.mif"
        j copy_text_extension

    copy_done:
    # Terminar as strings com um caractere nulo
    sb $zero, ($s1)
    sb $zero, ($s2)
    
    # Abrir o arquivo para leitura
    li $v0, 13                     # syscall para abrir arquivo
    la $a0, buffer_filename        # carrega o endereco do buffer_filename no registrador $a0
    li $a1, 0                      # flag para leitura (0=read)
    li $a2, 0                      # modo (nao necessario para leitura)
    syscall
    move $s0, $v0                  # armazena o descritor do arquivo em $s0
    
    # Tratamento de erro para verificar se o arquivo existe
    slt $t1, $s0, $zero            # verifica se $s0 < 0. Caso verdadeiro, o arquivo nao foi encontrado e $t1 = 1
    beq $t1, 1, fileError          # se $t1 = 1, pula para branch fileError

    # Prepara os registradores para o readFile
    la $s1, buffer_byte            # carrega o endereco do buffer_byte no registrador $s1
    la $s2, buffer_line            # carrega o endereco do buffer_line no registrador $s2
    move $s7, $s2		   # indice inicial do primeiro caractere depois de uma quebra de linha
    li $s3, 0                      # comprimento da linha atual
    li $s6, 0                      # flag para ignorar linha apos '#'
    j readFile                   # Chama a funcao para ler o arquivo


fecharArquivo:    
    # Fechar o arquivo
    li $v0, 16                     # syscall para fechar arquivo
    move $a0, $s6                  # descritor do arquivo
    syscall
    j readMemory
    
FIM:
    # Sair do programa
    li $v0, 10                     # syscall para terminar a execucao
    syscall
    
# Ler o conteudo do arquivo linha a linha
readFile:
    li $v0, 14                     # syscall para ler de arquivo
    move $a0, $s0                  # descritor do arquivo
    move $a1, $s1                  # endereco do buffer destino
    li $a2, 1                      # quantidade de bytes a ler no maximo
    syscall

    blez $v0, readDone             # continua lendo ate o byte ser menor ou igual a zero (fim do arquivo)
    
    lb $t2, ($s1)                  # le o byte atual
    li $t3, 35                     # caractere '#'
    beq $t2, $t3, commentFound     # se for '#', pula para commentFound
    
    # verifica se foi excedido o tamanho maximo de linha. Termina o read caso verdadeiro
    slti $t0, $s3, 1024 
    beqz $t0, readDone
    
    # verifica se o byte atual eh caractere de quebra de linha (ASCII 10).
    # Caso verdadeiro, pula para branch consumeLine para receber a proxima linha
    lb $s4, ($s1)
    li $t0, 10
    beq $s4, $t0, consumeLine
    li $t0, 9
    beq $s4, $t0, readFile # remove tab
    li $t0, 32
    beq $s4, $t0, readFile # remove espa�o em branco
    beq $s6, 1, skipByte           # se encontrou '#', ignora o byte atual
    
    # Adiciona o byte na linha atual
    add $s5, $s3, $s2
    sb $s4, ($s5) 

    addi $s3, $s3, 1               # incrementa o comprimento da linha
    
    b readFile                     # volta a ler o proximo byte

quebraLinha:

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
	
 	# pega o endereco de $s5 e copia para $s7. O objetivo � ir copiando o endereco a cada quebra de linha
	move $s7, $s5 
	addi $s7, $s7, 1
	addi $s3, $s3, 1 # contador
	add $s5, $s3, $s2 # endereco final
	
readMemory:
	la $t1, ($s2) #endereco inicial
	lb $t2, ($s5) #valor do endereco inicial
    	beq $t2, 10, quebraLinha
    	beqz $t2, FIM
    	li $v0, 0
    	
	addi $s3, $s3, 1 # contador
	add $s5, $s3, $s2 # endereco final
	b readMemory

prepara_loop:
	li $t3, 0 # zera o registrador // tambem vai ser o indice atual do loop
	sb $t3, ($s5) # zera o espaco em branco e separa a instrucao
	lw $t2, size_tipo_j # tamanho do array 
	la $t0, tipo_j # carrega o endereco array de instrucoes tipo J
	
which_instruction_loop:
	beq $t3, $t2, naoEntrou
	lw $a0, 0($t0) # pega o elemento atual do array e coloca no $a0
	addiu $t0, $t0, 4
	la $a1, ($t1) # pega o endereco da instrucao separada e coloca no $a1
        jal strcmp
   	beq $v0, 0, instrucao_tipo_j
   	addiu $t3, $t3, 1         	    	
        j which_instruction_loop
        
naoEntrou:
    li $v0, 4
    la $a0, string_text_ok
    syscall
    j FIM
    
# Fun��o de compara��o de strings
strcmp:
    lb $t5, 0($a0)       # Carregar byte da string no array
    lb $t4, 0($a1)       # Carregar byte da string alvo
    beqz $t5, check_end  # Se fim da string no array, verificar
    beqz $t4, check_end  # Se fim da string alvo, verificar
    bne $t5, $t4, strcmp_not_equal # Se diferentes, strings n�o s�o iguais
    addiu $a0, $a0, 1    # Incrementar ponteiros de ambas strings
    addiu $a1, $a1, 1
    j strcmp             # Repetir compara��o para o pr�ximo caractere

check_end:
    beq $t5, $t4, strcmp_equal

strcmp_not_equal:
    li $v0, 1            # Retornar 1 (n�o iguais)
    jr $ra
    
strcmp_equal:
    li $v0, 0            # Retornar 0 (iguais)
    jr $ra
    
instrucao_tipo_j:    
    li $v0, 4
    la $a0, string_data_ok
    syscall
    j FIM
    
commentFound:
    li $s6, 1                      # seta a flag para ignorar o resto da linha
    b readFile                     # volta a ler o proximo byte

skipByte:
    b readFile                     # pula o byte atual e volta a ler o próximo byte
	    		   		   		    		   		   		    		   		   	          		   		   		    		   		   		    		   		   		    		   		   				   		    		   		   		    		   		   		    		   		   	          		   		   		    		   		   		    		   		   		    		   		   				   		    		   		   		    		   		   		    		   		   	          		   		   		    		   		   		    		   		   		    		   		   		   		    		   		   		    		   		   		    		   		   	          		   		   		    		   		   		    		   		   		    		   		   		    		   		   		    		   		   		    		   		   	          		   		   		    		   		   		    		   		   		    		   		   				   		    		   		   		    		   		   		    		   		   	          		   		   		    		   		   		    		   		   		    		   		   				   		    		   		   		    		   		   		    		   		   	          		   		   		    		   		   		    		   		   		    		   		   		   		    		   		   		    		   		   		    		   		   	          		   		   		    		   		   		    		   		   		    		   		   		
consumeLine:
    lb $t4, ($s5)
    beq $t4, $t0, readFile
    
    # define o fim da linha
    add $s5, $s3, $s2
    sb $s4, ($s5)
    addi $s3, $s3, 1
    #li $s3, 0                      # reseta o comprimento da linha
    li $s6, 0                      # reseta a flag de comentário

    b readFile                     # volta a ler o proximo byte

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
    move $t1, $s7
    j compare_loop
	
compare_loop:
    lb $t2, 0($t0)          		# Carrega o byte atual da primeira string em $t2
    lb $t3, 0($t1)          		# Carrega o byte atual da segunda string em $t3
    beq $t2, $zero, end_compare 	# Se $t2 for nulo, chegou ao final da string
    beq $t2, $t3, next_char 		# Se $t2 == $t3, pula para a proxima comparacao de caractere
    li $v0, 1               		# Define $v0 como 1, strings sao diferentes
    jr $ra

next_char:
    addi $t0, $t0, 1        # Incrementa o endereco da primeira string
    addi $t1, $t1, 1        # Incrementa o endereco da segunda string
    j compare_loop          # Continua a comparacao

end_compare:
    li $t4, 10
    beq $t3, $t4, equal   # Se $t3 tambem for nulo, as strings são iguais
    li $v0, 1               # Define $v0 como 1, strings sao diferentes
    jr $ra

equal:
    li $v0, 0               # Define $v0 como 0, strings sao iguais
    jr $ra
  
readDone:
    la $s5, ($s2)
    li $t3, 0
    li $s3, 0
    li $v0, 0
    j fecharArquivo

criaArquivos:

    # Abrir o arquivo para escrita (ou criar se não existir)
    li $v0, 13            # Codigo da chamada de sistema para abrir ou criar arquivo
    la $a0, localArquivoText     # Carregue o endereco da string com o nome do arquivo
    li $a1, 1             # Modo de abertura (1 para escrita)
    li $a2, 0             # Permissões (não importa para escrita)
    syscall
    
    move $s6, $v0 #copia do descritor

    # Escrever a string inicial no arquivo de data
    li $v0, 15 # Codigo da chamada de sistema para escrever no arquivo
    move $a0, $s6 # Descritor de arquivo para escrita
    la $a1, startText # Endereco da string a ser escrita
    li $a2, 81 # Comprimento da string a ser escrita (ajuste conforme necessario)
    syscall

    # Ler o conteúdo da memória apontada por $s5 e escrever no arquivo .text
    move $t0, $s2         # Endereço da memória apontado por $s5
    li $t1, 0             # indice para percorrer a memória
    
    jal escreve_conteudo_text

    # Fechar o arquivo
    li $v0, 16 # Codigo da chamada de sistema para fechar arquivo
    move $a0, $s6 # Descritor de arquivo a ser fechado
    syscall
	
    # Abrir o arquivo para escrita (ou criar se não existir)
    li $v0, 13            # Codigo da chamada de sistema para abrir ou criar arquivo
    la $a0, localArquivoData     # Carregue o endereco da string com o nome do arquivo
    li $a1, 1             # Modo de abertura (1 para escrita)
    li $a2, 0             # Permissoees (nao importa para escrita)
    syscall
    
    move $s6, $v0 #copia do descritor

    # Escrever a string inicial no arquivo de data
    li $v0, 15 # Codigo da chamada de sistema para escrever no arquivo
    move $a0, $s6 # Descritor de arquivo para escrita
    la $a1, startData # Endereco da string a ser escrita
    li $a2, 81 # Comprimento da string a ser escrita (ajuste conforme necessario)
    syscall

    # Ler o conteúdo da memória apontada por $s5 e escrever no arquivo .data
    move $t0, $s2         # Endereço da memória apontado por $s5
    li $t1, 0             # indice para percorrer a memória

    jal escreve_conteudo_data

    # Fechar o arquivo
    li $v0, 16 # Codigo da chamada de sistema para fechar arquivo
    move $a0, $s6 # Descritor de arquivo a ser fechado
    syscall
    
    j fecharArquivo


escreve_conteudo_text:
    lb $t2, 0($t0)        # Ler byte da memória
    beq $t2, $zero, fim_leitura # Se for nulo, fim da leitura

    # Escrever o byte lido no arquivo
    li $v0, 15            # Código da chamada de sistema para escrever no arquivo
    move $a0, $s6         # Descritor de arquivo para escrita
    move $a1, $t0         # Endereço do byte a ser escrito
    li $a2, 1             # Escrever 1 byte
    syscall

    addi $t0, $t0, 1      # Próximo byte
    j escreve_conteudo_text

escreve_conteudo_data:
    lb $t2, 0($t0)        # Ler byte da memória
    beq $t2, $zero, fim_leitura # Se for nulo, fim da leitura

    # Escrever o byte lido no arquivo
    li $v0, 15            # Código da chamada de sistema para escrever no arquivo
    move $a0, $s6         # Descritor de arquivo para escrita
    move $a1, $t0         # Endereço do byte a ser escrito
    li $a2, 1             # Escrever 1 byte
    syscall

    addi $t0, $t0, 1      # Próximo byte
    j escreve_conteudo_data

fim_leitura:
    jr $ra
        
# Procedimento que vai "limpar" o caractere de quebra de linha
filenameClean:
    li $t0, 0                      # Inicializa contador do loop.
    li $t1, 80                     # Define limite do loop (tamanho do buffer_filename).
clean: 
    beq $t0, $t1, L2               # Se atingir o fim do buffer, sai do loop.
    lb $t3, buffer_filename($t0)   # Carrega byte por byte do buffer_filename.
    bne $t3, 0x0a, L1              # Se o byte nao eh uma nova linha, pula para incremento.
    sb $zero, buffer_filename($t0) # Se eh nova linha, substitui por 0.
L1:
    addi $t0, $t0, 1               # Incrementa contador do loop.
    j clean                        # Retorna ao inicio do loop.
L2:
    jr $ra                         # Retorna ao chamador.
    
# Procedimento para imprimir o erro em caso de arquivo não encontrado
fileError:
    la $a0, error_file_not_found   # carrega o endereco da mensagem de erro
    li $v0, 4                      # syscall para imprimir uma string
    syscall
    j FIM                          # pula para o final do programa
