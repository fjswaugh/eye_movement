classdef Data < matlab.mixin.Copyable
    properties
        trial_num;
        logmar;
        type;
        desirable;
        image_num;
        em_data;
    end
    
    methods
        % Constructor
        function obj = Data(raw_ps_data, em_data, em_data_size)
            % Takes in em_data_size because size(em_data, 1) doesn't work for
            % some reason
            obj.trial_num = 1:size(raw_ps_data, 1);
            obj.trial_num = obj.trial_num';
            obj.logmar = raw_ps_data(:, 1);

            % Flag up reversals first in desirable array
            obj.desirable = zeros(size(raw_ps_data, 1), 1);
            for i = 2:size(raw_ps_data, 1)
                if raw_ps_data(i-1, 5) ~= raw_ps_data(i, 5)
                    obj.desirable(i) = 1;
                end
            end

            % This will be useful for identifying catch trials
            catch_number = max(raw_ps_data(:, 6));

            % Now categorize by type
            obj.type = zeros(size(raw_ps_data, 1), 1);
            for i = 1:size(raw_ps_data, 1)
                % Is answer correct?
                if raw_ps_data(i, 3) == raw_ps_data(i, 4)
                    obj.type(i) = -1;
                else
                    obj.type(i) = 1;
                end

                % Is point reversal?
                if obj.desirable(i)
                    obj.type(i) = obj.type(i) * 2;
                end

                % Is point a catch trial?
                if raw_ps_data(i, 6) == catch_number
                    % Just check this (a catch trial should never be a reversal
                    % anyway
                    if obj.type(i) == 1 || obj.type(i) == -1
                        obj.type(i) = obj.type(i) * 3;
                    end
                end
            end

            % Highlight the final two catch trials as desirable
            count = 0;
            for i = size(raw_ps_data, 1):-1:1
                if raw_ps_data(i, 6) == catch_number
                    count = count + 1;
                    obj.desirable(i) = 1;
                end

                if count >= 2; break; end
            end

            obj.image_num = raw_ps_data(:, 4);

            obj.em_data = cell(1, 1);
            % Put the eye movement data into the right order in array, matching
            % up the trial numbers
            for i = 1:em_data_size
                trial_num = em_data(i).trial_num();
                indices = find(obj.trial_num == trial_num);
                if ~isempty(indices)
                    obj.em_data{indices(end), 1} = em_data(i);
                end
            end
        end
        
        function b = bcea(obj)
            b = zeros(obj.size(), 1);
            for i = 1:obj.size();
                b(i) = bcea(obj.em_data{i}.xdeg(),...
                            obj.em_data{i}.ydeg(), 3);
            end
        end
        
        function sz = size(obj)
            sz = size(obj.trial_num, 1);
        end
        
        function ts = type_str(obj)
            ts = cell(size(obj.trial_num, 1), 1);
            for i = 1:size(obj.trial_num, 1)
                ts{i, 1} = data_type_str(obj.type(i));
            end
        end

        function lm = logmar_of_trial_num(obj, num)
            indices = find(obj.trial_num == num);
            if isempty(indices)
                error('Trial number not found');
            end
            lm = obj.logmar(indices(end));
        end

        function d = em_data_for_trial(obj, num)
            indices = find(obj.trial_num == num);
            if isempty(indices)
                error('Trial number not found');
            end
            d = obj.em_data{indices(end)};
        end
        
        function set_limits(obj, a, b)
            for i = 1:obj.size()
                obj.em_data{i}.set_limits(a, b);
            end
        end
        
        function remove_limits(obj)
            for i = 1:obj.size()
                obj.em_data{i}.remove_limits();
            end
        end

        function d = desirable_data(obj)
            d = obj.copy();
            indices = find(obj.desirable == 1);

            d.trial_num = obj.trial_num(indices);
            d.logmar    = obj.logmar(indices);
            d.desirable = obj.desirable(indices);
            d.type      = obj.type(indices);
            d.image_num = obj.image_num(indices);

            % Now do em_data
            d.em_data = cell(1, 1);
            for i = 1:size(indices, 1)
                d.em_data{i, 1} = obj.em_data{indices(i), 1};
            end
        end
    end
end
