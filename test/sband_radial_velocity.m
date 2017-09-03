clear,clc

dbstop if error

filename = 'data/SA_CAP.bin';

% ��ȡ�����ٶ�
types = 2; % 
lon = 120.2011;
lat = 33.4311; % �״ﾭγ������

radar = read_sradar(filename, types, lon, lat, 0);

lat = radar.coordinate.elevation(1).latitude.data;
lon = radar.coordinate.elevation(1).longitude.data;
height1 = radar.coordinate.elevation(1).height.data;
prod = radar.products.elevation(1).data;
phinum = radar.info.elenum;

dbz = zeros(size(prod, 1), size(prod, 2), phinum);
z = dbz;
dbz(:, :, 1) = prod;
z(:, :, 1) = height1;

figure
pcolor(lon, lat, prod)
axis square        %  ���ֻ�ͼ��Ϊ������
shading flat       %  ȥ��ͼ��������
cid = colorbar;
%   set grid line style for colorbar to solid line
%   set(cid, 'YGrid', 'on', 'GridLineStyle', '-');
xlim([119.3, 120.5])
ylim([33.4, 34.6])

se = ginput(2);

stapos = se(1, :);
endpos = se(2, :);

interp = 'se';

method = 'nearest';

types = 1;
step = 0.01; % ���ƾ������ݲ�ֵ
itpstep = 0.01; % ���Ƹ߶Ȳ�ֵ���

[itpprod, itpheight, itplon, itplat] = cross_section_ppi(radar, interp, 'stapos', stapos, 'endpos', endpos, 'hor', step, 'ver', itpstep, 'method', 'nearest');

figure
pcolor(itplon, itpheight, itpprod)
ylabel('Height (km)')
ylim([0, 20])
%axis square        %  ���ֻ�ͼ��Ϊ������
shading flat       %  ȥ��ͼ��������
cid = colorbar;

%% ppi to rhi
azimu = 314;
[prod, height, lon, lat] = ppi_to_rhi(radar, azimu);
ylim([0, 20])
axis square        %  ���ֻ�ͼ��Ϊ������
shading flat       %  ȥ��ͼ��������
cid = colorbar;
