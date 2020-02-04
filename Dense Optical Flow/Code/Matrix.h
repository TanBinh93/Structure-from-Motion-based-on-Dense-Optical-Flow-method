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

#pragma once

class Matrix
{
public:
	int width;
	int height;
	double* data;

	Matrix(void);
	Matrix(int width, int height, double* data);
	
	inline double operator ()(int w, int h) const
	{
		return data[h*width + w];
	}

	inline double& operator ()(int w, int h)
	{
		return data[h*width + w];
	}		
};