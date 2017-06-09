#' Mapa del Golfo de Cádiz
#' 
#' Función auxiliar para sacar mapas de la campaña ARSA
#' @param xlims Define los limites longitudinales del mapa, los valores por defecto son los del total del área de la campaña 
#' @param ylims Define los limites latitudinales del mapa, los valores por defecto son los del total del área de la campaña 
#' @param lwdl Ancho de las líneas del mapa
#' @param cuadr Si T saca las cuadrículas de 5x5 millas naúticas
#' @param cuadrMSFD Si T dibuja cuadrícula de 10 millas naúticas utilizada para la evaluación de la estrategia marina (MSFD) 
#' @param ICESrect Si T saca los rectangulos ices de 1 grado de latitud por medio de longitud
#' @param ax Si T saca los ejes x e y
#' @param bw si T mapa con tierra en gris, si F tierra en color
#' @param es Si T saca titulos y ejes en español
#' @param wmf Si T saca a fichero metafile Arsaconc.emf
#' @param places Si T saca ciudades y puntos geográficos de referencia
#' @return Saca en pantalla el mapa y es utilizada por otras funciones
#' @seealso {\link{MapCant}}, {\link{mapporco}}
#' @examples MapArsa()
#' @family mapas base
#' @family ARSA
#' @export
MapArsa<-function(xlims=c(-8,-5.55),ylims=c(35.95,37.33),lwdl=1,cuadr=FALSE,cuadrMSFD=FALSE,ICESrect=FALSE,ax=TRUE,bw=F,wmf=FALSE,es=TRUE,places=TRUE) {
  data(CampR)
  asp<-diff(c(35.95,37.33))/(diff(c(-8,-5.55))*cos(mean(c(35.95,37.29))*pi/180))
  if (wmf) win.metafile(filename = "Arsaconc.emf", width = 10, height = 10*asp+.63, pointsize = 10)
  if (!wmf) par(mar=c(2,2.5,2, 2.5) + 0.3)
  if (!ax) par(mar=c(0,0,0,0),oma=c(0,0,0,0),omd=c(0,1,0,1))
  maps::map(Arsa.str,xlim=xlims,ylim=ylims,type="n",yaxs="i",xaxs="i")
  if (cuadr) {
    abline(h=seq(31,45,by=1/12),col=gray(.6),lwd=.6)
    abline(v=seq(-12,0,by=0.089),col=gray(.6),lwd=.6)
  }
  if (ICESrect) {
    abline(h=seq(31,45,by=.5),col=gray(.2),lwd=.6)
    abline(v=seq(-12,0,by=1),col=gray(.2),lwd=.6)
  }
  if (cuadrMSFD) {
    abline(h=seq(31,45,by=1/6),col=gray(.4),lwd=.5)
    abline(v=seq(-12,0,by=0.2174213),col=gray(.4),lwd=.5)
  }
  maps::map(Arsa.map,add=TRUE,fill=TRUE,col=c(rep(NA,5),ifelse(bw,"light gray","wheat")),lwd=lwdl)
  maps::map(Arsa.map,add=TRUE,fill=TRUE,col=c(rep(NA,6),ifelse(bw,"light gray","wheat")),lwd=lwdl)
  if (places) {
    points(c(-6.299667,-6.950833),c(36.53433,37.25833),pch=20)
    text(-6.950833,37.25833,"Huelva",cex=.85,font=2,pos=2)
    text(-6.299667,36.53433,"Cádiz",cex=.85,font=2,pos=3)
    text(-8,37.25,"PORTUGAL",cex=1,font=2,pos=4)
  }
  if (ax) {
     degs = seq(-8,-5,ifelse(abs(diff(xlims))>1,1,.5))
     alg = sapply(degs,function(x) bquote(.(abs(x))*degree ~ W))
     axis(1, at=degs, lab=do.call(expression,alg),font.axis=2,cex.axis=.8,tick=T,tck=c(-.01),mgp=c(1,.2,0))
     axis(3, at=degs, lab=do.call(expression,alg),font.axis=2,cex.axis=.8,tick=T,tck=c(-.01),mgp=c(1,.2,0))
     degs = seq(35,38,ifelse(abs(diff(ylims))>1,1,.5))
     alt = sapply(degs,function(x) bquote(.(x)*degree ~ N))
     axis(2, at=degs, lab=do.call(expression,alt),font.axis=2,cex.axis=.8,tick=T,tck=c(-.01),las=2,mgp=c(1,.5,0))
     axis(4, at=degs, lab=do.call(expression,alt),font.axis=2,cex.axis=.8,tick=T,tck=c(-.01),las=2,mgp=c(1,.5,0))
  }
  box(lwd=lwdl)
  if (wmf) dev.off()
  if (wmf) par(mar=c(5, 4, 4, 2) + 0.1)
}