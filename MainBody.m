%% Some Explanations

% These lines of codes predict and forecasts up to 6 months (180 days) for COVID 
% deaths, confirmed and Recovered Cases from Jan 2020 till Dec 2021 out of John Hopkins
% university dataset for Iran. Prediction is by ANFIS (FCM) and Forecasting is by nonlinear 
% ARX model. Just run the code. You can add your dataset and play with parameters.
% 
% This code is main part of the following research.
% If you used the code please cite below:
% 
% Mousavi, Seyed Muhammad Hossein, and S. Muhammad Hassan Mosavi. "Forecasting 
% SARS-CoV-2 Next Wave in Iran and the World Using TSK Fuzzy Neural Networks, 
% Third National Conference on Safety and Health, Tehran, Iran (2021).
% 
% Any question, contact:
% mosavi.a.i.buali@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% forecast performs prediction into the future, in a time range beyond the last 
% instant of measured data. In contrast, the predict command predicts the 
% response of an identified model over the time span of measured data. 
% Use predict to determine if the predicted result matches the observed response 
% of an estimated model. If sys is a good prediction model, consider using it
% with forecast.
clear;
dat=load('hopkinsirandeath.txt')';
dat1=load('hopkinsiranconfirmed.txt')';
dat2=load('hopkinsiranrecovered.txt')';

% Nonlinear ARX model to fit
sys = nlarx(dat,64);
sys1 = nlarx(dat1,64);
sys2 = nlarx(dat2,64);

% Compare the simulated output of sys with measured data to ensure it is a good fit.
nstep = 40;
figure;
set(gcf, 'Position',  [50, 200, 1300, 400])
subplot(1,3,1)
compare(dat,sys,nstep);title('Covid Iran Death');
grid on;
subplot(1,3,2)
compare(dat1,sys1,nstep);title('Covid Iran Confirm');
grid on;
subplot(1,3,3)
compare(dat2,sys2,2);title('Covid Iran Recovered');
grid on;
% Forecast the values into the future for a given time horizon K.
% K is number of days 
K = 180;
opt = forecastOptions('InitialCondition','e');
[p,ForecastMSE] = forecast(sys,dat,K,opt);
[p1,ForecastMSE1] = forecast(sys1,dat1,K,opt);
[p2,ForecastMSE2] = forecast(sys2,dat2,K,opt);

datsize=size(dat);datsize=datsize(1,1);
ylbl=datsize+K;
t = linspace(datsize,ylbl,length(p));
figure;
set(gcf, 'Position',  [1, 1, 1000, 950])
subplot(3,1,1)
plot(dat,'--',...
    'LineWidth',1,...
    'MarkerSize',5,...
    'Color',[0,0,0]);
hold on;
plot(t,p,'-.',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'Color',[0.9,0,0]);
title('Johns Hopkins Data for Iran COVID Deaths - Red is Forcasted')
xlabel('Days - From Jan 2020 Till Dec 2021','FontSize',12,...
       'FontWeight','bold','Color','b');
ylabel('Number of People','FontSize',12,...
       'FontWeight','bold','Color','b');
   datetick('x','mmm');
legend({'Measured','Forecasted'});
    subplot(3,1,2)
plot(dat1,'--',...
    'LineWidth',1,...
    'MarkerSize',5,...
    'Color',[0,0,0]);
hold on;
plot(t,p1,'-.',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'Color',[0.9,0,0]);
title('Johns Hopkins Data for Iran COVID Confirmed - Red is Forcasted')
xlabel('Days - From Jan 2020 Till Dec 2021','FontSize',12,...
       'FontWeight','bold','Color','b');
ylabel('Number of People','FontSize',12,...
       'FontWeight','bold','Color','b');
   datetick('x','mmm');
legend({'Measured','Forecasted'});
subplot(3,1,3)
plot(dat2,'--',...
    'LineWidth',1,...
    'MarkerSize',5,...
    'Color',[0,0,0]);
hold on;
plot(t,p2,'-.',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'Color',[0.9,0,0]);
title('Johns Hopkins Data for Iran COVID Recovered - Red is Forcasted')
xlabel('Days - From Jan 2020 Till Dec 2021','FontSize',12,...
       'FontWeight','bold','Color','b');
ylabel('Number of People','FontSize',12,...
       'FontWeight','bold','Color','b');
   datetick('x','mmm');
legend({'Measured','Forecasted'});
%
finalpredict=[dat;p];
finalpredict1=[dat1;p1];
finalpredict2=[dat2;p2];

%% Predicting original and forcasted data using ANFIS (FCM)
[TrainTargets,TrainOutputs]=fuzzfcm(finalpredict);
figure;
set(gcf, 'Position',  [10, 50, 1100, 300])
Plotit(TrainTargets,TrainOutputs,'ANFIS Predict COVID Deaths');
%
[TrainTargets,TrainOutputs]=fuzzfcm(finalpredict1);
figure;
set(gcf, 'Position',  [50, 100, 1100, 300])
Plotit(TrainTargets,TrainOutputs,'ANFIS Predict COVID Confirmed');
%
[TrainTargets,TrainOutputs]=fuzzfcm(finalpredict2);
figure;
set(gcf, 'Position',  [70, 130, 1100, 300])
Plotit(TrainTargets,TrainOutputs,'ANFIS Predict COVID Recovered');
