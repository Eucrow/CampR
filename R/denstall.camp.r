#' Función de densidad distribución de tallas
#'
#' Crea gráfico con la función de densidad de la distribución de tallas estratificada para la especie y las campañas seleccionadas
#' @param gr Grupo de la especie: 1 peces, 2 crustáceos 3 moluscos. 4 equinodermos y 5 invertebrados no se miden
#' @param esp Código de la especie numérico o carácter con tres espacios. 999 para todas las especies del grupo 
#' @param camp Campaña a representar en el mapa de un año comcreto (XX): Demersales "NXX", Porcupine "PXX", Arsa primavera "1XX" y Arsa otoño "2XX"
#' @param dns Elige el origen de las bases de datos: Porcupine "Pnew", Cantábrico "Cant", Golfo de Cádiz "Arsa" (proporciona los datos para Medits pero no saca mapas)
#' @param ti Si T añade título al gráfico, el nombre de la especie en latín
#' @param bw Gráfico en blanco y negro si T o en color si F
#' @param es Si T gráfico en castellano, si F gráfico en inglés
#' @param plot Saca el gráfico (T) o lo guarda como objeto para componer con otros gráficos (F)
#' @param idi Nombre científico de la especie ("l") o nombre común ("e")
#' @param layout Organización de gráficos en filas ó columnas c(r,c)
#' @param years Si T saca los años como nombre de campaña en los paneles lattice de campañas
#' @param cexleg Varía el tamaño de letra de los ejes y del número de la leyenda
#' @export
denstall.camp<- function(gr,esp,camp,dns,ti=F,bw=T,es=T,plot=T,idi="l",
  layout=NA,years=F,cexleg=1) {
  require(lattice)
  options(scipen=2)
  if (plot) trellis.par.set(col.whitebg())
  esp<-format(esp,width=3,justify="r")
  if (length(esp)>1 | any(esp=="999")) {
    print("Distintas especies pueden estar medidas en distintas unidades (mm y cm) o a la aleta anal")
    medida<-c("cm")
  }
  else { medida<-ifelse(unid.camp(gr,esp)[1]==1,"cm","mm") }
  if (bw) {
    colbars<-c("black",gray(.5),"white")
    trellis.par.set("strip.background",list(col=c(gray(.80))))
  }
  else {colbars<-c("lightyellow","steelblue","yellow1")}
  if (es) {ax<-c(paste("Talla (",medida,")",sep=""),"Número")}
  else {ax<-c(paste("Length (",medida,")",sep=""),"Number")}
  if (is.logical(ti)) {
    if (ti) {tit<-list(label=buscaesp(gr,esp,id=idi),font=ifelse(idi=="l",4,2),cex=1)}
    else {tit<-NULL}
  }
  else {
    if (is.list(ti)) tit<-ti
    else tit<-list(label=ti)
  }
  #	if (ti) tit<-list(label=buscaesp(gr,esp,id=id),font=4,cex=1.2)
  #	else tit<-NULL
  if (!plot) tit<-list(label=ifelse(es,"Distribuci?n de tallas","Length distribution"),font=2,cex=.9) 
  ndat<-length(camp)
  for (i in 1:ndat) {
    dtall<-data.frame(talla=dattal.camp(gr,esp,camp[i],dns)[,1],n=rowSums(dattal.camp(gr,esp,camp[i],dns)[-1]))
    ard<-as.data.frame(cbind(dtall[,1],rep(camp[i],nrow(dtall)),dtall$n))
    if (i==1) a<-ard
    else a<-rbind(a,ard)
  }
  a<-as.data.frame(a)
  names(a)<-c("talla","camp","n")
  if (years) {
    acamp<-a
    acamps<-camp
    camp<-camptoyear(camp)
    a$camp<-camptoyear(a$camp)
  }
  a$camp<-factor(as.character(a$camp),levels=camp)
  a$talla<-as.numeric(as.character(a$talla))
  a$n<-as.numeric(as.character(a$n))
  maxy<-tapply(a$n,a[,c(1,2)],sum)
  maxy[which(is.na(maxy))]<-0
  ylim= c(0,max(maxy)*1.05)
  xlimi<-c(min(a$talla)*(.95-1),max(a$talla)*1.05)
  if (ylim[2]>100) ylim[1]<-.10
  if (ylim[2]<20) ylim[1]<-10
  if (ylim[2]<100 & ylim[2]>20) ylim[1]<-1
  if (length(camp)==1) {
    foo<-densityplot(~rep(talla,a$n*ylim[1]),a,plot.points=F,lwd=2,xlim=xlimi,nint=40,
                     scales=list(alternating=F,tck=c(1,0),x=list(tick.number=10)),main=tit,
                     xlab=list(label=ax[1],cex=1.2),ylab=list(label="density",cex=1.2),
                     panel=function(x,subscripts,...) {panel.fill(col="white")
                                                       panel.grid(-1,0,lty=3,col="gray70")
                                                       panel.abline(v=quantile(x,c(.5),na.rm=T)+.5,lty=1,col="blue",lwd=1)
                                                       panel.densityplot(x,...)}
    )
  }
  else {
    if (ndat>2 & (ndat/2-trunc(ndat/2))==0 & any(is.na(layout))) layouti<- c(2,ndat/2)
    else layouti<- c(1,ndat)
    foo<-densityplot(~rep(talla,a$n*ylim[1])|rep(camp,a$n*ylim[1]),a,subscripts=T,xlim=xlimi,plot.points=F,nint=15,
                     scales=list(alternating=F,tck=c(1,0),cex=.7,x=list(tick.number=10)),main=tit,xlab=list(label=ax[1],cex=.9),
                     ylab=list(label="density",cex=cexleg*.9),layout=layouti,par.strip.text=list(cex=cexleg*.8,font=2),as.table=T,
                     panel=function(x,...) {
                       panel.fill(col="white")
                       panel.grid(-1,0,lty=3,col="gray60")
                       print(quantile(x,c(.5),na.rm=T))
                       panel.abline(v=quantile(x,c(.5),na.rm=T)+.5,lty=1,col="blue",lwd=1)
                       panel.densityplot(x,...)},
                     strip = function(...) strip.default(style=1,...))
  }
  if (plot) {print(foo)}
  else foo
}
# Comando para ordenar columnas lattice: as.numeric(unlist(strsplit(paste(c(0:7),c(8:15))," ")))
# denstall.camp(1,50,Psh,"Pnew",years=T)
