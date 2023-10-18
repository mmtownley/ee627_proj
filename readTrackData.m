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
% Read the track data
% Open the file for reading
fileID = fopen(track_file, 'r');

% Check if the file opened successfully
if fileID == -1
  error('Error: Could not open the file.');
end
charToCount = '|';
% Determine the dimensions of the array to store the track data in
maxCol = 0;
numTrack = 0;
% Read and parse the file line by line
while ~feof(fileID)
  % Read a line from the file
  line = fgetl(fileID);
  % Count the occurrences of the specified character in the line
  % This helps us determine how many columns to include
  currCol = sum(line == charToCount) + 1;
  if currCol > maxCol
    maxCol = currCol;
  end
  numTrack = numTrack + 1;
end
% Populate with -1's, then we will fill data over the -1's
trackData = -1*ones(numTrack,maxCol);
fileID = fopen(track_file, 'r');
delimiter = '|';
currTrack = 0;
while ~feof(fileID)
  % Read a line from the file
  line = fgetl(fileID);
  % Check if the line is not empty
  if ~isempty(line)
    currTrack = currTrack + 1;
    dataEntries = strsplit(line, delimiter);
    % Convert each data entry to a numeric value
    dataPoints = str2double(dataEntries);
    trackData(currTrack, 1:length(dataPoints)) = dataPoints;
  end
end

% Close the file
fclose(fileID);
