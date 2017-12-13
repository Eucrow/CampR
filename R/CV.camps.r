#' Abundancias en número y peso totales de la especie para varias campañas
#'
#' Función de resultados 
#' @param gr Grupo de la especie: 1 peces, 2 crustáceos 3 moluscos 4 equinodermos 5 invertebrados 6 para deshechos y otros. 9 incluye todos los grupos a excepción del 6
#' @param esp Código de la especie numérico o carácter con tres espacios. 999 para todas las especies del grupo 
#' @param camps Campañas de las que se solicitan los resultados un año concreto (XX): Demersales "NXX", Porcupine "PXX", Arsa primavera "1XX" y Arsa otoño "2XX"
#' @param dns Elige el origen de las bases de datos: Porcupine "Porc" o "Pnew", Cantábrico "Cant", Golfo de Cadiz "Arsa" (proporciona los datos para Medits pero no saca mapas)
#' @param cor.time Si T corrige las abundancias en función de la duración del lance
#' @param kg Si T saca los resultados en Kg, si F en gramos
#' @param dec Número de decimales de los resultados
#' @param excl.sect Excluye los sectores o subsectores dados como caracteres
#' @param verbose si T avisa que disintas especies pueden pertenercer a grupos distintos y hay que valorar si se pueden juntar
#' @return Devuelve una lista con valorees de media, SE y CV para los subestratos, estratos y total de la campaña
#' @seealso ListFauna.camp
#' @export
CV.camps<-function(gr,esp,camps,dns,cor.time=TRUE,kg=TRUE,dec=2,excl.sect=NA,verbose=TRUE) {
  esp<-format(esp,width=3,justify="r")
  ndat<-length(camps)
  dumb<-NULL
  for (i in 1:ndat) {
    dumb<-rbind(dumb,cbind(datos.camp(gr,esp,camps[i],dns,cor.time=cor.time,kg=kg,verbose=verbose),camp=camps[i]))
  }
  if (any(!is.na(excl.sect))) {
    for (i in 1:length(excl.sect)) {dumb<-dumb[-grep(excl.sect[i],as.character(dumb$sector)),]}
    dumb$sector<-factor(as.character(dumb$sector))
  }
  dumb$camp<-factor(dumb$camp,levels=camps,ordered=TRUE)
  campa=as.character(camps)
  dumb.weight<-round(strmean.camps(dumb$peso,dumb$sector,dumb$arsect,camps=dumb$camp),dec)
  dumb.number<-round(strmean.camps(dumb$num,dumb$sector,dumb$arsect,camps=dumb$camp),dec)
  dumb<-data.frame(camp=campa,weight=dumb.weight,number=dumb.number)
  dumb
}
