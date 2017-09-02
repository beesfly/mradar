clear,clc

dbstop if error

collev = [ 255,255,255; 0,236,236; 0,160,246; 0,0,246; 0,255,0; ...
           0,200,0; 0,144,0; 255,255,0; 231,192,0; 255,0,0; ...
           214,0,0; 192,0,0; 255,0,255; 153,85,201 ]/255.;
       
filename = 'data/SA_CAP.bin';

types = 1; % 当 eleva = 0.5，且 dupe = false 时，只有反射率数据
lon = 120.2011;
lat = 33.4311; % 雷达经纬度坐标

radar = read_sradar(filename, types, lon, lat, 0);

lat = radar.coordinate.elevation(1).latitude.data;
lon = radar.coordinate.elevation(1).longitude.data;
height1 = radar.coordinate.elevation(1).height.data;
prod = radar.products.elevation(1).data;
prod(prod < 0) = 0;
phinum = radar.info.elenum;

dbz = zeros(size(prod, 1), size(prod, 2), phinum);
z = dbz;
dbz(:, :, 1) = prod;
z(:, :, 1) = height1;

figure
pcolor(lon, lat, prod)
axis square        %  保持绘图框为正方形
shading flat       %  去除图形网格线
cid = colorbar;
caxis([0, 70])
%   set grid line style for colorbar to solid line
%   set(cid, 'YGrid', 'on', 'GridLineStyle', '-');
xlim([119.3, 120.5])
ylim([33.4, 34.6])
colormap(collev);

se = ginput(2);

stapos = se(1, :);
endpos = se(2, :);

interp = 'se';

method = 'nearest';

types = 1;
step = 0.001; % 控制经度数据插值
itpstep = 0.001; % 控制高度插值间隔

[itpprod, itpheight, itplon, itplat] = cross_section_ppi(radar, interp, 'stapos', stapos, 'endpos', endpos, 'hor', step, 'ver', itpstep, 'method', 'nearest');

figure
pcolor(itplon, itpheight, itpprod)
ylabel('Height (km)')
ylim([0, 20])
%axis square        %  保持绘图框为正方形
shading flat       %  去除图形网格线
cid = colorbar;
caxis([0, 70])
colormap(collev);

%% ppi to rhi
azimu = 314;
[prod, height, lon, lat] = ppi_to_rhi(radar, azimu);
pcolor(lon, height, prod)
ylim([0, 20])
%axis square        %  保持绘图框为正方形
shading flat       %  去除图形网格线
cid = colorbar;
caxis([0, 70])
colormap(collev);
