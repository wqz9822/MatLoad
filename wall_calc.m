function [rsj, Id0,Idh ] = wall_calc( h ,pm,wall_angle,sfw_angle)
%UNTITLED3 Summary of this function goes here
%   swf_angle 壁面太阳方位角  wall_angle 壁面倾角

I0 = 1353;       %太阳辐射常数
p = 0.62;        %大气透明系数

%------------------------------数组初始化--------------------------
rsj = zeros(1,24);       %太阳入射角
Id0 = zeros(1,24);       % p15 2-16 太阳直射辐射强度
Idh = zeros(1,24);       % p15 2-19 天空散射辐射

for ii = 1:24
  if  (h(ii)<=0 )
    rsj(ii) = 0;
    Id0(ii) = 0;
    Idh(ii) = 0; 
  else
    rsj(ii) = acosd(cosd(wall_angle)*sind(h(ii))+sind(wall_angle)*cosd(h(ii))*cosd(sfw_angle)); % p9 2-7 太阳入射角
    Id0(ii) = I0*pm(ii)*cosd(rsj(ii));  % p15 2-16 太阳直射辐射强度
    Idh(ii) = 0.5*I0*sind(h(ii))*(1-pm(ii))/(1-1.4*log(p));  % p15 2-19 天空散射辐射
  end
end
 
end
