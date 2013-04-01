function test_refprop_inputs_1_1_1()

addpath('../')
R134a = {'R134a', 1};
load('test_refprop_inputs_1_1_1');

output = refprop('T',310,'P',1.8e5,R134a);

if isequal(output,expected_output) ~= 1
    error('test_refprop_inputs_1_1_1:notEqual', 'Incorrect output.')
end

end

