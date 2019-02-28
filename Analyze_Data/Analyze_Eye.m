%% Eyelink PREPROCESSING
%
% 1. convert edf file to asc
% 2. create a FieldTrip-style data structure
% 3. interpolate Eyelink-defined and additionally detected blinks
%
% Anne Urai, 2016
% modified Felix Töpfer, 2019

%% setup path
clear; clc; close all;
%felix070219
%thispath = '~/Dropbox/code/PupilPreprocessing/';
thispath=pwd;
addpath(thispath);

%% first, define the asc filename
%felix070219
% edfFile = 'EL_P22_s5_b1_2015-06-28_11-14-27.edf';
% ascFile = regexprep(edfFile, 'edf', 'asc');

%This is the example file name, change it to anyother file name if you want
%to load anyother file
edfFile = 's307d1L1.edf';

ascFile = regexprep(edfFile, 'edf', 'asc');


% set path to FieldTrip - get this from http://www.fieldtriptoolbox.org/download
%felix070219
%addpath('~/Documents/fieldtrip/');
% it is important to just 'addpath' the fieldtrip folder. Do not 'genpath'
% the fieldtrip folder. Because this adds also the subfolders and leads to
% function referencing problems

addpath([thispath '\fieldtrip-20190205'])

% run default setting of fieldtrip
ft_defaults;

% ============================================== %
% 1. convert edf file to asc
% ============================================== %

if ~exist(ascFile, 'file'),
    if ismac,
        edf2ascPath = [thispath '/edf2asc-mac'];
    elseif isunix,
        edf2ascPath = [thispath '/edf2asc-linux'];
    else
        error('Sorry, I don''t have an edf2asc converter for Windows')
    end
    % use this converter to create the asc file
    % failsafe mode avoids errors when some samples are missing
    system(sprintf('%s %s -failsafe -input', edf2ascPath, edfFile));
end
assert(exist(ascFile, 'file') > 1, 'Edf not properly converted');

% ============================================== %
% 2. create a FieldTrip-style data structure
% ============================================== %

% read in the asc EyeLink file
%felix070219 -> changed to updated file from Anne Urai that now does not
%only consider the pupil but also the gaze position
%asc = read_eyelink_asc(ascFile);
asc = read_eyelink_ascNK_AU(ascFile);


% create events and data structure, parse asc
[data, event, blinksmp, saccsmp] = asc2dat(asc);

% ============================================== %
% 3. interpolate Eyelink-defined and additionally detected blinks
% ============================================== %

plotMe = true;
%felix 12.02.19 -> give out all available information
%newpupil = blink_interpolate(data, blinksmp, plotMe);
[newpupil, newblinksmp, nanIdx, dat] = blink_interpolate(data, blinksmp, plotMe);

