set.seed(20)
#La hipotesis normal es que al ser dos distribuciones diferentes de la normal y uniforme,
#entonces el parametro abs(t) debe ser grande.
#Por otro lado la hipotesis nula implica que si la distribucion es normal, entonces abs(t) es pequeño.
H0<-sapply(rep(13,10000),function(x){((abs(mean(rnorm(x))-mean(rnorm(x))))/(sqrt(var(rnorm(x)))))}) #distribucion normal.
H1<-sapply(rep(13,10000),function(x){((abs(mean(rt(x,1.5))-mean(rt(x,1.5))))/(sqrt(var(rt(x,1.5)))))}) #distribucion del estudiante.
hist(H0,breaks = seq(0,4,0.1),col=rgb(1,0,0,0.5),xlim = c(0,4))
hist(H1,breaks = seq(0,4,0.1),col=rgb(1,0,0.5),add=T)
try <- abs(mean(rt(13,1.5))-median(rt(13,1.5)))/(sqrt(var(rt(13,1.5))))
pvalue <- 1-fcum(try) # Esto es para aplicar el Test del valor -p.
#El bucle se usa para que uno de los valores que arroje pvalue pueda cumplir estar dentro de las 3sigma.

for (cont in 1:100)
{
  #El valor para tres sigmas es de parametro alfa : 0.0027
  m = 1 - fcum(1.63) # 0.00270000000000004
  M = 1 - fcum(2.0) #0.000499999999999945
  if ((pvalue > m)&(pvalue < M))
  {
    print("se alcanzo los 3-sigma")
  }
  if ((pvalue < m)|(pvalue > M))
  {
    print("No se alcanzo los 3-sigma")
  }
}