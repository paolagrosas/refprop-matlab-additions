function results = refpropv(var1,input1,var2,input2,fluid)
% Examples:
%
% fluid.fluid1 = 'R134a'; P = [1e5;2e5;3e5]; h = [3e5;4e5;5e5];
% test = refpropv('P',P,'h',h,fluid);
%
% fluid.fluid1 = 'R134a'; P = [1e5,2e5,3e5]; h = [3e5,4e5,5e5];
% test = refpropv('P',P,'h',h,fluid);
%
% fluid.fluid1 = 'R134a'; P = [1e5;2e5;3e5]; h = [3e5,4e5,5e5];
% test = refpropv('P',P,'h',h,fluid);
%
% fluid.fluid1 = 'R134a'; P = [1e5,2e5,3e5]; h = [3e5;4e5;5e5];
% test = refpropv('P',P,'h',h,fluid);
%

% If one or both the input arrays are NaN or empty, the refprop function
% answers properly, so we do not consider those cases here.


    function [mode, col_vect, line_vect] = test_1xm_or_mx1(array)
        org_size = size(array);
        % line vector 1xm
        if org_size(1) == 1 && org_size(2) > 1 && isempty(array) == 0
            mode = 1;
            col_vect = array';
            line_vect = array;
        % column vector mx1
        elseif org_size(2) == 1 && org_size(1) > 1 && isempty(array) == 0
            mode = 2;
            line_vect = array';
            col_vect = array;
        % 1x1 matrix equivalent to column vector 1x1
        elseif org_size(1) == 1 && org_size(2) == 1
            mode = 2;
            line_vect = array;
            col_vect = array;
        else % all the rest!
            mode = 0;
            line_vect = [];
            col_vect = [];
            fprintf(['WARNING: The input is not a line array or a ' ...
                'column array. Its current size is %dx%d\n'], ...
            size(array,1), size(array,2));
        end
    end

[mode_input1, col_input1, ~] = test_1xm_or_mx1(input1);
[mode_input2, col_input2, ~] = test_1xm_or_mx1(input2);

if mode_input1 == 2 && mode_input2 == 1
    input2 = col_input2;
    globalmode = 2;
elseif mode_input1 == 1 && mode_input2 == 2
    input1 = col_input1;
    globalmode = 2;
elseif mode_input1 == 1 && mode_input2 == 1 % both horizontal
    globalmode = 1;
elseif mode_input1 == 2 && mode_input2 == 2 % both vertical
    globalmode = 2;
elseif isempty(col_input1)==1 && isempty(col_input2)==1
    globalmode = -1;
else
    globalmode = 0;
end

if sum(size(input1) == size(input2)) ~= 2
    error('The two inputs are not compliant;\nsize imput1: %dx%d\nsize imput2: %dx%d\n',size(input1,1),size(input1,2),size(input2,1),size(input2,2))
end

if globalmode == 1 % horizontal
        for i = 1:size(input1,2)
            tmp = refprop(var1,input1(i),var2,input2(i),fluid);
            properties = fieldnames(tmp);
            for j = 1:size(properties,1)
                results.(properties{j})(1,i) = tmp.(properties{j});
            end
        end
elseif globalmode == 2 % vertical
    for i = 1:size(input1,1)
        tmp = refprop(var1,input1(i),var2,input2(i),fluid);
        properties = fieldnames(tmp);
        for j = 1:size(properties,1)
            results.(properties{j})(i,1) = tmp.(properties{j});
        end
    end
elseif globalmode == -1 % empty
    results = refprop(var1,[],var2,[],fluid);
else % all the rest
    error('globalmode = 0')
end

end
