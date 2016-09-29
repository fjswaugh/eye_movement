% This class contains all relevent data from a trial. It allows the user to
% set limits on which section of the data they want. For example, it 1000ms
% of data, the user may only want the first 250ms, in which case they would
% set the start limit to 1 and the end limit to 250. The 'getter' functions
% will then only return that subsection of data.
%
% Inherited from Copyable, which provides a copy method. E.g. data2 =
% data1.copy() (otherwise the class cannot be copied, only new references
% to the same data created).
classdef EyeMovementData < matlab.mixin.Copyable
    properties (Access = private)
        size_;  % Size of data set
        
        % If you wish to only look at part of the data when calculating
        % BCEA (for example), then limits can be set on the subsection
        % of milliseconds to look at.
        s_;  % Start limit
        e_;  % Finish limit
        
        trial_num_  % Number of the trial
        
        time_;  % Time data, running from 1 -> ~1000
        xpix_;  % x pixel data
        ypix_;  % etc.
        xdeg_;
        ydeg_;
        pupil_area_;
    end
    
    methods
        % Constructor
        function obj = EyeMovementData(trial_num, raw_data, screen_res)
            obj.size_ = size(raw_data, 1);

            obj.s_ = 1;
            obj.e_ = obj.size;
            
            obj.trial_num_ = trial_num;
            
            obj.time_ = (1:obj.size_)';
            
            obj.xpix_ = raw_data(:,2);
            obj.ypix_ = raw_data(:,3);
            
            xres = raw_data(:,5);
            yres = raw_data(:,6);
            % x and y data in degrees relative to centre
            obj.xdeg_ = (obj.xpix_ - screen_res(1)/2) ./ xres;
            obj.ydeg_ = (obj.ypix_ - screen_res(2)/2) ./ yres;
            
            obj.pupil_area_ = raw_data(:,4);
        end

        % Get functions, returning the relevant data only (within the limits)
        function tn   = trial_num(obj); tn   = obj.trial_num_;           end
        % size() returns the original size of the object, not the size
        % between the limits
        function size = size(obj);      size = obj.size_;                end
        function time = time(obj);      time = obj.time_(obj.s_:obj.e_); end
        function xpix = xpix(obj);      xpix = obj.xpix_(obj.s_:obj.e_); end
        function ypix = ypix(obj);      ypix = obj.ypix_(obj.s_:obj.e_); end
        function xdeg = xdeg(obj);      xdeg = obj.xdeg_(obj.s_:obj.e_); end
        function ydeg = ydeg(obj);      ydeg = obj.ydeg_(obj.s_:obj.e_); end
        function pa   = pupil_area(obj)
            pa = obj.pupil_area_(obj.s_:obj.e_);
        end
        
        function limits = limits(obj)
            if obj.s_ == 1 && obj.e_ == obj.size_
                limits = 'No limits';
            else
                limits = [obj.s_, obj.e_];
            end
        end

        function [] = remove_limits(obj)
            obj.s_ = 1;
            obj.e_ = obj.size;
        end
        
        function [] = set_limits(obj, start, finish)
            if finish < start
                error('End value cannot be smaller than start value');
            end
            if start < 1 || finish < 1
                error('Values cannot be smaller than 1');
            end
            if start > obj.size_
                error('Start limit outside data');
            end
            if finish > obj.size_
                warning(['End limit is larger than data size, and so has '...
                         'been set to its maximum']);
                finish = obj.size_;
            end
       
            obj.s_ = start;
            obj.e_ = finish;
        end

    end
end

