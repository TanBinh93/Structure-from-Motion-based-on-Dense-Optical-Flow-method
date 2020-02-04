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
#include "Matrix.h"

void occlusions_map(Matrix occ, Matrix hist, Matrix u, Matrix v)
{
    //initialization
    for (int j = 0; j < u.height; j++)
    {
        for (int i = 0; i < u.width; i++)
        {
            int cInd = j*u.width + i;
            occ.data[cInd] = 0;
            hist.data[cInd] = 0;
        }
    }
    
    //computes how many pixels hits a specific location after warping with the flow u and v
    //if the pixel (i, j) goes to (i+u, j+v), increase hist(i+u, j+v) with 1
    //use bilinear interpolation for non-integer displacements
    for (int j = 0; j < u.height; j++)
    {
        for (int i = 0; i < u.width; i++)
        {
            //the coordinates after adding the flow
            //the integer coordinates
            int jv = (int) ( j + v(i, j) );
            int iu = (int) ( i + u(i, j) );
            
            //the fractional part of the coordinates
            double alpha = j + v(i, j) - jv;
            double beta = i + u(i, j) - iu;
            
            if (jv >= 0 && jv < u.height && iu >= 0 && iu < u.width)
            {                
                /*
                 * the warped location (i + u, j + v) belongs to the pixels 
                 * (iu, jv), (iu, jv+1), (iu+1, jv), (iu+1, jv+1);
                 * how much it "belongs" to these locations is given by the 
                 * following factors, similar to bilinear interpolation
                 * add the factors to the histograms of the pixels
                 */
                hist(iu, jv) += (1-alpha)*(1-beta);                
                if (jv + 1 < u.height) hist(iu, jv+1) += alpha*(1-beta);
                if (iu + 1 < u.width) hist(iu + 1, jv) += (1-alpha)*beta;
                if (jv + 1 < u.height && iu + 1 < u.width) hist(iu+1, jv+1) += alpha * beta;
            }
        }
    }
    
    //compute the "amount" of occlusion for each pixel
    //a pixel is occluded if it hits the same location as some other pixels
    //(i, j) goes to (i+u, j+v) and hist(i+u, j+v) tells how many pixels reach (i+u, j+v)
    //again, use bilinear interpolation because (i+u, j+v) is not integer
    for (int j = 0; j < u.height; j++)
    {
        for (int i = 0; i < u.width; i++)
        {
            int jv = (int) ( j + v(i, j) );
            int iu = (int) ( i + u(i, j) );
            
            double alpha = j + v(i, j) - jv;
            double beta = i + u(i, j) - iu;
            
            if (jv >= 0 && jv < u.height && iu >= 0 && iu < u.width)
            {                
                occ(i, j) += (1-alpha)*(1-beta) * hist(iu, jv);
                if (jv + 1 < u.height) occ(i, j) += alpha*(1-beta) * hist(iu, jv+1);
                if (iu + 1 < u.width) occ(i, j) += (1-alpha)*beta * hist(iu+1, jv);
                if (jv + 1 < u.height && iu + 1 < u.width) occ(i, j) += alpha * beta * hist(iu+1, jv+1);
            }
            else
            {
                occ(i, j) = 10;//if the vector goes outside the image, it is occluded
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
    if(nlhs != 2)
        mexErrMsgTxt("Two outputs required.");
    
    //get the inputs
    
    /*  get the dimensions of the matrix input data */
    //Warning: the dimension are inversed; width becames height after matlab's implicit transposition
    const int* dims = mxGetDimensions(prhs[0]);
    int width = (int) dims[0];
    int height = (int) dims[1];    
    
    /*  create the input structures */
    Matrix u(width, height, (double*) mxGetPr(prhs[0]));
    Matrix v(width, height, (double*) mxGetPr(prhs[1]));    
    /* create the output structures */
    plhs[0] = mxCreateDoubleMatrix(width, height, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(width, height, mxREAL);
    Matrix occ(width, height, (double*) mxGetPr(plhs[0]));
    Matrix hist(width, height, (double*) mxGetPr(plhs[1]));
    /*  call the C subroutine */
   occlusions_map(occ, hist, u, v);
}