function [sun,tran ] = window(h,pm,ta,wall_angle,sfw_angle,F )
%通过玻璃窗的太阳辐射热量， 透过玻璃窗的太阳辐射得热
%   Detailed explanation goes here
a_a = 18;             %座舱外总换热系数 w/m^2.k
a_r = 8;              %座舱内总换热系数 w/m^2.k
Ra  = 1/a_a; 
Rr  = 1/a_r;
tr  = 20;             % 室内温度恒定20
td1 = 0.8;            % 玻璃对入射角为i的太阳直射辐射透射率
td2 = td1;            % 玻璃对太阳散射辐射透射率
ad1 = 0.08;           % 玻璃对入射角为i的太阳直射辐射吸收率
ad2 = ad1;            % 玻璃对太阳散射辐射吸收率
K   = 1.71;           % 窗户玻璃传热系数
%------------------------------数组初始化--------------------------
rsj = zeros(1,24);
Id1 = zeros(1,24);  
Id2 = zeros(1,24);
tran = zeros(1,24); %传热引起的窗玻璃传热量
sun = zeros(1,24); %由太阳辐射引起的窗玻璃传热
for ii = 1:24 
    %[rsj, Id0,Idh] = wall_calc(h ,pm,wall_angle,sfw_angle); 
    [rsj,Id1,Id2] = wall_calc(h ,pm,wall_angle,sfw_angle(ii));
    tran(ii) = K*F*(ta(ii)-tr);      % 传热量 p31 2-58 
    sun(ii)= F*(Id1(ii)*(td1+(Ra/(Ra+Rr))*ad1)+Id2(ii)*(td2+(Ra/(Ra+Rr)*ad2)));  % p32 2-62
end
end
