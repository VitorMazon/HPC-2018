set terminal pdf enhanced font "Times New Roman"
set output "BenchF90.pdf"
set ylabel "tempo"
set xlabel "O's"
set xtics 1
set title "Execução de Siesta"
plot 'gf-tempo.dat' pt 5 t "sem flags", 'gf-flags-tempo.dat' pt 7 t "flags do sistema(AMD)"
set output
