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

#include "Matrix.h"

void releaseMatrix(Matrix a)
{
	delete[] a.data;
}

Matrix::Matrix(int width, int height, double *data)
{
	this->width = width;
	this->height = height;
	this->data = data;
}