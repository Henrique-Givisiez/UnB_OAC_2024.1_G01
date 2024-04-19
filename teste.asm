addi $a0, $zero, 8 # Procura o $a0-enésimo termo na sequência
j Fibonacci # Jump incondicional pro procedimento Fibonacci

Fibonacci:
	beq $a0, $zero, FIM # Testa se o $a0-enésimo vale 0. Caso True, termina o programa
	addi $t0, $zero, 1 # Contador começando em 1 
	addi $v0, $zero, 1 # $v0 = n (valor inicial n=1)
	add $t1, $zero, $zero # Registrador auxiliar que irá ser o termo "n-1"
	L1: # Laço de repetição L1
	beq $t0, $a0, FIM # Testa se o contador chegou no $a0-enésimo termo 
	add $v0, $v0, $t1 # O próximo termo vai ser a soma dos último e penúltimo
	sub $t1, $v0, $t1 # Move o ponteiro de $t0 do penúltimo pro último elemento
	addi $t0, $t0, 1 # Incrementa o contador
	j L1 # Repete o laço
FIM:
