#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void main(int argc, char **argv) {
	int i=0, N;
	double *a, *b, *c, *d;
	double mflops;
	clock_t t;
	
	N=atof(argv[1]);
	a=malloc(N*sizeof(double *));
	b=malloc(N*sizeof(double *));
	c=malloc(N*sizeof(double *));
	d=malloc(N*sizeof(double *));
	
	t=clock();
	for(;i<N;i++) {
		a[i]=b[i]+c[i]*d[i];
	}
	t=clock()-t;
	//mflops=N*2/(t);
	printf("%ld\n", t);
}
