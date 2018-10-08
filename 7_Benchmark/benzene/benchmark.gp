set terminal pdf enhanced font "Times New Roman"
set output "BenchF90.pdf"
set ylabel "tempo (s)"
set xlabel "otimização"
set xtics 1
set yrange [200:1800]
set title "Execução de Siesta com gfortran"
plot 'gf-tempo.dat' w lp pt 5 t "sem flags", 'gf-flags-tempo.dat' w lp pt 7 t "flags do sistema"
set output

#set output "RendF90.pdf"
#set xlabel "otimização"
#set ylabel "performance (%)"
#set title "Performance do Siesta com gfrotran"
#plot 'gf-tempo.dat' u ($1):((1-$1/)) t "sem flags"
