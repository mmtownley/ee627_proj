% EE627 Final Project - music recommender
%clear;
close all;

% Define the file path
% train_file = 'trainItem2_small.txt';
% track_file = 'trackData2_small.txt';
% test_file = 'testItem2_small.txt';
train_file = 'trainItem2.txt';
track_file = 'trackData2.txt';
test_file = 'testItem2.txt';

% Read the test data
% Open the file for reading
fileID = fopen(test_file, 'r');
delimiter = '|';
numLines = 0;
while ~feof(fileID)
  line = fgetl(fileID);
  numLines = numLines + 1;
end
numTest = numLines/7;
% Reopen the file
fileID = fopen(test_file, 'r');
testSet = zeros(numTest,7);
% Read and parse the file line by line
tstIdx = 0;
userIdx = 0;
while ~feof(fileID)
  line = fgetl(fileID);
  numLines = numLines + 1;
  if contains(line, '|')
    % User line
    dataEntries = strsplit(line, delimiter);
    % Convert each data entry to a numeric value
    dataPoints = str2double(dataEntries);
    currUser = dataPoints(1);
    userIdx = userIdx+1;
    testSet(userIdx,1) = currUser;
    tstIdx = 1;
  else
    % Track Line
    tstIdx = tstIdx + 1;
    testSet(userIdx,tstIdx) = str2double(line);
  end
end






