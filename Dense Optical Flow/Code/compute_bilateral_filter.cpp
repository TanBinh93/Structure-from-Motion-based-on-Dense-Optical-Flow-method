
#include "mex.h"

#include <algorithm>
#include <math.h>
using namespace std;

#include "Matrix.h"
#include "Matrix4.h"

//forward declaration
void compute_bilateral_filter(
        Matrix4 bf,
        Matrix I1_L, Matrix I1_a, Matrix I1_b,
        int n_width, int n_height,
        double alpha, double beta
        );

/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    if(nrhs != 7)
        mexErrMsgTxt("Seven inputs required.");
    if(nlhs != 1)
        mexErrMsgTxt("One output required.");
    
    //get the inputs
    
    /*  get the dimensions of the matrix input data */
    //Warning: the dimension are inversed; width becames height after matlab's implicit transposition
    const int* dims = mxGetDimensions(prhs[0]);
    int width = (int) dims[0];
    int height = (int) dims[1];
    
    /*  create the input structures */
    Matrix I1_L(width, height, (double*) mxGetData(prhs[0]));
    Matrix I1_a(width, height, (double*) mxGetData(prhs[1]));
    Matrix I1_b(width, height, (double*) mxGetData(prhs[2]));
    //Warning: the dimension are inversed; n_width becames n_height after matlab's implicit transposition
    int n_height = (int) mxGetScalar(prhs[3]);
    int n_width = (int) mxGetScalar(prhs[4]);
    double alpha = (double) mxGetScalar(prhs[5]);
    double beta = (double) mxGetScalar(prhs[6]);
    
    /*  set the output pointer to the output matrix */
    int bf_dims[] = {width, height, n_width, n_height};
    plhs[0] = mxCreateNumericArray(4, bf_dims, mxDOUBLE_CLASS, mxREAL);
    /*  create a C pointer to a copy of the output matrix */
    Matrix4 bf(width, height, n_width, n_height, (double*) mxGetData(plhs[0]));
    
    //the function updates the inputs; no outputs required
    
    /*  call the C subroutine */
    compute_bilateral_filter(
            bf,
            I1_L, I1_a, I1_b,
            n_width, n_height,
            alpha, beta
            );
}

void compute_bilateral_filter(
        Matrix4 bf,
        Matrix I1_L, Matrix I1_a, Matrix I1_b,
        int n_width, int n_height,
        double alpha, double beta
        )
{
    int nx2 = (n_width - 1)/2;
    int ny2 = (n_height - 1)/2;
    
    for (int j = 0; j < I1_L.height; j++)
    {
        for (int i = 0; i < I1_L.width; i++)
        {
            double sum = 0;
            
            for (int y = -ny2; y <= ny2; y++)
            {
                bool isOutside_y = false;
                
                int jpy = j + y;
                if (jpy < 0)
                {
                    jpy = 0;
                    isOutside_y = true;
                }
                if (jpy > I1_L.height - 1)
                {
                    jpy = I1_L.height - 1;
                    isOutside_y = true;
                }
                //jpy = max(0, jpy);
                //jpy = min(I1_L.height - 1, jpy);
                
                int cy = y + ny2;
                
                for (int x = -nx2; x <= nx2; x++)
                {
                    bool isOutside_x = false;
                    
                    int ipx = i + x;
                    if (ipx < 0)
                    {
                        ipx = 0;
                        isOutside_x = true;
                    }
                    if (ipx > I1_L.width - 1)
                    {
                        ipx = I1_L.width - 1;
                        isOutside_x = true;
                    }
                    //ipx = max(0, ipx);
                    //ipx = min(I1_L.width - 1, ipx);
                    
                    int cx = x + nx2;
                    
                    double color_dist = 0;
                    double diff = 0; //auxiliary variable
                    //gaussian intensity exponent
                    diff = I1_L(ipx, jpy) - I1_L(i, j);
                    color_dist = color_dist + diff*diff;
                    diff = I1_a(ipx, jpy) - I1_a(i, j);
                    color_dist = color_dist + diff*diff;
                    diff = I1_b(ipx, jpy) - I1_b(i, j);
                    color_dist = color_dist + diff*diff;
                    
                    //the euclidian distance to the center
                    double dist = x*x + y*y;
                    
                    
                    //the combined exponent
                    double exponent = - color_dist/(2*alpha*alpha) - dist/(2*beta*beta);
                    
                    //combined factor
                    double combinedFactor = expf(exponent);
                    
                    bf(i, j, cx, cy) = combinedFactor;//replicate
                    
                    //boudary handling
                    //if (ipx < 0 || ipx > I1_L.width - 1 || jpy < 0 || jpy > I1_L.height - 1) combinedFactor = 0;
                    //boundary handling
                    bool isOutside = isOutside_x || isOutside_y;
                    if (isOutside )//0 outside
                        bf(i, j, cx, cy) = 0;
                    
                    sum += bf(i, j, cx, cy);
                }
            }
            
            //ignore the center
            //sum = sum - bf(i, j, nx2, ny2);
            //bf(i, j, nx2, ny2) = 0;
            
//            if (useNormalization == 1)
//            {
//                normalize the factor
//                for (int y = 0; y < n_height; y++)
//                {
//                    for (int x = 0; x < n_width; x++)
//                    {
//                        bf(i, j, x, y) = bf(i, j, x, y)/sum;
//                    }
//                }
//            }
//
        }
    }
    
}
