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
 * Simple regrouping of the terms such that <K*u, q> = <u, K'*q>; 
 * K'*q(i, j) = sum_x_y { q(i-x, j-y, x, y) - q(i, j, x, y)};
 **/
void apply_adjoint_linear_operator(Matrix Ksq, Matrix4 q)
{
    int nx2 = (q.n_width - 1)/2;
    int ny2 = (q.n_height - 1)/2;
    
    for (int j = 0; j < q.height; j++)
    {
        for (int i = 0; i < q.width; i++)
        {
            //compute Ksq (K'*q)
            double Ksq_i_j = 0;
            for (int y = -ny2; y <= ny2; y++)
            {
                int jmy = j - y;
                jmy = max(0, jmy);
                jmy = min(q.height - 1, jmy);
                
                int cy = y + ny2;
                
                for (int x = -nx2; x <= nx2; x++)
                {
                    
                    int imx = i - x;
                    imx = max(0, imx);
                    imx = min(q.width - 1, imx);
                    
                    int cx = x + nx2;
                    
                    Ksq_i_j = Ksq_i_j + q(imx, jmy, cx, cy) - q(i, j, cx, cy);                    
                }
            }
            
            Ksq(i, j) = Ksq_i_j;
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
    const int* dims_q = mxGetDimensions(prhs[1]);
    int width = (int) dims_q[0];
    int height = (int) dims_q[1];    
    int dims_q_4_or_2 = (int) mxGetNumberOfDimensions(prhs[1]);
    int n_width = 1; //if the number of dimensions is 2, then n_width = 1;
    int n_height = 1;
    if (dims_q_4_or_2 == 4)
    {
        n_width = (int) dims_q[2];
        n_height = (int) dims_q[3];    
    }
        
    /*  create the input structures */    
    Matrix Ksq(width, height, (double*) mxGetPr(prhs[0]));        
    Matrix4 q(width, height, n_width, n_height, (double*) mxGetPr(prhs[1]));    
    
    /* call the C subroutine */
    apply_adjoint_linear_operator(Ksq, q);
}