\name{integrate}
\alias{adapt}
\alias{integrate}
\alias{print.integration}
\title{Adaptive Integration in 1--20 Dimensions}
\usage{
adapt(ndim, lower, upper, minpts, maxpts, functn, eps,\dots)
integrate(functn, lower,upper,minpts=100,maxpts=500,eps=0.01,\dots)
}
\description{
    \code{integrate()} integrates a function of 1 variable over a
    specified interval, i.e. it computes
    \deqn{\int_l^u \mbox{functn}(t) \mbox{dt}}{integral[l .. u] functn(t) dt}
    where \eqn{l =}\code{lower}, \eqn{u =}\code{upper}.

    \code{adapt()} allows 1 to 20 variables and integrates over a rectangular
    box.
}
\arguments{
\item{ndim}{the number of dimensions of the function/integral}
\item{lower}{vector of at least length ndim of the lower bounds on the integral}
\item{upper}{vector of at least length ndim of the upper bounds on the integral}
\item{minpts}{the minimum number of function evaluations}
\item{maxpts}{the maximum number of function evaluations or NULL }
\item{functn}{the name of an \R function.
    \code{functn} should take a single vector
    argument and possibly some parameters and return the function value at
    that point.  \code{functn} must return a single numeric value.}
\item{eps}{The desired accuracy for the relative error.}
\item{\dots}{Other parameters to be passed to \code{functn}}
}
\value{
A list of \code{\link{class} "integrate"} with components
\item{value}{the estimated integral}
\item{relerr}{the estimated relative error; \code{< eps} argument if}
\item{minpts}{the actual number of function evaluations}
\item{ifail}{an error indicator.  If ifail is not equal to 0, the function
    warns the user of the error condition.}
}
\note{This is modified from Mike Meyer's S code. The functions just
call A.C. Genz's fortran ADAPT subroutine to do all of the
calculations.  A work array is allocated within the C/Fortran code. 

The Fortran function has been modified to use double precision, for
compatibility with \R. It only works in two or more dimensions; for
one-dimensional integrals we integrate over a strip of unit width.

Setting maxpts to NULL asks the function to keep doubling maxpts until
the desired precision is achieved or R runs out of room.
}

\examples{
integrate(dnorm,-1.96,1.96)
##-	   value       relerr	    minpts	 lenwrk	       ifail
##-    0.9500042 0.0003456134	       125	     73		   0

normloc <- function(x,mu) dnorm(x-mu)
integrate(normloc,-1.96,1.96, mu=0) # passing 'mu' arg. to  normloc()
integrate(normloc,-2.96,0.96, mu=-1)

## Example of a three dimensional spherical normal distribution:
ir2pi <- 1/sqrt(2*pi)
fred <- function(z) { ir2pi^length(z) * exp(-0.5 * sum(z * z))}
adapt(3, c(-2,-2,-2),c(2,2,2),100,500,fred,.01)
##-	   value       relerr	    minpts	 lenwrk	       ifail
##-    0.8691984 2.579652e-05	       345	     54		   0
##
## i.e., it took 345 function evaluations to find the integral.
      adapt(3, c(-2,-2,-2),c(2,2,2),100,NULL,fred,.00001)
##       value       relerr       minpts       lenwrk        ifail 
##   0.8696159 1.902895e-06         5073          804            0
##  ie 5073 points needed (4 doublings).
}
\keyword{math}
\keyword{utilities}

