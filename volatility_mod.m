clear
format long

S = csvread("btcprice.csv");
m = length(S);

% Calculate continously compounded return during day i (ui)
ui = zeros(m,1);
for i=2:m
  ui(i) = [S(i)-S(i-1)]/S(i-1);
end
flipui = flip(ui);

%%%%%%%% Data Distribution Modeling %%%%%%%%

x = 2000;
obs = hist(ui,x);      % Array of observed values
%while (min(obs)<1)
%  x = x-1;
%  obs = hist(ui,x);  
%end

% Normal Distribution Pearson Chi Square Test

mu = mean(ui);   
sig = std(ui);   
range = max(ui)-min(ui);     
expec = zeros(x,1);   % Array of expected values 
cdf = zeros(x,1);     % Array of cdf values
bins = zeros(x,2);    % Array of bin limits
chi = zeros(x,1); 
df = x-3;             % In a normal distribution, mean and sigma are known. Plus,
                      % subtract 1 for rows. 
                     
inc = range/x;        % Define bin limits
bins(1,1) = min(ui);
for i=2:x
  bins(i,1) = bins(i-1,1)+inc;
end  

for i=1:x
  bins(i,2) = bins(i,1)+inc;  
end

% Pearson Chi Square Test for Normality
for i=1:x
  cdf(i) = normcdf(bins(i,2),mu,sig)-normcdf(bins(i,1),mu,sig);
  expec(i) = cdf(i)*sum(obs);
  chi(i) = [(obs(i)-expec(i))^2]/expec(i);
  if chi(i) > 500
      chi(i) = 0;
  end
end

chi2 = sum(chi);
pval = 1-chi2cdf(chi2,df)

%%%%%%%% MLE GARCH(1,1) %%%%%%%%

ToEstMdl = garch(1,1);
EstParamCov = estimate(ToEstMdl, flipui);
omega = EstParamCov.Constant
alpha = EstParamCov.ARCH{1}
beta = EstParamCov.GARCH{1}
garchvar = var_array(omega, alpha, beta, ui);
for i=1:length(garchvar)
    garchvol(i) = (garchvar(i)^0.5)*100;
end

garch_stab = alpha+beta
vl = ((omega/(1-alpha-beta))^0.5)*100

% Auto-correlation & Ljung-Box

ui2 = ui.^2;
ui2sig2 = ui2./garchvar;
ui2sig2(1:2) = 0;

figure
subplot(2,1,1)
[ui2acf, ui2lags, ui2bounds, ui2h]=autocorr(ui2);
title('Auto-Correlation for ui^2');
subplot(2,1,2)
[sig2acf, sig2lags, sig2bounds, sig2h] = autocorr(ui2sig2);
title('Auto-Correlation for ui^2/sig^2');

w_k = zeros(length(ui2lags)-1,1);
LB_before = zeros(length(ui2lags)-1,1);
LB_after = zeros(length(ui2lags)-1,1);
for i=1:length(w_k)
    w_k(i) = (length(ui2)+2)/(length(ui2)-ui2lags(i+1));
    LB_before(i) = w_k(i)*(ui2acf(i+1))^2;
    LB_after(i) = w_k(i)*(sig2acf(i+1))^2;
end
LB_1 = length(ui2)*sum(LB_before);
LB_2 = length(ui2)*sum(LB_after);


%%%%%%%% EWMA %%%%%%%% 
lambda = 0.94;

ewmavar = zeros(m,1);
ewmavol = zeros(m,1);

for i=1:m
  if i < 2
    ewmavar(i) = lambda*ewmavar(i)+(1-lambda)*ui(i)^2;  
  else
    ewmavar(i) = lambda*ewmavar(i-1)+(1-lambda)*ui(i-1)^2;
  end
  ewmavol(i) = (ewmavar(i)^0.5)*100;
end


%%%%% Binomial Tree %%%%%

r = 0.12;    % Risk Free Interest Rate (Usually LIBOR rate)
T = 1/12;    % Time Frame (# of months till expiry divided by 12)

fu = ;   % Pay-off from upward movement
fd = ;   % Pay-off from downward movement

u = exp(vl*(T)^0.5);   % u & d parameters matched to volatility
d = exp(-vl*(T)^0.5);  

p = [exp(r*T)-d]/[u-d];
f = exp(-r*T)*[p*fu+(1-p)*fd];



xaxis = 1:1:m;


figure
subplot(2,1,1)
flipS = flip(S);
histfit(ui)
title('Distribution of Returns');
grid on;

subplot(2,1,2)
histfit(S,100,'lognormal')
title('Distribution of Asset Prices');
grid on;


figure
subplot(3,1,1)
plot(xaxis, S,'b')
ylabel('Spot Price')
xlabel("Day");
grid on;
title('Spot Price vs. Volatility %');

subplot(3,1,2)
plot(xaxis, ewmavol)
volatility.LineWidth = 2;
ylabel('EWMA Volatility %')
grid on;

subplot(3,1,3)
plot(xaxis, garchvol)
ylabel('GARCH (1,1) Volatility %');
grid on;











