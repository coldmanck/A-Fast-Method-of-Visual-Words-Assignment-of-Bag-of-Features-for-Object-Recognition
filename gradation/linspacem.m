function y = linspacem(d1, d2, n) 
% LINSPACEM 2つのベクトル、または2つの行列の線形に等間隔なベクトルの作成
%
% Y = linspacem(X1, X2)
% Y = linspacem(X1, X2, n)
%
% 入力 X1,X2 のクラスサポート:
%    float: double, single
%
% 入力：X1,X2,n
%  X1, X2 - 同じサイズの2つのベクトル、または2つの行列
%  n - 分割数(デフォルトは100)
%
% 出力：Y
%  Y - 線形に等間隔なベクトル
%
%	例 :
%	2点(0, 0, 0)、(3, 2, 4)間の等間隔な100個の点列の作成
%		linspacem([0,0,0], [3,2,4])
%		linspacem([0;0;0], [3;0;4])
%	
%	2点(0, 0, 0, 0)、(3, 2, 4, 5)間の等間隔な10個の点列の作成
%		linspacem([0;0;0;0], [3;0;4;5], 10)
%	
%	2つの行列を線形に10分割した行列群の作成
%		linspacem([[0;0],[0;0]], [[3;4],[3;3]], 10)
%
%	参考 LINSPACE LOGSPACE
% 
% --
%	Title : LINSPACEM()
%	Author : Sach1o : hTTp://sach1o.blog80.fc2.com/
%	Created : 2007/11/27
% //--

if nargin == 2 n = 100; end;
n = floor(n);

sz = size(d1);
if ~isequal(sz, size(d2)) error('2つの入力の次元が異なります。'); end;

% x,y,z...と次元を変えて座標を表した場合
if min(sz)==1 && length(sz)>2
	sz(2) = n;
	d1 = d1(:);
	d2 = d2(:);
	y = reshape([repmat(d1,1,n) + (d2-d1)*((0:(n-1))/(n-1))]', sz);
% 縦ベクトル
elseif sz(2)==1 
	y = repmat(d1,1,n) + (d2-d1)*((0:(n-1))/(n-1));
% 横ベクトル
elseif sz(1)==1 
	y = repmat(d1,n,1) + ((0:(n-1))/(n-1))'*(d2-d1);
% 行列
else 
	d1 = d1(:);
	d2 = d2(:);
	y = reshape( (repmat(d1,1,n) + (d2-d1)*((0:(n-1))/(n-1))), [sz,n]);
end;
