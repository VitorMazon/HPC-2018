# OpenMP

Pool de processos (threads) - Roda instruções designadas.

- Arquitetura NUMA;
- Compac e da HP, e popularizada pelos sistemas multicore(Core 2 DUO, 2002);
- A entrada na região de threads paralelos é a entrada no pool de threads;
- Fork join, abrir e fechar o pool(utilizado para executar processos híbridos, openMP e MPI);

## Sintaxe

1. Cláusulas;
	- Escopo de variaveis
	- IF
	- Redução
	- Escalonamento

2. Compilação Condicional

3. Compilação:

Exportar o número de threads
 - export OMP_NUM_THREADS=n


1 core pode executar mais de uma operação simultaneamente.
Modelo Fork - Join

## Observações
Ler nos slides (openMP).

## Atributos comuns

- Fazer o paralelismo para threads indefinidos
- Escalonar programa para 16 threads para projeto
- Variáves privadas dentro da parte paralela

- Diretivas: PARALLEL, DO/FOR, e SECTIONS. Controlar acesso de dados.
- Definir variáveis que tem que ser visível para todas as threads. (private, ou public)

## Atributos

	- Firstprivate
	- Lastprivate
	- Reduction


