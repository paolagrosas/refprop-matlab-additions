function test_refprop_inputs_1_1_1_with_props()

addpath('../')
R134a = {'R134a', 1};
load('test_refprop_inputs_1_1_1');
expected_output = rmfield(expected_output,{'T', 'cp', 'cv', 'h', ...
    'lambda','mu','rho','u','x'});

output = refprop('T',310,'P',1.8e5,R134a,'Properties','P,A,s');

if isequal(output,expected_output) ~= 1
    error('test_refprop_inputs_1_1_1:notEqual', 'Incorrect output.')
end

end

