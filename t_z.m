function [tz,qs,qr,qe] =t_z( Id0,Idh,Ish,Ta ,ea)
%UNTITLED2 Summary of this function goes here
% Detailed explanation goes here

    a_a = 18;        %座舱外总换热系数
    ad1 = 0.4;       %座舱外壁对太阳直射辐的吸收率
    ad2 = 0.3;       %对天空散射辐的吸收率
    Cb = 5.67;       % w/㎡·k4  黑体辐射常数
    pg = 0.2 ;
    cita = 0;        %与水平面成cita倾角的斜面所接受的地面反射辐射强度
    eo = 0.4;        %座舱外壁对天空的辐射系统黑度
    eg = 0.12;       %座舱外壁对地面的辐射系统黑度
    eos = eo;        % p29 line 1
    eog = eo*eg;     % 围护结构外表面与地面间的p29 line3
    aos = 1;         % aos+aog = 1 垂直壁面 aos = aog = 0.5 水平屋面 aos =1 aog =0
    aog = 0;
    
    tz = zeros(1,24);
    qs = zeros(1,24);  % 护结构外表面吸收太阳直射以及散射辐射
    qr = zeros(1,24);  % 护结构外表面吸收地面反射辐射
    qe = zeros(1,24);  % 夜间辐射
    % qb = zeros(1,24); %长波辐射
    %----------------------------------------------------------------------------------
    for ii = 1:24
        Ts = (0.51+0.208*sqrt(ea(ii)))^(0.25)*Ta(ii); %p17 2-27 天空当量温度
        %Ts = (0.51+0.208*sqrt(0.18))^(0.25)*Ta(ii);
        Tg = Ta(ii);
        qs(ii) = ad1*Id0(ii)+ad2*Idh(ii);              % p27 line 1
        qr(ii)= ad2*(pg)*Ish(ii)*(1-(cosd(cita/2))^2); % p27 line 4
        qe(ii) = Cb*eo*(Ta(ii)/100)^4 - Cb*eos*aos*(Ts/100)^4 - Cb*eog*aog*(Tg/100)^4;  % p29 2-54 夜间辐射
    
        tz(ii) = (Ta(ii)-273.15) + (qs(ii)+qr(ii))/a_a - qe(ii)/a_a;  % p29 2-55   室外空气综合温度
    end

end


