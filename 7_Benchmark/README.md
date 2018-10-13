# Como funciona?

Dentro da pasta siesta-4.0.1 executando os scripts para gfortran e intel, siesta é compilado.
Na pasta /benzene há dois scripts mk-data.sh e run.sh, que são responsaveis por executar para todos as flags e gera um arquivo com os tempos para cada um. (POssivel otimização seria utilizar mais de uma pasta de benzene para não perigo de travar a execução do processo).

Arquivos necessários para pasta /benzene:
	- H.psf
	- C.psf
	- benzene.fdf
