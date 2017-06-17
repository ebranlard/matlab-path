function [a,b,R2,R2fit,Correlation,y2,a0,R20,R2fit0,y20]=fLinearRegressionPlot(sig1,sig2)
b=~(isnan(sig1)|isnan(sig2));
sig1=sig1(b);
sig2=sig2(b);

Correlation = corrcoef(sig1,sig2)  ;
Correlation = Correlation(2)             ;
[a,b,R2,R2fit,y2]      = fLinearRegression(sig1,sig2,true);
[a0,~,R20,R2fit0,y20 ] = fLinearRegression(sig1,sig2,false);


figure, hold all, box on, grid on
plot(sig1,sig2,'.','MarkerSize',4)
plot(sig1,y2,'-')
plot(sig1,y20,'-')
legend(...
    sprintf('Data  - R^2 = %4.2f - \\rho = %4.2f',R2,Correlation), ... 
    sprintf('Model - y = %.3f x + %.3f  - R^2 = % 4.2f',a ,b,R2fit ),...
    sprintf('Model - y = %.3f x + %.3f  - R^2 = % 4.2f',a0,0,R2fit0),0)
