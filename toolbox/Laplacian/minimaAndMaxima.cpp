/*=================================================================
* Compute the minimal and maximal index of the mesh given a function

*
* This is a MEX-file for MATLAB.  
* Hui Wang, Mar. 24, 2009, wanghui19841109@163.com 
*
=================================================================*/

#include <mex.h>
#include <math.h>
#include <vector>
#include <algorithm>

typedef std::vector<int> Neighbor;
typedef std::vector<Neighbor> Neighbors;


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
	int i,numOfVertices,numOfFacets,n1,n2,n3;
    double *F,*scalarFunction,*percent,*minimaIndex,*maximaIndex;
    
    
    numOfFacets = mxGetM(prhs[0]);
	numOfVertices = mxGetM(prhs[1]);
	
	if(mxGetN(prhs[0]) != 3)
		mexErrMsgTxt("The mesh must be triangle mesh!");

	F = mxGetPr(prhs[0]);
	scalarFunction = mxGetPr(prhs[1]);
    percent = mxGetPr(prhs[2]);

	plhs[0] = mxCreateDoubleMatrix(numOfVertices,1,mxREAL);
	minimaIndex = mxGetPr(plhs[0]);
	plhs[1] = mxCreateDoubleMatrix(numOfVertices,1,mxREAL);
	maximaIndex = mxGetPr(plhs[1]);

	
    Neighbors neighbors;
	neighbors.resize(numOfVertices);

	for(i = 0;i < numOfFacets;i++)
	{
		n1 = (int)F[i]-1;
		n2 = (int)F[numOfFacets + i]-1;
		n3 = (int)F[2 * numOfFacets + i]-1;

        neighbors.at(n1).push_back(n2);
        neighbors.at(n1).push_back(n3);

		neighbors.at(n2).push_back(n1);
		neighbors.at(n2).push_back(n3);

		neighbors.at(n3).push_back(n1);
		neighbors.at(n3).push_back(n2);
	}
    
	int j,numOfNeighbor,maxNeighbor,minNeighbor;
	for(i = 0;i < numOfVertices;i++)
	{
		minimaIndex[i] = 0;
		maximaIndex[i] = 0;
		std::sort(neighbors.at(i).begin(),neighbors.at(i).end());
		Neighbor::iterator end = std::unique(neighbors.at(i).begin(),neighbors.at(i).end());
		Neighbor neighbor(neighbors.at(i).begin(),end);
       
        numOfNeighbor = neighbor.size();
        maxNeighbor = 0;
		minNeighbor = 0;
		
        for(j = 0;j < numOfNeighbor;j++)
        if(scalarFunction[int(neighbor.at(j))] > scalarFunction[i])
          maxNeighbor++;
		else if(scalarFunction[int(neighbor.at(j))] < scalarFunction[i])
		  minNeighbor++;
        
       if(maxNeighbor >= numOfNeighbor * percent[0])
          minimaIndex[i] = 1;
       if(minNeighbor >= numOfNeighbor * percent[0])
          maximaIndex[i] = 1;
	}
}

