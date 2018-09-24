set terminal png enhanced font "Times New Roman"
set output "cut.png"
unset key
set title "Padrão de Energia"
set xlabel "cutoff"
set ylabel "E [eV]"
plot 'ecutoff.dat' w lp pt 7 lt rgb "red"
set output

set output "kp.png"
set title "Padrão de Energia"
set xlabel "kpoint"
set ylabel "E [eV]"
plot 'ekpoint.dat' w lp pt 7 lt rgb "red"
set output
