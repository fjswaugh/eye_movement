% This class contains all relevent data from a trial. It allows the user to
% set limits on which section of the data they want. For example, in 1000ms
% of data, the user may only want the first 250ms, in which case they would
% set the start limit to 1 and the end limit to 250.
%
% Inherited from Copyable, which provides a copy method. E.g. data2 =
% data1.copy() (otherwise the class cannot be copied, only new references
% to the same data created).
classdef EyeMovementData < matlab.mixin.Copyable
    % Let properties be set only from within the constructor (before limits
    % have been applied)
    % Otherwise anyone editing these variables with the limits applied will
    % end up overwriting all data not within the limits. If editing is
    % required a different design approach for the class would be required,
    % perhaps using copies of each data set that were created when limits
    % are set and merged back into the master set when limits are removed.
    properties (SetAccess = immutable)
        trial_num;
        time;  % Time data, running from 1 -> ~1000
        xpix;  % x pixel data
        ypix;  % etc.
        xdeg;
        ydeg;
        pupil_area;
    end
    
    % These are simply internal to the class's workings
    properties (Access = private)
        % If you wish to only look at part of the data when calculating
        % BCEA (for example), then limits can be set on the subsection
        % of milliseconds to look at.
        s_;  % Start limit
        e_;  % Finish limit
        
        size_;  % Original size
    end
    
    methods
        % Constructor
        function obj = EyeMovementData(trial_num, raw_data,...
                                       screen_res, offset)
            if nargin == 0; return; end;
            
            % These must come first - whenever a property is referred to it
            % is assumed these quantities are defined
            obj.size_ = size(raw_data, 1);
            obj.s_ = 1;
            obj.e_ = obj.size_;
            
            obj.trial_num = trial_num;
            
            obj.time = (1:obj.size_)';
            
            obj.xpix = raw_data(:,2) - offset(1);
            obj.ypix = raw_data(:,3) - offset(2);
            
            xres = raw_data(:,5);
            yres = raw_data(:,6);
            % x and y data in degrees relative to centre
            obj.xdeg = (obj.xpix - screen_res(1)/2) ./ xres;
            obj.ydeg = (obj.ypix - screen_res(2)/2) ./ yres;
            
            obj.pupil_area = raw_data(:,4);
        end

        % size() returns the original size of the object, not the size
        % between the limits
        function s = size(obj)
            s = obj.size_;
        end
        
        % Get functions, returning the relevant data only (within the limits)
        function t  = get.time(obj)
            t  = obj.time(obj.s_:obj.e_);
        end
        function xp = get.xpix(obj)
            xp = obj.xpix(obj.s_:obj.e_);
        end
        function yp = get.ypix(obj)
            yp = obj.ypix(obj.s_:obj.e_);
        end
        function xd = get.xdeg(obj)
            xd = obj.xdeg(obj.s_:obj.e_);
        end
        function yd = get.ydeg(obj)
            yd = obj.ydeg(obj.s_:obj.e_);
        end
        function pa = get.pupil_area(obj)
            pa = obj.pupil_area(obj.s_:obj.e_);
        end
        
        function l = limits(obj)
            if obj.s_ == 1 && obj.e_ == obj.size()
                l = 'No limits';
            else
                l = [obj.s_, obj.e_];
            end
        end

        function remove_limits(obj)
            obj.s_ = 1;
            obj.e_ = obj.size();
        end
        
        function set_limits(obj, start, finish)
            if finish < start
                error('End value cannot be smaller than start value');
            end
            if start < 1 || finish < 1
                error('Values cannot be smaller than 1');
            end
            if start > obj.size()
                error('Start limit outside data');
            end
            if finish > obj.size()
                warning(['End limit is larger than data size, and so has '...
                         'been set to its maximum']);
                finish = obj.size();
            end
       
            obj.s_ = start;
            obj.e_ = finish;
        end

    end
end

