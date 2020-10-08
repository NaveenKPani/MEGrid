clear;
clc;

RawCdata=readmatrix("41025a2009.txt");
Rawcolumn=47; %Data availability
RawCdata=RawCdata(:,1:Rawcolumn);
[ros,~]=size(RawCdata);

YY=RawCdata(:,1);
MM=RawCdata(:,2);
DD=RawCdata(:,3);
HH=RawCdata(:,4);
i=6;
k=1;
while i<Rawcolumn+1
    Depth(k,1)=RawCdata(1,i);
    WTDir(:,k)=RawCdata(:,i+1); %Direction
    WTSpd(:,k)=RawCdata(:,i+2); %Speed
    for j=1:ros
        if WTDir(j,k)==999
            WTDir(j,k)=mean(WTDir(j-4,k):WTDir(j-1,k));
        end
        if WTSpd(j,k)==999
            WTSpd(j,k)=mean(WTSpd(j-4,k):WTSpd(j-1,k));
        end
    end
    k=k+1;
    i=i+3;
end
for j=1:ros
YYMM(j,1)=str2double(strcat(num2str(YY(j,1)),num2str(MM(j,1))));
end

YM=unique(YYMM);
A=zeros(size(YM));
for k=1:((Rawcolumn+1-6)/3)
    for n=1:numel(A)
        %you could also find the count with sum(L) and the sum with sum(y1(L))
        L=ismember(YYMM(:,1),YM(n,1));
        A(n,1)=mean(WTSpd(L,k));
    end
    AvgWTSpd(:,k)=A(:,1);
end

for k=1:((Rawcolumn+1-6)/3)
    for n=1:numel(A)
        %you could also find the count with sum(L) and the sum with sum(y1(L))
        L=ismember(YYMM(:,1),YM(n,1));
        A(n,1)=mean(WTDir(L,k));
    end
    AvgWTdir(:,k)=A(:,1);
end

% figure
% plot(AvgWTSpd');
% hold on;
% legend(num2str(YM(:,1)))
% xlabel('Depth')
% ylabel('Current Speed')

% for i=1:((Rawcolumn+1-6)/3)
%     direction=WTDir(:,i);
%     speed=WTSpd(:,i);
%     [figure_handle,count,speeds,directions,Table] = WindRose(direction,speed);
% end

%% Calculate density
NCLat=35.782169; %NC Latitude
g=9.80665; %m/s^2 gravitational acceleration
% Pressure Computes pressure given the depth at some latitude
% P=Pressure(D,LAT) gives the pressure P (dbars) at a depth D (m) at some latitude LAT (degrees).
% Ref: Saunders, "Practical Conversion of Pressure to Depth", J. Phys. Oceanog., April 1981.
for i=1:((Rawcolumn+1-6)/3)
    Dpth=Depth(i,1);
    D=sin(abs(NCLat*pi/180));
    C1=5.92E-3+(D.*D)*5.25E-3;
    WTPres(i,1)=(((1-C1)-sqrt(((1-C1).^2)-(8.84E-6*Dpth)))/4.42E-6); %dbar
    WTDens(i,1)=WTPres(i,1)/(g*Dpth)*10000; %kg/m^3
end

%% Power Density and Energy Flux
for i=1:((Rawcolumn+1-6)/3)
E(:,i)=0.5*WTDens(i,1)*WTSpd(:,i).^3/1000;
end