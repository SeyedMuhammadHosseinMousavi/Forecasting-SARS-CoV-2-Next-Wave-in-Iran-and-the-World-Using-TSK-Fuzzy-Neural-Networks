
function  [TrainTargets,TrainOutputs] = fuzzfcm(x)
x = x';
%
Delays = [1 2 3];
[Inputs, Targets] = TimeSeries(x, Delays);
Inputs = Inputs';
Targets = Targets';
nData = size(Inputs,1);

% Shuffling Data
PERM = 1:nData; % Permutation to Shuffle Data
%
pTrain=0.80;
nTrainData=round(pTrain*nData);
TrainInd=PERM(1:nTrainData);
TrainInputs=Inputs(TrainInd,:);
TrainTargets=Targets(TrainInd,:);
%
pTest=1-pTrain;
nTestData=nData-nTrainData;
TestInd=PERM(nTrainData+1:end);
TestInputs=Inputs(TestInd,:);
TestTargets=Targets(TestInd,:);

%% FCM FIS Generation Method and Parameters       
        nCluster=10;        
        Exponent=2;       
        MaxIt=100;          
        MinImprovment=1e-5;	
        DisplayInfo=1;
        FCMOptions=[Exponent MaxIt MinImprovment DisplayInfo];
        fis=genfis3(TrainInputs,TrainTargets,'sugeno',nCluster,FCMOptions);
        
% Training ANFIS Structure
MaxEpoch=100;                 
ErrorGoal=0;                
InitialStepSize=0.01;         
StepSizeDecreaseRate=0.9;     
StepSizeIncreaseRate=1.1;    
TrainOptions=[MaxEpoch ...
              ErrorGoal ...
              InitialStepSize ...
              StepSizeDecreaseRate ...
              StepSizeIncreaseRate];
DisplayInfo=true;
DisplayError=true;
DisplayStepSize=true;
DisplayFinalResult=true;
DisplayOptions=[DisplayInfo ...
                DisplayError ...
                DisplayStepSize ...
                DisplayFinalResult];
OptimizationMethod=1;
% 0: Backpropagation
% 1: Hybrid
fis=anfis([TrainInputs TrainTargets],fis,TrainOptions,DisplayOptions,[],OptimizationMethod);

% Apply ANFIS to Data
Outputs=evalfis(Inputs,fis);
TrainOutputs=Outputs(TrainInd,:);
TestOutputs=Outputs(TestInd,:);

% Error Calculation
TrainErrors=TrainTargets-TrainOutputs;
TrainMSE=mean(TrainErrors.^2);
TrainRMSE=sqrt(TrainMSE);
TrainErrorMean=mean(TrainErrors);
TrainErrorSTD=std(TrainErrors);
%
TestErrors=TestTargets-TestOutputs;
TestMSE=mean(TestErrors.^2);
TestRMSE=sqrt(TestMSE);
TestErrorMean=mean(TestErrors);
TestErrorSTD=std(TestErrors);

%Results
% figure;
% PlotResults(TrainTargets,TrainOutputs,'Train Data');
% figure;
% PlotResults(TestTargets,TestOutputs,'Test Data');
% figure;
% PlotResults(Targets,Outputs,'All Data');
% figure;
%     plotregression(TrainTargets, TrainOutputs, 'Train Data', ...
%                    TestTargets, TestOutputs, 'Test Data', ...
%                    Targets, Outputs, 'All Data');
end
