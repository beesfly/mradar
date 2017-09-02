function [itpprod, itpheight, itplon, itplat] = cross_section_ppi(radar, interp, varargin)
%    ȷ�������ߺ��״���������PPIɨ�����ݲ�ֵ����������
% 
%       ���������
%       --------------------
%          radar : �����״��Ʒ�Ľṹ������. ���� radar �ṹ����������ݽṹ�ɲ鿴
%                  read_sradar ����˵��
%         interp : ָ�����淽ʽ��Ϊ�ַ��ͱ�����
%                'se'  : ��ʾ����ѡ����ʼ������յ����꣬����ָ�������ߡ�
%                    'stapos' : ��ʼ����㣬��Ԫ���������ֱ�Ϊx��y����ʼ�㣬
%                               ��һ��ֵΪx����ʼ�㣬�ڶ���ֵΪy����ʼ�㡣
%                    'endpos' : �յ����꣬��Ԫ���������ֱ�Ϊx��y���յ㣬
%                               ��һ��ֵΪx���յ㣬�ڶ���ֵΪy���յ㡣
%                'md'  : ��ʾ����ͨ��ָ���е��������б�Ƕ�ѡ�������ߡ�
%                    'midpos' : �е����꣬��Ԫ��������
%                               ��һ��ֵΪx���е����꣬�ڶ���ֵΪy���е����ꡣ
%                    'angle'  : ����ָ����б�Ƕȣ���ֱ��б�ʡ� Ĭ��ֵΪ45�ȡ�
%                               ȡֵ��ΧӦ�� -90 �� 90 ֮�䡣
%                  ����ѡ�������ߵ�ģʽ����һ�� ���� ���������ڿ���ˮƽ��ֵ�ļ����
%                  'horspace'  :  ���ڿ��Ʋ�ֵ�ļ�����������ܶȡ�Ĭ��ֵΪ 0.1
%                           һ������²���Ĭ��ֵ���ɣ�����ѡ������������ʱ����
%                           �ʵ���С��ֵ����Ӧ��֤����0������ᱨ��
%                     ������ ע�� ������
%                         ��ʹ��Ĭ��ֵЧ�����û򱨴�ʱ��Ӧ��С��ֵ��
%       'verspace'  :  ������
%                  ���ڿ������洹ֱ����Ĳ�ֵ�����ֵΪ1ʱ�����в�ֵ. ���Ҫ�Դ�ֱ����
%                  ��ֵ����ֵ��С��1
%      'method' �� ��ֵ����.  �ַ�������
%                ֧�ֵĲ�ֵ���������� 'linear', 'nearest', 'cubic'
%                Ĭ��ֵΪ 'nearest'
%     
%        ���������
%       ------------------
%           itpprod    �� ��ѡ�����Ʒ����
%           itpheight  �� ��Ӧ����ĸ߶�
%           itplon     �� �����߸�㻯��ľ�������
%           itplat     �� �����߸�㻯���γ������
%
%    ��ͼʱʹ�� itpheight, itplon(�� itplat)��itpprod
%% ʾ����
%   ʾ��1
%   step = 0.01;
%   itpstep = 0.001;
%   se = ginput(2);
%   stapos = se(1, :);
%   endpos = se(2, :);
%   
%   interp = 'se'; 
%   [itpprod, itpheight, itplon, itplat] = cross_section_ppi(radar, interp, 'stapos', stapos, 'endpos', endpos, 'hor', step, 'ver', itpstep, 'method', 'nearest');
%
%   ʾ��2
%   interp = 'md';
%   angle = 45;
%   midpos = ginput(1);
%   [itpprod, itpheight, itplon, itplat] = cross_section_ppi(radar, interp, 'midpos', midpos, 'angle', angle, 'hor', step, 'ver', itpstep, 'method', 'cubic');
%%

p = inputParser;
validVard = @(x) isstruct(x);
validAngle = @(x) isnumeric(x) && x >= -90 && x <= 90;
validValue = @(x) isvector(x) && min(x) >=0 && ~isempty(x);
validHorVer = @(x) isnumeric(x) && length(x) == 1 && x > 0;
validMethod = @(x) ismember(x, {'linear', 'nearest', 'cubic'});
defaultAngle = 45;   % Ĭ������Ƕ�
defaultHor = 0.1;
defaultVer = 0.1;
defaultMethod = 'nearest';
addRequired(p, 'radar', validVard)
addRequired(p, 'interp', @isstr)
addParameter(p, 'stapos', validValue)
addParameter(p, 'endpos', validValue)
addParameter(p, 'midpos', validValue)
addParameter(p, 'angle', defaultAngle, validAngle)
addParameter(p, 'horspace', defaultHor, validHorVer)
addParameter(p, 'verspace', defaultVer, validHorVer)
addParameter(p, 'method', defaultMethod, validMethod);
parse(p, radar, interp, varargin{:})

step = p.Results.horspace;
itpstep = p.Results.verspace;
method = p.Results.method;

lat = radar.coordinate.elevation(1).latitude.data;
lon = radar.coordinate.elevation(1).longitude.data;
prod = radar.products.elevation(1).data;
phinum = double(radar.info.elenum);

if strcmp(p.Results.interp, 'se')
    stapos = p.Results.stapos;
    endpos = p.Results.endpos;
    x = stapos(1):step:endpos(1);
    y = ((endpos(2)-stapos(2))/(endpos(1)-stapos(1))).*(x - endpos(1)) + endpos(2);
elseif strcmp(p.Results.interp, 'md')
    midpos = p.Results.midpos;
    xmin = min(min(lon));
    xmax = max(max(lat));
    x = [xmin:step:midpos(1), midpos(1)+step:step:xmax];
    y = tan((angle*3.1415926)/180)*(x - midpos(1)) + midpos(2);
end

cross = zeros(length(x), phinum);
height = zeros(length(x), phinum);

distance = deg2km(sqrt((y - radar.info.latitude.data).^2 + (x - radar.info.longitude.data).^2));

cross(:, 1) = griddata(lat, lon, prod, y, x, method);
height(:, 1) = distance*tan(radar.products.elevation(1).elevation*3.1415926/180);

for i = 2:phinum
    lat1 = radar.coordinate.elevation(i).latitude.data;
    lon1 = radar.coordinate.elevation(i).longitude.data;
    prod1 = radar.products.elevation(i).data;
    
    cross(:, i) = griddata(lat1, lon1, prod1, y, x, method);
    height(:, i) = distance*tan(radar.products.elevation(i).elevation*3.1415926/180);
end

height = height + radar.info.height.data/1000;

horind = 1:length(x);
verind = 1:phinum;
[horgrid, vergrid] = ndgrid(horind, verind);
%  ��ֵ
itpverind = 1:itpstep:phinum; 
[itphorgrid, itpvergrid] = ndgrid(horind, itpverind);
itpheight = griddata(horgrid, vergrid, height, itphorgrid, itpvergrid);

itplon = repmat(x, length(itpverind), 1)';
itplat = repmat(y, length(itpverind), 1)';
itpprod = griddata(horgrid, height, cross, itphorgrid, itpheight);

org_mean_height = mean(mean(diff(height, 1, 2)));
itp_mean_height = mean(mean(diff(itpheight, 1, 2)));

fprintf('�߶ȷ�����ƽ�� %.4f km ��ֵ��ƽ�� %.4f km��\n', org_mean_height, itp_mean_height);
end