#include <stdio.h>
#include <omp.h>
#define N 		1000

void main() {
	int i, n;
	float a[N], b[N], c[N];
	
	//Algumas inicializações
	for(i=0; i<N; i++)
		a[i] = b[i] = i * 1.0;
	n = N;
	
	#pragma omp parallel shared(a,b,c,n) private(i)
	{
		#pragma omp sections nowait
		{
			
			#pragma omp section
			for(i=0; i<n/2; i++)
				c[i] = a[i] + b[i];
			
			#pragma omp section
			for(i=n/2; i<n; i++)
				c[i] = a[i] + b[i];
				
		} // fim das seções

	} // fim da seção paralela
}