## misc things

if (getRversion() >= '2.15.1') {
  utils::globalVariables(c('setScreenSize'))
}

## stuff from rawr
# %||%, kinda_sort, interleave, ident
## 

'%||%' <- function(x, y) if (is.null(x)) y else x

#' Kinda sort
#' 
#' \code{\link{sort}} a vector but not very well. For a vector, \code{x},
#' \code{n} elements will be randomly selected, and their positions will
#' remain unchanged as all other elements are sorted.
#' 
#' @param x a vector
#' @param n number of elements of x to remove from sorting (the default is
#' approximately 10\% of \code{x}), ignored if \code{indices} is given
#' @param decreasing logical; if \code{FALSE} (default), \code{x} is sorted
#' in increasing order
#' @param indices a vector of indices specifying which elemnts of \code{x}
#' should \emph{not} be sorted
#' 
#' @return
#' \code{x} sorted approximately \code{(length(x) - n)/length(x)*100} percent.
#' 
#' @examples
#' set.seed(1)
#' (x <- sample(1:10))
#' # [1]  3  4  5  7  2  8  9  6 10  1
#' 
#' kinda_sort(x)
#' # [1]  1  2  5  3  4  6  7  8  9 10
#' 
#' kinda_sort(x, indices = 2:5)
#' # [1]  1  4  5  7  2  3  6  8  9 10
#' 
#' @export

kinda_sort <- function(x, n, decreasing = FALSE, indices) {
  lx <- length(x)
  n <- if (missing(n)) ceiling(0.1 * lx) else if (n > lx) lx else n 
  wh <- if (!missing(indices)) indices else sample(seq.int(lx), size = n)
  y <- x[wh]
  x[wh] <- NA
  rl <- with(rle(!is.na(x)), rep(values, lengths))
  x[rl] <- sort(x, decreasing = decreasing)
  x[!rl] <- y
  x
}

interleave <- function(..., which) {
  ## rawr::interleave
  l <- list(...)
  if (all(sapply(l, function(x) is.null(dim(x)))))
    return(c(do.call('rbind', l)))
  else {
    if (missing(which))
      stop('specify which: \'rbind\' or \'cbind\'')
    if (which == 'rbind')
      return(do.call('rbind', l)[order(sequence(sapply(l, nrow))), ])
    else if (which == 'cbind')
      return(do.call('cbind', l)[ , order(sequence(sapply(l, ncol)))])
  }
}

ident <- function(..., num.eq = TRUE, single.NA = TRUE, attrib.as.set = TRUE,
                  ignore.bytecode = TRUE, ignore.environment = FALSE) {
  ## rawr::ident
  if (length(l <- list(...)) < 2L)
    stop('must provide at least two objects')
  l <- sapply(1:(length(l) - 1), function(x)
    identical(l[x], l[x + 1], num.eq = num.eq, single.NA = single.NA,
              attrib.as.set = attrib.as.set, ignore.bytecode = ignore.bytecode,
              ignore.environment = ignore.environment))
  all(l)
}
