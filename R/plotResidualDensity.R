#' @title Residual Density Plot
#'
#' @description Density of model residuals.
#'
#' @param object An object of class ModelAudit.
#' @param ... Other modelAudit objects to be plotted together.
#' @param variable A variable name. Residuals will be plotted separately for different values of variable. or continuous variables, they will be separated by a median.
#'
#' @return ggplot object
#'
#' @examples
#' library(car)
#' lm_model <- lm(prestige~education + women + income, data = Prestige)
#' lm_au <- audit(lm_model, data = Prestige, y = Prestige$prestige)
#' plotResidualDensity(lm_au)
#'
#' library(randomForest)
#' rf_model <- randomForest(prestige~education + women + income, data = Prestige)
#' rf_au <- audit(rf_model, data = Prestige, y = Prestige$prestige)
#' plotResidualDensity(lm_au, rf_au)
#'
#' @seealso \code{\link{plot.modelAudit}}
#'
#' @import ggplot2
#'
#' @export


plotResidualDensity <- function(object, ..., variable = NULL){
  residuals <- label <- NULL
  df <- getResidDensDF(object, variable)

  dfl <- list(...)
  if (length(dfl) > 0) {
    for (resp in dfl) {
      if(class(resp)=="modelAudit"){
        df <- rbind( df, getResidDensDF(resp, variable) )
      }
    }
  }


  if(!is.null(variable)) {
    p <- ggplot(df, aes(x = residuals, fill = variable)) +
      stat_density(alpha = 0.3, position="identity")+
      geom_vline(xintercept = 0) +
      geom_rug(aes(color = variable), alpha = 0.5) +
      facet_grid(label~.) +
      theme_light() +
      xlab("residuals") +
      ggtitle("Residual Density")

  } else {
    p <- ggplot(df, aes(x = residuals, fill = label)) +
      stat_density(alpha = 0.3, position="identity")+
      geom_vline(xintercept = 0) +
      geom_rug(aes(color = label), alpha = 0.5) +
      theme_light() +
      xlab("residuals") +
      ggtitle("Residual Density")
  }

  return(p)
}


getResidDensDF <- function(object, variable){

  df <- data.frame(residuals = object$residuals, label = object$label)
  if (!is.null(variable)) {
    modelData <- object$data

    if (class(modelData[, variable]) %in% c("numeric","integer")) {
      varMedian <- median(modelData[,variable])
      df$variable <- ifelse(modelData[,variable] > varMedian, paste(">", variable, "median"), paste("<=", variable, "median"))
    } else {
      df$variable <-modelData[,variable]
    }
  }

  return(df)
}

