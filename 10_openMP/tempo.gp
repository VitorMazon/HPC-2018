set terminal png enhanced font "Times New Roman"
set output "Dados.png"
plot 't0.dat','t1.dat','t2.dat','t3.dat'
set output

f(x)=a*x+b
g(x)=f(x)
h(x)=f(x)
p(x)=f(x)

fit f(x) 't0.dat' via a,b
fit g(x) 't1.dat' via a,b
fit h(x) 't2.dat' via a,b
fit p(x) 't3.dat' via a,b

set output "Analise.png"
plot f(x),g(x),h(x),p(x)
set output
