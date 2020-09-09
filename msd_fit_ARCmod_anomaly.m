% ARC modified March 2019
% ARC Modified 24/2/2018
% Neha Khetan,  22 Jan 2015
% Fitting an MSD curve to the anomlous diffusion equation

function [d_eff,alpha,predy]= msd_fit_ARCmod_anomaly(tim,msd)

% tim: for delta time values
% msd: for the msd values obtained from the fit

s= fitoptions('Method','NonlinearLeastSquares',...
    'Startpoint',[ 0 0],...
    'Algorithm' , 'Levenberg-Marquardt' );

% for 2D MSD function: <r^2> =  4Dt^alpha, here tim = x;

ft3     = fittype( '(4.*d.*(x.^a)) ',...
    'coefficients',{'a','d'},'options',s );
[ cf,~,~ ] = fit( tim , msd, ft3 );
% returns alpha and effective D values
alpha = cf.a;
d_eff = cf.d;
predy=cf(tim);

end
