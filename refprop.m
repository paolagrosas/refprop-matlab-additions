function results = refprop(spec1,value1,spec2,value2,fluid)
% results = refprop(spec1,value1,spec2,value2,fluid)
%
% Calculates the thermodynamic properties for a given state defined through
% the input variables Spec 1 and Spec 2.
%
% Inputs are:
%   Spec1   is a character giving what we want to specify (T, P, H or D)
%   Value1  is the corresponding value
%   Spec2   is a character giving the second specification (P, D, H, S, U
%           or Q)
%   Value2  is the corresponding value
%
% The fluid is defined either as a pure fluid together with a vector comp
% that defines the mass fractions. For each component add a field to the
% structure "fluid" as follows:
%   fluid.fluid1 = 'R134a'
%   fluid.massfraction1 = 0.32;
%   fluid.fluid2 = 'R32';
%   fluid.massfraction2 = 0.28;
%   fluid.fluid3 = 'R125';
%   fluid.massfraction3 = 0.4;
%   Point1 = refprop('P',10e5,'H',4e5,fluid);
%   
% More fields lead to longer calculations, therefore define just the
% necessary
% -------------------------------------------------------------------------
%The output P is a field containing the following values:
%   P        Pressure [Pa]
%   T        Temperature [K]
%   rho      Density [kg/m3]
%   h        Enthalpy [J/kg]
%   s        Entropy [J/(kg*K)]
%   A        Speed of sound [m/s]
%   mu       Dynamic viscosity [Pa*s]
%   x        Quality (vapor fraction) [kg/kg]
%   cp       Cp [J/(kg K)]
%   lambda   Thermal conductivity [W/(m K)]
%   gamma
%   cv
%

org_spec1 = spec1;
org_spec2 = spec2;

switch spec1
    case 'h'
        spec1='H';
    case 's'
        spec1='S';
    case 'rho'
        spec1='D';
    case 'mu'
        spec1='V';
    case 'x'
        spec1='Q';
    case 'cp'
        spec1='C';
    case 'lambda'
        spec1='L';
    case 'gamma'
        spec2='K';
    case 'cv'
        spec2='O';
end

switch spec2
    case 'h'
        spec2='H';
    case 's'
        spec2='S';
    case 'rho'
        spec2='D';
    case 'mu'
        spec2='V';
    case 'x'
        spec2='Q';
    case 'cp'
        spec2='C';
    case 'lambda'
        spec2='L';
    case 'gamma'
        spec2='K';
    case 'cv'
        spec2='O';
end

if isempty(value1)==1 || isempty(value2)==1
    disp(['WARNING: one or more of the input values is empty. ' ...
        'Properties returned are NaN...']);
    results.P = NaN;
    results.T = NaN;
    results.rho = NaN;
    results.h = NaN;
    results.s = NaN;
    results.A = NaN;
    results.mu = NaN;
    results.x = NaN;
    results.cp = NaN;
    results.lambda = NaN;
    results.gamma = NaN;
    results.cv = NaN;
    results.(org_spec1) = value1;
    results.(org_spec2) = value2;
elseif isnan(value1)==1 || isnan(value2)==1
    disp(['WARNING: one or more of the input values is NaN. ' ...
        'Properties returned are NaN...']);
    results.P = NaN;
    results.T = NaN;
    results.rho = NaN;
    results.h = NaN;
    results.s = NaN;
    results.A = NaN;
    results.mu = NaN;
    results.x = NaN;
    results.cp = NaN;
    results.lambda = NaN;
    results.gamma = NaN;
    results.cv = NaN;
    results.(org_spec1) = value1;
    results.(org_spec2) = value2;
else
    if spec1 == 'P'
        value1 = value1 /1000; %refpropm requires the pressure expressed in kPa
    end
    
    if spec2 == 'P'
        value2 = value2 /1000; % refpropm requires the pressure expressed
                               % in kPa
    end
    
    if isfield(fluid, 'fluid3') && isfield(fluid, 'fluid2') && ...
            isfield(fluid, 'fluid1')
        [results.P, ...
            results.T, ...
            results.rho, ...
            results.h, ...
            results.s, ...
            results.A, ...
            results.mu, ...
            results.x, ...
            results.cp, ...
            results.lambda, ...
            results.gamma, ...
            results.cv] = refpropm('PTDHSAVQCLKO', spec1, value1, ...
            spec2, value2, fluid.fluid1, fluid.fluid2, fluid.fluid3, ...
            [fluid.massfraction1 fluid.massfraction2 fluid.massfraction3]);
    elseif isfield(fluid, 'fluid2') && isfield(fluid, 'fluid1')
        [results.P, ...
            results.T, ...
            results.rho, ...
            results.h, ...
            results.s, ...
            results.A, ...
            results.mu, ...
            results.x, ...
            results.cp, ...
            results.lambda, ...
            results.gamma, ...
            results.cv] = refpropm('PTDHSAVQCLKO', spec1, value1, ...
            spec2, value2, fluid.fluid1, fluid.fluid2, ...
            [fluid.massfraction1 fluid.massfraction2]);
    elseif isfield(fluid, 'fluid1')
        [results.P, ...
            results.T, ...
            results.rho, ...
            results.h, ...
            results.s, ...
            results.A, ...
            results.mu, ...
            results.x, ...
            results.cp, ...
            results.lambda, ...
            results.gamma, ...
            results.cv] = refpropm('PTDHSAVQCLKO', spec1, value1, ...
            spec2, value2, fluid.fluid1);
    end
    results.P = results.P * 1000; % Pressure expressed in Pa
    results.x(results.x < 0) = 0;
    results.x(results.x > 1) = 1;
end

results = orderfields(results);
