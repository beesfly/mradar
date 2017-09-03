
clear,clc

dbstop if error
tic
collev = [ 255,255,255; 0,236,236; 0,160,246; 0,0,246; 0,255,0; ...
           0,200,0; 0,144,0; 255,255,0; 231,192,0; 255,0,0; ...
           214,0,0; 192,0,0; 255,0,255; 153,85,201 ]/255.;

filename = 'E:\MATLAB\radar\NUIST.20140928.070704.AR2';
       
radar = read_cradar(filename, 2);     

toc       
lat = radar.coordinate.elevation(1).latitude.data;
lon = radar.coordinate.elevation(1).longitude.data;
height1 = radar.coordinate.elevation(1).height.data;
prod = radar.products.elevation(1).data;
% prod(prod < 0) = 0;

figure
pcolor(lon, lat, prod)
axis square        %  ���ֻ�ͼ��Ϊ������
shading flat       %  ȥ��ͼ��������
cid = colorbar;
caxis([0, 70])
colormap(collev)

se = ginput(2);

stapos = se(1, :);
endpos = se(2, :);

interp = 'se';

method = 'nearest';

step = 0.01; % ���ƾ������ݲ�ֵ
itpstep = 0.01; % ���Ƹ߶Ȳ�ֵ���

[itpprod, itpheight, itplon, itplat] = cross_section_ppi(radar, interp, 'stapos', stapos, 'endpos', endpos, 'hor', step, 'ver', itpstep, 'method', 'nearest');

figure
%axis([min(min(dist)) max(max(dist)) 0 20])
pcolor(itplon, itpheight, itpprod)
ylabel('Height (km)')
ylim([0, 20])
axis square        %  ���ֻ�ͼ��Ϊ������
shading flat       %  ȥ��ͼ��������
cid = colorbar;
caxis([0, 70])
colormap(collev);

