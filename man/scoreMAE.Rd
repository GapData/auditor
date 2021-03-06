% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scoreMAE.R
\name{scoreMAE}
\alias{scoreMAE}
\title{Mean Absolute Error}
\usage{
scoreMAE(object)
}
\arguments{
\item{object}{An object of class ModelAudit.}
}
\value{
an object of class scoreAudit
}
\description{
Mean Absolute Error.
}
\examples{
library(car)
lm_model <- lm(prestige~education + women + income, data = Prestige)
lm_au <- audit(lm_model, data = Prestige, y = Prestige$prestige)
scoreMAE(lm_au)


}
\seealso{
\code{\link{score}}
}
