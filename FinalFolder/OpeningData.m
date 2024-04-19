function [DataStructure, ParData, num_subfolders] = OpeningData(FolderRaw,FolderExperiment)
% this function allows you to be able to open the data containing
% fid signals and some useful parameters 

% INPUT -------------------------------
% FolderExperiment = path experiment 
% FolderRaw = path raw folder 

% OUTPUT ------------------------------
% DataStructure = contains raw fid
% ParData = contains useful parameter selected from .par file 


% strucutre initialization 
DataStructure = struct('fid',[]);

if not(isfolder(join([FolderRaw, '\raw1'])))  % if the folder raw1 doesn't exist (branch NO) 
    
    % save file .par 
    file_par = dir(fullfile(FolderExperiment, '*.par')); % lists the files and folders in the current folder 
    par=fopen(join([FolderExperiment,'\',file_par.name]),'r');
    ParData=textscan(par,'%s %f', 'Delimiter','\t');
    fclose(par);

    txtFile = replace(file_par.name,'.par','.txt'); 
    parameters = fopen(txtFile, 'w');
    for j = 1:length(ParData{1})
        fprintf(parameters, '%s %f\n', ParData{1}{j});
    end
    fclose(parameters);

    % count number of file inside the folder 
    listing = dir(fullfile(FolderRaw, '\*.fid')); % array of nx1 where n is the number of files 
    num_signal = numel(listing); % number of signal to examine
    for i=1:num_signal 
        filename=sprintf('%s%s',FolderRaw, '\', listing(i).name);        
        h=fopen(filename,'r'); 
        sgn=fread(h,inf,'float');
        DataStructure.fid{i,1}= sgn; 
    end

else  % branch SI
    
    % main_folder2 = fullfile(date_experiment, '\1\raw');
    dirinfo = dir(FolderRaw); 
    dirinfo(1:2)=[];
    num_subfolders =numel(dirinfo);
    for i = 1:num_subfolders
        % current path subfolders
        current_subfolder = fullfile(FolderRaw, join(['raw', num2str(i)]));
        fid_files = dir(fullfile(current_subfolder , '*.fid'));
        filename=sprintf('%s%s',append(fid_files.folder,"\"),fid_files.name);
        h=fopen(filename,'r'); 
        sgn=fread(h,inf,'float');
        DataStructure.fid{i,1}= sgn; 
    end

    % Load corresponding .par file
    file_par=replace(fid_files.name, '_1.fid', '.par');
    path = fid_files.folder; 
    filename_par=sprintf('%s%s',append(path,"\"),file_par);
    data_par=fopen(filename_par,'r');
    ParData=textscan(data_par,'%s %f', 'Delimiter','\t');
    fclose(data_par);
    
    txtFile = replace(file_par,'.par','.txt'); 
    par= fopen(txtFile, 'w');
    for j = 1:length(ParData{1})
        fprintf(par, '%s %f\n', ParData{1}{j});
    end
    fclose(par);
    delete(replace(file_par,'.par','.txt'))
end
end