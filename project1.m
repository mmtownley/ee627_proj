% EE627 Final Project - music recommender
%clear;
close all;
% Read Data if it hasn't already been read. This takes awhile, so don't do
% this if you don't have to.  If you do, go get a cup of coffee...
%readData;
% Can also read a subset of the data - i.e. tracks only, training data only...

% Temporary for a quick test
numUsers = 10;
tracksPerUser = 6;
% Rules based recommendation approach
% This code hasn't been run yet, just putting ideas down
for ii = 1:numUsers
  testUser = testSet(ii, 1);
  hits = zeros(1,tracksPerUser);
  rating = zeros(1,tracksPerUser);
  for jj = 1:tracksPerUser
    testTrack = testSet(ii, jj+1);
    % Look up the user's rating of the track's associated album, artist,
    % and genre(s)
    % Search column 1 of track data for the track
    trackIdx = find(testTrack == trackData(:,1));
    albumID = trackData(trackIdx,2);
    % If the album ID exists, use that. If not listed under the track, then
    % just use the rest of the associated data from the track listing
    % Load associated elements (album, artist, genre(s))
    if isnan(albumID)
      assocData = trackData(trackIdx,2:end);
    else
      albumIdx = find(albumID == albumData(:,1));
      assocData = albumData(albumIdx,1:end);
    end
    % Associated data may include NaNs and -1s, so ignore those
    for kk = 1:length(assocData)
      elem = assocData(kk);
      if ~isnan(elem) && elem ~= -1
        searchData = [testUser, elem];
        searchRows = find(trainData(:,1) == searchData(1));
        for search = 1:length(searchRows)
          if trainData(searchRows(search),2) == searchData(2)
            hits(jj) = hits(jj) + 1;
      	    rating(jj) = rating(jj) + trainData(searchRows(search),3);
          end
        end

        %hitIdx = find(trainData == searchData);
      end
    end
  end
end
