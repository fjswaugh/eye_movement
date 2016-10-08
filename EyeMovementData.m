% This class contains all relevent data from a trial. It allows the user to
% set limits on which section of the data they want. For example, in 1000ms
% of data, the user may only want the first 250ms, in which case they would
% set the start limit to 1 and the end limit to 250.
%
% Inherited from Copyable, which provides a copy method. E.g. data2 =
% data1.copy() (otherwise the class cannot be copied, only new references
% to the same data created).
classdef EyeMovementData < matlab.mixin.Copyable
    % These are the public facing properties. They represent the data
    % within the limits set.
    properties
        trial_num;
        time;  % Time data, running from 1 -> ~1000
        xpix;  % x pixel data
        ypix;  % etc.
        xdeg;
        ydeg;
        pupil_area;

    end
    
    % These are properties internal to the class's workings
    properties (Access = private)
        % If you wish to only look at part of the data when calculating
        % BCEA (for example), then limits can be set on the subsection
        % of milliseconds to look at.
        s_;  % Start limit
        e_;  % Finish limit
        
        % Mastrer data. These are kept private since they are not directly
        % accessed by users of the class. Instead a copy of them is kept
        % public that represents the data within whatever limits are set.
        time_;
        xpix_;
        ypix_;
        xdeg_;
        ydeg_;
        pupil_area_;
        
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
            
            % Set the master copies of the data
            
            obj.time_ = (1:obj.size_)';
            obj.xpix_ = raw_data(:,2) - offset(1);
            obj.ypix_ = raw_data(:,3) - offset(2);
            
            xres = raw_data(:,5);
            yres = raw_data(:,6);
            % x and y data in degrees relative to centre
            obj.xdeg_ = (obj.xpix_ - screen_res(1)/2) ./ xres;
            obj.ydeg_ = (obj.ypix_ - screen_res(2)/2) ./ yres;
            
            obj.pupil_area_ = raw_data(:,4);
            
            % Set the public copies of the data to be the same as the
            % master copies (at least until the limits are changed)
            
            obj.time       = obj.time_;
            obj.xpix       = obj.xpix_;
            obj.ypix       = obj.ypix_;
            obj.xdeg       = obj.xdeg_;
            obj.ydeg       = obj.ydeg_;
            obj.pupil_area = obj.pupil_area_;
        end

        % size() returns the original size of the object, not the size
        % between the limits
        function s = size(obj)
            s = obj.size_;
        end
        
        function l = limits(obj)
            if obj.s_ == 1 && obj.e_ == obj.size()
                l = 'No limits';
            else
                l = [obj.s_, obj.e_];
            end
        end

        function remove_limits(obj)
            % Merge the public data back with the master data, preserving
            % any changes made
            obj.time_(obj.s_:obj.e_)       = obj.time;
            obj.xpix_(obj.s_:obj.e_)       = obj.xpix;
            obj.ypix_(obj.s_:obj.e_)       = obj.ypix;
            obj.xdeg_(obj.s_:obj.e_)       = obj.xdeg;
            obj.ydeg_(obj.s_:obj.e_)       = obj.ydeg;
            obj.pupil_area_(obj.s_:obj.e_) = obj.pupil_area;
            
            obj.s_ = 1;
            obj.e_ = obj.size();
            
            % Reset the public data to be the same as the master data
            obj.time       = obj.time_;
            obj.xpix       = obj.xpix_;
            obj.ypix       = obj.ypix_;
            obj.xdeg       = obj.xdeg_;
            obj.ydeg       = obj.ydeg_;
            obj.pupil_area = obj.pupil_area_;
        end
        
        function set_limits(obj, start, finish)
            if finish < start
                error('End value cannot be smaller than start value');
            elseif start < 1 || finish < 1
                error('Values cannot be smaller than 1');
            elseif start > obj.size()
                error('Start limit outside data');
            end
            
            if finish > obj.size()
                warning(['End limit is larger than data size, and so '...
                         'has been set to its maximum']);
                finish = obj.size();
            end
            
            % First remove limits to save any changes made to the
            % public data
            obj.remove_limits();
       
            obj.s_ = start;
            obj.e_ = finish;
            
            obj.time       = obj.time_(obj.s_:obj.e_);
            obj.xpix       = obj.xpix_(obj.s_:obj.e_);
            obj.ypix       = obj.ypix_(obj.s_:obj.e_);
            obj.xdeg       = obj.xdeg_(obj.s_:obj.e_);
            obj.ydeg       = obj.ydeg_(obj.s_:obj.e_);
            obj.pupil_area = obj.pupil_area_(obj.s_:obj.e_);
        end
        
        % Set methods allow restrictions to be placed when setting the
        % public data, to preserve the integrity of the class
        function obj = set.time(obj, t)
            if size(t, 1) == obj.e_ - obj.s_ + 1
                obj.time = t;
            else
                error('Length mismatch');
            end
        end
        function obj = set.xpix(obj, xp)
            if size(xp, 1) == obj.e_ - obj.s_ + 1
                obj.xpix = xp;
            else
                error('Length mismatch');
            end
        end
        function obj = set.ypix(obj, yp)
            if size(yp, 1) == obj.e_ - obj.s_ + 1
                obj.ypix = yp;
            else
                error('Length mismatch');
            end
        end
        function obj = set.xdeg(obj, xd)
            if size(xd, 1) == obj.e_ - obj.s_ + 1
                obj.xdeg = xd;
            else
                error('Length mismatch');
            end
        end
        function obj = set.ydeg(obj, yd)
            if size(yd, 1) == obj.e_ - obj.s_ + 1
                obj.ydeg = yd;
            else
                error('Length mismatch');
            end
        end
        function obj = set.pupil_area(obj, pa)
            if size(pa, 1) == obj.e_ - obj.s_ + 1
                obj.pupil_area = pa;
            else
                error('Length mismatch');
            end
        end
    end
end
