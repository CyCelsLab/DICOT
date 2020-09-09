% ARC modified March 2019
% ARC Modified 24/2/2018
% Neha Khetan,  22 Jan 2015
% Fitting an MSD curve to the diffusion-with-drift equation

function [d_eff,v,predy]= msd_fit_ARCmod_drift(tim,msd)

% tim: for delta time values
% msd: for the msd values obtained from the fit

s= fitoptions('Method','NonlinearLeastSquares',...
    'Startpoint',[ 0 0 ],...
    'Algorithm' , 'Levenberg-Marquardt' );

% for 2D MSD function: <r^2> =  4Dt^alpha, here tim = x;

ft3     = fittype( '(4.*d.*(x)) + ((v*x)^2)',...
    'coefficients',{'d','v'},'options',s );
[ cf,~,~ ] = fit( tim , msd, ft3 );
% returns drift velocity and effective D values
v = cf.v;
d_eff = cf.d;
predy=cf(tim);


end
