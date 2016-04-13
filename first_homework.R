######################################################################
######################################################################
setwd("~/Rcourse")
icecube = read.table("NuAstro_4yr_IceCube_Data.txt", header = T)
icecube <- na.omit(icecube)
#######################################################################
#######################################################################
library(data.table)
icecube.dt =data.table(icecube)
icecube.dt[,list(mean_Ang_Res=mean(Med_Ang_Res_deg)), by = 'Topology']
#######################################################################
#######################################################################
topo = c()
for (ll in 1:nn)
{
  topo = c(topo,as.character(icecube[,9][ll]))
}
topo <- unique(topo)
tama = length(topo)
reso = c()
for (pp in 1:tama)
{
  reso = c(reso,pp)
}
nt = nrow(icecube)
for (fc in 1:tama)
{
  prom = c()
  for (sc in 1:nt)
  {
    vari = as.character(icecube[,9][sc])
    if (vari == topo[fc])
    {
      prom = c(prom,as.numeric(icecube[,8][sc]))
    }
  }
  reso[fc] <- mean(prom)
}
for(ki in 1:tama)
{
  tiri = paste(topo[ki],": ",", Mean: ", as.character(reso[ki]))
  print(tiri)
}
#################################################
#################################################
GMD <- function(MJ)
{
  #Constants
  y = 4716
  j = 1401
  m = 2
  n = 12
  r = 4
  p = 1461
  v = 3
  u = 5
  s = 153
  w = 2
  B = 274277
  C = -38
  
  #Begin - Algorithm
  
  J = MJ + 2400000.5
  f = J + j + (((4*J +B)%/%146097)*3)%/%4 + C
  e = r*f + v
  g = (e%%p)%/%r
  h = u*g + w
  D = (h%%s)%/%u + 1
  M = (((h%/%s)+ m)%%n) + 1
  Y = (e%/%p) - y + ((n+m-M)%/%n)
  date = paste(c(D,M,Y),collapse = "-")
  date <- as.character(as.Date(date, format="%d-%m-%Y"))
  return(date)
}

###########################################################
###########################################################

Add_GMT <- function(Table)
{
  #meta_col = Table[,1]
  nr = nrow(Table)
  for (j in 1:nr)
  {
    aux = Table$Time_MJD[j]
    #print(aux)
    Table$GMT[j] <- GMD(aux)
    #print(meta_col[j])
  }
  #Table$GMT <- meta_col
  return(Table)
}

#############################################################
#############################################################

evt_month <- function(Tabla,mes)
{
  fecha = Tabla[,10]
  nc = nrow(Tabla)
  cant = 0
  for (i in 1:nc)
  {
    meta_m = substring(fecha[i],6,7)
    month = as.integer(meta_m)
    if (month == mes)
    {
      cant = cant + 1
    }
  }
  return(cant)
}

###############################################################
###############################################################
x = c()
y = c()
for (k in 1:12)
{
  x = c(x,k)
  y = c(y,evt_month(icecube,k))
}

###############################################################
###############################################################

x_ev = c()
y_ev = c()
n = nrow(icecube)
for (q in 1:n)
{
  xx = icecube$Declination_deg[q]
  x_ev = c(x_ev,xx)
  yy = icecube$RA_deg[q]
  y_ev = c(y_ev,yy)
}

plot(yy,xx,main="Events on Equatorial Coordinates", xlab="Right ascension", ylab = "Declination")
##############################################################
##############################################################

M = max(y)
len = length(y)
order = 0
for (l in 1:len) 
{
  order = order + 1
  if (y[l] == M)
  {
    break
  }
}
month = c(1,2,3,4,5,6,7,8,9,10,11,12)
tir_mon = month.abb[month]
month_high = tir_mon[order]
paste("El mes con mas eventos es ",month_high," el cual tiene ",y[order], " eventos")

########################################################################
########################################################################

best_fit <- function(En)
{
  best.fit = 1.5*(1.0e-8)*(En/100)**(-0.3)
  return(best.fit)
}
