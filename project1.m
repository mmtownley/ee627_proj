% EE627 Final Project - music recommender
%clear;
close all;
% Read Data if it hasn't already been read. This takes awhile, so don't do
% this if you don't have to.  If you do, go get a cup of coffee...
%readData;
% Can also read a subset of the data - i.e. tracks only, training data only...


% Rules based recommendation approach
% This code hasn't been run yet, just putting ideas down
% for ii = 1:numUsers
%   testUser = testSet(ii, 1);
%   for jj = 1:6
%     testTrack = testSet(ii, jj);
%     % Look up the user's rating of the track's associated album, artist,
%     % and genre(s)
%     % Search column 1 of track data for the track
%     trackIndex = find(testTrack == trackData(:,1));
%     % Load associated elements (album, artist, genre(s))
%     assocData = trackData(trackIndex,2:end);
%     % Associated data may include NaNs and -1s, so ignore those
%     for kk = length(assocData)
%       elem = assocData(kk);
%       if ~isnan(elem) && elem ~= -1
%         searchData = [testUser, elem];
% 
%       end
%     end
% 
%   end
% end
