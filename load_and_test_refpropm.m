function load_and_test_refpropm
% load_and_test_refpropm
%
% This function loads the refpropm function and basic extra-functions with
% the right path on every recognized operating systems and performs some
% basic tests in order to confirm that the function behaves correctly.
%

% Set path
switch computer
    case {'GLNXA64', 'GLNX86', 'MACI', 'MACI64', 'SOL64'}
            refpropm_path = '/opt/software/cse-software/refprop/9.2/';
        otherwise
            BasePath = 'C:\Program Files\REFPROP\refprop-extras\MATLAB';
            if and(~exist(BasePath,'dir'), strcmp(computer('arch'), 'win64'))
                refpropm_path = 'C:\Program Files (x86)\REFPROP\refprop-extras\MATLAB';
            end
end

% Load path
addpath(refpropm_path)

% Run basic tests
runtests('refpropm_basic_test.m');

end