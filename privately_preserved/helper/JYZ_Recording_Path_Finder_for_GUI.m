function [raw_data_path, sac_path, sac_ref_path] = JYZ_Recording_Path_Finder_for_GUI(recording_dir)
% if succeed, return three strings of paths (sac_ref_path would be empty if
% original algorithm is not run); if failed, return 3 0s

try
    assert(ismember('raw_data', {dir(recording_dir).name}), ['raw_data directory not find in path: ' recording_dir])
    raw_data_dir = [recording_dir  '\' 'raw_data'];
    sac_dir = [recording_dir '\' 'analyzed_data'  '\' 'behavior_data' '\' 'eye'];
    assert(exist(sac_dir, 'dir')~=0, ['This directory should exist: ' sac_dir]);
    
    file_list = {dir(raw_data_dir).name};
    hdf5_list = file_list(contains(file_list, '.hdf5'));
    fhd_list = file_list(contains(file_list, '.fhd'));
    mat_list = file_list(contains(file_list, '.mat'));
    if length(hdf5_list)==1 && isempty(fhd_list) && length(mat_list)==1
        % raw_data_version = 'hdf5';
        temp1 = split(hdf5_list{1}, '.');
        temp2 = split(mat_list{1}, '.');
        assert(strcmp(temp1{1}, temp2{1}), 'name of hdf5 file and mat file should be identical');
    elseif length(fhd_list)==1 && isempty(hdf5_list) && length(mat_list)==1
        % raw_data_version = 'fhd';
        temp1 = split(fhd_list{1}, '.');
        temp2 = split(mat_list{1}, '.');
        assert(strcmp(temp1{1}, temp2{1}), 'name of fhd file and mat file should be identical');
    else
        % raw_data_version = '';
        message = ['there should be one hdf5 file with one mat file, or one fhd file with one mat file in the data directory.' raw_data_dir];
        assert(false, message)
    end
    raw_data_name = mat_list{1};
    data_name = split(raw_data_name, '.');
    data_name = data_name{1};
    raw_data_path = [sac_dir '\' data_name '_CONVERTED.mat'];
    sac_path = [sac_dir '\' data_name '_UNEYE.mat'];
    assert(exist(raw_data_path, 'file')&&exist(sac_path, 'file'), 'converted data and UNEYE result should be both present for curation')
    if exist([sac_dir '\' data_name '_ANALYZED.mat'], 'file')
        sac_ref_path = [sac_dir '\' data_name '_ANALYZED.mat'];
    else
        sac_ref_path = '';
    end
catch ME
    disp(ME.message)
    raw_data_path = '0';
    sac_path = '0';
    sac_ref_path = '0';
end

