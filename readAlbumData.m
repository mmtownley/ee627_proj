% EE627 Final Project - music recommender
%clear;
close all;

% Define the file path
album_file = 'albumData2.txt';

% Read the test data
% Open the file for reading
fileID = fopen(album_file, 'r');
delimiter = '|';
charToCount = '|';
numLines = 0;
maxCol = 0;
maxRow = 0;
while ~feof(fileID)
  line = fgetl(fileID);
  currCol = sum(line == charToCount) + 1;
  if currCol > maxCol
    maxCol = currCol;
    maxRow = numLines+1;
  end
  numLines = numLines + 1;
end
% Reopen the file
fileID = fopen(album_file, 'r');
% Populate with -1's, then we will fill data over the -1's
albumData = -1*ones(numLines,maxCol);
% Read and parse the file line by line
currAlb = 0;
while ~feof(fileID)
  line = fgetl(fileID);
  if ~isempty(line)
    currAlb = currAlb + 1;
    dataEntries = strsplit(line, delimiter);
    % Convert each data entry to a numeric value
    dataPoints = str2double(dataEntries);
    albumData(currAlb, 1:length(dataPoints)) = dataPoints;
  end
end






