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
#include <math.h>
using namespace std;

#include "Matrix.h"
#include "Matrix4.h"

/*
 * Ku(i, j, x, y) = u(i+x, j+y) - u(i, j);
 */
void apply_linear_operator(Matrix4 Ku, Matrix u)
{
    int nx2 = (Ku.n_width - 1)/2;
    int ny2 = (Ku.n_height - 1)/2;
    
    for (int j = 0; j < u.height; j++)
    {
        for (int i = 0; i < u.width; i++)
        {
            //process the neighborhood of the location (i, j)
            for (int y = -ny2; y <= ny2; y++)
            {
                int jpy = j + y;
                jpy = max(0, jpy);
                jpy = min(u.height - 1, jpy);
                
                int cy = y + ny2;
                
                for (int x = -nx2; x <= nx2; x++)
                {
                    
                    int ipx = i + x;
                    ipx = max(0, ipx);
                    ipx = min(u.width - 1, ipx);
                    
                    int cx = x + nx2;                                        
                    
                    //computes Ku
                    Ku(i, j, cx, cy) = u(ipx, jpy) - u(i, j);                    
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
    /*  get the dimensions of the input data matrix */
    const int* dims_Ku = mxGetDimensions(prhs[0]);
    int width = (int) dims_Ku[0];
    int height = (int) dims_Ku[1];    
    int dims_Ku_4_or_2 = (int) mxGetNumberOfDimensions(prhs[0]);
    int n_width = 1; //if the number of dimensions is 2, then n_width = 1;
    int n_height = 1;
    if (dims_Ku_4_or_2 == 4)
    {
        n_width = (int) dims_Ku[2];
        n_height = (int) dims_Ku[3];    
    }
        
    /*  create the input structures */
    Matrix4 Ku(width, height, n_width, n_height, (double*) mxGetPr(prhs[0]));    
    Matrix u(width, height, (double*) mxGetPr(prhs[1]));        
    
    /* call the C subroutine */
    apply_linear_operator(Ku, u);
}


