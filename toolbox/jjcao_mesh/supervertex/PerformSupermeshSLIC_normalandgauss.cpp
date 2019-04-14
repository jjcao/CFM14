#include <iostream>
#include <cmath>
#include <vector>
#include <cfloat>
#include <fstream>
#include <string>
#include <algorithm>
#include "KDTree.h"
#include "mex.h"
using namespace std;

//===========================================================================
///	PerformSupermeshSLIC
///
///	Performs k mean segmentation. It is fast because it searches locally, not
/// over the entire image.
//===========================================================================

void PerformSupermeshSLIC(
	vector< vector<double> >& input_verts,
	vector<vector<int>>&          input_faces,
	vector<vector<double>>&   facenormal,
	vector<int>&                        landmarks,
	vector<double>&                 cgauss,  //
	vector<int>&				         klabels)
{
	const int numk = landmarks.size();
	const int verts = input_verts.size();
	const int faces = input_faces.size();

	vector<double> clustersize(numk, 0);
	vector<double> inv(numk, 0);                                                           //to store 1/clustersize[k] values
	vector<double> sigmac(numk, 0);
	vector<double> sigmax(numk, 0);
	vector<double> sigmay(numk, 0);
	vector<double> sigmaz(numk, 0);
	klabels.assign(faces,-1); 

	vector<vector<double>> input_data(faces, vector<double>(3,0));
	for (int i = 0; i < faces; i++)
	{
		for (int j = 0; j < 3; j++)
		{
		input_data[i][j] = (input_verts[input_faces[i][0]][j]+input_verts[input_faces[i][1]][j]+input_verts[input_faces[i][2]][j])/3;
		}
	}

     KDTree* tree = new KDTree( input_data );
	 for (int k = 0; k < numk; k++)
	 {
		 vector<double> point(3,0);
		 point[0] = input_verts[landmarks[k]][0];
		 point[1] = input_verts[landmarks[k]][1];
		 point[2] = input_verts[landmarks[k]][2]; 
		landmarks[k] = tree->closest_point(point);
	 }

	vector<double> distvec(faces, DBL_MAX);

	double dc, dx, dy,dz;
	int parts = faces/(numk-2);      //每一个领域点的个数 
	double dist;
	vector<int>  vertIndex;


    //vector<int>  vertIndex;
	for( int itr = 0; itr < 10; itr++ )
	{
		for( int n = 0; n < numk; n++ )
		{
//--------------------------------------------------------------------------
			vector<double>  p(3,0);
			p[0] = input_data[landmarks[n]][0];
			p[1] = input_data[landmarks[n]][1]; 
			p[2] = input_data[landmarks[n]][2]; 

			vector<double> distsss;

			tree->k_closest_points(p,parts,vertIndex,distsss);
		
			for  (unsigned int count=0; count < vertIndex.size(); count++)
			{
				if(cgauss[vertIndex[count]] <cgauss[landmarks[n]])  landmarks[n]=vertIndex[count];
			}
//-----------------------------------------------------------------------------------------------------------------------------------
			for (unsigned int i=0; i < vertIndex.size(); i++)
			{
				double ddx = facenormal[vertIndex[i]][0] -facenormal[landmarks[n]][0];
				double ddy = facenormal[vertIndex[i]][1] -facenormal[landmarks[n]][1];
				double ddz = facenormal[vertIndex[i]][2] -facenormal[landmarks[n]][2];
			    double dnormal= sqrt(ddx*ddx + ddy*ddy + ddz*ddz);
				dx=input_data[vertIndex[i]][0] -input_data[landmarks[n]][0];
			    dy=input_data[vertIndex[i]][1] -input_data[landmarks[n]][1];
				dz=input_data[vertIndex[i]][2] -input_data[landmarks[n]][2];
				dist=dnormal+5*sqrt((dx*dx+dy*dy+dz*dz)*numk /faces);
				if(dist < distvec[vertIndex[i]])
				{
					distvec[vertIndex[i]] =dist;
					klabels[vertIndex[i]] =n;
				}
			}
		}

		//--------------------------------------------------------------------------
		vector<int>  reset(0);
		for (int i = 0; i <faces; i++ )
		{if(klabels[i]==-1)  reset.push_back(i);}
		vector<double> distss(input_data.size(), DBL_MAX);
		for (int k= 0;k< numk; k++)
		{
			for (unsigned int j= 0; j <reset.size() ; j++)
			{
				double ddx = facenormal[reset[j]][0] -facenormal[landmarks[k]][0];
				double ddy = facenormal[reset[j]][1] -facenormal[landmarks[k]][1];
				double ddz = facenormal[reset[j]][2] -facenormal[landmarks[k]][2];
				double dnormal= sqrt(ddx*ddx + ddy*ddy + ddz*ddz);
				dx=input_data[reset[j]][0] -input_data[landmarks[k]][0];
				dy=input_data[reset[j]][1] -input_data[landmarks[k]][1];
				dz=input_data[reset[j]][2] -input_data[landmarks[k]][2];
				dist=dnormal+sqrt((dx*dx+dy*dy+dz*dz)*numk /faces);
				if(dist < distss[reset[j]])
				{
					distss[reset[j]] =dist;
					klabels[reset[j]] =k;
				}
			}
		}

		//--------------------------------------------------------------------------
		//-----------------------------------------------------------------
		// Recalculate the centroid and store in the seed values
		//-----------------------------------------------------------------
		//instead of reassigning memory on each iteration, just reset.

		sigmac.assign(numk, 0); 
		sigmax.assign(numk, 0);
		sigmay.assign(numk, 0);
		sigmaz.assign(numk, 0);
		clustersize.assign(numk, 0);

	//--------------------------------------------------------------------------------
		for (int j = 0; j<faces; j++)
		{
			//sigmac[klabels[j]] += cgauss[j];
			sigmax[klabels[j]] += input_data[j][0];
			sigmay[klabels[j]] += input_data[j][1];
			sigmaz[klabels[j]] += input_data[j][2];
			clustersize[klabels[j]] += 1.0;
        }

//----------------------------------------------------------------------------------
		for (int k = 0; k < numk; k++)
		{
			if(clustersize[k] <= 0)  clustersize[k] = 1;
			inv[k] = 1.0/clustersize[k];
		}

//------------------------------------------------------------------------------------
	
		//vector<double>  pp(4,0);
		vector<double>  pp(3,0);
       for (int k = 0; k < numk; k++)
       { 
		   pp.assign(3,0);
		   //pp[3]=sigmac[k]*inv[k];
		   pp[0]=sigmax[k]*inv[k];
		   pp[1]=sigmay[k]*inv[k];
		   pp[2]=sigmaz[k]*inv[k];
		   int idx_close = tree -> closest_point( pp );
		   landmarks[k] = idx_close;
	   }
}
	 tree->~KDTree();
	}
	//--------------------------------------------------------------------------------------------------------

// matlab entry point
void retrieve_data( const mxArray* matptr, vector< vector<double> >& dataV, int& npoints, int& ndims)
{
	// retrieve pointer from the MX form
	double* data = mxGetPr(matptr);
	// check that I actually received something
	if( data == NULL )
		mexErrMsgTxt("vararg{1} must be a [kxN] matrix of data\n");

	// retrieve amount of points
	npoints = mxGetM(matptr);
	ndims   = mxGetN(matptr);

	// FILL THE DATA STRUCTURES
	dataV.resize(npoints, vector<double>(ndims));
	for( int i=0; i<npoints; i++ )
		for( int j=0; j<ndims; j++ )
			dataV[i][j] = data[ i + j*npoints ]; 
}

void retrieve_faces( const mxArray* matptr, vector< vector<int> >& dataV, int& npoints, int& ndims)
{
	// retrieve pointer from the MX form
	double* data = mxGetPr(matptr);
	// check that I actually received something
	if( data == NULL )
		mexErrMsgTxt("vararg{1} must be a [kxN] matrix of data\n");

	// retrieve amount of points
	npoints = mxGetM(matptr);
	ndims   = mxGetN(matptr);

	// FILL THE DATA STRUCTURES
	dataV.resize(npoints, vector<int>(ndims));
	for( int i=0; i<npoints; i++ )
		for( int j=0; j<ndims; j++ )
			dataV[i][j] = data[ i + j*npoints ] -1 ; 
}
void retrieve_landmarks( const mxArray* matptr, vector<int>& point  )
{
	// check that I actually received something
	if( matptr == NULL )
		mexErrMsgTxt("vararg{3} must be a [kxN] matrix of data\n");

	double* data = mxGetPr(matptr);
	int a = mxGetM(matptr);
	int b = mxGetN(matptr);
	int num = a*b;
	point.resize(num);
	for(int dim=0; dim < num; dim++)
		point[dim] = data[dim];
}

void retrieve_guass( const mxArray* matptr, vector<double>& point  )
{
	// check that I actually received something
	if( matptr == NULL )
		mexErrMsgTxt("vararg{3} must be a [kxN] matrix of data\n");

	double* data = mxGetPr(matptr);
	int a = mxGetM(matptr);
	int b = mxGetN(matptr);
	int num = a*b;
	point.resize(num);
	for(int dim=0; dim < num; dim++)
		point[dim] = data[dim];
}

void mexFunction(int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[])
{
	// check number of arguments
	if( nrhs!=5 )
		mexErrMsgTxt("This function requires 5 arguments\n");
	/*if( !mxIsNumeric(prhs[0]) )
	mexErrMsgTxt("varargin{0} must be a valid kdtree pointer\n");
	if( !mxIsNumeric(prhs[1]) )
	mexErrMsgTxt("varargin{1} must be a query point\n");
	if( !mxIsNumeric(prhs[2]) )
	mexErrMsgTxt("varargin{2} must be a query point\n");*/
		
	// retrieve the input_data
	vector< vector<double> > input_verts;
	int npoints;
	int ndims;
	retrieve_data( prhs[0], input_verts, npoints, ndims );

    // retrieve the query point
   vector< vector<int> > input_faces;
   retrieve_faces( prhs[1], input_faces, npoints, ndims );

   // retrieve the normal data
   vector<vector<double>> facenormal;
   retrieve_data( prhs[2], facenormal, npoints, ndims );

    // retrieve the query cardinality
    vector<int> landmarks;
     retrieve_landmarks( prhs[3], landmarks );

	 // guass
	 vector<double>  cgauss;
	 retrieve_guass(prhs[4], cgauss);


    // execute the query
    vector<int> klabels;
	PerformSupermeshSLIC( input_verts,input_faces,facenormal,landmarks,cgauss, klabels);
  
    // return the indexes
    plhs[0] = mxCreateDoubleMatrix( klabels.size(), 1, mxREAL);
    //plhs[1] = mxCreateDoubleMatrix(idxsInRange.size(), 1, mxREAL);  
    double* indexes = mxGetPr(plhs[0]);
	for (int i = 0; i < klabels.size(); i++)
	{
		indexes[i] = klabels[i];
	}

}