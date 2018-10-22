# Paralelismo

## Modelos de paralelismo

### Paralelismo Funcional

Também chamdo de MPMD (multiple program multiple data)
- informações passadas por programas diferentes
- Problema: balanceamente de carga (gargalos)

Mestre trabalhador, estilo MPI

### Decomposição funcional

Resolução da equação de Navier-Stokes (elementos finitos)

~paralelismo nem sempre irá otimizar~

## Escalabilidade Paralela

- dividir entre trabalhadores
- distribuição de carga
- barreiras
- mensagens entre processos (comunicação)

Métrica: Definir tamanho geral, s + p = 1, onde 's' é a parte serial e 'p' é a fração perfeitamente paralelizável.

1. Limitação do algoritmo;
2. Gargalos;
3. Sobrecarga de inicialização;
4. Comunicação.

## Lei de Amdahl
Importante. Utilizar. Eficiência paralela
