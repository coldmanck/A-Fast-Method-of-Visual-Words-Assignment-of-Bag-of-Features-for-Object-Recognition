% convertToEPS(imgName,type)
% By Jeremy Kubica, 2001
%
% Uses Matlab to convert a image file into a EPS file.
%  imgName - the name of the image file
%  type - the file type
%
% Example: to convert file "sample.jpg" to "sample.esp"
%   convertToEPS('sample','jpg');
% New file is saved as imgName.esp
function convertToEPS(imgName,type)

pic = imread(imgName,type);
[y x c] = size(pic)

figure('Units','Pixels','Resize','off',...
   'Position',[100 100 x y],'PaperUnit','points',...
      'PaperPosition',[0 0 x y]);
	  axes('position',[0 0 1 1]);
	  image(pic);
	  axis off

	  saveas(gcf,imgName,'epsc');
