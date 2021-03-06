% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CAMPtoHL_crust.R
\name{CAMPtoHLcrust}
\alias{CAMPtoHLcrust}
\title{Exporta datos de formato CAMP a formato DATRAs HL para crustáceos con tallas en ntallXXXdbf. Depende de que los códigos Aphia estén correctos en especies.dbf da error si son incompletos}
\usage{
CAMPtoHLcrust(camp, dns, inclSpecie = F, quart = T, incl2 = F)
}
\arguments{
\item{camp}{Campaña de la que se extraen los datos: año concreto (XX): Demersales "NXX", Porcupine "PXX", Arsa primavera "1XX" y Arsa otoño "2XX"}

\item{dns}{Elige el origen de las bases de datos: Porcupine "Porc", Cantábrico "Cant, Golfo de Cádiz "Arsa"}

\item{inclSpecie}{si T incluye el nombre de la especie y el Código, si no sólo el Aphia}

\item{quart}{si F deja en cada lance el valor del trimestre en que se realizó el lance, si T se deja el que tiene la campaña por defecto, 1 para Arsa 1Q, 3 para Porcupine y 4 para Arsa 4Q y Demersales Northern Shelf}

\item{incl2}{Si F deja fuera los lances especiales que actualmente no se transmiten a DATRAS, si T los incluye}
}
\value{
Devuelve un data.table con datos de cada especie en el formato HL de DATRAS. DATRAS requiere que los datos no tengan cabecera y el trimestre sea el que corresponde a la campaña, además de no tener "". Por ello se debe pasar a fichero con la orden: write.table(CAMPtoHH(Xyy,dns),"nombrearchivo.csv",sep=",",quote=F,col.names=F,row.names=F))
}
\description{
Función de Salida de datos a DATRAS:
Extrae las características de las capturas por lance para una campaña desde el fichero NTALLxxx.DBF y los transforma en formato DATRAS HL. De momento sólo funciona con peces y en el SPNGFS y SPPORC (Para completar crustáceos y moluscos hay que añadir los AphiaID, y para ARSA añadirlos al especies de ARSA)
}
\examples{
# CAMPtoHLcrust("N17","Cant",incl2=T,inclSpecie=T)
}
