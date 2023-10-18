% EE627 Final Project - music recommender
clear;
close all;

% Define the file path
% train_file = 'trainItem2_small.txt';
% track_file = 'trackData2_small.txt';
% test_file = 'testItem2_small.txt';
train_file = 'trainItem2.txt';
track_file = 'trackData2.txt';
test_file = 'testItem2.txt';

% Open the file for reading
fileID = fopen(train_file, 'r');

% Check if the file opened successfully
if fileID == -1
  error('Error: Could not open the file.');
end

% Count the number os users in the file
% Define the character to count
charToCount = '|';
% Initialize a variable to store the count
% numUsers = 0;
% numLines = 0;
numUsers = 49204;
numLines = 12452779;

% Read and parse the file line by line
% while ~feof(fileID)
%   % Read a line from the file
%   line = fgetl(fileID);
%   % Count the occurrences of the specified character in the line
%   numUsers = numUsers + contains(line, '|');
%   numLines = numLines + 1;
% end
userList = zeros(numUsers, 1);
numEntries = numLines - numUsers;
trainData = zeros(numUsers, 3);
% Reopen the file
fileID = fopen(train_file, 'r');
% Read and parse the file line by line
userIdx = 0;
dataIdx = 0;
while ~feof(fileID)
  % Read a line from the file
  line = fgetl(fileID);

  % Check if the line is not empty
  if ~isempty(line)
    % Split the line into individual data entries using a delimiter
    if contains(line, '|')
      % User Header
      delimiter = '|';
      dataEntries = strsplit(line, delimiter);
      % Convert each data entry to a numeric value
      dataPoints = str2double(dataEntries);
      currUser = dataPoints(1);
      userIdx = userIdx+1;
      userList(userIdx) = currUser;
      numPoints = dataPoints(2);
    else
      delimiter = char(9);
      dataEntries = strsplit(line, delimiter);
      % Convert each data entry to a numeric value
      dataPoints = str2double(dataEntries);
      elem = dataPoints(1);
      rating = dataPoints(2);
      dataIdx = dataIdx + 1;
      trainData(dataIdx,1) = currUser;
      trainData(dataIdx,2) = elem;
      trainData(dataIdx,3) = rating;
    end
  end
end

% Close the file
fclose(fileID);
% Now read the track data
% Open the file for reading
fileID = fopen(track_file, 'r');

% Check if the file opened successfully
if fileID == -1
  error('Error: Could not open the file.');
end

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
% Now read the track data
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






