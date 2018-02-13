#' Comprueba la distancia recorrida en los lances y la consistencia con recorrido y la velocidad en los datos del CAMP
#' 
#' Sirve para control de calidad y asegurarse que los datos de distancias y posiciones son correctos
#' @param camp campaña a revisar los datos en formato Camp Xyy
#' @param dns Origen de bases de datos: "Cant" cantábrico, "Porc" o "Pnew" Porcupine, "Arsa" para el Golfo de Cádiz y "Medi" para MEDITS
#' @param todos Por defecto F. Si T lista todos los lances con valores, si no sólo los que pc.error>error
#' @param pc.error porcentaje de error aceptable para no mostrar los lances como erróneos
#' @return Devuelve un data.frame con campaña, lance, recorrido y rumbo según: camp, según la fórmula haversine entre largada y virada, velocidad, velocidad para recorrer el recorrido, tiempo y %s de error en las comparaciones
#' @examples qcdistlan.camp("C14","Cant",pc.error=.01)
#' @examples qcdistlan.camp("216","Arsa",pc.error=.01)
#' @seealso {\link{MapLansGPS}}
#' @references distHaversine function gives the haversine calculation of distance between two geographic points \code{\link[geosphere]{distHaversine}}
#' @family Control de calidad
#' @export
qcdistlan.camp<-function(camp,dns="Cant",todos=FALSE,pc.error=2) {
  dumblan<-datlan.camp(camp,dns,redux=FALSE)
  dumblan$mins<-round(dumblan$haul.mins*dumblan$weight.time,1)
  dumblan$dist.vel<-round(c(dumblan$weight.time*dumblan$haul.mins)/60*dumblan$velocidad*1852,0)
  dumblan$dist.hf<-round(geosphere::distHaversine(dumblan[,c("longitud_l","latitud_l")],dumblan[,c("longitud_v","latitud_v")]))
  dumblan$vel.dist<-round((dumblan$dist.hf/1852)/(dumblan$weight.time*dumblan$haul.mins/60),1)
  dumblan$error.vel<-round((dumblan$dist.vel-dumblan$recorrido)*100/dumblan$recorrido,2)
  dumblan$error.dist<-round((dumblan$dist.hf-dumblan$recorrido)*100/dumblan$recorrido,2)
  dumblan$rumb<-round(geosphere::bearingRhumb(dumblan[,c("longitud_l","latitud_l")],dumblan[c("longitud_v","latitud_v")]),1)
  dumblan$error.rumb<-round(dumblan$rumb-dumblan$rumbo)
  dumblan[abs(dumblan$error.dist)>pc.error | abs(dumblan$error.vel)>pc.error | abs(dumblan$error.rumb)>pc.error,c("camp","lance","recorrido","dist.hf","vel.dist","velocidad","error.dist","error.vel","error.rumb")]
  if (todos) return(dumblan[order(dumblan$camp,dumblan$lance),c("camp","lance","recorrido","dist.hf","dist.vel","velocidad","mins","vel.dist","error.dist","error.vel","rumbo","error.rumb")])
  else return(dumblan[abs(dumblan$error.dist)>pc.error | abs(dumblan$error.vel)>pc.error*2 | abs(dumblan$error.rumb)>pc.error,
                       c("camp","lance","recorrido","dist.hf","dist.vel","velocidad","mins","rumbo","rumb","vel.dist","error.dist","error.vel","error.rumb")])
    }
