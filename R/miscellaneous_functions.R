orderResidualsDF <- function(object, variable, is.df = FALSE){
  tmpDF <- data.frame(residuals=object$residuals)
  if(!is.null(variable)){
    if((variable == "Predicted response") || (variable == "Fitted values")) {
      values <- object$fitted.values

    } else if (variable == "Observed response") {
      values <- object$y
    } else {
      values <- object$data[,variable]
    }

  } else {
    values <- 1:nrow(tmpDF)
  }

  tmpDF$values <- values
  tmpDF <- tmpDF[order(values), ]
  if(is.df == FALSE){
    return(tmpDF$residuals)
  } else {
    return(tmpDF)
  }

}
