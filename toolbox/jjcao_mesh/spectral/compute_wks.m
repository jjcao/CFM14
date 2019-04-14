% adapted by Li Shuhua & JJCAO
% This is the implementation of the Wave Kernel Signature described
% in the paper:
% 
%    The Wave Kernel Signature: A Quantum Mechanical Approach To Shape Analysis 
%    M. Aubry, U. Schlickewei, D. Cremers
%    In IEEE International Conference on Computer Vision (ICCV) - Workshop on 
%    Dynamic Shape Capture and Analysis (4DMOD), 2011
% 
% Please refer to the publication above if you use this software. 
% 
% This work is licensed under a Creative Commons
% Attribution-NonCommercial 3.0 Unported License  
% ( http://creativecommons.org/licenses/by-nc/3.0/ )
% 
% The WKS is patented and violation to the license agreement would
% imply a patent infringement.
%
% THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY EXPRESSED OR IMPLIED WARRANTIES
% OF ANY KIND, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THIS SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THIS SOFTWARE.


function [WKS,e,E,PHI] = compute_wks(vertices,faces)

% function [WKS,E,PHI] = compute_WKS(vertices,faces) compute
%   the Wave Kernel Signature of triangle mesh given by
%   [vertices,faces]
%   
%   INPUT:
%   vertices is (number of vertices) x 3 matrix
%   faces is a (number of faces) x 3 matrix
%   
%   OUTPUT:
%   WKS is the (number of vertices) x 100 WKS matrix 
%   E is the vector of LB eigenvalues (by default of size 300 x 1)
%   PHI is the (number of vertices x 300) matrix of LB eigenfunctions 
%   L is the cotan Laplace-Beltrami matrix
%
%   The main parameter to adjust depending on your task is wks_variance


%% parameters

n_eigenvalues=300; % number of eigenvalues used for computations
% depending on the application, you can use less than 300
N = 100; % number of evaluations of WKS
wks_variance = 6; % variance of the WKS gaussian (wih respect to the 
% difference of the two first eigenvalues). For easy or precision tasks 
% (eg. matching with only isometric deformations) you can take it smaller



%% basic quantities

num_vertices = size(vertices,1);
num_faces = size(faces,1);



%% detect boundary vertices

% Calculate the (directed) adjacency matrix. adjacency_matrix(m,n) = 1 if the oriented
% boundary of a triangle contains the directed edge from vertex m to vertex
% n, and 0 otherwise. This matrix is not quite symmetric due to boundary edges.
adjacency_matrix = sparse([faces(:,1); faces(:,2); faces(:,3)], ...
                         [faces(:,2); faces(:,3); faces(:,1)], ...
    	                 ones(3 * num_faces, 1), ...
                         num_vertices, num_vertices, 3 * num_faces);
if any(any(adjacency_matrix > 1))
    error('Triangles must be oriented consistently.')
end
clear adjacency_matrix;
%% compute LB eigenvalues and eigenfunctions 

fprintf('Computing Laplace-Beltrami eigenfunctions...');
[PHI,E]=compute_Laplace_eigen(vertices,faces,n_eigenvalues);
fprintf('done. \n');

%% compute WKS 

fprintf('Computing WKS...');

WKS=zeros(num_vertices,N);

log_E=log(max(abs(E),1e-6))';
e=linspace(log_E(2),(max(log_E))/1.02,N);  
sigma=(e(2)-e(1))*wks_variance;

C = zeros(1,N); %weights used for the normalization of f_E

for i = 1:N
    WKS(:,i) = sum(PHI.^2.*...
        repmat( exp((-(e(i) - log_E).^2) ./ (2*sigma.^2)),num_vertices,1),2);
    C(i) = sum(exp((-(e(i)-log_E).^2)/(2*sigma.^2)));
end

% normalize WKS
WKS(:,:) = WKS(:,:)./repmat(C,num_vertices,1);

fprintf('done. \n');

