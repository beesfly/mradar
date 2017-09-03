clear,clc

dbstop if error
tic

filename = 'E:\MATLAB\radar\NUIST.20140928.070704.AR2';
       
% ��ȡ�����ٶ�
radar = read_cradar(filename, 3);     

toc       
lat = radar.coordinate.elevation(1).latitude.data;
lon = radar.coordinate.elevation(1).longitude.data;
height1 = radar.coordinate.elevation(1).height.data;
prod = radar.products.elevation(1).data;

pcolor(lon, lat, prod)
axis square        %  ���ֻ�ͼ��Ϊ������
shading flat       %  ȥ��ͼ��������
cid = colorbar;

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
