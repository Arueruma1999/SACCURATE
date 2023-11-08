function output_ = JYZ_Sac_Finder_for_GUI(trial_eye_velocity_trace, ind_search_begin, ind_search_end, params)
% Author: Ehsan Sedaghat-Nejad (esedaghatnejad@gmail.com)
% You can use this code with any of the following input configurations
% output_ = ESN_Sac_Finder(trial_eye_velocity_trace)
% output_ = ESN_Sac_Finder(trial_eye_velocity_trace, ind_search_begin)
% output_ = ESN_Sac_Finder(trial_eye_velocity_trace, ind_search_begin, ind_search_end)
% output_ = ESN_Sac_Finder(trial_eye_velocity_trace, ind_search_begin, ind_search_end, params)
%
% This function receives the velocity trajectory for a trial (or a portion of it) along with the
% indeces for beginning and ending of the search window. it will return an structure as output which
% contains:
% sac_validity: boolean specifying if the criteria for saccade detection has been met or not
% inds_sac: 150 indeces which correspond to the saccade. The saccade peak velocity aligned to index
% number 60. indeces are based on the input velocity trace
% ind_sac_start: index for the begining of the saccade wrt to input trace
% ind_sac_vmax: index for saccade peak velocity wrt to input trace
% ind_sac_finish: index for the end of the saccade wrt to input trace
% function inputs:
% trial_eye_velocity_trace: the velocity trace for a trial (or a portion of it)
% ind_search_begin: index wrt to input trace for beginning of search window
% ind_search_end: index wrt to input trace for end of search window
% params: the parameters for saccade detection and validation,
% MinPeakHeight (150deg/s), MinPeakProminence (100data points), rough_threshold (50deg/s),
% fine_threshold (20deg/s)

if nargin < 1
    output_.validity    = nan;
    output_.inds        = nan;
    output_.ind_start   = nan;
    output_.ind_vmax    = nan;
    output_.ind_finish  = nan;
    return;
end
if nargin < 2
    ind_search_begin = 1;
end
if nargin < 3
    ind_search_end = length(trial_eye_velocity_trace);
end
if nargin < 4
    params.MinPeakHeight      = 0; % deg/s
    params.MinPeakProminence  = 25; % data points
    params.rough_threshold    = 50.0; % deg/s
    params.fine_threshold     = 20.0; % deg/s
    params.sampling_freq      = 2000.0; % Hz
    params.cutoff_freq        = 75.0; % Hz
    params.window_half_length = 4; % data points
    params.prominence_or_first = 'prominent'; % which peak to select, 'prominent' or 'first'
end

MinPeakHeight_       = params.MinPeakHeight;
MinPeakProminence_   = params.MinPeakProminence;
rough_threshold_     = params.rough_threshold;
fine_threshold_      = params.fine_threshold;
sampling_freq_       = params.sampling_freq;
cutoff_freq_         = params.cutoff_freq;
window_half_length_  = params.window_half_length;
prominence_or_first_ = params.prominence_or_first;

% turn off warning for findpeaks
MSGID = 'signal:findpeaks:largeMinPeakHeight';
warning('off', MSGID);

length_input_trace = length(trial_eye_velocity_trace);
% filter params
[b_butter,a_butter] = butter(3,(cutoff_freq_/(sampling_freq_/2)), 'low');

% handling an error where the search window was too small
if (ind_search_end - ind_search_begin) < 200
    ind_search_end = round(min([length_input_trace, ind_search_end+200]));  
end

% make sure that the beginning of the search is not less than 1 and is also an integer
ind_search_begin = round(max([ind_search_begin, 1]));
ind_search_begin = round(min([ind_search_begin, length_input_trace-200]));
% make sure that the ending of the search is not more than length of data and is also an integer
ind_search_end    = round(min([length_input_trace, ind_search_end]));
% search slot for primary saccade
sac_inds_search_slot = ind_search_begin : 1 : ind_search_end;
% extract primary sac
sac_analyze_flag  = true;
sac_validity      = true;
sac_vm            = trial_eye_velocity_trace(sac_inds_search_slot);
sac_vm_filt_heavy = filtfilt(b_butter,a_butter,sac_vm);
[sac_vmax_, ind_sac_vmax_] = findpeaks(sac_vm_filt_heavy, 'MinPeakProminence',MinPeakProminence_, ...
                                                 'MinPeakHeight', MinPeakHeight_);
% % peaks happen very close to each other
% if(sum(diff(ind_sac_vmax_)<80))
%     sac_validity         = false;
% end
% select the peak based on prominent or first
if strcmp(prominence_or_first_, 'prominent')
    [sac_vmax, ind_sac_vmax] = findpeaks(sac_vm_filt_heavy, 'MinPeakProminence',MinPeakProminence_, ...
                                                            'SortStr','descend', ...
                                                            'NPeaks', 1, ...
                                                            'MinPeakHeight', MinPeakHeight_);
elseif(~isempty(sac_vmax_))
    sac_vmax     = sac_vmax_(1);
    ind_sac_vmax = ind_sac_vmax_(1);
else
    sac_vmax = [];
end

if(isempty(sac_vmax))
    sac_validity         = false;
end

if(~sac_validity)
    ind_sac_vmax         = round((ind_search_begin+ind_search_end)/2);
    inds_sac             = max([(ind_sac_vmax -59), 1]) : 1 : ...
                           min([(ind_sac_vmax -59+149), length_input_trace]);
    ind_sac_start        = max([(ind_sac_vmax - 20), 1]);
    ind_sac_finish       = min([(ind_sac_vmax + 25), length_input_trace]);
    sac_analyze_flag     = false;
end

% find the ind_sac_vmax in original time series (non heavily filtered)
% re-define the search slot
if(sac_analyze_flag)
    if ((ind_sac_vmax+10) > (length(sac_vm))) || ((ind_sac_vmax-10) < 1)
        ind_sac_vmax_ = 11; % handling an error in which the max happened in the end
    else
        [~, ind_sac_vmax_] = max(sac_vm(ind_sac_vmax-10:ind_sac_vmax+10));
    end
    ind_sac_vmax_   = ind_sac_vmax_ + ((ind_sac_vmax-10) - 1);
    ind_sac_vmax    = ind_sac_vmax_ + (sac_inds_search_slot(1) - 1);
    % put the v_max at index 100, narrow the search to 300ms
    sac_inds_search_slot = max([(ind_sac_vmax - 100), 1]) : 1 : ...
                           min([(ind_sac_vmax - 100 + 299), length_input_trace]);
    sac_vm               = trial_eye_velocity_trace(sac_inds_search_slot);
    sac_vm_filt_heavy    = filtfilt(b_butter,a_butter,sac_vm);
end

% find sac begining based on rough threshold (default: 50deg/s)
sac_begining_flag = true;
if(sac_analyze_flag)
    % find the index that sac_vm_filt_heavy is more than rough
    ind_sac_start_rough        = find(sac_vm_filt_heavy(1:100)<rough_threshold_, 1, 'last');
    % if the data is too noisy, set the ind_sac_start to 50 and make the saccade invalid
    if(isempty(ind_sac_start_rough))
        ind_sac_start     = 50;
        sac_validity      = false;
        sac_begining_flag = false;
    end
end

% find sac begining based on fine (20deg/s) threshold
ind_sac_start_fine = [];
if (sac_begining_flag && sac_analyze_flag)
    ind_sac_start_fine    = find(sac_vm_filt_heavy(1:ind_sac_start_rough)<fine_threshold_, 1, 'last');
end
if(isempty(ind_sac_start_fine) && sac_begining_flag && sac_analyze_flag)
    % if the sac start is between fine (20deg/s) and rough (50deg/s) then
    % find the ind_sac_start from original data based on rough (50deg/s) threshold
    ind_sac_start_       = find(sac_vm( ...
                                        max([(ind_sac_start_rough-window_half_length_), 1]) : ...
                                        min([(ind_sac_start_rough+window_half_length_), length(sac_vm)], 101) ) ...
                                        < rough_threshold_, 1, 'last') ...
                                        - 1 + (max([(ind_sac_start_rough-window_half_length_), 1]) );
    if(isempty(ind_sac_start_))
        % if for whatever reason the original data is noisy but heavily filtered data is OK
        % use the index from heavily filtered data
        ind_sac_start    = ind_sac_start_rough;
    else
        ind_sac_start    = ind_sac_start_;
    end
end
if((~isempty(ind_sac_start_fine)) && sac_begining_flag && sac_analyze_flag)
    % find the ind_sac_start from original data based on fine (20deg/s) threshold
    ind_sac_start_       = find(sac_vm( ...
                                max([(ind_sac_start_fine-window_half_length_), 1]) : ...
                                min([(ind_sac_start_fine+window_half_length_), length(sac_vm), 101]) ) ...
                                < fine_threshold_, 1, 'last')...
                                - 1 + (max([(ind_sac_start_fine-window_half_length_), 1]) );
    if(isempty(ind_sac_start_))
        % if for whatever reason the original data is noisy but heavily filtered data is OK
        % use the index from heavily filtered data
        ind_sac_start    = ind_sac_start_fine;
    else
        ind_sac_start    = ind_sac_start_;
    end
end

% find sac ending based on rough (50deg/s) threshold
sac_ending_flag = true;
if(sac_analyze_flag)
    % find the index that sac_vm_filt_heavy is less than rough (50deg/s) threshold
    ind_sac_finish_rough       = find(sac_vm_filt_heavy(100:end)<rough_threshold_, 1, 'first') - 1 + 100;
    if(isempty(ind_sac_finish_rough))
        % if the data is too noisy, set the ind_sac_finish to 150 and make the saccade invalid
        ind_sac_finish      = 150;
        sac_validity        = false;
        sac_ending_flag     = false;
    end
end

% find sac ending based on fine (20deg/s) threshold
ind_sac_finish_fine = [];
if ( sac_ending_flag && sac_analyze_flag)
    ind_sac_finish_fine   = find(sac_vm_filt_heavy( ...
                                       100 : ...
                                       min([(ind_sac_finish_rough+50), length(sac_vm_filt_heavy)]) ) ...
                                       < fine_threshold_, 1, 'first') ...
                                       - 1 + 100;
end
if(isempty(ind_sac_finish_fine) && sac_ending_flag && sac_analyze_flag)
    % if the sac end is between fine (20deg/s) and rough (50deg/s) threshold then
    % find the ind_sac_finish from original data based on rough (50deg/s) threshold
    ind_sac_finish_       = find(sac_vm( ...
                                 max([(ind_sac_finish_rough-window_half_length_), 101]) : ...
                                 min([(ind_sac_finish_rough+window_half_length_), length(sac_vm)]) ) ...
                                 < rough_threshold_, 1, 'first') ...
                                 - 1 + (max([(ind_sac_finish_rough-window_half_length_), 1]) );
    if(isempty(ind_sac_finish_))
        % if for whatever reason the original data is noisy but heavily filtered data is OK
        % use the index from heavily filtered data
        ind_sac_finish    = ind_sac_finish_rough;
    else
        ind_sac_finish    = ind_sac_finish_;
    end
end
if((~isempty(ind_sac_finish_fine)) && sac_ending_flag && sac_analyze_flag)
    % find the ind_sac_finish from original data based on fine (20deg/s) threshold
    ind_sac_finish_       = find(sac_vm( ...
                                 max([(ind_sac_finish_fine-window_half_length_), 101]) : ...
                                 min([(ind_sac_finish_fine+window_half_length_), length(sac_vm)]) ) ...
                                 < fine_threshold_, 1, 'first') ...
                                 - 1 + (max([(ind_sac_finish_fine-window_half_length_), 1]));
    if(isempty(ind_sac_finish_))
        % if for whatever reason the original data is noisy but heavily filtered data is OK
        % use the index from heavily filtered data
        ind_sac_finish    = ind_sac_finish_fine;
    else
        ind_sac_finish    = ind_sac_finish_;
    end
end

if(sac_analyze_flag)
    ind_sac_start    = max([(ind_sac_vmax - 1 - 100 + ind_sac_start), 1]);
    ind_sac_finish   = min([(ind_sac_vmax - 1 - 100 + ind_sac_finish), length_input_trace]);
    inds_sac         = max([(ind_sac_vmax -59), 1]) : 1 :...
                       min([(ind_sac_vmax -59+149), length_input_trace]);
end

% make sure the size of inds_sac is 150, repeat the last index till the size become 150
if length(inds_sac) < 150
    inds_sac(length(inds_sac)+1:150) = inds_sac(end);
end

output_.validity    = sac_validity;
output_.inds        = inds_sac;
output_.ind_start   = ind_sac_start;
output_.ind_vmax    = ind_sac_vmax;
output_.ind_finish  = ind_sac_finish;

end