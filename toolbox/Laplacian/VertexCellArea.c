/*=================================================================
* The cell area of each vertex

*
* This is a MEX-file for MATLAB.  
* Hui Wang, Dec. 31, 2009, wanghui19841109@163.com 
*
=================================================================*/

#include <mex.h>
#include <math.h>

double areaOfFacet(double P[], double Q[], double R[])
{
	double d[3];
    d[0] = (Q[1] - P[1]) * (R[2] - P[2]) - (Q[2] - P[2]) * (R[1] - P[1]);
    d[1] = (Q[2] - P[2]) * (R[0] - P[0]) - (Q[0] - P[0]) * (R[2] - P[2]);
    d[2] = (Q[0] - P[0]) * (R[1] - P[1]) - (Q[1] - P[1]) * (R[0] - P[0]);

	return 0.5 * sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
}


double cotangent(double P[], double Q[], double R[])
{
	double dot = (P[0] - Q[0]) * (R[0] - Q[0]) + (P[1] - Q[1]) * (R[1] - Q[1]) 
        + (P[2] - Q[2]) * (R[2] - Q[2]);
    
	double d[3];
    double cross_norm;
    
    d[0] = (Q[1] - P[1]) * (R[2] - P[2]) - (Q[2] - P[2]) * (R[1] - P[1]);
    d[1] = (Q[2] - P[2]) * (R[0] - P[0]) - (Q[0] - P[0]) * (R[2] - P[2]);
    d[2] = (Q[0] - P[0]) * (R[1] - P[1]) - (Q[1] - P[1]) * (R[0] - P[0]);
    cross_norm = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
    
	if(cross_norm != 0.0)
		return (dot/cross_norm);
	else
		return 0.0; 
}

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
	int i,numOfVertices,numOfFacets,n1,n2,n3;
	double *cellAreaOfVertex,*V,*F;
	double v1[3],v2[3],v3[3];
	double cot1,cot2,cot3,a12,a13,a23,area;

	numOfVertices = mxGetM(prhs[0]);
	numOfFacets = mxGetM(prhs[1]);
	if(mxGetN(prhs[1]) != 3)
		mexErrMsgTxt("The mesh must be triangle mesh!");

	V = mxGetPr(prhs[0]);
	F = mxGetPr(prhs[1]);

	plhs[0] = mxCreateDoubleMatrix(numOfVertices,1,mxREAL);
	cellAreaOfVertex = mxGetPr(plhs[0]);
    for(i = 0; i < numOfVertices;i++)
	  cellAreaOfVertex[i] = 0;

	for(i = 0;i < numOfFacets;i++)
	{
		n1 = (int)F[i]-1;
		n2 = (int)F[numOfFacets + i]-1;
		n3 = (int)F[2 * numOfFacets + i]-1;
        
		v1[0] = V[n1];
        v1[1] = V[numOfVertices + n1];
        v1[2] = V[2*numOfVertices + n1];
        
        v2[0] = V[n2];
        v2[1] = V[numOfVertices + n2];
        v2[2] = V[2*numOfVertices + n2];
        
        v3[0] = V[n3];
        v3[1] = V[numOfVertices + n3];
        v3[2] = V[2*numOfVertices + n3];
        
		cot1 = cotangent(v2,v1,v3);
		cot2 = cotangent(v1,v2,v3);
		cot3 = cotangent(v1,v3,v2);
        
		if(cot1 * cot2 * cot3 > 0)
		{
          a12 = ((v1[0] - v2[0]) * (v1[0] - v2[0])
            + (v1[1] - v2[1]) * (v1[1] - v2[1])
            + (v1[2] - v2[2]) * (v1[2] - v2[2])) * cot3;
          a23 = ((v2[0] - v3[0]) * (v2[0] - v3[0])
            + (v2[1] - v3[1]) * (v2[1] - v3[1])
            + (v2[2] - v3[2]) * (v2[2] - v3[2])) * cot1;
          a13 = ((v1[0] - v3[0]) * (v1[0] - v3[0])
            + (v1[1] - v3[1]) * (v1[1] - v3[1])
            + (v1[2] - v3[2]) * (v1[2] - v3[2])) * cot2;

		  cellAreaOfVertex[n1] += 0.125 * (a12 + a13);
		  cellAreaOfVertex[n2] += 0.125 * (a12 + a23);
		  cellAreaOfVertex[n3] += 0.125 * (a13 + a23);
		}
		else
		{
           area = 0.25 * areaOfFacet(v1,v2,v3);
           cellAreaOfVertex[n1] += area;
		   cellAreaOfVertex[n2] += area;
		   cellAreaOfVertex[n3] += area;

		   if(cot1 <= 0)
			   cellAreaOfVertex[n1] += area;
		   if(cot2 <= 0)
		       cellAreaOfVertex[n2] += area;
		   if(cot3 <= 0)
			   cellAreaOfVertex[n3] += area;
		} 
	}
}
