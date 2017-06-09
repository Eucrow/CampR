#' Índices ecológicos para un grupo en una campaña
#' 
#' Utiliza los datos del Camp para calcular la riqueza, diversidad y dominancia
#' @param gr Grupo de la especie: 1 peces, 2 crustáceos 3 moluscos 4 equinodermos 5 invertebrados 6 para deshechos y otros. 9 incluye todos los grupos a excepción del 6
#' @param esp ha de ser 999 cuando se quiere incluir todas las especies del grupo, o elegir todas las especies deseadas con los codigos de las especies
#' @param camp Campaña de la que se extraen los datos: un año comcreto (XX): Demersales "NXX", Porcupine "PXX", Arsa primavera "1XX" y Arsa otoño "2XX"
#' @param dns Elige el origen de las bases de datos: Porcupine "Pnew", Cantábrico "Cant, Golfo de Cádiz "Arsa", Mediterráneo "Medi"
#' @param ind Elige el valor sobre el que se calculan los índices de diversidad, dominancia....
#' @return Devuelve un data.frame con campos lan,lat,long,prof,div (Diversidad de Shanon),numbesp (riqueza: número de especies),simp (diversidad de simpson),domsimp (indice de dominancia de simpson). 
#' @seealso {\link{MapEcol.camp}}
#' @examples ecolgr.camp(1,999,"P08","Pnew",ind="n")
#' @examples ecolgr.camp(1,999,"M08","Medi",ind="n")
#' @family ecologia
#' @export
ecolgr.camp<- function(gr,esp=999,camp,dns="Pnew",ind="n") {
  if (length(camp)>1) {
    stop("Seleccionadas más de una campaña, sólo se sacan resultados de campañas de una en una")
  }
  grupo<-as.character(gr)
  esp<-format(esp,width=3,justify="r")
  ch1<-RODBC::odbcConnect(dsn=dns)
  if (gr!="9" & esp!="999") {
    absp<-RODBC::sqlQuery(ch1,paste("select lance,grupo,esp,peso_gr,numero from FAUNA",
                             camp," where grupo='",gr,"' and esp='",esp,"'",sep="")) }
  if (gr!="9" & esp=="999") {
    absp<-RODBC::sqlQuery(ch1,paste("select lance,grupo,esp,peso_gr,numero from FAUNA",camp," where grupo='",gr,"'",sep="")) }
  if (gr=="9" & esp=="999") {
    absp<-RODBC::sqlQuery(ch1,paste("select lance,grupo,esp,peso_gr,numero from FAUNA",camp,sep=""))
    absp<-absp[absp$grupo!=6,]
  }
  RODBC::odbcClose(ch1)
  lan<-datlan.camp(camp,dns,redux=TRUE,incl2=TRUE,incl0=FALSE)
  if (length(lan)==1) {
    mm<-data.frame(lan=0,lat=0,long=0,prof=0,numero=0,peso.gr=0)
  }
  ch1<-RODBC::odbcConnect(dsn="camp")
  especies<-RODBC::sqlQuery(ch1,"select grupo,esp,especie from Especies")
  RODBC::odbcCloseAll()
  especies$especie<-as.character(especies$especie)
  especies$ke<-paste(especies$grupo,format(especies$esp,width=3,justify="r"),sep=".")
  absp$ke<-paste(absp$grupo,format(absp$esp,width=3,justify="r"),sep=".")
  absp$especie<-especies$especie[match(absp$ke,especies$ke)]
  names(absp)<-gsub("_",".",names(absp))
  lan<-lan[,c("lance","lat","long","prof","weight.time")]
  names(lan)<-c("lan","lat","long","prof","weight.time")
  absp<-absp[absp$lance %in% lan$lan,]
  if (ind=="p") ecol<-tapply(absp$peso.gr,absp[,c(1,7)],sum)
  if (ind=="n") ecol<-tapply(absp$numero,absp[,c(1,7)],sum)
  ecol[is.na(ecol)]<-0
  # browser()
  numbesp<-vegan::specnumber(ecol)
  div<-vegan::diversity(ecol)
  simp<-vegan::diversity(ecol,"simpson")
  invsimp<-vegan::diversity(ecol,"invsimpson")
  ecolinds<-data.frame(lance=names(div),div=div,numbesp=numbesp,simp=simp,domsimp=invsimp)
  mm<-merge(lan,ecolinds,by.x="lan",by.y="lance",all.x=TRUE,all.y=TRUE)
  if (!identical(as.numeric(which(is.na(mm[,4]))),numeric(0))) {
    mm[which(is.na(mm[,4])),4]<-0
    mm[which(is.na(mm[,5])),5]<-0
  }
  mm
}
