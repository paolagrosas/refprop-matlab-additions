classdef MeasuredPhysicalValue
    
    properties
        measuredValue
        uncertaintyValue
        calibrationCoefficients
        % metadata
        time
        units
        sensorID
        sensorType
        acquisitionDevice
        acquisitionModule
        acquisitionChannel
        acquisitionAddress
        calibrationDate
        comments
    end
    
    methods
        
        % Main: mval
        function obj = set.measuredValue(obj, value)
            obj.measuredValue = value;
        end
        
        % Main: uncertainty value
        function obj = set.uncertaintyValue(obj, value)
            obj.uncertaintyValue = value;
        end
        
        % Main: calibration coefficients
        function obj = set.calibrationCoefficients(obj, value)
            obj.calibrationCoefficients = value;
        end
        
        % Get calibrated values
        function calibVal = CalibrateValues(obj)
            calibVal = polyval(obj.calibrationCoefficients, obj.measuredValue);
        end
        
        % Export a PhysicalValue object
        function physVal = ExportPhysicalValue(obj)
            physVal = PhysicalValue();
            coefs = obj.calibrationCoefficients;
            x = polyval(obj.calibrationCoefficients, obj.measuredValue);
            if size(obj.uncertaintyValue, 1) ~= size(obj.measuredValue, 1)
                dx = repmat(obj.uncertaintyValue, size(obj.measuredValue, 1), 1);
            else
                dx = obj.uncertaintyValue;
            end
            xMatrix = repmat(x, 1, size(coefs, 2));
            rxMatrix = repmat((dx ./ x), 1, size(coefs, 2));
            degPower = repmat(size(coefs, 2)-1:-1:0, size(x, 1), 1);
            xMatrixPower = xMatrix.^degPower;
            aeval = sqrt(sum(repmat(coefs, size(x, 1), 1).^2 .* (xMatrixPower .* sqrt(degPower .* rxMatrix.^2)).^2, 2));
            nval = polyval(coefs, x);
            physVal.nominalValue = nval;
            physVal.absoluteError = aeval;
        end
    end
end