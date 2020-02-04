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

#include "Matrix4.h"

void releaseMatrix(Matrix4 a)
{
	delete[] a.data;
}

Matrix4::Matrix4(int width, int height, int n_width, int n_height, double *data)
{
	this->width = width;
	this->height = height;
	this->n_width = n_width;
	this->n_height = n_height;

	this->data = data;
}