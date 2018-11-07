# Como funciona?

Dentro da pasta /7_Benchmark/siesta-4.0.1, executando os scripts para gfortran e intel, o siesta é compilado.
Na pasta /benzene há dois scripts mk-data.sh e run.sh, que são responsaveis por executar o siesta para todas os tipos de flags e gerar um arquivo com os tempos para cada um. (Possivel otimização seria utilizar mais de uma pasta de benzene para não perigo de travar a execução do processo).

Arquivos necessários para pasta /benzene:
	- H.psf
	- C.psf
	- benzene.fdf
	- mk-data.sh
	- run.sh
