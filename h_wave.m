function  [HG,cita] = h_wave( tz )
%求衰减倍数和相位延迟
%   Detailed explanation goes here
    T = 24;
    a_a = 18;                          %座舱外总换热系数 w/m^2.k
    a_r = 8;                           %座舱内总换热系数 w/m^2.k
    lamda = 0.05;                      %座舱壁导热系数
    c = 1500  ;                        %比热容 kj/kg・k
    l = 0.12;                          %厚度
    p = 2800;                          % 密度 kg/m^3
    a = lamda/(p*c)*3600;              %导温系数 m^2/h
    K = (1/a_a+l/lamda+1/a_r)^(-1);    %传热系数 w/m^2.k
    F = 240;                           %板壁围护结构的面积 m^2
    tr = 20 ;                          %室内温度恒定为20度
    average_tz = mean(tz);             %室外空气平均综合温度
    %--------------------------------------------------
    v  = zeros(1,12);   %衰减倍数
    fi = zeros(1,12);   %时间延迟
    
    an = zeros(1,12);
    bn = zeros(1,12);
    A  = zeros(1,12);     %第n阶正弦波外扰振幅   oc
    Fi = zeros(1,12);     %第n阶正弦波外扰初相位 rad
    cita = zeros(1,24);   %各个时刻当量温差
    HG = zeros(1,24);     %传热得热量
    %-------------------------------------------------------------
    %传递矩阵
    syms s;

    G3=[1,   -1/a_r;
        0,      1  ];
    
    G2=[cosh(sqrt(s/a)*l),  -sinh(sqrt(s/a)*l)/(lamda*sqrt(s/a)); 
           -lamda*sqrt(s/a)*sinh(sqrt(s/a)*l),  cosh(sqrt(s/a)*l)];
    
    G1=[1,   -1/a_a;
        0,       1];
        
    G=G3*G2*G1;

    B=-G(1,2);
      for n=1:12
      v(n)=a_r*abs(subs(B,s,i*n*2*pi/24));   %p62 3-40-2
      fi(n)=angle(subs(B,s,i*n*2*pi/24));    %p62 3-40-1
      end
    
    %傅里叶级数展开
    for n=1:12
        for j=0:23
            an(n)=an(n)+(2/T)*tz(j+1)*cos(n*2*pi/24*j);
            bn(n)=bn(n)+(2/T)*tz(j+1)*sin(n*2*pi/24*j);
        end
        A(n)=sqrt(an(n)^2+bn(n)^2);      %第n阶正弦波外扰振幅   oc
        Fi(n)=atan(an(n)/bn(n));         %第n阶正弦波外扰初相位 rad
       
    end
    
    for j=0:23
        cita(j+1) = average_tz - tr;
        for n=1:12
             cita(j+1) = cita(j+1) + (a_r/K) * A(n)  / v(n) * sin(n*2*pi/24*j+Fi(n)-fi(n)); % p68 3-46 各个时刻当量温差
        end
        HG(j+1) = K*F*cita(j+1); % p67 3-43
    end
      
end

