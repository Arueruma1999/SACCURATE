classdef JYZ_Scaler
    %SCALER z score scaler to standardize the data with function fit and
    % predict similar to sklearn in python
    
    properties
        mean_value
        standard_deviation
    end
    
    methods
        function obj = JYZ_Scaler()
            %SCALER Construct an instance of this class
            %   Detailed explanation goes here
            obj.mean_value = [];
            obj.standard_deviation = [];
        end
        
        function obj = fit(obj,data)
            %METHOD1 Summary of this method goes here
            %   data should be of shape [sample_num, feature_num], it will
            %   return the trained model.
            obj.mean_value = mean(data);
            obj.standard_deviation = std(data);
            obj.standard_deviation(obj.standard_deviation==0) = 1;
        end

        function data = transform(obj, data)
            assert(~isempty(obj.mean_value) && ~isempty(obj.standard_deviation), 'please fit before transform')
            data = (data-obj.mean_value)./obj.standard_deviation;
        end

        function data = reverse(obj, data)
            assert(~isempty(obj.mean_value) && ~isempty(obj.standard_deviation), 'please fit before reverse')
            data = data.*obj.standard_deviation+obj.mean_value;
        end

    end
end

