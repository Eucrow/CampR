% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CVtal.bt.camp.R
\name{CVtal.bt.camp}
\alias{CVtal.bt.camp}
\title{Abundancias, SE y coeficientes de variación paramétricos calculados con bootstrap}
\usage{
CVtal.bt.camp(
  gr,
  esp,
  camp,
  dns,
  tmin,
  tmax,
  cor.time = TRUE,
  Rbt = 1000,
  excl.sect = NA
)
}
\arguments{
\item{gr}{Grupo de la especie: 1 peces, 2 crustáceos 3 moluscos 4 equinodermos 5 invertebrados 6 para deshechos y otros. 9 incluye todos los grupos a excepción del 6}

\item{esp}{Código de la especie numérico o carácter con tres espacios. 999 para todas las especies del grupo}

\item{camp}{Campaña de la que sacar datos año concreto (XX): Demersales "NXX", Porcupine "PXX", Arsa primavera "1XX" y Arsa otoño "2XX", Mediterráneo "MXX"}

\item{dns}{Elige el origen de las bases de datos: Porcupine "Porc", Cantábrico "Cant" o "Cnew", Golfo de Cádiz "Arsa" y Mediterráneo "Medi"}

\item{tmin}{Talla mínima}

\item{tmax}{Talla máxima}

\item{cor.time}{Si T corrige las abundancias en función de la duración del lance}

\item{Rbt}{número de iteraciones bootstrap para calcular los intervalos de confianza}

\item{excl.sect}{Excluye los sectores o subsectores dados como caracteres}
}
\value{
Devuelve el valor medio por bootstrap de la media, el error estándar y el CV
}
\description{
Función de resultados a partir de bootstrap con Rbt iteraciones conservando el diseño de muestreo
}
\seealso{
{\link{grafhistbox}}
}
