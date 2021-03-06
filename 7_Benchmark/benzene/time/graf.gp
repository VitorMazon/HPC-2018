set terminal png enhanced font "Times New Roman"
set xlabel "otimização"
set ylabel "tempo (s)"
set xtics 1

set output "Benchmark-f90.png"
set title "Execução siesta para gfortran"
plot "gf-tempo.dat" w lp pt 5 t "sem flags", "gflags-tempo.dat" w lp pt 7 t "com flags"
set output

set output "Benchmark-intel.png"
set title "Execução siesta para ifort"
plot "intel-tempo.dat" w lp pt 5 t "sem flags", "intel-flags-tempo.dat" w lp pt 7 t "com flags", "intel-mkl-tempo.dat" w lp pt 9 t "mkl"
set output

set output "Benchmark-noflags.png"
set title "Execução siesta sem flags"
plot "gf-tempo.dat" w lp pt 5 t "gfortran", "intel-tempo.dat" w lp pt 7 t "ifort"
set output

set output "Benchmark-flags.png"
set title "Execução siesta com flags"
plot "gf-tempo.dat" w lp pt 5 t "gfortran", "intel-flags-tempo.dat" w lp pt 7 t "ifort", "intel-mkl-tempo.dat" w lp pt 9 t "ifort-mkl"
set output
