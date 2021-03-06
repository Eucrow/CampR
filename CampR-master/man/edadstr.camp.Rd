% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/edadstr.camp.r
\name{edadstr.camp}
\alias{edadstr.camp}
\title{Calcula las abundancias estratificadas por edad 
 
Función de resultados: abundancias estratificadas por edad para cada estrato batimétrico a partir de los datos del camp.}
\usage{
edadstr.camp(gr, esp, camp, dns = "Porc", plus = 8, cor.time = TRUE,
  AltAlk = NA, n.ots = F)
}
\arguments{
\item{gr}{Grupo de la especie: 1 peces sólo hay claves de talla para peces y cigala?}

\item{esp}{Código de la especie numérico o carácter con tres espacios. Sólo admite una especie por gráfica}

\item{camp}{Campaña de la que se extraen los datos un año concreto (XX): Demersales "NXX", Porcupine "PXX", Arsa primavera "1XX" y Arsa otoño "2XX"}

\item{dns}{Elige el origen de las bases de datos: Porcupine "Porc" o "Pnew", Cantábrico "Cant", Golfo de Cádiz "Arsa" (proporciona los datos para Medits pero no saca mapas)}

\item{plus}{Edad plus: Edad considerada como plus, todas las edades mayores se suman como edad +}

\item{cor.time}{Si T corrige las abundancias en función de la duración del lance}

\item{AltAlk}{ALK alternativa tomada de un fichero de edad del Camp edadXYY.dbf sin ruta ni extensión}
}
\description{
Calcula las abundancias estratificadas por edad 
 
Función de resultados: abundancias estratificadas por edad para cada estrato batimétrico a partir de los datos del camp.
}
\examples{
edadstr.camp(1,45,"P01","Porc",8)
}
\seealso{
Other edades: \code{\link{ALKs.dns.camp}},
  \code{\link{GetAlk.camp}}, \code{\link{bubbage.camp}},
  \code{\link{datagegr.camp}}, \code{\link{edadsect.camp}},
  \code{\link{grafedtal.camps}},
  \code{\link{grafedtal.camp}},
  \code{\link{logabage.camp}},
  \code{\link{logabage2.camp}}, \code{\link{maphistage}}
}
\concept{edades}
