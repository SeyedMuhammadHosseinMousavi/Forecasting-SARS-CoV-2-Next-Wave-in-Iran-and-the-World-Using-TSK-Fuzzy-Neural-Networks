
function PlotResults(targets, outputs, Name)

    errors=targets-outputs;

    MSE=mean(errors.^2);
    RMSE=sqrt(MSE);
    
    error_mean=mean(errors);
    error_std=std(errors);

    subplot(2,2,[1 2]);
    plot(targets,'-.',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'Color',[0.9,0,0]);
    hold on;
    plot(outputs,'--',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','g',...
    'Color',[0,0.9,0]);
    legend('Target','Output');
    title(Name);
    xlabel('Sample Index');
    grid on;

    subplot(2,2,3);
    plot(errors,'-',...
    'LineWidth',1,...
    'MarkerSize',2,...
    'MarkerEdgeColor','m',...
    'Color',[1,0,1]);
    legend('Error');
    title(['MSE = ' num2str(MSE) ', RMSE = ' num2str(RMSE)]);
    grid on;

    subplot(2,2,4);
    histfit(errors, 50);
    title(['Error Mean = ' num2str(error_mean) ', Error St.D. = ' num2str(error_std)]);

end