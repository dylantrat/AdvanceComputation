#########################################################################################################
#########################################################################################################
#Pregunta numero 2 - se define la lista de valores que se desean interpolar
#usando el test de Kolmogorov se aproxima el valor de p-valor - para las
# distribuciones de weibull y normal.
library(MASS)
valores <- c(0.0021,0.0540,0.1627,0.2182,0.2241,0.2498,0.2352,0.2320,0.2210,0.1929,0.1984,0.1884,0.1712,0.1501,0.1491,0.1372,0.1244,0.1079,0.0990,0.0963,0.0855,0.0905,0.0742,0.0727,0.0592,0.0453)
fitdistr(valores, "weibull")
#shape        scale   
#1.97641213   0.15543129 
#(0.32644889) (0.01601621)
ks.test(valores, "pweibull", scale=0.15543129, shape=1.97641213)
#data:  valores
#D = 0.11451, p-value = 0.8469
#alternative hypothesis: two-sided
ks.test(valores, "pnorm", mean=mean(julio), sd=sd(julio))
#data:  valores
#D = 0.10737, p-value = 0.8943
#alternative hypothesis: two-sided
