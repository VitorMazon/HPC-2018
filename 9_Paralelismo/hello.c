#include <stdio.h>
#include <omp.h>

void main() {
	int nthreads, tid;
	
	//Pega um time de threads e dá a eles suas próprias cópias de varaiveis
	#pragma omp parallel private(nthreads, tid)
	{
		//Obtem e imprime a id da thread
		tid=omp_get_thread_num();
		printf("Hello World do thread=%d\n", tid);
		
		//Somente o thread master faz isso
		if(tid==0)
		{
			nthreads=omp_get_num_threads();
			printf("Numero de threads=%d\n", nthreads);
		}
	} //Todas as threads se juntam a master e são eliminadas
}
