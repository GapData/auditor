#' @title Runs Score
#'
#' @description Score based on Runs test statistic. Note that this test is not very strong. It utilizes only signs of the residuals.
#'
#' @param object object An object of class ModelAudit
#' @param variable name of dependent or independent variable to order residuals. If NULL the fitted values are taken.
#'
#' @importFrom tseries runs.test
#'
#' @export

scoreRuns <- function(object, variable = NULL){
  if(is.null(variable)) {
    variable <- "Fitted values"
    dataRuns <- data.frame(variable=object$fitted.values, residuals = object$residuals)
  } else {
    dataRuns <- data.frame(variable=object$data[,variable], residuals = object$residuals)
  }

    dataRunsOrdered <- dplyr::arrange(dataRuns, variable)
    residuals <- dataRunsOrdered$residuals
    signumOfResiduals <- factor(sign(residuals))
    RunsTested <- runs.test(signumOfResiduals)


  result <- list(
    name = "Runs test",
    score = RunsTested$statistic[[1]],
    pValue = RunsTested$p.value
  )

    class(result) <- "scoreAudit"
  return(result)
}


