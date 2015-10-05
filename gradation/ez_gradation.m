function CMAP = ez_gradation(cvec, cnum) 
%	EZ_GRADATION	複数のカラーベクトルからグラデーションのカラーマップを作成する。
%	
%	EZ_GRADATION(CVEC)は，複数のカラーベクトルCVECからグラデーションを作成し，色数64のカラーマップを作成する。
%	EZ_GRADATION(CVEC, CNUM)は，複数のカラーベクトルCVECからグラデーションを作成し，色数CNUMのカラーマップを作成する。
%
%	MATLABの仕様により、カラーマップの長さは任意(MS-WindowsとMacintosh上では256まで)です。
%
%	例:
%		この例は青から赤へ変わる色数64のカラーマップをCとして取得します。
%		C = ez_gradation([[0,0,1];[1,0,0]])
%	
%		この例は白から青、さらに赤へ変わる色数256のカラーマップをCとして取得します。
%		C = ez_gradation([[1,1,1];[0,0,1];[1,0,0]], 256)

% --
%	この関数ez_gradation()は、linspacem()も必要です。
%	同じサイトより入手してください。
% --
%	Title : EZ_GRADATION()
%	Author : Sach1o : http://sach1o.blog80.fc2.com/
%	Created : 2007/12/04
% //-- 

% 色数のデフォルト：64
if nargin==1 
	cnum=64;
end;

% 入力カラーベクトルのチェック
if ~isreal(cvec) | mod(numel(cvec),3)~=0 | any(cvec<0) | any(cvec>1) 
	error('色の指定が不正です'); 
end;
% 入力色数のチェック
if (cnum~=floor(cnum) | numel(cnum)~=1 | cnum<=0 )
	error('色数は、正の整数のスカラでなければなりません。');
end;

% 入力カラーマップを線形補間
cvec = reshape(cvec(:), floor(numel(cvec)/3), 3);

if numel(cvec)==3 
	CMAP =repmat(cvec, cnum, 1);
else 
	sz = length(cvec(:,1));
	sind = floor(linspace(1,cnum,sz));
	sdiv = diff(sind) + 1;

	CMAP =zeros(cnum,3);
	for ii=1:sz-1 
		CMAP(sind(ii):sind(ii+1),:) = linspacem(cvec(ii,:), cvec(ii+1,:), sdiv(ii));
	end;
end;
