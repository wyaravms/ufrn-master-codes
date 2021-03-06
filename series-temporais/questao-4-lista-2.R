
# QUESTAO 4 - LISTA 2 de Exercicios
# DADOS US_FIX_INVESTIMENT

# leitura do arquivo de dados
usfix<-read.csv("F:\\mestrado-ufrn-2015.2016\\ufrn-2015.2\\series-temporais\\prova-1\\us-fix_investment.csv", header=T, dec=".", sep=";")
attach(usfix)
seriesd<-ts(usfix)
serie<-diff(seriesd)

#Gr�fico da s�rie
plot(serie,xlab="Tempo",ylab="US Fix Investiment",main="")


#Gr�fico das FAC�s e FACP�s
par(mfrow=c(2,1))
acf(serie,main="",xlab="Lag",ylab="FAC")
pacf(serie,main="",xlab="Lag",ylab="FACP")

#Voltando � configura��o padr�o da tela gr�fica
par(mfrow=c(1,1))

#Ajustando o modelo AR2
ar2<-arima(serie,order=c(2,0,0))
ar2

#Identificando os nomes dos objetos dentro do objeto ar2
names(ar2)

#Calculando a signific�ncia dos coeficientes
dp.coef<-sqrt(diag(ar2$var.coef))
t.valor<-ar2$coef/dp.coef
gl<-length(serie)-length(ar2$coef)
valor.p<-pt(abs(t.valor),gl,lower.tail=F) #Valor-p unilateral!
valor.p

#Produz os gr�ficos dos res�duos ao longo do tempo, as
#FAC�s dos res�duos e o teste de Ljung-Box para v�rios lags
#Mas tem que ajustar os graus de liberdade descritos abaixo!
tsdiag(ar2)

#Verificando a adequa��o do ajuste
Box.test(ar2$residuals,lag=1,type=c("Box-Pierce","Ljung-Box"),fitdf = 0)

#Verifica��o de Normalidade dos res�duos
par(mfrow=c(1,2))
h<-hist(ar2$residuals,prob=T,xlab="Res�duos",ylab="Densidade",
main="",col="gray",ylim=c(0,0.20),xlim=c(-10,10))
curve(dnorm(x,0, sd(ar2$res)),
from=min(h$breaks),to=max(h$breaks),col="red", add=T)
qqnorm(ar2$residuals,xlab="Quantis Te�ricos",ylab="Quantis
Amostrais",main="")
qqline(ar2$residuals,col="red")

#Teste de normalidade
shapiro.test(ar2$residuals)

#Teste de normalidade
ks.test(ar2$residuals,"pnorm")

#Ajustando o modelo MA2
ma2<-arima(serie,order=c(0,0,2))
ma2

#Calculando a signific�ncia dos coeficientes
dp.coef<-sqrt(diag(ma2$var.coef))
t.valor<-ma2$coef/dp.coef
gl<-length(serie)-length(ma2$coef)
valor.p<-pt(abs(t.valor),gl,lower.tail=F) #Valor-p unilateral!
valor.p

#Produz os gr�ficos dos res�duos ao longo do tempo, as
#FAC�s dos res�duos e o teste de Ljung-Box para v�rios lags
#Mas tem que ajustar os graus de liberdade descritos abaixo!
tsdiag(ma2)

#Verificando a adequa��o do ajuste
Box.test(ma2$residuals,lag=1,type=c("Box-Pierce","Ljung-Box"),fitdf = 0)
# help pra tirar mais duvidas
?Box.test

#Verifica��o de Normalidade dos res�duos
par(mfrow=c(1,2))
h<-hist(ma2$residuals,prob=T,xlab="Res�duos",ylab="Densidade",
main="",col="gray",ylim=c(0,0.20),xlim=c(-10,10))
curve(dnorm(x,0, sd(ma2$res)),
from=min(h$breaks),to=max(h$breaks),col="red", add=T)
qqnorm(ma2$residuals,xlab="Quantis Te�ricos",ylab="Quantis
Amostrais",main="")
qqline(ma2$residuals,col="red")

#Teste de normalidade
shapiro.test(ma2$residuals)

#Teste de normalidade
ks.test(ma2$residuals,"pnorm")

#Calculando os crit�rios de informa��o
csm<-function(objeto)
{
aicn<-AIC(objeto,k=2)/length(objeto$res)
bicn<-AIC(objeto,k=log(length(objeto))) /length(objeto$res)
EQM<-objeto$sigma2*length(objeto$resid)/
(length(objeto$resid)-length(objeto$coef))
fpe<-EQM*(1+(length(objeto$coef)+1)/length(objeto$resid))
saida<-matrix(c(aicn,bicn,fpe),byrow=T,nrow=1,
dimnames=list(c("Valor"),c("AICn","BICn","FPE")))
saida
}

csm(ar2)
csm(ma2)

# valor do delta no AR(2)
delta<-ar2$coef[3]*(1-sum(ar2$coef[-3]))
delta

# modelo final AR(2)
# fi1=0.7128  fi2=-0.2372 delta=0.5731033

# visualizar o c�digo da fun��o, quando ela n�o retorna direto
methods(AIC)
getAnywhere(AIC.default)


