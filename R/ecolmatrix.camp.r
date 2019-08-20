#' Extrae los datos del FAUNA de una especie en concreto.
#'
#' Crea un data frame con campos lance, peso, numero, subestrato (en doble cifra), área subestrato  y posición geográfica. Usando códigos "9" "999" extrae los datos para el conjunto de todas las especies y grupos
#' @param gr Grupo de la especie: 1 peces, 2 crustáceos 3 moluscos 4 equinodermos 5 invertebrados 6 para deshechos y otros. 9 incluye todos los grupos a excepción del 6 ver parámetro incl6 mas abajo
#' @param esp ha de ser 999 cuando se quiere incluir todas las especies del grupo, o elegir todas las especies deseadas con los codigos de las especies
#' @param camp Campaña de la que se extraen los datos: un año comcreto (XX): Demersales "NXX", Porcupine "PXX", Arsa primavera "1XX" y Arsa otoño "2XX"
#' @param dns Elige el origen de las bases de datos: Porcupine "Porc" o "Pnew", Cantábrico "Cant, Golfo de Cádiz "Arsa" (únicamente para sacar datos al IBTS, no gráficos)
#' @param ind Elige el valor (n)úmero o (p)eso que se utiliza en el resultado
#' @param incl6 Si F se excluye el grupo 6 de otros (en general material no orgánico o antropogénico). Si T lo incluye dentro del grupo de "especies"
#' @param codes Si T da los códigos de las especies, si F el nombre científico
#' @return Devuelve un data.frame con columnas lan, una con el peso o número de cada especie del grupo solicitado, lat, long, prof
#' @seealso {\link{MapEcol.camp}}, {\link{ecolgr.camp}}
#' @examples ecolmatrix.camp(1,999,"P01","Porc",ind="p")
#' @export
ecolmatrix.camp<- function(gr,esp=999,camp,dns,ind="p",incl6=FALSE,codes=TRUE) {
  grupo<-as.character(gr)
  esp<-format(esp,width=3,justify="r")
  ch1<-DBI::dbConnect(odbc::odbc(), dns)
  fauna<-DBI:::dbGetQuery(ch1,paste0("select * from FAUNA",camp))
  DBI::dbDisconnect(ch1)
  if (length(esp)==1) {
    if (grupo!="9" & esp!="999") {
      absp<-fauna[fauna$GRUPO==as.integer(grupo) & fauna$ESP==as.integer(esp),]
      }
    if (grupo!="9" & esp=="999") {
      absp<-fauna[fauna$GRUPO==as.integer(grupo),] }
    if (grupo=="9" & esp=="999") {
      if (incl6) {absp<-fauna}
      else absp<-fauna[fauna$GRUPO!=6,]
      }
      }
  else {
    absp<-fauna[fauna$GRUPO==grupo & fauna$ESP %in% as.integer(esp),]
    }
  names(absp)<-tolower(names(absp))
  lan<-datlan.camp(camp,dns,redux=TRUE,incl0=FALSE,incl2=TRUE)
  lan$lance<-format(lan$lance,width=nchar(absp$lan[1]),justify="r")
  ch1<-DBI::dbConnect(odbc::odbc(), "Camp")
  especies<-DBI::dbGetQuery(ch1,"select grupo,esp,especie from Especies")
  especies$especie<-as.character(especies$especie)
  especies$ke<-paste(especies$grupo,format(especies$esp,width=3,justify="r"),sep=".")
  absp$ke<-paste(absp$grupo,format(absp$esp,width=3,justify="r"),sep=".")
  absp$especie<-especies$especie[match(absp$ke,especies$ke)]
  names(absp)<-gsub("_",".",names(absp))
  lan<-lan[,c("lance","lat","long","prof")]
  names(lan)<-c("lan","lat","long","prof")
  absp<-absp[absp$lance %in% lan$lan,]
  if (ind=="p") ecol<-tapply(absp$peso.gr,absp[,c(1,ifelse(codes,6,7))],sum)
  if (ind=="n") ecol<-tapply(absp$numero,absp[,c(1,ifelse(codes,6,7))],sum)
  ecol[is.na(ecol)]<-0
  m.names<-gsub(" ","",colnames(ecol))
  ecol<-data.frame(lan=as.numeric(rownames(ecol)),ecol)
  names(ecol)<-c("lan",m.names)
  ecol<-merge(ecol,lan,by="lan",all.x=TRUE,all.y=TRUE)
  ecol[is.na(ecol)]<-0
  ecol
}
