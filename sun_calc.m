function [omega,h,alpha,m,pm] = sun_calc( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

current_year = 2012;
current_month = 12;
current_day = 20;

jd = 117.2;      %东经
s_jd = 120;      %北京标准经度
wd = 39.1;       %北纬
p = 0.62;        %大气透明系数

%------------------------------数组初始化--------------------------
omega = zeros(1,24);     %真太阳时
h     = zeros(1,24);     %太阳高度角
alpha = zeros(1,24);     %太阳方位角
m     = zeros(1,24);     %大气质量
pm    = zeros(1,24);

%---------------------------------------------------------------------------------------------
    n = days_calc(12,20);
    n0 = 79.6764 + 0.2422*(current_year-1985) - fix((current_year-1985)/4);  %年份修正
    t= n - n0  ;
    cita = 2*pi*t/(365.2422-0.3);    % -0.3日 经度修正
    cwj = 0.3723 + 23.2567*sin(cita)+ 0.1149*sin(2*cita)-0.1712*sin(3*cita)-0.758*cos(cita)+0.3656*cos(2*cita)+0.0201*cos(3*cita);

    e = 0.0028 - 1.9857*sin(cita)+9.9059*sin(2*cita)-7.0924*cos(cita)-0.6882*cos(2*cita);
%--------------------------------------------------------------------------------------------   
 for ii = 1:24

      omega(ii) = ((ii-1) + (jd - s_jd)/15 + e/60 -12)*15;                   % p8 2-3 真太阳时
      h(ii) = asind(sind(wd)*sind(cwj)+cosd(wd)*cosd(cwj)*cosd(omega(ii)));  % p8 2-4 太阳高度角
      alpha(ii) = asind(cosd(cwj)*sind(omega(ii))/cosd(h(ii)));              % p9 2-5 太阳方位角
      m(ii) = 1/sind(h(ii));                                                 % p15 2-15 大气质量
      pm(ii) = p^m(ii);
 end
 
end

function [n] = days_calc(current_month,current_day)
    days = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    n = 0;
    for ii = 1:(current_month-1)
        n = n + days(ii);
    end
    n = n+ current_day;
end


