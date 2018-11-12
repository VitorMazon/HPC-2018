#include <stdio.h>
#include <omp.h>
#define CHUNK 100
#define N 10000

void main() {
	int i, n, chunk;
	float a[N], b[N], c[N];
	// Algumas inicializações
	for (i=0;i<N;i++)
		a[i] = b[i] = i * 1.0;
	
	n=N;
	chunk=CHUNK;
	#pragma omp parallel shared(a, b, c, n, chunk) private(i)
	{ 
		#pragma omp for parallel schedule(dynamic, chunk) nowait
		for (i=0;i<n;i++)
			c[i]=a[i]+b[i];
	} //fim da seção paralela
}
