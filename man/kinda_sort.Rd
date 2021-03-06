% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/zzz.R
\name{kinda_sort}
\alias{kinda_sort}
\title{Kinda sort}
\usage{
kinda_sort(x, n, decreasing = FALSE, indices)
}
\arguments{
\item{x}{a vector}

\item{n}{number of elements of x to remove from sorting (the default is
approximately 10\% of \code{x}), ignored if \code{indices} is given}

\item{decreasing}{logical; if \code{FALSE} (default), \code{x} is sorted
in increasing order}

\item{indices}{a vector of indices specifying which elemnts of \code{x}
should \emph{not} be sorted}
}
\value{
\code{x} sorted approximately \code{(length(x) - n)/length(x)*100} percent.
}
\description{
\code{\link{sort}} a vector but not very well. For a vector, \code{x},
\code{n} elements will be randomly selected, and their positions will
remain unchanged as all other elements are sorted.
}
\examples{
set.seed(1)
(x <- sample(1:10))
# [1]  3  4  5  7  2  8  9  6 10  1

kinda_sort(x)
# [1]  1  2  5  3  4  6  7  8  9 10

kinda_sort(x, indices = 2:5)
# [1]  1  4  5  7  2  3  6  8  9 10
}

