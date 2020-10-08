clear;
clc;
%% Load 41025 Met Data
load('Station_41025_Met_Data.mat')
[r,c]=size(Station_41025_Met_Data);
stpt=1537;
%% Data Components
YY=Station_41025_Met_Data(:,1); 
MM=Station_41025_Met_Data(:,2); 
DD=Station_41025_Met_Data(:,3); 
hh=Station_41025_Met_Data(:,4); 
mm=Station_41025_Met_Data(:,5); 
WiDIR=Station_41025_Met_Data(:,6); %degT Wind direction
WiSPD=Station_41025_Met_Data(:,7); %m/s Wind speed 
WiGST=Station_41025_Met_Data(:,8); %m/s Peak 5 or 8 second gust speed 
WVHT=Station_41025_Met_Data(:,9); %m Significant wave height
WVDPD=Station_41025_Met_Data(:,10); %Sec Dominant wave period
WVAPD=Station_41025_Met_Data(:,11); %Sec Average wave period
WVMWD=Station_41025_Met_Data(:,12); %degT The direction from which the waves at the dominant period (DPD) are coming.
APRES=Station_41025_Met_Data(:,13); %hPa Sea level pressure (hPa)
ATMP=Station_41025_Met_Data(:,14); %degC Air temperature
WtTMP=Station_41025_Met_Data(:,15); %degC Sea surface temperature
DEWP=Station_41025_Met_Data(:,16); %degC Dewpoint temperature
%% Assumptions
S=35.8; %ppt Surface Salinity
g=9.80665; %m/s^2 gravitational acceleration
%% Data conversion
for i=1:r
% Wiucomp(i,1)=WSPD(i,1)*cos(WDIR(i,1)); %m/s towards north x
% Wivcomp(i,1)=WSPD(i,1)*sin(WDIR(i,1)); %m/s towards West y
APRESbar(i,1)=APRES(i,1)/1000; %bar
rho0(i,1)=(999.84259+6.793952*(10^-2)*WtTMP(i,1)-9.095290*(10^-3)*WtTMP(i,1)^2+1.001685*(10^-4)*WtTMP(i,1)^3-1.120083*(10^-6)*WtTMP(i,1)^4+6.536332*(10^-9)*WtTMP(i,1)^5)+(0.824493-4.0899*(10^-3)*WtTMP(i,1)+7.6438*(10^-5)*WtTMP(i,1)^2-8.2467*(10^-7)*WtTMP(i,1)^3+5.3875*(10^-9)*WtTMP(i,1)^4)*S+(-5.72466*(10^-3)+1.0227*(10^-4)*WtTMP(i,1)-1.6546*(10^-6)*WtTMP(i,1)^2)*S^1.5+(4.8314*(10^-4))*S^2;
K0(i,1)=((19652.21+148.4206*WtTMP(i,1)-2.327105*WtTMP(i,1)^2+1.360477*(10^-2)*WtTMP(i,1)^3-5.155288*(10^-5)*WtTMP(i,1)^4)+(54.6746-0.603459*WtTMP(i,1)+1.09987*(10^-2)*WtTMP(i,1)^2-6.1670*(10^-5)*WtTMP(i,1)^3)*S+(7.944*10^-2+1.6483*10^-2*WtTMP(i,1)-5.30094*10^-4*WtTMP(i,1)^2)*S^1.5)+((3.239908+1.43713*10^-3*WtTMP(i,1)+1.16092*10^-4*WtTMP(i,1)^2-5.77905*10^-7*WtTMP(i,1)^3)+(2.2838*10^-3-1.0981*10^-5*WtTMP(i,1)-1.6078*10^-6*WtTMP(i,1)^2)*S+1.91075*10^-4*S^1.5)*APRESbar(i,1)+((8.50935*10^-5-6.12293*10^-6*WtTMP(i,1)+5.2787*10^-8*WtTMP(i,1)^2)+(-9.9348*10^-7+2.0816*10^-8*WtTMP(i,1)+9.1697*10^-10*WtTMP(i,1)^2)*S)*APRESbar(i,1)^2;
WtDensity(i,1)=rho0(i,1)/(1-(APRESbar(i,1)/K0(i,1))); %kg/m^3
WvCg(i,1)=WVAPD(i,1)*0.5*g/(2*pi()); %m/s group velocity
WvCp(i,1)=2*WvCg(i,1); %m/s phase velocity
Wvlen(i,1)=WVAPD(i,1)^2*0.5*g/(2*pi()); %m wave length
WvMED(i,1)=(WtDensity(i,1)*g*WVHT(i,1)^2)/16000; %J/m^2 Mean Energy Density
WvEFlux(i,1)=WvMED(i,1)*WvCg(i,1); %kW/m wave energy flux 
end
WvEFAvg=mean(WvEFlux(stpt:end,:)) %285:52988
WvEFsum=sum(WvEFlux(stpt:end,:))

figure
plot(WvEFlux/1000);
hold on;
plot(WvEFAvg/1000*ones(size(WvEFlux(stpt:end,:))));
legend('WEF','Mean WEF')
title('Mean Wave Energy Flux for month Sep 2019 to August 2020')
xlabel('Time period (10 min)');
ylabel('wave energy flux MW/m');

Power_Produced=WvEFlux(stpt:end,:)*10*0.31;
sum(Power_Produced)