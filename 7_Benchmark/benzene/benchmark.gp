set terminal pdf enhanced font "Times New Roman"
set output "BenchF90.pdf"
set ylabel "tempo (s)"
set xlabel "otimização"
set xtics 1
set yrange [200:1800]
set title "Execução de Siesta"
plot 'gf-tempo.dat' pt 5 t "sem flags", 'gf-flags-tempo.dat' pt 7 t "flags do sistema"
set output
