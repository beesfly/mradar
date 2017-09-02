function [prod, height, lon, lat] = ppi_to_rhi(radar, azimu)
%% Ѱ���������λ������ķ�λ�����ݣ���ȡ��������������
%   ֻѰ���������λ������ķ�λ�����ݣ������в�ֵ
%
%   ���������
%       radar  ��  �������״��Ʒ�����Լ�������Ϣ.  �ṹ��
%       azimu  ��  ��λ��.  ����������
%   ���������
%       prod   �� ��ȡ���Ĳ�Ʒ����
%       height �� ��ȡ���Ĳ�Ʒ���ݶ�Ӧ�ĸ߶���Ϣ
%       lon    �� ��λ�Ƕ�Ӧ�ľ�����Ϣ
%       lat    �� ��λ�Ƕ�Ӧ��γ����Ϣ
%  ע�⣺
%     ��ͼʱʹ�� lon(��lat)��height��prod���������������������
%%
phinum = radar.info.elenum;

for i = 1:phinum
    azimuth = radar.coordinate.elevation(1).azimuth.data;

    [~, k] = min(abs(azimuth - azimu));

    nea_ind = unique(k);

    if nea_ind > 1
        near_ind = nea_ind(1);
    else
        near_ind = nea_ind;
    end

    if  i == 1
        lon1 = radar.coordinate.elevation(1).longitude.data(near_ind, :);
        lat1 = radar.coordinate.elevation(1).latitude.data(near_ind, :);
        height1 = radar.coordinate.elevation(1).height.data(near_ind, :);
        [~, s2] = size(radar.products.elevation(1).data);
        prod = zeros(s2, phinum);
        height = prod;
        prod(:, 1) = radar.products.elevation(1).data(near_ind, :);
        height(:, 1) = height1;
    else
    
    lon2 = radar.coordinate.elevation(i).longitude.data;
    lat2 = radar.coordinate.elevation(i).latitude.data;
    height2 = radar.coordinate.elevation(i).height.data;
    prodc = radar.products.elevation(i).data;
    prod(:, i) = griddata(lon2, lat2, prodc, lon1, lat1);
    height(:, i) = griddata(lon2, lat2, height2, lon1, lat1);    
    end
end

lon = repmat(lon1', phinum, 1);
lat = repmat(lat1', phinum, 1);

end