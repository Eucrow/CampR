\name{datgr.camp1}
\alias{datgr.camp1}
\title{Datos de biomasa y abundancia para una especie y campaña}
\usage{
datgr.camp1(gr, esp, camp, dns, cor.time = T)
}
\arguments{
  \item{gr}{Grupo de la especie: 1 peces, 2 crustáceos 3
  moluscos 4 equinodermos 5 invertebrados}

  \item{esp}{Código de la especie numérico o carácter
  con tres espacios. 999 para todas las especies del grupo}

  \item{camp}{Campaña de la que se extraen los datos: año
  comcreto (XX): Demersales "NXX", Porcupine "PXX", Arsa
  primavera "1XX" y Arsa otoño "2XX"}

  \item{dns}{Elige el origen de las bases de datos:
  Porcupine "Pnew", Cantábrico "Cant, Golfo de Cádiz
  "Arsa" (únicamente para sacar datos al IBTS, no
  gráficos)}

  \item{cor.time}{Si T corrige abundancias con la duración
  del lance para llevarlo a 30 minutos}
}
\value{
Devuelve un data.frame con información del lance, latitud,
longitud, profundidad, peso (gramos) y numero
}
\description{
Función de acceso a datos: Extrae los datos de peso y
número de una especie o conjunto de especies a partir de
las faunísticas de una campaña
}
\examples{
datgr.camp(1,50,"P10","Pnew",cor.time=T)
}

