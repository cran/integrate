#include "S.h"
#include "Rinternals.h"

static SEXP rho;

/* All this routine does is call the approriate fortran
   function.  We need this so as to properly pass the S function */
/* changed to doubles for R by Thomas Lumley */
void cadapt(int *ndim, double *lower, double *upper,
	    int *minpts, int *maxpts,
	    void *functn, void *env,
	    double *eps, double *relerr,
	    int *lenwrk, double *finest, int *ifail)
{
  double *wrkstr;
  wrkstr = (double *) S_alloc(*lenwrk, sizeof(double));

  rho=env;

  F77_CALL(adapt)(ndim,lower,upper,minpts,maxpts,functn,eps,relerr,lenwrk,
		  wrkstr,finest,ifail);
}

/* This is the fixed routine called by adapt */
/* changed to double for R, also rewritten to use eval() */

double F77_NAME(adphlp)(void *f, int *ndim, double *z)
{
  SEXP args,resultsxp;
  double result;
  int i;

  PROTECT(args=allocVector(REALSXP,*ndim));
  for (i=0;i<*ndim;i++){
    REAL(args)[i]=z[i];
  }

  PROTECT(resultsxp=eval(lang2( (SEXP) f,args), (SEXP) rho));

  result=REAL(resultsxp)[0];

  UNPROTECT(2);

  return(result);
}
