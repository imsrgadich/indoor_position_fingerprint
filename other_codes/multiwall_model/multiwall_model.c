
/*
 
  Compute 2D - MultiWall model
 
  Usage
  ------
 
  rs_amp = multiwall_model(TXpoint , RXpoint , walls , material , [L0]  , [n]);
 
 
  Inputs
  -------
 
  TXpoint                               Transmitter points (2 x Nt)
  RXpoint                               Receiver points (2 x Nr)
  walls                                 Walls (4 x nwall)
  material                              Material (2 x nwall)
  L0                                    Reference loss value at 1m (L0 = 40.2 default)
  n                                     Power decay factor (n = 2 default)
 
  Outputs
  -------
 
  rs_amp                                Total power (Nt x Nr)
 
  
 
  Example 1
  ---------
 
  walls                    = [1 1 9 9 3 2 5 7 5 ; 1 9 9 1 5 3 5 3 9 ; 1 9 9 1 3 5 9 7 7 ; 9 9 1 1 9 3 5 5 7];
  material                 = [1 1 1 1 2 2 2 2 2 ; 5.9 5.9 5.9 5.9 8 8 8 8 8];
  x_min                    = min(min(walls([1 , 3] , :) , [] , 2));
  x_max                    = max(max(walls([1 , 3] , :) , [] , 2));
  y_min                    = min(min(walls([2 , 4] , :) , [] , 2));
  y_max                    = max(max(walls([2 , 4] , :) , [] , 2));
  offset                   = 0.5;
  axis([x_min-offset x_max+offset y_min-offset y_max+offset])  
  plot(walls([1 , 3] , :) , walls([2 , 4] , :));
  hold on
  text(sum(walls([1 , 3] , :))/2 , sum(walls([2 , 4] , :))/2 , num2str((1:size(walls,2))','%d'))
  hold off

  TXpoint                  = [1;1];
  RXpoint                  = [8;8];
  L0                       = 40.2;
  n                        = 2;
  Nt                       = 5;
  Nr                       = 10;
  Cov                      = [3 0 ; 0 3];
  TXpoint                  = TXpoint(: , ones(1 , Nt)) + chol(Cov)'*randn(2 , Nt);
  RXpoint                  = RXpoint(: , ones(1 , Nr)) + chol(Cov)'*randn(2 , Nr);
  rs_amp                   = multiwall_model(TXpoint ,RXpoint , walls , material , L0 , n);
  


  Example 2
  ---------
 
  clear, close all
  nb_pts                   = 200;
  L0                       = 40.2;
  n                        = 2;


  load  data_mw;
  x_min                    = min(min(walls([1 , 3] , :) , [] , 2));
  x_max                    = max(max(walls([1 , 3] , :) , [] , 2));
  y_min                    = min(min(walls([2 , 4] , :) , [] , 2));
  y_max                    = max(max(walls([2 , 4] , :) , [] , 2));
  vectx                    = (x_min:(x_max-x_min)/(nb_pts-1):x_max);
  vecty                    = (y_min:(y_max-y_min)/(nb_pts-1):y_max);
  [X , Y]                  = meshgrid(vectx , vecty);
  RXpoint                  = [X(:) , Y(:)]';


  offset                   = 0.5;
  axis([x_min-offset x_max+offset y_min-offset y_max+offset])  
  plot(walls([1 , 3] , :) , walls([2 , 4] , :) , 'linewidth' , 2);
  title('select beacon(s) '' position (right click to end selection)')
  axis equal

  hold on
  [x , y]                 = getpts;
  TXpoint                 = [x' ; y'];
%  text(sum(walls([1 , 3] , :))/2 , sum(walls([2 , 4] , :))/2 , num2str((1:size(walls,2))','%d') , 'fontsize' , 6)
  plot(TXpoint(1 , :) , TXpoint(2 , :) , 'k+' , 'markersize' , 10) 
  hold off
  drawnow
 
  rs_amp                   = multiwall_model(TXpoint ,RXpoint , walls , material , L0 , n);

  figure(1)
  imagesc(vectx , vecty , reshape(log(sum(exp(rs_amp) , 1)) , nb_pts, nb_pts));
  hold on
  plot(walls([1 , 3] , :) , walls([2 , 4] , :) , 'linewidth' , 2);
  plot(TXpoint(1 , :) , TXpoint(2 , :) , 'k+' , 'markersize' , 10) 
  hold off
  axis xy
  colorbar
  axis equal
  title(sprintf('Multiwall model, L0 = %4.2f, n = %4.2f' , L0 , n))


  To compile
  ----------
 
 
  mex  multiwall_model.c
 
  mex  -f mexopts_intel10.bat -output multiwall_model.dll multiwall_model.c

  If OMP directive is added, OpenMP support for multicore computation

  mex -v -DOMP -f mexopts_intel10.bat -output multiwall_model.dll multiwall_model.c "C:\Program Files\Intel\Compiler\11.1\065\mkl\ia32\lib\mkl_core.lib" "C:\Program Files\Intel\Compiler\11.1\065\mkl\ia32\lib\mkl_intel_c.lib" "C:\Program Files\Intel\Compiler\11.1\065\mkl\ia32\lib\mkl_intel_thread.lib" "C:\Program Files\Intel\Compiler\11.1\065\lib\ia32\libiomp5md.lib" 

  If OS64

  mex -v -DOMP -f mexopts_intel10.bat -output multiwall_model.dll multiwall_model.c "C:\Program Files (x86)\Intel\Compiler\11.1\065\mkl\em64t\lib\mkl_core.lib" "C:\Program Files (x86)\Intel\Compiler\11.1\065\mkl\em64t\lib\mkl_intel_lp64.lib" "C:\Program Files (x86)\Intel\Compiler\11.1\065\mkl\em64t\lib\mkl_intel_thread.lib" -largeArrayDims 
 
 Author : Sébastien PARIS : sebastien.paris@lsis.org
 -------  Date : 04/27/2008

 ChangeLog  
 10/13/2011  : -Minor cleanup
               -Add openMP support (linked with MKL)
         
 

 Ref    : "Performance Evaluation of Indoor Localization Techniques Based on RF Power Measurements from Active or Passive Devices",
 -----    Damiano De Luca, Franco Mazzenga, Cristiano Monti and Marco Vari, EURASIP Journal on Applied Signal Processing
          Volume 2006, Article ID 74796, Pages 1-11
 
 */

#include <math.h>
#include <mex.h>

#ifdef OMP 
 #include <omp.h>
#endif

#ifndef MAX_THREADS
#define MAX_THREADS     64
#endif


#ifndef max
    #define max(a,b) (a >= b ? a : b)
    #define min(a,b) (a <= b ? a : b)
#endif

/*-------------------------------------------------------------------------------------------------------------- */
/* Function prototypes */

void multiwall_model(double *, double * , double * , double * , double  , double , double *, int  , int , int );

/*-------------------------------------------------------------------------------------------------------------- */
void mexFunction( int nlhs, mxArray *plhs[] , int nrhs, const mxArray *prhs[] )
{     
	double *TXpoint , *RXpoint , *walls , *material;   
	double L0=40.2, n = 2.0;
	int    Nt , Nr, nwalls;
	double *rs_amp;

	/* Inputs  */

	if( (nrhs <4) || (nrhs >6) )        
	{
		mexErrMsgTxt("At least 4 inputs are requiered for multiwall_model");   
	}

	TXpoint    = mxGetPr(prhs[0]);
	if( mxGetNumberOfDimensions(prhs[0]) !=2 || mxGetM(prhs[0]) != 2 )
	{
		mexErrMsgTxt("TXpoint must be (2 x Nt)"); 
	}
	Nt         = mxGetN(prhs[0]);

	RXpoint    = mxGetPr(prhs[1]);
	if( mxGetNumberOfDimensions(prhs[1]) !=2 || mxGetM(prhs[1]) != 2 )
	{
		mexErrMsgTxt("RXpoint must be (2 x Nr)");
	}    
	Nr         = mxGetN(prhs[1]);

	walls       = mxGetPr(prhs[2]);
	if( mxGetNumberOfDimensions(prhs[2]) !=2 || mxGetM(prhs[2]) !=4 )
	{
		mexErrMsgTxt("walls must be (4 x nwalls)");   
	}	
	nwalls      = mxGetN(prhs[2]);

	material    = mxGetPr(prhs[3]);
	if( mxGetNumberOfDimensions(prhs[3]) !=2 || mxGetM(prhs[3]) !=2 )
	{
		mexErrMsgTxt("material must be (2 x nwalls)");   
	}
	if( nrhs > 4)     
	{
		L0          = mxGetScalar(prhs[4]);
	}    
	if( nrhs > 5)   
	{
		n          = mxGetScalar(prhs[5]);
	}

	/* Outputs  */

	plhs[0]               = mxCreateDoubleMatrix(Nt , Nr, mxREAL);
	rs_amp                = mxGetPr(plhs[0]);


	/*---------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------*/
	/* ----------------------- MAIN CALL  -------------------------------------------- */
	/*---------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------*/
	/*---------------------------------------------------------------------------------*/

	multiwall_model(TXpoint ,RXpoint , walls , material , L0 , n, rs_amp, Nt , Nr, nwalls);

	/*-----------------------------------------------*/
	/*-----------------------------------------------*/
	/* ------------ END of Mex File ---------------- */
	/*-----------------------------------------------*/
	/*-----------------------------------------------*/
}
void multiwall_model(double *TXpoint, double *RXpoint , double *walls , double *material , double L0 , double n,double *rs_amp, int Nt , int Nr, int nwalls)
{	
	int i , j , k;	
	int id, jd, kd, iNt;
	double x1 , x2 , x3 , x4, y1 , y2, y3, y4;
	double disttr , Lfsl, L;
	double denom  , cx , cy , bx , by , dx , dy , t , u, nn = 5.0*n;

#ifdef OMP 
	int num_threads = min(MAX_THREADS,omp_get_num_procs()) ;
    omp_set_num_threads(num_threads);
#endif
	for (i=0 ; i < Nr ; i++)
	{	
		id    = i*2;	
		iNt   = i*Nt;
		x2    = RXpoint[0 + id];
		y2    = RXpoint[1 + id];
		for (j = 0 ; j < Nt ; j++)
		{
			jd       = j*2;
			x1       = TXpoint[0 + jd];
			y1       = TXpoint[1 + jd];
			bx       = (x2 - x1);
			by       = (y2 - y1);
			disttr   = bx*bx + by*by;
			Lfsl     = max(L0 , L0 + nn*log(disttr));
			L        = Lfsl;
#ifdef OMP 
#pragma omp parallel for default(none) private(k,kd,x3,y3,x4,y4,dx,dy,cx,cy,denom,t,u) shared (material,walls,nwalls,by,bx,x1,y1) reduction (+:L)
#endif
			for (k = 0 ; k < nwalls ; k++)
			{
				kd       = k*4;	
				x3       = walls[0 + kd];		
				y3       = walls[1 + kd];
				x4       = walls[2 + kd];
				y4       = walls[3 + kd];
				dx       = (x4 - x3);
				dy       = (y4 - y3);
				cx       = (x3 - x1);
				cy       = (y3 - y1);
				denom    = dy*bx - dx*by;
				if (denom != 0)			
				{
					t = (dy*cx - dx*cy)/denom;	
					u = (by*cx - bx*cy)/denom;
					if ( (t >= 0) && (t <= 1) && (u >= 0) && (u <= 1) )
					{
						L              += material[k*2 + 1];	
					}
				}
			}
			rs_amp[j + iNt] = -L;
		}
	}
}
/*----------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------*/