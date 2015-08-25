classdef PhysicalValue
    
    properties
        nominalValue = [];
        absoluteError = [];
    end
    
    properties (Dependent)
        relativeError = [];
        lowerValue = [];
        upperValue = [];
    end
        
    methods
        
        % Constructor
        function obj = PhysicalValue(nominalValue, absoluteError)
            
            if nargin > 0
                obj.nominalValue = nominalValue;
            end
            
            if nargin > 1
                if size(absoluteError) == [1, 1];
                    absoluteError = repmat(absoluteError, size(nominalValue));
                end
                obj.absoluteError = absoluteError;
            end
            
        end
        
        % Set and get
        
        function obj = set.nominalValue(obj, value)
            obj.nominalValue = value;
        end
        
        function value = get.nominalValue(obj)
            value = obj.nominalValue;
        end
                
        function obj = set.absoluteError(obj, value)
            obj.absoluteError = value;
        end
        
        function value = get.absoluteError(obj)
            if abs(obj.absoluteError) > abs(obj.nominalValue)
                value = abs(obj.nominalValue);
            else
                value = abs(obj.absoluteError);
            end
        end
        
        function value = get.relativeError(obj)
            value = abs(obj.absoluteError ./ obj.nominalValue);
        end
        
        function value = get.lowerValue(obj)
            value = obj.nominalValue - abs(obj.absoluteError);
        end
        
        function value = get.upperValue(obj)
            value = obj.nominalValue + abs(obj.absoluteError);
        end
        
        % Methods
        
        function obj = plus(obj01, obj02)
            if isa(obj02, 'double')
                nval = obj02 + obj01.nominalValue;
                aeval = obj01.absoluteError;
            else
                nval = obj01.nominalValue + obj02.nominalValue;
                aeval = sqrt(obj01.absoluteError.^2 + obj02.absoluteError.^2);
            end
            obj = PhysicalValue(nval, aeval);
        end
        
        function obj = minus(obj01, obj02)
            if isa(obj01, 'double')
                nval = obj01 - obj02.nominalValue;
                aeval = obj02.absoluteError;
            elseif isa(obj02, 'double')
                nval = obj01.nominalValue - obj02;
                aeval = obj01.absoluteError;
            else
                nval = obj01.nominalValue - obj02.nominalValue;
                aeval = sqrt(obj01.absoluteError.^2 + obj02.absoluteError.^2);
            end
            obj = PhysicalValue(nval, aeval);
        end
        
        function obj = uminus(obj)
            nval = -obj.nominalValue;
            aeval = obj.absoluteError;
            obj = PhysicalValue(nval, aeval);
        end
        
        function obj = uplus(obj)
            nval = +obj.nominalValue;
            aeval = obj.absoluteError;
            obj = PhysicalValue(nval, aeval);
        end
        
        function obj = times(obj01, obj02)
            obj = mtimes(obj01, obj02);
        end
        
        function obj = mtimes(obj01, obj02)
            if isa(obj01, 'double')
                obj01 = PhysicalValue(obj01, 0);
            elseif isa(obj02, 'double')
                obj02 = PhysicalValue(obj02, 0);
            end
            nval = obj01.nominalValue .* obj02.nominalValue;
            reval = sqrt(obj01.relativeError.^2 + obj02.relativeError.^2);
            aeval = reval .* nval;
            obj = PhysicalValue(nval, aeval);
        end
        
        function obj = rdivide(obj01, obj02)
            obj = mrdivide(obj01, obj02);
        end
        
        function obj = mpower(obj01, obj02)
            if isa(obj02, 'double')
                nval = obj01.nominalValue .^ obj02;
                aeval = obj01.nominalValue .* (abs(obj02) .* obj01.relativeError);
            else
                fprintf('This case is not available\n')
            end
            obj = PhysicalValue(nval, aeval);
        end
        
        function obj = mrdivide(obj01, obj02)
            if isa(obj02, 'double')
                nval = obj01.nominalValue ./ obj02;
                aeval = obj01.absoluteError ./ abs(obj02);
            elseif isa(obj01, 'double')
                nval = abs(obj01) ./ obj02.nominalValue;
                aeval = abs(obj01) ./ obj02.absoluteError;
                aeval(abs(aeval)==Inf) = 0;
            else
                nval = obj01.nominalValue ./ obj02.nominalValue;
                reval = sqrt(obj01.relativeError.^2 + obj02.relativeError.^2);
                aeval = reval .* nval;
            end
            obj = PhysicalValue(nval, aeval);
        end
        
        function result = lt(obj01, obj02)
            if lt(obj01.nominalValue, obj02.nominalValue)
                result = true;
            else
                result = false;
            end
        end
        
        function result = log10(obj)
            nval = log10(obj.nominalValue);
            aeval = sqrt((obj.absoluteError./(log(10) * obj.nominalValue)).^2);
            result = PhysicalValue(nval, aeval);
        end
        
        function result = log(obj)
            nval = log(obj.nominalValue);
            aeval = sqrt(obj.relativeError.^2);
            result = PhysicalValue(nval, aeval);
        end
        
        function result = power(obj1, obj2)
            if isa(obj2, 'double')
                obj2 = PhysicalValue(obj2, 0);
            end
            nval = obj1.nominalValue.^(obj2.nominalValue);
            aeval = sqrt(nval .* ((obj2.nominalValue .* obj1.absoluteError ./ obj1.nominalValue).^2 + (log(obj1.nominalValue) .* obj2.absoluteError).^2));
            result = PhysicalValue(nval, aeval);
        end
        
        function result = sqrt(obj)
            nval = sqrt(obj.nominalValue);
            aeval = sqrt(obj.nominalValue .* (obj.relativeError/2).^2);
            result = PhysicalValue(nval, aeval);
        end
        
        function result = gt(obj01, obj02)
            if gt(obj01.nominalValue, obj02.nominalValue)
                result = true;
            else
                result = false;
            end
        end
        
        function result = le(obj01, obj02)
            if le(obj01.nominalValue, obj02.nominalValue)
                result = true;
            else
                result = false;
            end
        end
       
        function result = ge(obj01, obj02)
            if le(obj01.nominalValue, obj02.nominalValue)
                result = true;
            else
                result = false;
            end
        end
        
        function result = eq(obj01, obj02)
            Indic(1) = eq(obj01.nominalValue, obj02.nominalValue);
            Indic(2) = eq(obj01.absoluteError, obj02.absoluteError);
            Indic(3) = eq(obj01.relativeError, obj02.relativeError);
            if sum(Indic) == size(indic, 2)
                result = true;
            else
                result = false;
            end
        end
        
        function result = ne(obj01, obj02)
            Indic(1) = eq(obj01.nominalValue, obj02.nominalValue);
            Indic(2) = eq(obj01.absoluteError, obj02.absoluteError);
            Indic(3) = eq(obj01.relativeError, obj02.relativeError);
            if sum(Indic) ~= size(indic, 2)
                result = true;
            else
                result = false;
            end
        end
        
        function obj = vertcat(obj01, obj02)
            nval = [obj01.nominalValue; obj02.nominalValue];
            aeval = [obj01.absoluteError; obj02.absoluteError];
            obj = PhysicalValue(nval, aeval);
        end
        
        function horzcat(~, ~)
            error('Operation not permitted at the moment.')
        end
        
        function obj = repmat(obj, x, y)
            if y ~= 1
                error('PhysicalProperties can be replicated in columns')
            else
                nval = repmat(obj.nominalValue, x, y);
                aeval = repmat(obj.absoluteError, x, y);
                obj = PhysicalProperties(nval, aeval);
            end
        end
        
        function obj = abs(obj)
            nval = abs(obj.nominalValue);
            aeval = obj.absoluteError;
            obj = PhysicalValue(nval, aeval);
        end
        
    end
end


% a + b
% 	
% 
% plus(a,b)
% 	
% 
% Binary addition
% 
% a - b
% 	
% 
% minus(a,b)
% 	
% 
% Binary subtraction
% 
% -a
% 	
% 
% uminus(a)
% 	
% 
% Unary minus
% 
% +a
% 	
% 
% uplus(a)
% 	
% 
% Unary plus
% 
% a.*b
% 	
% 
% times(a,b)
% 	
% 
% Element-wise multiplication
% 
% a*b
% 	
% 
% mtimes(a,b)
% 	
% 
% Matrix multiplication
% 
% a./b
% 	
% 
% rdivide(a,b)
% 	
% 
% Right element-wise division
% 
% a.\b
% 	
% 
% ldivide(a,b)
% 	
% 
% Left element-wise division
% 
% a/b
% 	
% 
% mrdivide(a,b)
% 	
% 
% Matrix right division
% 
% a\b
% 	
% 
% mldivide(a,b)
% 	
% 
% Matrix left division
% 
% a.^b
% 	
% 
% power(a,b)
% 	
% 
% Element-wise power
% 
% a^b
% 	
% 
% mpower(a,b)
% 	
% 
% Matrix power
% 
% a < b
% 	
% 
% lt(a,b)
% 	
% 
% Less than
% 
% a > b
% 	
% 
% gt(a,b)
% 	
% 
% Greater than
% 
% a <= b
% 	
% 
% le(a,b)
% 	
% 
% Less than or equal to
% 
% a >= b
% 	
% 
% ge(a,b)
% 	
% 
% Greater than or equal to
% 
% a ~= b
% 	
% 
% ne(a,b)
% 	
% 
% Not equal to
% 
% a == b
% 	
% 
% eq(a,b)
% 	
% 
% Equality
% 
% a & b
% 	
% 
% and(a,b)
% 	
% 
% Logical AND
% 
% a | b
% 	
% 
% or(a,b)
% 	
% 
% Logical OR
% 
% ~a
% 	
% 
% not(a)
% 	
% 
% Logical NOT
% 
% a:d:b
% 
% a:b
% 	
% 
% colon(a,d,b)
% 
% colon(a,b)
% 	
% 
% Colon operator
% 
% a'
% 	
% 
% ctranspose(a)
% 	
% 
% Complex conjugate transpose
% 
% a.'
% 	
% 
% transpose(a)
% 	
% 
% Matrix transpose
% 
% command window output
% 	
% 
% display(a)
% 	
% 
% Display method
% 
% [a b]
% 	
% 
% horzcat(a,b,...)
% 	
% 
% Horizontal concatenation
% 
% [a; b]
% 	
% 
% vertcat(a,b,...)
% 	
% 
% Vertical concatenation
% 
% a(s1,s2,...sn)
% 	
% 
% subsref(a,s)
% 	
% 
% Subscripted reference
% 
% a(s1,...,sn) = b
% 	
% 
% subsasgn(a,s,b)
% 	
% 
% Subscripted assignment
% 
% b(a)
% 	
% 
% subsindex(a)
% 	
% 
% Subscript index
