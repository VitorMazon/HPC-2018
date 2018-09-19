#
# This file is part of the SIESTA package.
#
# Copyright (c) Fundacion General Universidad Autonoma de Madrid:
# E.Artacho, J.Gale, A.Garcia, J.Junquera, P.Ordejon, D.Sanchez-Portal
# and J.M.Soler, 1996- .
# 
# Use of this software constitutes agreement with the full conditions
# given in the SIESTA license, as signed by all legitimate users.
#
SIESTA_ARCH=gfortran
#
# Serial compilation without the need of any installed libraries.
#
FC=gfortran
#
FC_ASIS=$(FC)
#
MKLROOT=/opt/intel/compilers_and_libraries/linux/mkl
todas=-funroll-loops -ffast-math 
FFLAGS=-O3 -fexpensive-optimizations -m64 -foptimize-register-move ${todas}  
#FFLAGS=-O0 -m64 -I${MKLROOT}/include
FFLAGS_DEBUG= -g 
LDFLAGS= -O2 -fexpensive-optimizations -m64 -foptimize-register-move -funroll-loops -ffast-math
RANLIB=echo
SYS=nag
FPPFLAGS=-DGFORTRAN -DFC_HAVE_FLUSH -DFC_HAVE_ABORT -DGRID_DP         # Note this !!

#LIBS= -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_gf_lp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_sequential.a -Wl,--end-group -lpthread -lm
LIBS= -Wl,--no-as-needed -L${MKLROOT}/lib/intel64 -lmkl_gf_lp64 -lmkl_core -lmkl_sequential -lpthread -lm
#COMP_LIBS=liblapack.a libblas.a linalg.a
#
.F.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS)  $(FPPFLAGS) $<
.f.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS)   $<
.F90.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS)  $(FPPFLAGS) $<
.f90.o:
	$(FC) -c $(FFLAGS) $(INCFLAGS)   $<
#

