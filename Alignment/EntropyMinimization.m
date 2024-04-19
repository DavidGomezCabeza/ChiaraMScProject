function [FinalEntropyData ] = EntropyMinimization(DataBeforePhase,a_num)
% GA algorithm setup
simplexZeroAndFirstOrder = 2;
params.nonNegativePenalty = true;
params.searchMethod = simplexZeroAndFirstOrder;

% Structure definition for the first GA optimization
np =50;  % Number of parents
problem.ni = 50 % Number of interaction 
problem.nvars = 1;  % Number of variables in the optimization problem 
problem.solver = 'ga'; 
problem.ub =[10.5];  % Upper bound
problem.lb =[-10.5];  % Lower bound
problem.fitnessfcn =@(phi) (phaseCorrectCostFunction( DataBeforePhase.*exp(-sqrt(-1)*(phi)), params));  
problem.options=gaoptimset('PopulationSize',np, 'PopInitRange', [-0.5; 0.5]);  % 'PlotFcns', @gaplotbestf

% Apply GA optimization
[x, ~, ~, ~] = ga(problem); 

EntropyData =DataBeforePhase.*exp(-sqrt(-1)*x);

% Structure definition for the second GA optimization
np =50;  % Number of parents
problem.ni = 50; % Number of interaction 
problem.nvars = 1;  % Number of variables in the optimization problem 
problem.solver = 'ga'; 
problem.ub =[100];  % Upper bound
problem.lb =[-100];  % Lower bound
problem.fitnessfcn =@(phi) (phaseCorrectCostFunction(EntropyData.*exp(-sqrt(-1)*phi*a_num), params)); % 
problem.options=gaoptimset('PopulationSize',np);  % 'PlotFcns', @gaplotbestf
% problem.options=gaoptimset('PopulationSize',np, 'PopInitRange', [-0.5; 0.5]);  % 'PlotFcns', @gaplotbestf

% Apply GA optimization
[y, ~,~,~] = ga(problem); 

EntropyData2 = EntropyData.*exp(-sqrt(-1)*y*a_num);

% BaseLine correction
EntropyPeakInfo  =  GetPeaks( real( EntropyData2), 6, 0.001 );
EntropyWeight = ones( length(EntropyData2),1 );

% Set weights to 0 for regions around identified peaks
for i = 1 : length( EntropyPeakInfo )
    EntropyWeight( EntropyPeakInfo( i ).Start:EntropyPeakInfo( i ).End ) = 0;
end

Temp  = real(EntropyData2);
L = length(Temp);
E = speye( L );
D = diff( E, 1 );
W = spdiags(EntropyWeight, 0, L, L );
C = chol( W + 1600 * D' * D );
EntropyBaseLine = C\( C'\( EntropyWeight.* Temp' ) );

% Baseline correction
FinalEntropyData = Temp - EntropyBaseLine';

end