/* 
 * Author: Marius Drulea
 * http://www.cv.utcluj.ro/optical-flow.html
 * 
 * Reference
 * Drulea, M.; Nedevschi, S., "Motion Estimation Using the Correlation Transform,"
 * Image Processing, IEEE Transactions on , vol.22, no.8, pp.3260,3270, Aug. 2013
 * 
 * Copyright (C) 2013 Technical University of Cluj-Napoca 
 */

#include "mex.h"

#include <algorithm>
#include <cmath>
using namespace std;

#include "Matrix.h"
#include "Matrix4.h"

inline double non_zero(double x, double s_val)
{
    //if x is to close to zero, return s_val
    //otherwise return x
    
    double y = x;
    if ( 0 <= x && x < s_val ) y = s_val;
    if (-s_val < x < 0) y = - s_val;
    
    return y;
}

void compute_correlation_transform(Matrix4 C, Matrix I)
{    
    double s_val = 1e-06; // a small value to avoid division by zero
    
    int dx = C.n_width;
    int dy = C.n_height;
    
    int dx2 = (dx - 1)/2;
    int dy2 = (dy - 1)/2;
	
	double b = 1.0/dx/dy;
    
    for (int j = 0; j < I.height; j++)
    {
        for (int i = 0; i < I.width; i++)
        {
            //bool is_nan_of_inf = false;
            //compute the local mean
            double meanI = 0;
            for (int y = -dy2; y <= dy2; y++)
            {                
                int jpy = j + y;
                if (jpy < 0) jpy = 0;                    
                if (jpy > I.height - 1) jpy = I.height - 1;                               
                
                for (int x = -dx2; x <= dx2; x++)
                {                    
                    int ipx = i + x;
                    if (ipx < 0) ipx = 0;
                    if (ipx > I.width - 1) ipx = I.width - 1;                    
                    					
					meanI = meanI + b*I(ipx, jpy);
                    
                    //if (mxIsNaN(I(ipx, jpy)) || mxIsInf(I(ipx, jpy))) is_nan_of_inf = true;
                }
			}
			
			//local standard deviation
            double stdI = 0;
            for (int y = -dy2; y <= dy2; y++)
            {                
                int jpy = j + y;
                if (jpy < 0) jpy = 0;                    
                if (jpy > I.height - 1) jpy = I.height - 1;                               
                
                for (int x = -dx2; x <= dx2; x++)
                {                    
                    int ipx = i + x;
                    if (ipx < 0) ipx = 0;
                    if (ipx > I.width - 1) ipx = I.width - 1;                    
                    					
					double diff = non_zero(I(ipx, jpy) - meanI, s_val);
                
					stdI = stdI + b*diff*diff;
                }
			}
			
			stdI = sqrt(stdI);
			
			//the correlation transform
			for (int y = -dy2; y <= dy2; y++)
            {                
                int jpy = j + y;
                if (jpy < 0) jpy = 0;                    
                if (jpy > I.height - 1) jpy = I.height - 1;                               
                
                for (int x = -dx2; x <= dx2; x++)
                {                    
                    int ipx = i + x;
                    if (ipx < 0) ipx = 0;
                    if (ipx > I.width - 1) ipx = I.width - 1;                    
                    										               
					double diff = non_zero(I(ipx, jpy) - meanI, s_val);
                    
                    C(i, j, x+dx2, y+dy2) = diff/stdI;
                    
                    //if (is_nan_of_inf == false) C(i, j, x+dx2, y+dy2) = diff/stdI;
                    //else                 C(i, j, x+dx2, y+dy2) = sqrt(-1.0); //assign nan value
                }
			}
                        
        }
    }
    
}		
        
/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    if(nrhs != 2)
        mexErrMsgTxt("Two inputs required.");
    if(nlhs != 0)
        mexErrMsgTxt("No outputs required.");
    
    //get the inputs
    
    /*  get the dimensions of the matrix input data */
    //Warning: the dimension are inversed; width becames height after matlab's implicit transposition
    const int* dims_C = mxGetDimensions(prhs[0]);
    int width = (int) dims_C[0];
    int height = (int) dims_C[1];
    int dims_C_4_or_2 = (int) mxGetNumberOfDimensions(prhs[0]);
    int n_width = 1; //if the number of dimensions is 2, then n_width = 1;
    int n_height = 1;
    if (dims_C_4_or_2 == 4)
    {
        n_width = (int) dims_C[2];
        n_height = (int) dims_C[3];    
    }
    
    /*  create the input structures */
    Matrix4 C(width, height, n_width, n_height, (double*) mxGetPr(prhs[0]));
    Matrix I(width, height, (double*) mxGetPr(prhs[1]));
    //the function updates the inputs; no outputs required
    
    /*  call the C subroutine */
    compute_correlation_transform(C, I);
}