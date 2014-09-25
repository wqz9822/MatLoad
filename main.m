%------------------------------------------- 基本信息--------------------------------- 
% 1. 客机机头朝南放置；
% 2. 客机座舱壁简化为一保温材料，导热系数0.05 W/m-K，厚度120 mm，比热容1.5kJ/kg-K，密度2800 kg/m3。
% 3. 机舱两侧窗户面积4.466 m2，驾驶舱窗户面积1.5288 m2，窗户厚度为60 mm。窗户玻璃的传热系数可视为1.71 W/m2-K，
%    窗户对太阳辐射的透过率为0.8，吸收率为0.08，反射率为0.12。
% 4. 座舱外总换热系数aa=18 W/m2-K，座舱内总换热系数ar=8 W/m2-K。
% 5. 座舱外壁对太阳直射辐射的吸收率aD=0.4，对天空散射辐射的吸收率ad=0.3，对天空的辐射系统黑度?0=0.4，
%    对地面的辐射系统黑度?g=0.12。大气透明系数p=0.62。
% 6. 天津东经117.2度，北纬39.1度。

%------------------------------数组初始化--------------------------

t   = zeros(1,24);           %温度
t_k = zeros(1,24);      
ea  = zeros(1,24);           %水蒸气分压力

omega = zeros(1,24);         %真太阳时
h     = zeros(1,24);         %太阳高度角
alpha = zeros(1,24);         %太阳方位角
m     = zeros(1,24);         %大气质量
pm    = zeros(1,24);
rsj   = zeros(1,24);         %太阳入射角
Id0   = zeros(1,24);         % p15 2-16 太阳直射辐射强度
Idh   = zeros(1,24);         % p15 2-19 天空散射辐射

tz = zeros(1,24);            %室外空气综合温度
qs = zeros(1,24);      	     %围护结构外表面吸收太阳直射以及散射辐射
qr = zeros(1,24);            %围护结构外表面吸收地面反射辐射
qe = zeros(1,24);            %夜间辐射
HG_wall   = zeros(1,24);     %壁面传热量
HG_window = zeros(1,24);     % 西，东，南，总

HG_sum = zeros(1,24);
cita   = zeros(1,24);       %当量温差


%---------------------------------------读入数据------------------------------------------

filename = 'heat.xlsm';
ta= xlsread(filename, 1,'B8:Y8');     %室外空气温度
t_k = ta + 273.15;
ea = xlsread(filename,1,'B10:Y10');   %水蒸气分压力


%----------------------------------------------------------------------------------------
 
[omega,h,alpha,m,pm] = sun_calc();             %太阳参数计算

%[rsj, Id0,Idh] = wall_calc(h ,pm,wall_angle,sfw_angle); 
 
[rsj, Id0,Idh] = wall_calc(h ,pm,0,0);         %墙面参数计算
 
[tz,qs,qr,qe]= t_z( Id0, Idh,Id0+Idh,t_k,ea);  %计算综合室外空气温度
 
[HG_wall,cita] = h_wave(tz);                   %谐波反应法
 
%function [sun,tran ] = window(h,pm,ta,wall_angle,sfw_angle,F )
[sun_w,tran_w] = window(h,pm,ta,90, alpha-90, 4.466);
[sun_e,tran_e] = window(h,pm,ta,90, alpha+90, 4.466);
[sun_s,tran_s] = window(h,pm,ta,90, alpha, 1.5288);
HG_window_tran = (tran_w)+ (tran_e)+(tran_s);
HG_window_sun = (sun_w)+ (sun_e)+(sun_s);
HG_sum = (-sun_w-tran_w)+ (-sun_e-tran_e)+(-sun_s-tran_s) - HG_wall;
 
 main_data =[ omega           %1
              h               %2
              alpha           %3
              rsj             %4
              m               %5
              pm              %6
              Id0             %7
              Idh             %8
              Id0+Idh         %9
              ta              %10
              tz              %11
              qs              %12
              qe              %13
              cita            %14
              HG_wall         %15
              HG_window_tran  %16
              HG_window_sun   %17
              HG_sum          %18
            ];
                  
xlswrite(filename,main_data,2,'E3');
 



