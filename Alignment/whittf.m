function yf = whittf(y,beta)
% Whittaker smoothing for equally spaced data, y
% Beta: smoothing parameter >0

m = length(y); 
p = diff(speye(m),3);
yf = (speye(m)+beta*p'*p)\y;

return 