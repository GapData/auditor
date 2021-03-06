#' @title Predicted response vs Observed or Variable Values
#'
#' @description Plot of predicted response vs observed or variable Values.
#'
#'
#' @param object An object of class modelAudit.
#' @param ... Other modelAudit objects to be plotted together.
#' @param variable Name of model variable to order residuals. If value is NULL data order is taken. If value is "Observed response" the data is ordered by a vector of actual response (\code{y} parameter passed to the \code{\link{audit}} function).
#' @param smooth Logical, indicates whenever smooth line should be added.
#'
#' @examples
#' library(car)
#' lm_model <- lm(prestige~education + women + income, data = Prestige)
#' lm_au <- audit(lm_model, data = Prestige, y = Prestige$prestige)
#' plotPrediction(lm_au)
#'
#' library(randomForest)
#' rf_model <- randomForest(prestige~education + women + income, data = Prestige)
#' rf_au <- audit(rf_model, data = Prestige, y = Prestige$prestige)
#' plotPrediction(lm_au, rf_au)
#'
#' @seealso \code{\link{plot.modelAudit}}
#'
#' @import ggplot2
#'
#' @export
plotPrediction <- function(object, ..., variable = "Observed response", smooth = TRUE){
  values <- predicted <- label <- NULL

  df <- generatePredictionDF(object, variable)

  dfl <- list(...)
  if (length(dfl) > 0) {
    for (resp in dfl) {
      if(class(resp)=="modelAudit"){
        df <- rbind( df, generatePredictionDF(resp, variable) )
      }
    }
  }

  maybeVS <- ifelse(is.null(variable), "", "vs")

  p <- ggplot(df, aes(values, predicted, color = label)) +
          geom_point() +
          xlab(variable) +
          ylab("Predicted values") +
          ggtitle(paste("Predicted", maybeVS, variable)) +
          theme_light()

  if(smooth == TRUE){
    p <- p + geom_smooth(method = "loess", se = FALSE)
  }

  if(!is.null(variable) && variable == "Observed response") p <- p + geom_abline(slope = 1, intercept = 0)

  return(p)
}


generatePredictionDF <- function(object, variable){
  if(!is.null(variable)){
    if (variable == "Observed response") {
      values <- object$y
    } else {
      values <- object$data[,variable]
    }
  } else {
    values <- 1:length(object$residuals)
  }
  resultDF <- data.frame(predicted = object$fitted.values, values = values, label = object$label)
  return(resultDF)
}
