####################################################################
ABP_D = read.table("ABP-D.txt", header = T)
ABP_D$decan <- (ABP_D$sample_year - 1) + (((30.0*(ABP_D$sample_month - 1))+ ABP_D$sample_day)/365.0)
plot(ABP_D$decan,ABP_D$analysis_value,type="o",col="blue",ann=FALSE)
title(main="ABP-Discrete-Data",col.main="red", font.main=4)
title(xlab="Años", col.lab=rgb(0,0.5,0))
title(ylab="Concentracion-CO2(ppm)", col.lab=rgb(0,0.5,0))
####################################################################
ALT_D = read.table("ALT-D.txt", header = T)
ALT_D$decan <- (ALT_D$sample_year - 1) + (((30.0*(ALT_D$sample_month - 1))+ ALT_D$sample_day)/365.0)
plot(ALT_D$decan,ALT_D$analysis_value,type="o",col="blue",ann=FALSE)
title(main="ALT-Discrete-Data",col.main="red", font.main=4)
title(xlab="Años", col.lab=rgb(0,0.5,0))
title(ylab="Concentracion-CO2(ppm)", col.lab=rgb(0,0.5,0))
####################################################################
ASC_D = read.table("ASC-D.txt", header = T)
ASC_D$decan <- (ASC_D$sample_year - 1) + (((30.0*(ASC_D$sample_month - 1))+ ASC_D$sample_day)/365.0)
plot(ASC_D$decan,ASC_D$analysis_value,type="o",col="blue",ann=FALSE)
title(main="ASC-Discrete-Data",col.main="red", font.main=4)
title(xlab="Años", col.lab=rgb(0,0.5,0))
title(ylab="Concentracion-CO2(ppm)", col.lab=rgb(0,0.5,0))
####################################################################
AVI_D = read.table("AVI-D.txt", header = T)
AVI_D$decan <- (AVI_D$sample_year - 1) + (((30.0*(AVI_D$sample_month - 1))+ AVI_D$sample_day)/365.0)
plot(AVI_D$decan,AVI_D$analysis_value,type="o",col="blue",ann=FALSE)
title(main="AVI-Discrete-Data",col.main="red", font.main=4)
title(xlab="Años", col.lab=rgb(0,0.5,0))
title(ylab="Concentracion-CO2(ppm)", col.lab=rgb(0,0.5,0))
####################################################################
AMS_D = read.table("AMS-D.txt", header = T)
AMS_D$decan <- (AMS_D$sample_year - 1) + (((30.0*(AMS_D$sample_month - 1))+ AMS_D$sample_day)/365.0)
plot(AMS_D$decan,AMS_D$analysis_value,type="o",col="blue",ann=FALSE)
title(main="AMS-Discrete-Data",col.main="red", font.main=4)
title(xlab="Años", col.lab=rgb(0,0.5,0))
title(ylab="Concentracion-CO2(ppm)", col.lab=rgb(0,0.5,0))
####################################################################
ABP <- as.data.frame.matrix(ABP)
ALT <- as.data.frame.matrix(ALT)
ASC <- as.data.frame.matrix(ASC)
AVI <- as.data.frame.matrix(AVI)
AMS <- as.data.frame.matrix(AMS)
####################################################################
TEN = cbind2(ABP, ALT)
TEN = cbind2(TEN, ASC)
TEN = cbind2(TEN, AVI)
TEN = cbind2(TEN, AMS)
####################################################################
ll = length(TEN[,1])
AUX = matrix(ncol = 11, nrow = ll)
Dat-Col = matrix(ncol=1, nrow = ll)
ii = 0
for(i in 1:ll){
  AUX[i,1] = 1.0
  AUX[i,2] = as.numeric(TEN[i,2])
  AUX[i,3] = (as.numeric(TEN[i,2]))**2
  Dat-Col[ll,1] = as.numeric(TEN[i,3]) 
  for(j in 1:4){
    AUX[i,2*(j+1)] =  sin(2*pi*j*as.numeric(TEN[i,2]))
    AUX[i,(2*j)+3] =  cos(2*pi*j*as.numeric(TEN[i,2]))
  }
}
require(MASS)
coeff-fin = t(AUX)*ginv(t(AUX)*AUX)

inte = seq(1980, 2015, by = 1)

ss = length(inte)
aux-co = matrix(ncol = 1, nrow = ss)
for(kk in 1:ss){
  aux-co[kk,1] = coeff-fin[1,1] + coeff-fin[2,1]*inte[ss] + coeff-fin[3,1]*(inte[ss]**2)
  coeff-fin[4,1]*sin(2*pi*inte[ss]) + coeff-fin[5,1]*cos(2*pi*inte[ss])
  + coeff-fin[6,1]*sin(2*pi*2*inte[ss]) + coeff-fin[7,1]*cos(2*pi*2*inte[ss])
  + coeff-fin[8,1]*sin(2*pi*3*inte[ss]) + coeff-fin[9,1]*cos(2*pi*3*inte[ss])
  + coeff-fin[10,1]*sin(2*pi*4*inte[ss]) + coeff-fin[11,1]*cos(2*pi*4*inte[ss])
}

MM = read.table("mon-me.txt")
plot(MM$V1,MM$V3,type="o",col="blue",ann=FALSE)
title(main="Modelo Armonico - Promedio mensual (Directo)",col.main="red", font.main=4)
title(xlab="Años", col.lab=rgb(0,0.5,0))
title(ylab="Concentracion-CO2(ppm)", col.lab=rgb(0,0.5,0))
