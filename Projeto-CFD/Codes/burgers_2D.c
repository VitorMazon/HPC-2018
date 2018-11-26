#include <stdio.h>
#include <math.h>
#include <stlib.h>

void main() {
	double i=0.;
	
	int nx, ny, nt, c;
	double dx, dy, sigma, nu, dt;
	
	//Declaração de variáveis
	nx = 41;
	ny = 41;
	nt = 120;
	c = 1;
	dx = 2/(nx-1);
	dy = 2/(ny-1);
	sigma = 0.0009;
	nu = 0.01;
	dt = sigma*dx*dy/nu;
	
	x = (double) malloc(nx*sizeof(double));
	y = (double) malloc(ny*sizeof(double));
	
	for(i=0.; i<2; i=i+dx){ x[i] = i; }
	for(i=0.; i<2; i=i+dy){ y[i] = i; }
	
	
	
	for(i=0.; i<2; i=i+dx) {
		u[0][i] = 1;
		v[0][i] = 1;
		un[0][i] = 1;
		vn[0][i] = 1;
		comb[0][i] = 1;
	}
	
	free(x);
	free(y);
}

